# Library Management System Database

This MySQL database is designed to manage a library's collection of books, loans, customers, and the relationships between them. It also includes stored procedures for common database operations and a folder for connecting the database to a .NET application.

## Tables

1. **books**: Contains information about each book in the library, such as title, author, genre, and availability.

2. **loans**: Tracks loans made to customers, including the book ID, customer ID, loan date, and return date.

3. **book2loan**: Represents the many-to-many relationship between books and loans, linking each book to its loan record.

4. **book2genre**: Maps books to their respective genres.

5. **book2author**: Maps books to their respective authors.

6. **customers**: Stores information about library customers, including their name, contact information, and any fines they may have.

## Files

1. `queries.sql`: Contains a collection of SQL queries for performing various operations on the database, such as adding a new book or updating a customer's information.

2. `st_procedures.sql`: Includes stored procedures for common database tasks, such as checking out a book or calculating fines for overdue books.

3. `executions.sql`: Provides examples of how to execute the stored procedures in `st_procedures.sql`.

4. `pa_3_bonus`: Folder containing logic to connect the database to a .NET application, allowing for easy integration into a library management system software.

## Purpose

The primary purpose of this database is to efficiently manage a library's collection of books, loans, and customers. It provides a structured way to store and retrieve information, making it easier for librarians to track book availability, loan history, and customer details.

