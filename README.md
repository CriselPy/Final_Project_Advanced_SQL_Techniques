# Advanced SQL Techniques - Final Project

[![MySQL](https://img.shields.io/badge/MySQL-v8.0-3f51b5.svg)](https://www.mysql.com/)
[![Workbench](https://img.shields.io/badge/Workbench-v8.0.25-lightblue.svg)](https://dev.mysql.com/downloads/workbench/)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/blob/main/LICENSE/)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-6495ed.svg)](#-contributing)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Cristina_Ortega-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/cristina-ortega-451750275/)
[![GitHub](https://img.shields.io/badge/GitHub-CriselPy-pink?logo=github&style=flat-square)](https://github.com/CriselPy)
[![GitHub stars](https://img.shields.io/github/stars/CriselPy/Final_Project_Advanced_SQL_Techniques?style=social&label=Stars)](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/stargazers)
[![Issues](https://img.shields.io/github/issues/CriselPy/Final_Project_Advanced_SQL_Techniques?style=flat-square&color=673ab7)](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/issues)



## 📋 Table of Contents
- [Project Overview](#-project-overview)
- [Technologies Used](#-technologies-used)
- [Installation](#-installation)
- [Database Setup](#-database-setup)
- [Exercises](#-exercises)
  - [Exercise 1: Using Joins](#exercise-1-using-joins)
  - [Exercise 2: Creating a View](#exercise-2-creating-a-view)
  - [Exercise 3: Creating a Stored Procedure](#exercise-3-creating-a-stored-procedure)
  - [Exercise 4: Using Transactions](#exercise-4-using-transactions)
- [Usage Examples](#-usage-examples)
  - [Example 1: Query to Get School Data with Safety Ratings](#example-1-query-to-get-school-data-with-safety-ratings)
  - [Example 2: Updating School Leadership Score](#example-2-updating-school-leadership-score)
- [File and Interaction](#-file-and-interaction)
- [Resources](#-resources)
- [Contributing](#-contributing)
- [Author](#-author)
- [License](#-license)


## 📖 Project Overview

This project is part of the "Advanced SQL Techniques" course, where we explore complex SQL operations in MySQL. The exercises included here demonstrate the use of joins, views, stored procedures, and transactions to solve practical data analysis problems based on datasets from the city of Chicago.

## 🛠 Technologies Used

- **MySQL 8.0**: A relational database management system used for storing, retrieving, and managing the data.
- **MySQL Workbench 8.0.25**: A unified visual tool for database architects, developers, and DBAs.
- **IBM Skills Network Labs**: A virtual lab environment used for database management and SQL queries.

## ⚙️ Installation

To run this project locally, you need to have MySQL and MySQL Workbench installed on your system.

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/advanced-sql-techniques.git
   cd advanced-sql-techniques
   
## ⚙️ Set up MySQL

1. **Set up MySQL:**
   - Make sure MySQL service is running on your local machine.
   - Open MySQL Workbench and connect to your local MySQL server.

2. **Import the SQL file:**
   - In MySQL Workbench, go to `File > Open SQL Script` and select the provided `.sql` file.
   - Execute the script to set up the database and tables.

## 🗄️ Database Setup

This project uses a database named `Mysql_Learners`. The database contains three tables:

- `chicago_public_schools`
- `chicago_socioeconomic_data`
- `chicago_crime`

The data is imported using SQL dump files, which are executed as part of the database setup.

## 📚 Exercises

## Exercise 1: Using Joins

### Question 1

Write and execute an SQL query to list the names of the schools, community names, and the average student attendance for communities with a hardship index of 98.
```sql
SELECT P_SL.NAME_OF_SCHOOL, P_SL.COMMUNITY_AREA_NAME, P_SL.AVERAGE_STUDENT_ATTENDANCE
FROM chicago_public_schools AS P_SL
LEFT JOIN chicago_socioeconomic_data AS socio
ON P_SL.COMMUNITY_AREA_NAME = socio.COMMUNITY_AREA_NAME
WHERE socio.HARDSHIP_INDEX = 98;
```
### Question 2

Write and execute an SQL query to list all crimes that occurred in a school. Include the case number, type of crime, and the name of the community.
```sql
SELECT ch_crime.CASE_NUMBER, ch_crime.PRIMARY_TYPE, socio.COMMUNITY_AREA_NAME
FROM chicago_crime AS ch_crime
LEFT JOIN chicago_socioeconomic_data AS socio
ON ch_crime.COMMUNITY_AREA_NUMBER = socio.COMMUNITY_AREA_NUMBER
WHERE ch_crime.LOCATION_DESCRIPTION LIKE '%SCHOOL%'
ORDER BY ch_crime.CASE_NUMBER, socio.COMMUNITY_AREA_NAME;

```
### Exercise 2: Creating a View

**Question 1:**

Create a view showing specific columns with new names.
```sql
CREATE VIEW Chicago_p_schools_v AS
SELECT NAME_OF_SCHOOL AS School_Name,
       Safety_Icon AS Safety_Rating,
       Family_Involvement_Icon AS Family_Rating,
       Environment_Icon AS Environment_Rating,
       Instruction_Icon AS Instruction_Rating,
       Leaders_Icon AS Leaders_Rating,
       Teachers_Icon AS Teachers_Rating
FROM chicago_public_schools;
```
### Verifying the View

To verify the view and return all columns:
```sql
SELECT * FROM Chicago_p_schools_v;
```
To return only the school name and the leaders rating:
```sql
SELECT School_Name, Leaders_Rating FROM Chicago_p_schools_v;
```
## Exercise 3: Creating a Stored Procedure

### Question 1

Write the structure of a query to create or replace a stored procedure called `UPDATE_LEADERS_SCORE`.
```sql
DELIMITER $$
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT, IN in_Leader_Score INT)
BEGIN
    UPDATE chicago_public_schools
    SET Leaders_Score = in_Leader_Score
    WHERE School_ID = in_School_ID;
END $$
DELIMITER ;
```
### Question 2

Within your stored procedure, write an SQL statement to update the `Leaders_Score` field. This is already included in the procedure above.

### Question 3

Within your stored procedure, write an `IF` statement to update the `Leaders_Icon` field.
```sql
DELIMITER $$
CREATE PROCEDURE UPDATE_LEADERS_ICON(IN in_School_ID INT, IN in_Leader_Score INT)
BEGIN
    -- Exception handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- Undo changes in case of error
        RESIGNAL;  -- Propagate the error
    END;

    START TRANSACTION;  -- Start a transaction

    -- Conditional update for Leaders_Icon based on the score
    IF in_Leader_Score >= 0 AND in_Leader_Score <= 19 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Very weak'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score <= 39 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Weak'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score <= 59 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Average'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score <= 79 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Strong'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score <= 99 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Very strong'
        WHERE School_ID = in_School_ID;
    ELSE
        -- Raise an error if the score is not within the allowed range
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid value for in_Leader_Score. The value must be between 0 and 99.';
    END IF;

    COMMIT;  -- Confirm the transaction if everything is okay
END $$
DELIMITER ;
```
### Testing the Procedure

Test the procedure with valid and invalid data:

```sql
CALL UPDATE_LEADERS_ICON(610185, 50); -- Valid score
````

```sql
CALL UPDATE_LEADERS_ICON(610185, 101); -- Invalid score
```
## Exercise 4: Using Transactions

### Question 1

Update the definition of your stored procedure. Add a generic `ELSE` clause that performs a rollback of the current work if the score does not fit into any of the previous categories. This is already included in the `UPDATE_LEADERS_ICON` stored procedure defined above.

### Question 2

Update the definition of your stored procedure again. Add a statement to commit the unit of work at the end of the procedure. This is also included in the `UPDATE_LEADERS_ICON` stored procedure defined above.

``
## 📚 Resources

- [MySQL 8.0 Documentation](https://dev.mysql.com/doc/refman/8.0/en/)
- [MySQL Workbench Manual](https://dev.mysql.com/doc/workbench/en/)
- [IBM Skills Network Labs](https://skills.network/)
- [SQL Transactions](https://dev.mysql.com/doc/refman/8.0/en/commit.html)
- [Creating and Using Views](https://dev.mysql.com/doc/refman/8.0/en/views.html)
- [Stored Procedures](https://dev.mysql.com/doc/refman/8.0/en/stored-routines.html)

## 📂 Exercise File and Interaction Data

To complete the exercises and setups described in this project, you can use the provided SQL file. This file contains the database structure and the necessary data to run the queries and stored procedures.

### Link to the File

- [final_project.sql](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/blob/main/final_project.sql)
## 📂 File and Interaction

The following files are included in this repository:

- **[`chicago_public_schools.sql`](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/blob/main/chicago_public_schools.sql)**: Contains the SQL commands to create and populate the `chicago_public_schools` table.
- **[`chicago_socioeconomic_data.sql`](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/blob/main/chicago_socioeconomic_data.sql)**: Contains the SQL commands to create and populate the `chicago_socioeconomic_data` table.
- **[`chicago_crime.sql`](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/blob/main/chicago_crime.sql)**: Contains the SQL commands to create and populate the `chicago_crime` table.

The data is imported using these SQL dump files, which are executed as part of the database setup.

### How to Use the Files

1. **Download the Files:**
   - Click on the links above to download each SQL file.

2. **Import the SQL Files into MySQL Workbench:**
   - Open MySQL Workbench and connect to your MySQL server.
   - Go to `File > Open SQL Script` and select the downloaded `.sql` files in the order listed above.
   - Execute each script to create the tables and load the data into your database.

3. **Verify the Database Setup:**


   - After importing the SQL files, verify that the tables `chicago_public_schools`, `chicago_socioeconomic_data`, and `chicago_crime` are correctly created and populated with data.

1. **Download the file:**
   - Click the link to download the `final_project.sql` file to your local machine.

2. **Import the file into MySQL Workbench:**
   - Open MySQL Workbench and connect to your MySQL server.
   - Go to `File > Open SQL Script` and select the `final_project.sql` file.
   - Execute the script to create the tables and load the data into your database.

3. **Run Exercises:**
   - Use the queries and procedures provided in the "Exercises" section to interact with the data.

## 🤝 Contributing

This project is a personal solution to an exercise from the IBM "Advanced SQL Techniques" course. Since it was completed individually, no external contributions are included. However, contributions are welcome!

If you have suggestions to improve the exercises, find errors in the queries or procedures, or have ideas for adding new features, I encourage you to contribute. You can do so in the following ways:

- **Open an Issue:** If you find a bug or have a suggestion, open an [issue](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/issues) to discuss it.
- **Submit a Pull Request:** If you have made improvements to the code or fixed a problem, feel free to submit a pull request.
- **Share Your Own Solutions:** If you want to share your own solutions or approaches to the exercises, you can do so in the repository comments.

I appreciate any constructive feedback that can help improve the content. Your contributions will be recognized and appreciated.

[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-6495ed.svg)](#-contributing)

## ✍️ Author

This project was completed by 
# Crisel Nublo🪻

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

