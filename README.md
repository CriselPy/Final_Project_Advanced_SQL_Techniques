# Advanced SQL Techniques - Final Project

![MySQL](https://img.shields.io/badge/MySQL-v8.0-blue.svg)
![Workbench](https://img.shields.io/badge/Workbench-v8.0.25-lightblue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Cristina_Ortega-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/cristina-ortega-451750275/)
[![GitHub](https://img.shields.io/badge/GitHub-CriselPy-black?logo=github&style=flat-square)](https://github.com/CriselPy)
[![GitHub stars](https://img.shields.io/github/stars/CriselPy/Final_Project_Advanced_SQL_Techniques?style=social&label=Stars)](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/stargazers)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Cristina_Ortega-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/cristina-ortega-451750275/)
[![GitHub](https://img.shields.io/badge/GitHub-CriselPy-black?logo=github&style=flat-square)](https://github.com/CriselPy)
[![GitHub stars](https://img.shields.io/github/stars/CriselPy/Final_Project_Advanced_SQL_Techniques?style=social&label=Stars)](https://github.com/CriselPy/Final_Project_Advanced_SQL_Techniques/stargazers)

## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Exercises](#exercises)
  - [Exercise 1: Using Joins](#exercise-1-using-joins)
  - [Exercise 2: Creating a View](#exercise-2-creating-a-view)
  - [Exercise 3: Creating a Stored Procedure](#exercise-3-creating-a-stored-procedure)
  - [Exercise 4: Using Transactions](#exercise-4-using-transactions)
- [Usage Examples](#usage-examples)
  - [Example 1: Query to Get School Data with Safety Ratings](#example-1-query-to-get-school-data-with-safety-ratings)
  - [Example 2: Updating School Leadership Score](#example-2-updating-school-leadership-score)
- [Resources](#resources)
- [File and Interaction](#file-and-interaction)
- [Contributing](#contributing)
- [License](#license)

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

### Exercise 1: Using Joins

In this exercise, we explore how to join multiple tables to extract meaningful insights from the data.

#### Question 1: List School Names, Community Names, and Average Attendance
```sql
SELECT P_SL.NAME_OF_SCHOOL, P_SL.COMMUNITY_AREA_NAME, P_SL.AVERAGE_STUDENT_ATTENDANCE
FROM chicago_public_schools AS P_SL
LEFT JOIN chicago_socioeconomic_data AS socio
ON P_SL.COMMUNITY_AREA_NAME = socio.COMMUNITY_AREA_NAME
WHERE socio.HARDSHIP_INDEX = 98;
```
#### Question 2: List Crimes That Took Place at a School
```sql
SELECT ch_crime.CASE_NUMBER, ch_crime.PRIMARY_TYPE, socio.COMMUNITY_AREA_NAME
FROM chicago_crime AS ch_crime
LEFT JOIN chicago_socioeconomic_data AS socio
ON ch_crime.COMMUNITY_AREA_NUMBER = socio.COMMUNITY_AREA_NUMBER
WHERE ch_crime.LOCATION_DESCRIPTION LIKE '%SCHOOL%'
ORDER BY ch_crime.CASE_NUMBER, socio.COMMUNITY_AREA_NAME;

```
### Exercise 2: Creating a View

Create a view to ensure privacy and restrict access to sensitive information in the database.

#### Creating the View
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
### Exercise 3: Creating a Stored Procedure

This exercise focuses on creating a stored procedure to update scores and their corresponding icons in the `chicago_public_schools` table.

#### Creating the Stored Procedure
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
### Exercise 4: Using Transactions

Modify the stored procedure to handle transactions and ensure data integrity.

#### Creating the Stored Procedure with Transactions

```sql
DELIMITER $$
CREATE PROCEDURE UPDATE_LEADERS_ICON(IN in_School_ID INT, IN in_Leader_Score INT)
BEGIN
    -- Exception handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- Undo changes if an error occurs
        RESIGNAL;  -- Propagate the error
    END;

    START TRANSACTION;  -- Begin a transaction

    -- Conditional logic to update Leaders_Icon based on score
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
        -- Signal an error if the score is out of range
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid value for in_Leader_Score. Value must be between 0 and 99.';
    END IF;

    COMMIT;  -- Commit the transaction if all goes well
END $$
DELIMITER ;
```
## 💡 Usage Examples

Provide sample queries or use cases that show how to apply the exercises or stored procedures in real scenarios.

#### Example 1: Query to Get School Data with Safety Ratings
```sql
SELECT * FROM Chicago_p_schools_v WHERE Safety_Rating = 'Strong';
```
#### Example 2: Updating School Leadership Score
```sql
-- Call the stored procedure to update the leadership score of a school with ID 101 to 85
CALL UPDATE_LEADERS_SCORE(101, 85);

```
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

- [final_project.sql](https://github.com/CriselPy/advanced-sql-techniques/blob/main/final_project.sql)

### How to Interact with the File

1. **Download the file:**
   - Click the link to download the `final_project.sql` file to your local machine.

2. **Import the file into MySQL Workbench:**
   - Open MySQL Workbench and connect to your MySQL server.
   - Go to `File > Open SQL Script` and select the `final_project.sql` file.
   - Execute the script to create the tables and load the data into your database.

3. **Run Exercises:**
   - Use the queries and procedures provided in the "Exercises" section to interact with the data.

## 🤝 Contributing

This project is a personal solution to an exercise from the Advanced SQL Techniques course provided by IBM. Since it was worked on individually, there are no external contributions included. However, if you have suggestions to improve the exercises or find errors in the queries and procedures, please feel free to open an issue to discuss potential improvements.

If you wish to share your own solutions or approaches to these exercises, you are welcome to do so in the repository comments. I appreciate any constructive feedback that can help enhance the content.

## ✍️ Author

This project was completed by #[Crisel Nublo🪻](https://github.com/crisel-nublo).

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

