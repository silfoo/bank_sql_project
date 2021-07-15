
USE bank;

/*
   This function create the amount of each quota including the corresponding tax.
    params: @amount -> it is total loan bank value
            @quotas -> how many quotas are.
            @type_loan -> if tax personal or mortgage, else an average interest on the different existing interests )
    Return the value of the monthly fee.
*/
DELIMITER $$
CREATE FUNCTION loan_quota_value(amount DECIMAL(15,2), quotas INT, type_loan INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
	DECLARE tax_personal DECIMAL(5,2);
    DECLARE tax_mortgage DECIMAL(5,2);
    DECLARE loan_quota_valor DECIMAL(15,2);
    SET tax_personal = 1.10;
    SET tax_mortgage = 1.18;
    CASE 
		WHEN type_loan = 1 THEN
        SET loan_quota_valor = (amount / quotas)* tax_personal;
		WHEN type_loan = 2 THEN
        SET loan_quota_valor = (amount / quotas)* tax_mortgage;
		ELSE
        SET loan_quota_valor = (amount / quotas)* 1.14;
	END CASE;
    RETURN loan_quota_valor;
END$$
DELIMITER ;

/*
	Get the current balance of each customer and update it in the bank_account and credit_card tables.
    If product is 1 -> the update will be in the bank_account table.
    If product is 2 -> The update will be in the credit_card table.
	    Also, in this case will be a verification about limit card:
        If the limit card is bigger than current balance, so, update it.
	    IF not -> change status 'LOCK'

*/
DELIMITER $$
CREATE PROCEDURE balance (product INT, amount DECIMAL(15,2), customer INT, num_movement INT, card_account_num BIGINT)
BEGIN
    CASE product
	WHEN 1 then
		UPDATE bank_account SET current_balance = current_balance + (amount)
        WHERE id_customer = customer AND account_number = card_account_num;
	WHEN 2 then
		SELECT limit_card, (current_balance - amount) into @limit_card, @current_balance
        FROM credit_card
        WHERE id_customer = customer AND card_number = card_account_num;
			IF @limit_card > @current_balance THEN
			UPDATE credit_card SET current_balance = @current_balance
            WHERE id_customer = customer AND card_number = card_account_num;
			ELSE 
			UPDATE credit_card SET current_balance = @current_balance, status = 'LOCK'
            WHERE id_customer = customer AND card_number = card_account_num ;
			END IF;
	END CASE;
END$$
DELIMITER ;

/*
	This procedure get the IBAN number.
	param: @customer -> id_customer
	       @account -> account_number

    Two variables are declared with bank entity data and country code.
    The query is made according id_customer and account_number (param),
	then will be save it into new variables
	that was created in the same query (@country, @account_number, @number_office, @control_code, @name, @surname, @surname_two)

	I tried to make the most similar IBAN formatter than the original, for it, I used concat()

	IF/ELSE are used to create the control code, that is a two digit number.
    The number of digits of each name were added.
	If the result is one digit, 10 is added to complete the rule,
	If the result is three digits, a digit is take out.
	The result will be always two digit to create @control_code.

	The code country is validated with a CASE. The formatter is two letters and one number of two digit.
    The letters are the country and the number is the international numerical prefix.

	Finally, all information is shown like corresponding IBAN.
*/
DELIMITER $$
CREATE PROCEDURE get_IBAN(customer INT, account BIGINT)
BEGIN
	DECLARE banking_entity INT;
    DECLARE code_country CHAR(4);
    SET banking_entity = 3456;
    
	SELECT p.id_country, cb.account_number, o.number_office, length(cl.name)+length(cl.surname)+length(IFNULL(cl.surname_two,'')),
		   cl.name, cl.surname, cl.surname_two
    INTO @country, @account_number, @number_office, @control_code, @name, @surname, @surname_two
	FROM customer cl JOIN bank_account cb ON cl.id_customer = cb.id_customer
					JOIN office o ON cb.id_office = o.id_office
					JOIN branch_office s ON o.id_branch_office = s.id_branch_office
					JOIN country p ON s.id_country = p.id_country
	WHERE cl.id_customer = customer AND cb.account_number = account;

	IF @control_code <= 9 THEN
	SET @control_code = @control_code + 10;
    ELSEIF @control_code >= 100 THEN
    SET @control_code = @control_code % 100;
    END IF;
    
    CASE @country
    WHEN 1 then		
		SET code_country = 'ES34';
    WHEN 2 then
		SET code_country = 'FR33';
	ELSE
		SET code_country = 'EEEE';
    END CASE;
    
	SELECT @name AS Name,
		   @surname AS Surname,
           @surname_two AS Second_Surname,
		   @account_number AS Account_number,
		   concat(code_country,'-',banking_entity,'-',@number_office,'-',@control_code,'-',@account_number) AS IBAN;
    
END$$
DELIMITER ;

/*
	After insert information in movements table, the information in bank_account and credit_card are updated,
	always if the status is ACTIVE or APPROVE.

	This trigger call a procedure,
	this is `balance(product INT, amount DECIMAL(15,2), customer INT, num_movement INT, card_account_num BIGINT)`

	param: Is the new information in movements table.
*/
DELIMITER $$
CREATE TRIGGER update_balance AFTER INSERT ON movements
    FOR EACH ROW
    BEGIN
        IF NEW.status = 'ACTIVE' OR NEW.status = 'APPROVED' THEN
		CALL balance(NEW.id_product, NEW.amount, NEW.id_customer, NEW.id_movements, NEW.card_account_num);
        END IF;
	END $$
DELIMITER ;

/*
	After update status TO_BE_APPROVE to ACTIVE or APPROVED, the information in bank_account and credit_card tables are updated.

    This trigger call a procedure,
	this is `balance(product INT, amount DECIMAL(15,2), customer INT, num_movement INT, card_account_num BIGINT)`

    param: Is the old information in movements table.
*/
DELIMITER $$
CREATE TRIGGER update_pending_balance AFTER UPDATE ON movements
	FOR EACH ROW
    BEGIN
		IF OLD.status = 'TO_BE_APPROVE' AND (NEW.status = 'ACTIVE' OR NEW.status = 'APPROVED') THEN
        CALL balance(OLD.id_product, OLD.amount, OLD.id_customer, OLD.id_movements, OLD.card_account_num);
		END IF;
    END $$
DELIMITER ;

/*
	After insert new record in customer table, this information is inserted in audit table, specifying the operation (INSERT)

*/
DELIMITER $$
CREATE TRIGGER audit_customer_insert AFTER INSERT ON customer
    FOR EACH ROW
    BEGIN
    DECLARE query VARCHAR (1024);
	SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
	INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('customer', 'insert', CURRENT_USER(), query );
	END $$
DELIMITER ;

/*
    After update information in customer table, this is inserted in audit table, specifying the operation (UPDATE)

*/
DELIMITER $$
CREATE TRIGGER audit_customer_update AFTER UPDATE ON customer
    FOR EACH ROW
    BEGIN
		DECLARE query VARCHAR (1024);
		SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
		INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('customer', 'update', CURRENT_USER(), query );
	END $$
DELIMITER ;

/*
	After delete some record in customer table, this information is inserted in audit table, specifying the operation (DELETE)
*/
DELIMITER $$
CREATE TRIGGER audit_customer_delete AFTER DELETE ON customer
    FOR EACH ROW
    BEGIN
		DECLARE query VARCHAR (1024);
		SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
		INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('customer', 'delete', CURRENT_USER(), query );
	END $$
DELIMITER ;

/*
	After insert new record in loan table, this information is inserted in audit table, specifying the operation (INSERT)
*/
DELIMITER $$
CREATE TRIGGER audit_loan_insert AFTER INSERT ON loan
    FOR EACH ROW
    BEGIN
		DECLARE query VARCHAR (1024);
		SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
		INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('loan', 'insert', CURRENT_USER(), query );
	END $$
DELIMITER ;

/*
	 After update information in loan table, this is inserted in audit table, specifying the operation (UPDATE)
*/
DELIMITER $$
CREATE TRIGGER audit_loan_update AFTER UPDATE ON loan
    FOR EACH ROW
    BEGIN
		DECLARE query VARCHAR (1024);
		SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
		INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('loan', 'update', CURRENT_USER(), query );
	END $$
DELIMITER ;

/*
	After delete some record in loan table, this information is inserted in audit table, specifying the operation (DELETE)

*/
DELIMITER $$
CREATE TRIGGER audit_loan_delete AFTER DELETE ON loan
    FOR EACH ROW
    BEGIN
		DECLARE query VARCHAR (1024);
		SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
		INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('loan', 'delete', CURRENT_USER(), query );
	END $$
DELIMITER ;

/*
	After insert new record in bank_account table, this information is inserted in audit table, specifying the operation (INSERT)

*/
DELIMITER $$
CREATE TRIGGER audit_bank_account_insert AFTER INSERT ON bank_account
    FOR EACH ROW
    BEGIN
		DECLARE query VARCHAR (1024);
		SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
		INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('bank_account', 'insert', CURRENT_USER(), query );
	END $$
DELIMITER ;

/*
	After update information in bank_account table, this is inserted in audit table, specifying the operation (UPDATE)
*/
DELIMITER $$
CREATE TRIGGER audit_bank_account_update AFTER UPDATE ON bank_account
    FOR EACH ROW
    BEGIN
		DECLARE query VARCHAR (1024);
		SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
		INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('bank_account', 'update', CURRENT_USER(), query );
	END $$
DELIMITER ;

/*
	After delete some record in bank_account table, this information is inserted in audit table, specifying the operation (DELETE)
*/
DELIMITER $$
CREATE TRIGGER audit_bank_account_delete AFTER DELETE ON bank_account
    FOR EACH ROW
    BEGIN
		DECLARE query VARCHAR (1024);
		SET query = (SELECT info  FROM INFORMATION_SCHEMA.PROCESSLIST WHERE id = CONNECTION_ID());
		INSERT INTO audit (table_name, operation, user_bank, info_SQL) VALUES ('bank_account', 'delete', CURRENT_USER(), query );
	END $$
DELIMITER ;
