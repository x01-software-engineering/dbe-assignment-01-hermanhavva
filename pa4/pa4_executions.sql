-- practising with st. proc.
SET @book_name = '1984';
CALL select_by_substring_in_name_sproc(@book_name);

START TRANSACTION;
CALL get_book_name_by_id_sproc(1, @name);
SELECT @name;
COMMIT;


-- get the customer`s id by full name and address 
START TRANSACTION;
SET @customer_name = 'Alice Johnson'; 
SET @customer_address = '123 Main St, Anytown, USA';
CALL get_customer_id_by_name_and_address_sproc(@customer_name, @customer_address, @customer_id);
SELECT @customer_id;
COMMIT; 

-- created a procedure which will handle loaning a book 
-- AddLoan is a stored proc which is used to handle addition of a loan
CALL add_loan_sproc(@customer_id,9,1);  

-- create a mechanism which will handle returning a book
CALL close_loan_sproc(23, 9);

 -- those can be used to return the database to initial state 
DELETE FROM loan WHERE loan.return_date IS NULL;
delete from book2loan b2l WHERE loan_id > 13;
UPDATE number_books_available nba SET nba.amount_available = 3 WHERE nba.amount_available = 0;




