CREATE OR REPLACE PACKAGE customer_pkg
AS
    PROCEDURE change_telephone(	customerID in CUSTOMER.IDCUSTOMER%TYPE,
								phoneType in TELEPHONE.TELEPHONETYPE%TYPE DEFAULT NULL,
								phoneNumber in TELEPHONE.TELEPHONENUMBER%TYPE DEFAULT NULL); 
    
   
   PROCEDURE change_address(	customerID in CUSTOMER.IDCUSTOMER%TYPE,
								street in ADDRESS.STREET%TYPE DEFAULT NULL,
								city in ADDRESS.CITY%TYPE DEFAULT NULL,
								province in ADDRESS.PROVINCE%TYPE DEFAULT NULL,
								postalcode in ADDRESS.POSTALCODE%TYPE DEFAULT NULL); 
								
	PROCEDURE change_name( 		customerID in CUSTOMER.IDCUSTOMER%TYPE,
								firstName in CNAME.FIRSTNAME%TYPE DEFAULT NULL,
								lastName in CNAME.LASTNAME%TYPE	DEFAULT NULL); 
   
   FUNCTION new_customer(
    password CUSTOMER.PASSWORD%TYPE,
	birthdate CUSTOMER.BIRTHDATE%TYPE,
    
    telephone_Type TELEPHONE.TELEPHONETYPE%TYPE DEFAULT NULL,
    telephone_Number TELEPHONE.TELEPHONENUMBER%TYPE DEFAULT NULL,
    street ADDRESS.STREET%TYPE DEFAULT NULL,
    city ADDRESS.CITY%TYPE DEFAULT NULL,
    province ADDRESS.PROVINCE%TYPE DEFAULT NULL,
    postal_code ADDRESS.POSTALCODE%TYPE DEFAULT NULL,
    first_name CNAME.FIRSTNAME%TYPE DEFAULT NULL,
    last_name CNAME.LASTNAME%TYPE DEFAULT NULL
  ) RETURN CUSTOMER.IDCUSTOMER%TYPE;
   
END customer_pkg; 
/

-- defining the body package

CREATE OR REPLACE
PACKAGE BODY CUSTOMER_PKG AS


PROCEDURE change_telephone(	customerID in CUSTOMER.IDCUSTOMER%TYPE,
								phoneType in TELEPHONE.TELEPHONETYPE%TYPE DEFAULT NULL,
								phoneNumber in TELEPHONE.TELEPHONENUMBER%TYPE DEFAULT NULL) AS
								
								
		newCustomerPhoneID TELEPHONE.IDTELEPHONE%TYPE;
		
		
		v_count NUMBER;
		
		
		id_oldCustomer NUMBER;
		
		
		current_date_val CUSTOMER_TELEPHONE.ENDDATE%TYPE:= SYSDATE;
		
		
		newPhoneID TELEPHONE.IDTELEPHONE%TYPE := mySequenceTelephone.NEXTVAL;
  BEGIN
		
		INSERT INTO TELEPHONE ( IDTELEPHONE,TELEPHONETYPE,TELEPHONENUMBER)
		VALUES (newPhoneID,phoneType, phoneNumber);
		
		SELECT COUNT(CUSTOMER_IDCUSTOMER) INTO v_count
		FROM CUSTOMER_TELEPHONE
		WHERE CUSTOMER_IDCUSTOMER = customerID;
		
		
		IF v_count > 0 THEN
			
			SELECT IDCUSTOMER_TELEPHONE INTO id_oldCustomer
			FROM CUSTOMER_TELEPHONE
			WHERE 	CUSTOMER_IDCUSTOMER = customerID AND enddate IS NULL;
					
			UPDATE CUSTOMER_TELEPHONE 
			SET ENDDATE = current_date_val
			WHERE IDCUSTOMER_TELEPHONE = id_oldCustomer;			
			
		END IF;
		
		newCustomerPhoneID := mySequenceCustomer_telephone.NEXTVAL;
		
		INSERT INTO CUSTOMER_TELEPHONE (IDCUSTOMER_TELEPHONE,
										STARTDATE,
										ENDDATE,
										CUSTOMER_IDCUSTOMER,
										TELEPHONE_IDTELEPHONE)
		VALUES (newCustomerPhoneID,current_date_val, NULL,customerID,newPhoneID);
		
		
         
	END change_telephone;
	
	
	-- SECOND PROCEDUR ADDRESS-----------------------------------------
	
	
	PROCEDURE change_address(	customerID in CUSTOMER.IDCUSTOMER%TYPE,
								street in ADDRESS.STREET%TYPE DEFAULT NULL,
								city in ADDRESS.CITY%TYPE DEFAULT NULL,
								province in ADDRESS.PROVINCE%TYPE DEFAULT NULL,
								postalcode in ADDRESS.POSTALCODE%TYPE DEFAULT NULL) AS
    
	
		
        newCustomerAddressID CUSTOMER_ADDRESS.IDCUSTOMER_ADDRESS%TYPE;
		
		
		v_count NUMBER;
		
		
		id_oldCustomer NUMBER;
		
		
		current_date_val CUSTOMER_ADDRESS.ENDDATE%TYPE:= SYSDATE;

		
		newAddressID ADDRESS.IDADDRESS%TYPE := mySequenceAddress.NEXTVAL;
		
    BEGIN
		
		-- Insert the new address with its values
		INSERT INTO ADDRESS ( IDADDRESS,STREET,CITY,PROVINCE,POSTALCODE)
		VALUES (newAddressID,street, city,province,postalcode);
		
		-- Check if the ID exists in the table
		SELECT COUNT(CUSTOMER_IDCUSTOMER) INTO v_count
		FROM CUSTOMER_ADDRESS
		WHERE CUSTOMER_IDCUSTOMER = customerID;
		
		-- if ID already exists so it should 
		-- find the primary key for that RECORD
		-- and update the END TIME in that RECORD
		-- with the current time
		IF v_count > 0 THEN
			
			SELECT IDCUSTOMER_ADDRESS INTO id_oldCustomer
			FROM CUSTOMER_ADDRESS
			WHERE 	CUSTOMER_IDCUSTOMER = customerID AND enddate IS NULL;
					
			UPDATE CUSTOMER_ADDRESS 
			SET ENDDATE = current_date_val
			WHERE IDCUSTOMER_ADDRESS = id_oldCustomer;			
			
		END IF;
	
		-- Assign a new UNIQUE ID for the new telephone on the many to many table
		newCustomerAddressID := mySequenceCustomer_address.NEXTVAL;
		
		
		-- Insert the new telephone in the many to many table 
		INSERT INTO CUSTOMER_ADDRESS (IDCUSTOMER_ADDRESS,
										STARTDATE,
										ENDDATE,
										CUSTOMER_IDCUSTOMER,
										ADDRESS_IDADDRESS)
		VALUES (newCustomerAddressID,current_date_val, NULL,customerID,newAddressID);
        
        
		
		DBMS_OUTPUT.PUT_LINE('my_variable');
    
	END change_address;
	
	
	-- Third PROCEDURE NAME------------------------
	
	
	PROCEDURE change_name( 		customerID in CUSTOMER.IDCUSTOMER%TYPE,
								firstName in CNAME.FIRSTNAME%TYPE DEFAULT NULL,
								lastName in CNAME.LASTNAME%TYPE	DEFAULT NULL) IS
    
	
		-- create a new variable to store the new Unique ID for the new telephone
		-- but in the many to many table
        newCustomerNameID CUSTOMER_NAME.IDCUSTOMER_NAME%TYPE;
		
		-- variable to check if the CUSTOMER ID is already on the many to many table
		v_count NUMBER;
		
		-- variable to store the previous ID that hold if the customer already exist
		id_oldCustomer NUMBER;
		
		-- Assign the current date to the variable
		current_date_val CUSTOMER_NAME.ENDDATE%TYPE:= SYSDATE;

		-- Assign a new UNIQUE ID for the new telephone
		newNameID CNAME.IDNAME%TYPE := mySequenceCNAME.NEXTVAL;
		
    BEGIN
		
		
		
		-- Insert the new telephone with its values
		INSERT INTO CNAME ( IDNAME,FIRSTNAME,LASTNAME)
		VALUES (newNameID,firstName, lastName);
	
		-- Check if the ID exists in the table
		SELECT COUNT(CUSTOMER_IDCUSTOMER) INTO v_count
		FROM CUSTOMER_NAME
		WHERE CUSTOMER_IDCUSTOMER = customerID;
		
		-- if ID already exists so it should 
		-- find the primary key for that RECORD
		-- and update the END TIME in that RECORD
		-- with the current time
		IF v_count > 0 THEN
			
			SELECT IDCUSTOMER_NAME INTO id_oldCustomer
			FROM CUSTOMER_NAME
			WHERE 	CUSTOMER_IDCUSTOMER = customerID AND enddate IS NULL;
					
			UPDATE CUSTOMER_NAME 
			SET ENDDATE = current_date_val
			WHERE IDCUSTOMER_NAME = id_oldCustomer;			
			
		END IF;
	
		-- Assign a new UNIQUE ID for the new telephone on the many to many table
		newCustomerNameID := mySequenceCustomer_name.NEXTVAL;
		
		
		-- Insert the new telephone in the many to many table 
		INSERT INTO CUSTOMER_NAME	   (IDCUSTOMER_NAME,
										STARTDATE,
										ENDDATE,
										CUSTOMER_IDCUSTOMER,
										NAME_IDNAME)
		VALUES (newCustomerNameID,current_date_val, NULL,customerID,newNameID);
        
        
    
	END change_name;

FUNCTION new_customer(
    password CUSTOMER.PASSWORD%TYPE,
	birthdate CUSTOMER.BIRTHDATE%TYPE,
    
    telephone_Type TELEPHONE.TELEPHONETYPE%TYPE DEFAULT NULL,
    telephone_Number TELEPHONE.TELEPHONENUMBER%TYPE DEFAULT NULL,
    street ADDRESS.STREET%TYPE DEFAULT NULL,
    city ADDRESS.CITY%TYPE DEFAULT NULL,
    province ADDRESS.PROVINCE%TYPE DEFAULT NULL,
    postal_code ADDRESS.POSTALCODE%TYPE DEFAULT NULL,
    first_name CNAME.FIRSTNAME%TYPE DEFAULT NULL,
    last_name CNAME.LASTNAME%TYPE DEFAULT NULL
  ) RETURN CUSTOMER.IDCUSTOMER%TYPE IS
  
  
        -- Declare any local variables (optional)
        newCustomerID CUSTOMER.IDCUSTOMER%TYPE := mySequenceCustomer.NEXTVAL;
        

        
    BEGIN
	
		-- Insert the new customer with its values
		INSERT INTO CUSTOMER ( IDCUSTOMER,BIRTHDATE,PASSWORD)
		VALUES (newCustomerID,birthdate,password);
	
		-- if there is some value on telephone that is not null should create the record
		if telephone_Type is NOT NULL OR telephone_Number is not NULL THEN
		
			change_telephone(newCustomerID,telephone_Type,telephone_Number);
	
		END IF;
		-- if there is some value on address that is not null should create the record
		if street is NOT NULL OR city is not NULL OR province is not NULL OR postal_code is not NULL THEN
		
			change_address(	newCustomerID,street,city,province,postal_code);
	
		END IF;
		
		-- if there is some value on name table that is not null should create the record
		if first_name is NOT NULL OR last_name is not NULL THEN
		
			change_name(newCustomerID,first_name,last_name);
	
		END IF;
		
		
	
	
	
		RETURN newCustomerID;
	
    END new_customer;
END CUSTOMER_PKG;
/



-- to remove package

drop package body customer_pkg;
drop package customer_pkg;


-- VIEW---------------------------------------
CREATE OR REPLACE VIEW CUSTOMER_VIEW AS 
SELECT CUSTOMER.IDCUSTOMER, CUSTOMER.BIRTHDATE, CUSTOMER.PASSWORD,  CNAME.FIRSTNAME, CNAME.LASTNAME
FROM CUSTOMER_NAME
LEFT JOIN CNAME 
ON CUSTOMER_NAME.NAME_IDNAME = CNAME.IDNAME
LEFT JOIN CUSTOMER
ON CUSTOMER_NAME.CUSTOMER_IDCUSTOMER = CUSTOMER.IDCUSTOMER

WHERE
(CUSTOMER_NAME.ENDDATE is NULL)

ORDER BY CUSTOMER.IDCUSTOMER ASC;































-- Trigger-------------------------------

CREATE OR REPLACE TRIGGER trg_customer_view_update
INSTEAD OF INSERT OR UPDATE ON CUSTOMER_VIEW

DECLARE
  v_cname_id CNAME.IDNAME%TYPE;
  new_id NUMBER;
  
BEGIN
  IF INSERTING THEN
    -- Insert a new record into CUSTOMER
    new_id := customer_pkg.new_customer(
									:NEW.PASSWORD,
									:NEW.BIRTHDATE,
									
									NULL,
									NULL,
									NULL,
									NULL,
									NULL,
									NULL,
									:NEW.FIRSTNAME,
									:NEW.LASTNAME
  );
    
  ELSIF UPDATING THEN
    -- Update the existing CUSTOMER_NAME record ENDDATE to the current SYSDATE
	
	DBMS_OUTPUT.PUT_LINE('my_variable');
	
    UPDATE CUSTOMER
    SET PASSWORD = :NEW.PASSWORD,
		BIRTHDATE = :NEW.BIRTHDATE
    WHERE IDCUSTOMER = :NEW.IDCUSTOMER;
    
	-- update the table CNAME with the previous procedure
	customer_pkg.change_name( 	:NEW.IDCUSTOMER,
								:NEW.FIRSTNAME,
								:NEW.LASTNAME); 
	
	
  END IF;
END;
/
















-- trigger to make some tests
CREATE OR REPLACE TRIGGER prueba
INSTEAD OF INSERT OR UPDATE ON CUSTOMER_VIEW

  v_cname_id CNAME.NAME%TYPE;
  
BEGIN
  IF INSERTING THEN
    
	DBMS_OUTPUT.PUT_LINE('Estamos insertando');
    
  ELSIF UPDATING THEN
    DBMS_OUTPUT.PUT_LINE('Estamos Updeitiando');
  END IF;
END;
/