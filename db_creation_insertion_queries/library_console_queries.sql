
SELECT book_id, loan_id, COUNT(loan_id) FROM book2loan 
GROUP BY loan_id, book_id;

SELECT book_id, COUNT(loan_id) AS num_loans  -- скільки разів кожну книгу брали в лоан
FROM book2loan
GROUP BY book_id;

SELECT name, id, num_loans FROM books   -- скільки разів кожну книгу брали в лоан + ім'я книги
JOIN 
(SELECT book_id, COUNT(loan_id) AS num_loans   
FROM book2loan
GROUP BY book_id) AS a
ON id = a.book_id 
ORDER BY num_loans DESC; 

 -- скільки кожний кастомер взяв книг 
SELECT name, customer_id, COUNT(book2loan.book_id) FROM customer 
INNER JOIN 
(SELECT *
 FROM loan) as loan 
ON loan.customer_id = customer.id
INNER JOIN 
(SELECT * FROM book2loan) AS book2loan
ON book2loan.loan_id = loan.id
GROUP BY customer_id;

 -- робить те саме, що й попередня кверя 
SELECT customer_id, customer.name, COUNT(loan_id) FROM customer 
INNER JOIN
(SELECT *
FROM loan) as loan
ON loan.customer_id = customer.id
INNER JOIN
(SELECT * FROM book2loan) AS book2loan
ON book2loan.loan_id = loan.id
INNER JOIN books
ON books.id = book2loan.book_id
GROUP BY customer_id
ORDER BY COUNT(loan_id) DESC;

 -- найактивніший кастомер за останній місяць 
SELECT name, customer_id, COUNT(book2loan.book_id) FROM customer
INNER JOIN
(SELECT *
FROM loan) as loan
ON loan.customer_id = customer.id

INNER JOIN
(SELECT * FROM book2loan) AS book2loan
ON book2loan.loan_id = loan.id
WHERE DATEDIFF(CURDATE(), return_date) < 31
GROUP BY customer_id; 



 -- популярність книг по лонах 
SELECT id, name, COUNT(b2l.loan_id) FROM books 
JOIN book2loan b2l on books.id = b2l.book_id
GROUP BY b2l.book_id
ORDER BY COUNT(b2l.loan_id) DESC;

 -- вивести авторів котрі продали найбільшу кількість книг 
SELECT name, COUNT(b2l.book_id) loaned_books FROM author 
JOIN book2author b2a ON b2a.author_id = author.id
JOIN book2loan b2l ON b2l.book_id = b2a.book_id
GROUP BY author.name
ORDER BY loaned_books DESC;



-- List all users who have not borrowed any books 
SELECT customer.id, name, COUNT(loan.id) FROM customer 
LEFT JOIN loan ON loan.customer_id = customer.id
GROUP BY customer.id
HAVING COUNT(loan.id) = 0;


-- Find the list of users who borrowed the same book and the number of times they did it 
SELECT customer.id, customer.name, COUNT(customer.id) AS count_data, books.name FROM customer
JOIN loan ON loan.customer_id = customer.id
JOIN book2loan ON loan.id = book2loan.loan_id
JOIN books on book2loan.book_id = books.id
GROUP BY customer.id, book2loan.book_id
ORDER BY  count_data DESC;










SELECT name FROM customer where customer.id in (SELECT customer_id FROM loan WHERE return_date > due_date); -- імена людей, котрі просрочили

SELECT customer.name AS customer_name, books.name AS book_name  -- імена людей + назви книг, котрі просрочили
FROM customer
         JOIN loan ON customer.id = loan.customer_id
         JOIN books ON loan.book_id = books.id                          
WHERE loan.return_date > loan.due_date;

SELECT name FROM author  -- виведе автора найпопулярнішої книги, щось дуже накрутив тут
JOIN 
(
SELECT author_id FROM books 
JOIN 
(
SELECT id FROM books
JOIN (
SELECT b.name  -- виведе найпопулярнішу книгу
FROM books b
         JOIN (
    SELECT book_id
    FROM loan
    GROUP BY book_id
    ORDER BY COUNT(1) DESC
    LIMIT 1
)   AS popular_books ON b.id = popular_books.book_id)
 
AS most_popular ON most_popular.name = books.name) 
AS popular_id ON popular_id.id = books.id) AS author_idt ON author_idt.author_id = author.id ;




SELECT b.name  -- виведе найпопулярнішу книгу
FROM books b
         JOIN (
    SELECT book_id
    FROM loan
    GROUP BY book_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
) AS popular_books ON b.id = popular_books.book_id;


SELECT id FROM customer where customer.id in (SELECT customer_id FROM loan WHERE return_date <= due_date); -- імена людей, котрі не просрочили

SELECT id, name FROM customer  -- поверне ім'я людини та ії id, котра брала тільки один раз
JOIN 
    (SELECT loan.customer_id FROM loan 
    GROUP BY customer_id
    HAVING COUNT(*) = 1  
) AS once_taken ON customer.id = once_taken.customer_id;

SELECT name FROM author
JOIN 
    (SELECT id FROM books) as books_id ON books_id.id = author.id; 

SELECT name FROM author WHERE id in -- виведе ім'я того, хто написав книгу з назвою '1984'
(SELECT author_id FROM books WHERE name = '1984');

SELECT name FROM author WHERE id in -- виведе того, хто написав книгу в назві якої є вказаний substring
(SELECT author_id FROM books WHERE name LIKE '%harry potter%'); 

SELECT name FROM books -- тепер зробимо так, щоб можна було вивести усі книги одного автора
JOIN 
    (SELECT id FROM author WHERE author.name LIKE '%Rowling%') AS author_id_table
ON books.author_id = author_id_table.id;

SELECT name FROM books -- не знаю як зробити 
JOIN
                 (SELECT id
                  FROM books
                  WHERE name IN (-- виводить id книг одного автора
                  SELECT name
                  FROM books -- виводить книги одного автора
                      JOIN
                      (SELECT id FROM author WHERE author.name LIKE '%Rowling%') AS k ON k.id = books.id)) ; 

SELECT name FROM books 
JOIN
    (SELECT id FROM author WHERE author.name LIKE '%Rowling%') AS author_id_table
ON books.author_id = author_id_table.id;

SELECT a.name, b.name FROM author a
INNER JOIN books b on a.id = b.author_id;

SELECT a.name, COUNT(b.id) AS book_count  -- виводить автора, в котрого кількість книг більша за два  
FROM author a
         INNER JOIN books b ON a.id = b.author_id
GROUP BY a.id,
         a.name
HAVING COUNT(b.id) > 0;

SELECT a.name, COUNT(a.name)       -- виводить авторів і кількість їх книг 
FROM author a
JOIN books b on a.id = b.author_id
GROUP BY a.name
HAVING COUNT(a.name) > 0;



WITH RankedAuthors AS (
    SELECT
        a.id AS author_id,
        a.name AS author_name,
        c.id AS customer_id,
        c.name AS customer_name,
        COUNT(1) AS reads_count,
        
        RANK() OVER (PARTITION BY a.id ORDER BY COUNT(*) DESC) AS author_rank
    FROM
        author a
            JOIN books b ON a.id = b.author_id
            JOIN loan l ON b.id = l.book_id
            JOIN customer c ON l.customer_id = c.id
    
    GROUP BY
        a.id, c.id
)
SELECT
    author_id,
    author_name
FROM
    RankedAuthors
WHERE
    author_rank >= -5
GROUP BY
    author_id
ORDER BY
    COUNT(*) DESC;


WITH RankedAuthors AS (
    SELECT
        a.id AS author_id,
        a.name AS author_name,
        c.id AS customer_id,
        c.name AS customer_name,
        COUNT(*) AS reads_count,
        RANK() OVER (PARTITION BY a.id ORDER BY COUNT(*) DESC) AS author_rank
    FROM
        author a
            JOIN books b ON a.id = b.author_id
            JOIN loan l ON b.id = l.book_id
            JOIN customer c ON l.customer_id = c.id
    WHERE
        MONTH(l.loan_date) = MONTH(CURRENT_DATE()) AND YEAR(l.loan_date) = YEAR(CURRENT_DATE())
    GROUP BY
        a.id, c.id
    HAVING
        COUNT(1) > 0  -- Ensures that authors have been read by at least one customer
)
SELECT
    author_id,
    author_name
FROM
    RankedAuthors
WHERE
    author_rank <= 10
GROUP BY
    author_id
ORDER BY
    COUNT(*) DESC;

-- schema does not support rename

