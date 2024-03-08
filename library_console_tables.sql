-- create a table
CREATE TABLE books (
                       id INTEGER PRIMARY KEY AUTO_INCREMENT,
                       name VARCHAR(255) NOT NULL,
                       ISBN VARCHAR(255),   -- lowercase  not text
                       edition INTEGER NOT NULL,
                       year_date YEAR NOT NULL,
                       dollar_price INTEGER NOT NULL,
                       publisher_id INT,
                       FOREIGN KEY (publisher_id) REFERENCES publisher(id),
                       INDEX ISBN_index (ISBN)

);
-- insert some values into books

CREATE TABLE author (
                        id INTEGER PRIMARY KEY AUTO_INCREMENT,
                        name VARCHAR(255) NOT NULL,
                        date_of_birth DATE NOT NULL, -- more apropriate name
                        nationality VARCHAR(255),
                        biography TEXT
);


CREATE TABLE book2author (  -- junction table
                             book_id INT,
                             author_id INT,
                             PRIMARY KEY (book_id, author_id),  -- кожний запис є унікальним з точністю до пари значень 
                             FOREIGN KEY (book_id) references books(id),
                             FOREIGN KEY (author_id) references author(id)
);


CREATE TABLE publisher (
                           id INTEGER PRIMARY KEY AUTO_INCREMENT,
                           name VARCHAR(255) NOT NULL,
                           address VARCHAR(255),
                           phone VARCHAR(20),
                           website VARCHAR(300)
);


CREATE TABLE genre (
                       id INTEGER PRIMARY KEY AUTO_INCREMENT,
                       name VARCHAR(255) NOT NULL,
                       description TEXT
);

CREATE TABLE book2genre (  -- junction table
                            book_ISBN varchar(255),
                            genre_id INT,
                            FOREIGN KEY (book_ISBN) REFERENCES books(ISBN),
                            FOREIGN KEY (genre_id) REFERENCES genre(id),
                            PRIMARY KEY (book_ISBN, genre_id)  -- пара не може повторюватись
);


CREATE TABLE customer (
                          id INTEGER PRIMARY KEY AUTO_INCREMENT,
                          name VARCHAR(255) NOT NULL,
                          address VARCHAR(255) NOT NULL,
                          phone VARCHAR(255) NOT NULL,
                          email VARCHAR(255) NOT NULL,
                          password_hash VARCHAR(255) NOT NULL,   -- password зарезервована назва
                          password_salt VARCHAR(255) NOT NULL
);



CREATE TABLE loan (
                      id INTEGER PRIMARY KEY AUTO_INCREMENT,
                      customer_id INTEGER NOT NULL,
                      loan_date DATE NOT NULL,
                      due_date DATE NOT NULL,
                      return_date DATE,
                      FOREIGN KEY (customer_id) REFERENCES customer(id)
);


CREATE TABLE book2loan(
                          book_id INT,
                          loan_id INT,
                          FOREIGN KEY (loan_id) REFERENCES loan(id),
                          FOREIGN KEY (book_id) REFERENCES books(id),
                          PRIMARY KEY (book_id, loan_id)
);
