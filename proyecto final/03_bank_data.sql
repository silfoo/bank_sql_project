USE bank;

# insert values in catalog table: document_type
INSERT INTO document_type (document_type) VALUES ('DNI');
INSERT INTO document_type (document_type) VALUES ('NIE');
INSERT INTO document_type (document_type) VALUES ('NIF');
INSERT INTO document_type (document_type) VALUES ('PASSPORT');

# insert values in catalog table: country
INSERT INTO country (name) VALUES ('ESPAÑA');
INSERT INTO country (name) VALUES ('FRANCIA');

# insert values in city table
INSERT INTO city (name, id_country) VALUES ('MADRID', 1); 
INSERT INTO city (name, id_country) VALUES ('BARCELONA', 1); 
INSERT INTO city (name, id_country) VALUES ('PARIS', 2); 


# insert values in postcode table
INSERT INTO postcode (number_postcode, id_city) VALUES (28008, 1); 
INSERT INTO postcode (number_postcode, id_city) VALUES (28009, 1); 
INSERT INTO postcode (number_postcode, id_city) VALUES (08003, 2); 
INSERT INTO postcode (number_postcode, id_city) VALUES (75001, 3); 
INSERT INTO postcode (number_postcode, id_city) VALUES (75003, 3); 


# insert values in catalog table: branch_office
INSERT INTO branch_office (name, id_country) VALUES ('Moncloa', 1); 
INSERT INTO branch_office (name, id_country) VALUES ('Barceloneta', 1);
INSERT INTO branch_office (name, id_country) VALUES ('Del louvre', 2); 


# insert values in office table
INSERT INTO office (number_office, id_branch_office) VALUES (1234,1); 
INSERT INTO office (number_office, id_branch_office) VALUES (1236,1); 
INSERT INTO office (number_office, id_branch_office) VALUES (3246,2);
INSERT INTO office (number_office, id_branch_office) VALUES (7501,3);
INSERT INTO office (number_office, id_branch_office) VALUES (7503,3); 

# insert values in catalog table: currency
INSERT INTO currency (code, currency) VALUES ('EUR','Euro');
INSERT INTO currency (code, currency) VALUES ('GBP','Libras Esterlinas');
INSERT INTO currency (code, currency) VALUES ('USD','Dolar statusunidense');

# insert values in credit_card_type table
INSERT INTO credit_card_type (type) VALUES ('VISA');
INSERT INTO credit_card_type (type) VALUES ('MASTERCARD');
INSERT INTO credit_card_type (type) VALUES ('LINK');
INSERT INTO credit_card_type (type) VALUES ('BANELCO');

# insert values in catalog table: type_loan
INSERT INTO type_loan (type) VALUES ('personal');
INSERT INTO type_loan (type) VALUES ('hipotecario');

# insert values in product table
INSERT INTO product (name) VALUES ('Cuenta Bancaria');
INSERT INTO product (name) VALUES ('Tarjeta credito');

# insert values in customer table
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES 	('Drugi', 'Lorkings', null, 2, 'I1283050-V', '1969-05-12', '2010-10-25 00:19:06', 3, 'ACTIVE');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Alexine', 'Squibb', null, 1, '27915370-V', '2000-12-11', '1996-12-05 08:41:36', 1, 'ACTIVE');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Baxie', 'Bardsley', 'Bynert', 3, 'T4482478-J', '1958-05-05', '1999-02-22 13:34:20', 4, 'ELIMINATE');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Irvin', 'Cardno', 'Durrans', 1, '27464488-O', '1991-06-03', '1999-02-11 04:55:57', 1, 'DISABLED');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Johnathon', 'McCrillis', null, 1, '65369334-G', '1977-02-06', '2002-01-18 18:32:30', 5, 'ACTIVE');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Blane', 'Gianasi', 'Aslin', 3, 'X3010591-E', '1961-02-14', '2016-05-26 05:17:56', 2, 'ACTIVE');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Myca', 'Cameron', null, 1, '56885083-P', '1994-11-15', '2004-06-16 07:46:10', 2, 'ACTIVE');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Siegfried', 'Jeandet', 'Doumer', 2, 'D1120834-Q', '1995-11-28', '1995-11-06 17:45:36', 4, 'ELIMINATE');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Carine', 'McGeachy', 'Spikings', 4, 'KBA7869362', '1978-04-02', '2014-03-20 15:40:38', 2, 'ACTIVE');
INSERT INTO customer (name, surname, surname_two, id_document_type, number_document, birthday, registration_date, id_postcode, status) 
		VALUES  ('Shanda', 'Coole', null, 3, 'R1346745-W', '1979-10-01', '2017-03-22 07:03:35', 1, 'ACTIVE');


# insert values in bank_account table
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES  (1, '2010-10-25 00:19:06', 1, '94759.98', 6858213408,3);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES  (2, '1996-12-05 08:41:36', 1, '75463.13', 8189537125,1);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES	(3, '1999-02-22 13:34:20', 1, '64093.75', 9123746194,4);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES	(4, '1999-02-11 04:55:57', 1, '24943.10', 8334648554,2);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES	(5, '2002-01-18 18:32:30', 1, '91161.80', 3477210109,5);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES	(6, '2016-05-26 05:17:56', 1, '17253.64', 4158903636,2);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES	(7, '2004-06-16 07:46:10', 1, '65248.59', 9457382997,1);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES	(8, '1995-11-06 17:45:36', 1, '14345.28', 2781756537,4);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES	(9, '2014-03-20 15:40:38', 1, '90295.14', 1383553535,1);
INSERT INTO bank_account (id_customer, creation_date, id_currency, current_balance, account_number, id_office) 
		VALUES	(10, '2017-03-22 07:03:35', 1, '69969.31', 3171065811,2);

# insert values in credit_card table
INSERT INTO credit_card (card_number, valid_from, valid_until, id_currency, limit_card, current_balance, id_credit_card_type, id_customer, status) 
		VALUES (9164243884316063, '2004-06-16 09:50:35', DATE_ADD(valid_from, INTERVAL 10 YEAR), 1, '550000.00', 0, 2, 7, 'ELIMINATE');
INSERT INTO credit_card (card_number, valid_from, valid_until, id_currency, limit_card, current_balance, id_credit_card_type, id_customer, status) 
		VALUES (5603717507585016, '2014-06-16 09:50:35', DATE_ADD(valid_from, INTERVAL 10 YEAR), 1, '550000.00', '75464.75', 2, 7, 'ACTIVE');
INSERT INTO credit_card (card_number, valid_from, valid_until, id_currency, limit_card, current_balance, id_credit_card_type, id_customer, status) 
		VALUES (6471506478423497, '2018-07-09 02:30:46', DATE_ADD(valid_from, INTERVAL 10 YEAR), 1, '550000.00', '20911.15', 2, 6, 'ACTIVE');
INSERT INTO credit_card (card_number, valid_from, valid_until, id_currency, limit_card, current_balance, id_credit_card_type, id_customer, status) 
		VALUES (6151324948555317, '2014-03-20 15:40:38', DATE_ADD(valid_from, INTERVAL 10 YEAR), 1, '550000.00', '58590.81', 3, 9, 'ACTIVE');
INSERT INTO credit_card (card_number, valid_from, valid_until, id_currency, limit_card, current_balance, id_credit_card_type, id_customer, status) 
		VALUES (7439986987923952, '2002-01-18 18:32:30', DATE_ADD(valid_from, INTERVAL 10 YEAR), 1, '550000.00', 0, 1, 5, 'ELIMINATE');
INSERT INTO credit_card (card_number, valid_from, valid_until, id_currency, limit_card, current_balance, id_credit_card_type, id_customer, status) 
		VALUES (4153511033885862, '2012-01-18 18:32:30', DATE_ADD(valid_from, INTERVAL 10 YEAR), 1, '550000.00', '44601.95', 1, 5, 'ACTIVE');

# insert values in loan table
INSERT INTO loan (loan_date, id_type_loan, id_currency, amount, number_quota, quota, limit_date, payday, id_customer, status )
VALUES ('2009-06-29 08:40:13', 1, 1, '50000.00', 30, loan_quota_value(amount, number_quota, id_type_loan),
		DATE_ADD(loan_date, INTERVAL number_quota MONTH), '2009-08-10', 5, 'CANCELED');
INSERT INTO loan (loan_date, id_type_loan, id_currency, amount, number_quota, quota, limit_date, payday, id_customer, status )
VALUES ('2018-02-10 11:20:30', 1, 1, '45000.00', 48, loan_quota_value(amount, number_quota, id_type_loan),
       DATE_ADD(loan_date, INTERVAL number_quota MONTH), '2018-04-10', 9, 'ACTIVE');

# insert values in movements table
INSERT INTO movements (date , type_movement, id_product, card_account_num, id_currency, amount, id_customer, status) 
	VALUES ('2018-02-10 11:57:41', 'LOAN', 1, 1383553535, 1, 45000.00, 9, 'TO_BE_APPROVE');
INSERT INTO movements (date , type_movement, id_product, card_account_num, id_currency, amount, id_customer, status) 
	VALUES ('2018-04-10 08:00:10', 'LOAN', 1, 1383553535, 1, -1031.25, 9, 'APPROVED');
INSERT INTO movements (date , type_movement, id_product, card_account_num, id_currency, amount, id_customer, status) 
	VALUES ('2019-09-23 04:51:34', 'PURCHASE', 2, 6151324948555317, 1, -5000.00, 9, 'APPROVED');
INSERT INTO movements (date , type_movement, id_product, card_account_num, id_currency, amount, id_customer, status) 
	VALUES ('2019-08-12 15:32:12', 'PURCHASE', 2, 5603717507585016, 1, -2350.45, 7, 'APPROVED');
INSERT INTO movements (date , type_movement, id_product, card_account_num, id_currency, amount, id_customer, status) 
	VALUES ('2019-08-12 15:32:12', 'PURCHASE', 2, 5603717507585016, 1, -2350.45, 7, 'TO_BE_APPROVE');
    
# update values in movements table
    UPDATE movements SET status = 'APPROVED' WHERE card_account_num = 5603717507585016;
    UPDATE movements SET status = 'APPROVED' WHERE card_account_num = 1383553535;

