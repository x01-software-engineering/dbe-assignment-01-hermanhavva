

 -- виводить одну книгу в котрої жанр fiction 
SELECT name FROM books b 
WHERE name = (SELECT name FROM books b 
              INNER JOIN book2genre b2g ON b2g.book_ISBN = b.ISBN
              WHERE b2g.genre_id IN (SELECT id FROM genre g WHERE g.name LIKE '%fiction%') 
              LIMIT 1);


 -- виводить ім'я автора, котрий написав книгу, в чий назві є substring '%Harry Potter%'
SELECT id, name FROM author a
WHERE a.name = (SELECT a.name FROM author a
                JOIN book2author b2a ON b2a.author_id = a.id
                WHERE b2a.book_id IN (
                    SELECT id FROM books WHERE name LIKE '%Harry Potter%'));

-- виводить всі книги, котрі не є fiction  
SELECT name FROM books b
WHERE name  NOT IN (SELECT name FROM books b
                    INNER JOIN book2genre b2g ON b2g.book_ISBN = b.ISBN
                    WHERE b2g.genre_id IN (SELECT id FROM genre g WHERE g.name LIKE '%fiction%'));

-- якщо існують бодай якісь книги, то обираємо всі
SELECT name FROM books
WHERE EXISTS(SELECT name FROM books);

-- якщо існують якісь книги, то обери ту, що має в назві '1984'
SELECT name FROM books
WHERE EXISTS(SELECT name FROM books) AND name LIKE '%1984%';

-- вибирає всіх авторів, котрі написали одну книгу 
SELECT id, name
FROM author a
WHERE (
          SELECT COUNT(*)  -- рахує кіл-ість книг для автора
          FROM book2author b2a
          WHERE b2a.author_id = a.id
       ) = 1;

-- виводить ім'я авторів, котрі написали книги 
SELECT id, name
FROM author a
WHERE id IN (
           SELECT author_id  
           FROM book2author b2a
           WHERE b2a.author_id = a.id
       );

-- вибирає авторів котрі не написали жодної книги 
SELECT id, name
FROM author a
WHERE id NOT IN (
     SELECT author_id
     FROM book2author b2a
     WHERE b2a.author_id = a.id
                );
 -- виводить книгу з назвою 1984 
SELECT id, name
FROM author a
WHERE EXISTS (
     SELECT 1
     FROM book2author b2a
     JOIN books b ON b.id = b2a.book_id
     WHERE b2a.author_id = a.id
     AND b.name LIKE '%1984%'
);
 -- виводить автора котрий не написав книгу 1984
SELECT id, name
FROM author a
WHERE NOT EXISTS (
     SELECT 1
     FROM book2author b2a
     JOIN books b ON b.id = b2a.book_id
     WHERE b2a.author_id = a.id
     AND b.name LIKE '%1984%'
);
 -- зміне номер версії книги згідно рокам
UPDATE books
SET edition = 2
WHERE books.year_date IN (1998, 1999);

 -- зміне номер версії книги згідно рокам 
UPDATE books
 SET edition = 2
     WHERE books.year_date NOT IN (1998, 1999, 2000, 2001) AND books.name LIKE '%harry potter%';

-- зміне всі ім'я на Rowling де автор не писав книгу 1984
UPDATE author a
SET name = 'Rowling'
WHERE NOT EXISTS (
     SELECT 1
     FROM book2author b2a
        JOIN books b ON b.id = b2a.book_id
        WHERE b2a.author_id = a.id
        AND b.name LIKE '%1984%'
 );

 -- зміне ім'я на J.K. Rowling де автор написав книги про Гаррі Поттера 
UPDATE author a
SET name = 'J.K. Rowling'
WHERE  EXISTS (
     SELECT 1
     FROM book2author b2a
     JOIN books b ON b.id = b2a.book_id
     WHERE b2a.author_id = a.id
     AND b.name LIKE '%Harry Potter%'
 );
-- змінити ім'я автора там, де назва його книги співпадає 
UPDATE author a
SET name = 'Scot Fitzgerald'
WHERE a.id IN (SELECT b2a.author_id FROM book2author b2a 
               JOIN books b on b.id = b2a.book_id
                WHERE b.name LIKE '%great Gat%');

-- зміне ім'я на J.K. Rowling де автор написав книги про Гаррі Поттера 
UPDATE author a
SET name = 'J.K. Rowling'
WHERE name IN (
     SELECT name
     FROM book2author b2a
     JOIN books b ON b.id = b2a.book_id
     WHERE b2a.author_id = a.id
     AND b.name LIKE '%Harry Potter%'
 );

 -- змінює назву книги на 1984 якщо в назві цієї книги є harry potter і індекс жанру = 2 
UPDATE books b
SET name = '1984'
WHERE name IN (
     SELECT name
     FROM book2genre b2g
     JOIN books b ON b.ISBN = b2g.book_ISBN
     WHERE b2g.genre_id = 2
       AND b.name LIKE '%Harry Potter%'
 );


 -- зміне ім'я на J.K. Rowling де автор написав книги не про Гаррі Поттера 
UPDATE author a
SET name = 'J.K. Rowling'
WHERE name IN (
     SELECT name
     FROM book2author b2a
     JOIN books b ON b.id = b2a.book_id
     WHERE b2a.author_id = a.id
     AND b.name LIKE '%Harry Potter%'
 );




-- змінює ISBN
UPDATE books
SET ISBN = '09424242349'
WHERE ISBN = '0942424223';

 -- видаляє записи книг, де номер жанру книги = 121
DELETE FROM books
WHERE year_date IN (SELECT year_date FROM book2genre b2g
                    WHERE b2g.genre_id = 121);
-- видаляє записи книг, де номер жанру книги != 121
DELETE FROM books
WHERE year_date NOT IN (SELECT year_date FROM book2genre b2g
                     WHERE b2g.genre_id = 121);
-- видаляє записи книг де індекс жанру = 121 
 DELETE FROM books
 WHERE EXISTS (
     SELECT 1
     FROM book2genre b2g
     WHERE b2g.genre_id = 121
     AND b2g.book_ISBN = books.ISBN
 );

-- видаляє записи, де в книги нема жанру з індексом 121 
 DELETE FROM books
 WHERE NOT EXISTS (
     SELECT 1
     FROM book2genre b2g
     WHERE b2g.genre_id = 121
     AND b2g.book_ISBN = books.ISBN
 );

-- видаляє книги котрі брали в лоан і котрі мають айді 1 чи 2 
DELETE FROM books b
WHERE b.id IN (SELECT b2l.book_id FROM book2loan b2l
               WHERE b2l.book_id IN (1,2));                 


-- видаляє запис автора котрий написав книгу з даним ISBN 
DELETE FROM author
WHERE author.id = (SELECT author_id FROM book2author b2a 
                   JOIN books b ON b.id = b2a.book_id
                    WHERE ISBN = '324324324');

-- видалить усіх customer`ів, котрі брали книги в loan
DELETE FROM customer c
WHERE c.id IN (SELECT customer_id FROM book2loan
               JOIN loan ON loan_id = id 
               WHERE c.id = loan.customer_id);


-- UNION/UNION ALL/EXCEPT/INTERSECT 
-- виведе всі книги котрі не підпадають під умову що їх брали в лоан і автор РОулінг 
SELECT b1.name FROM books b1 
EXCEPT
SELECT b.name FROM books b
JOIN book2author b2a ON b.id = b2a.book_id
JOIN author a ON a.id = author_id
right JOIN book2loan b2l ON b2l.book_id = b.id
WHERE a.name LIKE '%rowling%';

-- виведе книги котрі мають жанром драму і котрі брали в в лоан 
SELECT b.name FROM books b                   -- вибирає книги, котрі мають жанром драму
JOIN book2genre b2g ON b2g.book_ISBN = b.ISBN
JOIN genre g ON g.id = b2g.genre_id
WHERE g.name LIKE '%drama%'
INTERSECT
SELECT b.name FROM books b                  -- обирає книги, котрі люди брали в лоан 
JOIN book2author b2a ON b.id = b2a.book_id
JOIN author a ON a.id = author_id
RIGHT JOIN book2loan b2l ON b2l.book_id = b.id;

-- об'єднує кастомерів, котрі взагалі не брали книг з тими, хто брали тільки одну книгу
SELECT customer.id, name, COUNT(loan.id) FROM customer
LEFT JOIN loan ON loan.customer_id = customer.id
GROUP BY customer.id
HAVING COUNT(loan.id) = 0
UNION ALL
SELECT customer.id, name, COUNT(loan.id) FROM customer
LEFT JOIN loan ON loan.customer_id = customer.id
GROUP BY customer.id
HAVING COUNT(loan.id) = 1;

-- тут знаходиться об'єднання кастомерів котрі зовсім нічого не брали в лоан з тими, хто хочаб щось брав
SELECT customer.id, name FROM customer -- по факту отримається просто сет усіх кастомерів 
LEFT JOIN loan ON loan.customer_id = customer.id
GROUP BY customer.id
HAVING COUNT(loan.id) = 0
UNION
SELECT customer.id, name FROM customer
LEFT JOIN loan ON loan.customer_id = customer.id
GROUP BY customer.id
HAVING COUNT(loan.id) > 0
















