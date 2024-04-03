SET AUTOCOMMIT = ON;

CREATE PROCEDURE select_by_substring_in_name_sproc(IN name VARCHAR(64))
BEGIN 
SET name = CONCAT('%', name, '%');
SELECT b.id, b.name, b.year_date, b.dollar_price FROM books b 
WHERE b.name LIKE name;
END;
drop procedure select_by_substring_in_name_sproc;


CREATE PROCEDURE get_book_name_by_id_sproc(IN book_id INTEGER, OUT name_to_get VARCHAR(64))
BEGIN 
    SELECT b.name INTO name_to_get FROM books b 
    WHERE b.id = book_id;
END;
drop procedure get_book_name_by_id_sproc;

-- example of a procedure with inout parameter
CREATE PROCEDURE get_increment(INOUT number INTEGER)
BEGIN 
    SET number = number + 1;
END;


CREATE PROCEDURE add_loan_sproc (IN loan_customer_id INTEGER, IN loan_book_id INTEGER, IN loan_time_frame INTEGER)
BEGIN
    START TRANSACTION;
    IF EXISTS(SELECT 1 FROM customer c WHERE c.id = loan_customer_id) AND
       EXISTS(SELECT 1 FROM books b WHERE b.id = loan_book_id) AND
       (SELECT nba.amount_available FROM number_books_available nba WHERE nba.book_id = loan_book_id) > 0 THEN
    
    INSERT INTO loan(customer_id, loan_date, due_date, return_date) VALUES 
    (loan_customer_id, CURDATE(), ADDDATE(CURDATE(), INTERVAL loan_time_frame MONTH), null);
    INSERT INTO book2loan(book_id, loan_id) VALUES (loan_book_id, (SELECT MAX(id) AS max_id FROM loan));
    UPDATE number_books_available nba SET amount_available = amount_available - 1 
    WHERE nba.book_id = loan_book_id;
    SELECT 'executed successfully';
    COMMIT;
    ELSEIF (SELECT nba.amount_available FROM number_books_available nba WHERE nba.book_id = loan_book_id) = 0 THEN
        SELECT 'book is unavailable';
        ROLLBACK;
    ELSE 
        SELECT 'The customer does not exist or the book does not exist';
        ROLLBACK;
    END IF;
END;
drop procedure add_loan_sproc;

CREATE PROCEDURE get_customer_id_by_name_and_address_sproc(IN customer_name VARCHAR(255), IN customer_address VARCHAR(255), OUT customer_id INTEGER)
BEGIN
    IF EXISTS(SELECT 1 FROM customer c WHERE c.name = customer_name AND c.address = customer_address) THEN
        SET customer_id =  (SELECT id FROM customer c
        WHERE c.name = customer_name AND c.address = customer_address);
    ELSE 
        SELECT 'Customer not found';
    end if;
END;
DROP PROCEDURE get_customer_id_by_name_and_address_sproc;

CREATE PROCEDURE close_loan_sproc(IN loan_id INTEGER, IN loan_book_id INTEGER)
BEGIN
    
    START TRANSACTION;
    
    IF (SELECT l.return_date FROM loan l WHERE l.id = loan_id) IS NULL AND 
       (SELECT b2l.book_id FROM book2loan b2l WHERE b2l.loan_id = loan_id) = loan_book_id THEN
        
        UPDATE loan l SET l.return_date = CURDATE() WHERE l.id = loan_id; 
        UPDATE number_books_available nba SET nba.amount_available = (nba.amount_available + 1) 
        WHERE nba.book_id = loan_book_id;
        COMMIT;
        SELECT 'loan closed successfully';
    ELSE 
        ROLLBACK;
        SELECT 'transaction failed (wrong loan_id or book_id)';
    END IF;
END;
drop procedure close_loan_sproc;