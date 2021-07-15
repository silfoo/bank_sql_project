# if bank exist in our database, so delete it.
DROP DATABASE IF EXISTS bank;

# creation database bank
CREATE DATABASE bank;

# selection database bank
USE bank;

# creation catalog table:  document_type
CREATE TABLE document_type(
	id_document_type INT AUTO_INCREMENT PRIMARY KEY,
    document_type VARCHAR (30) UNIQUE NOT NULL 
);

# creation catalog table:  country
CREATE TABLE country(
	id_country INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE
);

# creation table:  city
CREATE TABLE city(
	id_city INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    id_country INT NOT NULL,
		INDEX country_id(id_country),
        FOREIGN KEY (id_country)
        REFERENCES country(id_country)
);

# creation table: postcode
CREATE TABLE postcode(
	id_postcode INT AUTO_INCREMENT PRIMARY KEY,
    number_postcode INT NOT NULL,
    id_city INT NOT NULL,
		INDEX city_id(id_city),
		FOREIGN KEY (id_city)
        REFERENCES city(id_city)
);
# creation table:  customer
CREATE TABLE customer(
	id_customer INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (50) NOT NULL,
    surname VARCHAR (30) NOT NULL,
    surname_two VARCHAR (30),
    id_document_type INT NOT NULL,
    number_document CHAR(10) UNIQUE NOT NULL,
    birthday DATE NOT NULL,
    registration_date DATETIME NOT NULL,
    id_postcode INT NOT NULL,
    status ENUM ('ACTIVE','DISABLED','ELIMINATE'),
		INDEX customer_id (id_customer),
        INDEX surname (surname),
        INDEX num_document (number_document),
        INDEX status(status),
		FOREIGN KEY (id_document_type)
        REFERENCES document_type(id_document_type),
        FOREIGN KEY (id_postcode)
        REFERENCES postcode(id_postcode)
);

# creation catalog table:  branch_office
CREATE TABLE branch_office(
	id_branch_office INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    id_country INT NOT NULL,
		INDEX country_id(id_country),
		FOREIGN KEY (id_country)
        REFERENCES country(id_country)
);

# creation table:  office
CREATE TABLE office(
	id_office INT AUTO_INCREMENT PRIMARY KEY,
    number_office INT UNIQUE NOT NULL,
    id_branch_office INT NOT NULL,
		INDEX branch_office_id (id_branch_office),
		FOREIGN KEY (id_branch_office)
        REFERENCES branch_office(id_branch_office)
);

# creation catalog table: currency
CREATE TABLE currency(
	id_currency INT AUTO_INCREMENT PRIMARY KEY,
    code CHAR (3) NOT NULL,
    currency VARCHAR(30) NOT NULL
);

# creation table bank_account
CREATE TABLE bank_account(
	id_bank_account INT AUTO_INCREMENT PRIMARY KEY,
    id_customer INT NOT NULL,
    creation_date DATETIME NOT NULL,
    id_currency INT NOT NULL,
    current_balance DECIMAL(15,2) NOT NULL,
    account_number BIGINT UNIQUE NOT NULL,
    id_office INT NOT NULL,
		INDEX customer_id(id_customer),
        INDEX num_account(account_number),
        INDEX office_id(id_office),
		FOREIGN KEY (id_customer)
        REFERENCES customer(id_customer),
        FOREIGN KEY (id_office)
        REFERENCES office(id_office),
        FOREIGN KEY (id_currency)
        REFERENCES currency(id_currency)
);

# creation catalog table: credit_card_type
CREATE TABLE credit_card_type(
	id_credit_card_type INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(20) UNIQUE NOT NULL
);

# creation table:  credit_card
CREATE TABLE credit_card(
	id_credit_card INT AUTO_INCREMENT PRIMARY KEY,
    card_number BIGINT UNIQUE NOT NULL,
    valid_from DATETIME NOT NULL,
    valid_until DATETIME NOT NULL,
    id_currency INT NOT NULL,
	limit_card DECIMAL(15,2) NOT NULL,
    current_balance DECIMAL(15,2) NOT NULL,
    id_credit_card_type INT NOT NULL,
	id_customer INT NOT NULL,
    status ENUM('ACTIVE', 'CREATE', 'SENDING', 'SENT', 'RECEIVED', 'LOCK', 'ELIMINATE') NOT NULL,
		INDEX num_card(card_number),
        INDEX currency_id(id_currency),
        INDEX customer_id(id_customer),
        INDEX status(status),
		FOREIGN KEY (id_credit_card_type)
        REFERENCES credit_card_type(id_credit_card_type),
		FOREIGN KEY (id_customer)
        REFERENCES customer(id_customer),
        FOREIGN KEY (id_currency)
        REFERENCES currency(id_currency)
		
);

# creation catalog table: type_loan
CREATE TABLE type_loan(
	id_type_loan INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) UNIQUE NOT NULL
);

# creation table: loan
CREATE TABLE loan(
	id_loan INT AUTO_INCREMENT PRIMARY KEY,
    loan_date DATETIME NOT NULL,
    id_type_loan INT NOT NULL,
    id_currency INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    number_quota INT NOT NULL,
    quota DECIMAL(15,2) NOT NULL,
    limit_date DATETIME NOT NULL,
    payday DATE NOT NULL, # payday of each month
	id_customer INT NOT NULL,
	status ENUM ('ACTIVE', 'CANCELED', 'PAID', 'ELIMINATE', 'DISABLED'),
		INDEX type_loan_id(id_type_loan),
        INDEX customer_id(id_customer),
        INDEX status(status),
		FOREIGN KEY (id_type_loan)
        REFERENCES type_loan(id_type_loan),
        FOREIGN KEY (id_customer)
        REFERENCES customer(id_customer),
        FOREIGN KEY (id_currency)
        REFERENCES currency(id_currency)
);

# creation catalog table: product
CREATE TABLE product(
	id_product INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

# creation table: movements
CREATE TABLE movements(
	id_movements INT AUTO_INCREMENT PRIMARY KEY,
    date DATETIME NOT NULL,
    type_movement ENUM ('DEPOSIT', 'WITHDRAWAL', 'LOAN', 'PURCHASE'),
    id_product INT NOT NULL,
    card_account_num BIGINT NOT NULL,
    id_currency INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    id_customer INT NOT NULL,
    status ENUM('ACTIVE', 'TO_BE_APPROVE', 'APPROVED', 'ELIMINATE'),
		INDEX movements(type_movement),
        INDEX product_id(id_product),
        INDEX customer_id(id_customer),
        INDEX status(status),
		FOREIGN KEY (id_product)
        REFERENCES product(id_product),
        FOREIGN KEY (id_customer)
        REFERENCES customer(id_customer),
        FOREIGN KEY (id_currency)
        REFERENCES currency(id_currency)
);


/* creation tale:  audit, saved all information about modifications in tables: customer and loan.
    what kind of modifications: UPDATE, INSERT, DELETE
    
    NOTE: The audit triggers can be create for all tables, although it was chosen to create them in the tables mentioned above.
*/
CREATE TABLE audit(
	id_audit INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR (50),
    operation VARCHAR(10), # (insert, update, delete)
    user_bank VARCHAR(50),
    audit_time TIMESTAMP DEFAULT NOW(),
    info_SQL VARCHAR (1024),
		INDEX tabla(table_name),
        INDEX operation(operation),
        INDEX user_bank(user_bank)
);
