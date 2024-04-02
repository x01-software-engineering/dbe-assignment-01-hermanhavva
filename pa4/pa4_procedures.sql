SET AUTOCOMMIT = ON;

CREATE PROCEDURE SelectBySubstringInName(IN name VARCHAR(64))
BEGIN 
SET name = CONCAT('%', name, '%');
SELECT b.id, b.name, b.year_date, b.dollar_price FROM books b 
WHERE b.name LIKE name;
END;
drop procedure UpdateBookNameById;

CREATE PROCEDURE UpdateBookNameById (IN id_to_update INTEGER, IN new_name VARCHAR(64))
BEGIN 
    UPDATE books b 
    SET b.name = new_name
    WHERE b.id = id_to_update;
END;

CREATE PROCEDURE GetBookNameById(IN book_id INTEGER, OUT name_to_get VARCHAR(64))
BEGIN 
    SELECT b.name INTO name_to_get FROM books b 
    WHERE b.id = book_id;
END;
drop procedure GetBookNameById;

CREATE PROCEDURE GetIncrement(INOUT number INTEGER)
BEGIN 
    SET number = number + 1;
END;


CREATE PROCEDURE AddLoan (IN loan_customer_id INTEGER, IN loan_book_id INTEGER, IN loan_time_frame INTEGER)
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
    
drop procedure AddLoan;


