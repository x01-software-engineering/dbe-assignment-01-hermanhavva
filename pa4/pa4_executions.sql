SET @name = '1984';
CALL SelectBySubstringInName(@name);


START TRANSACTION;
CALL UpdateBookNameById(1, 'test_name');
SELECT b.name FROM books b;
ROLLBACK;
SELECT b.name FROM books b;


START TRANSACTION;
CALL GetBookNameById(1, @name);
SELECT @name;
COMMIT;

 -- create a mechanism which will handle loaning a book 

-- AddLoan is a stored proc which is used to handle addition of a loan
CALL AddLoan(3,9,1);  



 -- can be used to return the database to initial state 
DELETE FROM loan WHERE loan.return_date IS NULL;
delete from book2loan b2l WHERE loan_id > 13;
UPDATE number_books_available nba SET nba.amount_available = 3 WHERE nba.amount_available = 0;




