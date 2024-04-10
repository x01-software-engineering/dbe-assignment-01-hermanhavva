SET @@sql_mode = '';

CREATE VIEW loaned_books_view AS  
SELECT b.name AS title,
       GROUP_CONCAT(a.name SEPARATOR ', ') AS authors,
       CONCAT(p.name, ', ', b.year_date) AS publisher_and_release_year,
       loan_date AS date_of_loan,
       DATEDIFF(l.due_date, CURDATE()) AS days_left
FROM books b
         INNER JOIN book2author b2a ON b.id = b2a.book_id
         INNER JOIN author a ON a.id = b2a.author_id
         INNER JOIN publisher p ON p.id = b.publisher_id
         INNER JOIN book2loan b2l ON b.id = b2l.book_id
         INNER JOIN loan l ON l.id = b2l.loan_id
WHERE l.return_date IS NULL
GROUP BY b.id, l.id;  -- grouping by l.id to make sure we return the data about distinct books 

SELECT * FROM loaned_books_view;
