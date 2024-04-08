INSERT INTO books (name, ISBN, edition, year_date, dollar_price,  publisher_id) VALUES
                                                                                    ('Harry Potter and the chamber of secrets', '9788831000154', 2, 2014, 100, 2),
                                                                                    ( 'Harry Potter and the death hollows', '97888310001555', 3, 2017, 115, 2),
                                                                                    ( 'Harry Potter and the halfblood prince', '9788831000166', 2, 2016, 120, 3),
                                                                                    ( 'Harry Potter and the philosofer`s stone', '9788831000120', 1, 2010, 150, 4),
                                                                                    ( 'Harry Potter and the prisoner of Azkaban', '9788831000133', 6, 2020, 95, 1),
                                                                                    ( 'Harry Potter and the goblet of fire', '9788831000100', 3, 2022, 200, 2),
                                                                                    ( '1984', '9788831709832', 10, 2000, 280, 5),
                                                                                    ( 'The lord of the rings', '9788831008710', 1, 2021, 80, 3),
                                                                                    ( 'The great Gatsby', '9788831000215', 4, 2020, 110, 5),
                                                                                    ('Good Omens', '9788831003211', 3, 2017, 80, 5), -- authors are Terry Pratchet and Neil Gaiman 
                                                                                    ('The Guernsey Literary and Potato Peel Pie Society', '97888315032398', 1, 2018, 40, 6); -- authors are Mary Ann Shaffer and Annie Barrows

INSERT number_books_available (book_id, amount_available) VALUES 
(1,1),
(2,1),
(3,0),
(4,2),
(5,1),
(6,1),
(7,2),
(8,2),
(9,1),
(10,0),
(11,1);
CREATE TRIGGER check_positive_integer BEFORE INSERT ON number_books_available
    FOR EACH ROW
BEGIN
    IF NEW.amount_available < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Book amount must be a positive integer or zero';
    END IF;
END;
INSERT INTO author (name, date_of_birth, nationality, biography) VALUES
                                                                     ('J.K. Rowling', '1965-07-31', 'British', 'Joanne Rowling, better known by her pen name J.K. Rowling, is a British author, philanthropist, film producer, television producer, and screenwriter.'),
                                                                     ('Francis Scott Fitzgerald', '1896-09-24', 'American', 'Francis Scott Key Fitzgerald was an American novelist, essayist, screenwriter, and short-story writer. He is best known for his novels depicting the flamboyance and excess of the Jazz Age, notably "The Great Gatsby." Fitzgerald is regarded as one of the greatest American writers of the 20th century.'),
                                                                     ('J.R.R. Tolkien', '1892-01-03', 'British', 'John Ronald Reuel Tolkien, known as J.R.R. Tolkien, was an English writer, poet, philologist, and university professor.'),
                                                                     ('Terry Pratchet','1948-02-05', 'British', 'was an English author, humorist, and satirist, best known for his 41 comic fantasy novels set on the Discworld, and for the apocalyptic comedy novel Good Omens (1990) which he wrote with Neil Gaiman'),
                                                                     ('Neil Gaiman', '1950-03-10', 'British', 'English author of short fiction, novels, comic books, graphic novels, audio theatre, and screenplays. His works include the comic book series The Sandman and the novels Good Omens, Stardust, Anansi Boys, American Gods, Coraline, and The Graveyard Book. In 2023, he starred as the voice of Gef the talking mongoose in the black comedy film Nandor Fodor and the Talking Mongoose'),
                                                                     ('Mary Ann Shaffer', '1940-04-12', 'American', 'an American writer, editor, librarian, and a bookshop worker. She is noted for her posthumously published work The Guernsey Literary and Potato Peel Pie Society,[2][3] which she wrote with her niece, Annie Barrows'),
                                                                     ('Annie Barrows','1945-05-01', 'American', 'is an American editor and author. She is best known for the Ivy and Bean series of children''s books, but she has written several other books for adult readers as well.[1] With her aunt Mary Ann Shaffer she co-wrote The Guernsey Literary And Potato Peel Pie Society, which was later adapted into a film'),
                                                                     ('Jeorge Orwell', '1903-05-25','British', 'was an English novelist, essayist, journalist, and critic who wrote under the name George Orwell. His work is characterised by lucid prose, social criticism, opposition to totalitarianism, and support of democratic socialism');


-- insert values into book2author 
INSERT INTO book2author (book_id, author_id) VALUES
                                                 (1,1),
                                                 (2,1),
                                                 (3,1),
                                                 (4,1),
                                                 (5,1),
                                                 (6,1),
                                                 (7,8),
                                                 (8,3),
                                                 (9,2),
                                                 (10,4), -- two authors 
                                                 (10,5),
                                                 (11,6), -- two authors 
                                                 (11,7);


INSERT INTO publisher (name, address, phone, website) VALUES
                                                          ('HarperCollins Publishers', '195 Broadway, New York, NY 10007, United States', '+1-212-207-7000', 'https://www.harpercollins.com/'),
                                                          ('Macmillan Publishers', '120 Broadway, New York, NY 10271, United States', '+1-646-307-5151', 'https://us.macmillan.com/'),
                                                          ('Random House', '1745 Broadway, New York, NY 10019, United States', '+1-212-782-9000', 'https://www.randomhousebooks.com/'),
                                                          ('Bloomsbury Publishing', '50 Bedford Square, London, England', '+44 (0)20 7631 5600', 'https://www.bloomsbury.com/'),
                                                          ('Penguin Random House', '1745 Broadway, New York, NY 10019, United States', '+1-212-782-9000', 'https://www.penguinrandomhouse.com/'),
                                                          ('Simon & Schuster', '1230 Avenue of the Americas, New York, NY 10020, United States', '+1-212-698-7000', 'https://www.simonandschuster.com/');


INSERT INTO genre (name, description) VALUES
                                          ('Fantasy', 'Fantasy is a genre of speculative fiction involving magical elements, typically set in a fictional universe and usually inspired by mythology or folklore.'),
                                          ('Antiutopia', 'An anti-utopian novel is where a utopia is secretly a horrible place. '),
                                          ('Drama', 'Drama implies something dramatical happening'),
                                          ('Fiction', 'Fiction is the telling of stories which are not real. More specifically, fiction is an imaginative form of narrative, one of the four basic rhetorical modes. Although the word fiction is derived from the Latin fingo, fingere, finxi, fictum, "to form, create", works of fiction need not be entirely imaginary and may include real people, places, and events.'),
                                          ('Romance', ' "Two basic elements comprise every romance novel: a central love story and an emotionally-satisfying and optimistic ending." Both the conflict and the climax of the novel should be directly related to that core theme of developing a romantic relationship'),
                                          ('Historical', 'the events most likely feature historical events or take place in certain historical period');

INSERT INTO book2genre (book_ISBN, genre_id) VALUES
                                                 ('9788831000154', 1),
                                                 ('9788831000154', 3),
                                                 ('97888310001555', 1),
                                                 ('97888310001555', 3),
                                                 ('9788831000166', 1),
                                                 ('9788831000166', 3),
                                                 ('9788831000120', 1),
                                                 ('9788831000133', 3),
                                                 ('9788831000133', 1),

                                                 ('9788831000100', 1),
                                                 ('9788831000100', 3),

                                                 ('9788831709832', 2),
                                                 ('9788831709832', 3),

                                                 ('9788831008710', 4),
                                                 ('9788831008710', 3),

                                                 ('9788831000215', 3),

                                                 ('9788831000215', 5),

                                                 ('9788831003211', 1),
                                                 ('9788831003211', 4),

                                                 ('97888315032398', 4),
                                                 ('97888315032398', 5),
                                                 ('97888315032398', 6);

INSERT INTO customer (name, address, phone, email, password_hash, password_salt) VALUES
                                                                                     ('Alice Johnson', '123 Main St, Anytown, USA', '+1234567890', 'alice@example.com', SHA(CONCAT('password123' , password_salt)), '123'),
                                                                                     ('Bob Smith', '456 Elm St, Othertown, USA', '+0987654321', 'bob@example.com', SHA(CONCAT('securepassword' , password_salt)), '123'),
                                                                                     ('Emily Brown', '789 Oak St, Another Town, USA', '+1112223333', 'emily@example.com', SHA(CONCAT('mypassword', password_salt)), '123'),
                                                                                     ('Michael Davis', '321 Pine St, Somewhereville, USA', '+5556667777', 'michael@example.com', sha(CONCAT('pass123', password_salt)), '123'),
                                                                                     ('Sarah Wilson', '654 Maple St, Nowhereville, USA', '+7778889999', 'sarah@example.com', SHA(CONCAT('123456', password_salt)), '123'),
                                                                                     ('David Jones', '987 Cedar St, Anywhere, USA', '+3334445555', 'david@example.com', SHA(CONCAT('password', password_salt)), '123');

INSERT INTO loan (customer_id,  loan_date, due_date, return_date) VALUES  -- другу колонку треба прибрати 
                                                                          (1, '2024-02-06', '2024-02-20', '2024-02-19'),
                                                                          (3, '2024-02-01', '2024-02-10', '2024-02-11'), -- просрочили
                                                                          (5, '2024-02-21', '2024-03-20', '2024-03-29'), -- просрочили
                                                                          (3, '2024-02-25', '2024-03-11', '2024-03-10'),
                                                                          (2, '2023-02-25', '2023-05-11', '2023-04-10'),
                                                                          (3, '2024-01-12', '2024-02-05', '2024-02-06'),
                                                                          (1, '2024-01-26', '2024-02-14', '2024-02-10'),
                                                                          (1, '2024-01-12', '2024-02-05', '2024-02-06'),
                                                                          (3, '2024-01-12', '2024-02-05', '2024-02-06'),
                                                                          (5, '2024-01-12', '2024-02-05', '2024-02-06');

INSERT INTO book2loan (book_id, loan_id) VALUES
                                             (1,1),
                                             (3,1),
                                             (2,2),
                                             (5,2),
                                             (1,3),
                                             (4,4),
                                             (5,5),
                                             (8,6),
                                             (7,7),
                                             (8,8),
                                             (7,8),
                                             (7,9),
                                             (9,10),
                                             (1, 10);
