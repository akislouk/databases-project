# Databases Project

This project was an exercise for the Databases course at the Technical University of Crete.

## Phase A

In the first phase of the project, we were given part of a fictional University's PostgreSQL database along with an ER diagram and we were asked to complete the database schema and create the missing tables, along with some functions, triggers and views. The database was about the courses, students, professors, labs, etc. of the University. All the SQL of the database can be found in the [SQL](SQL) directory, along with backup files of the database in its initial and final state.

A detailed description of the first phase can be found [here](Phase%20A.pdf).

## Phase B

For the second phase of the project, we were asked to create a Java application that would interact with the database we created in the first phase. The application would allow the user to perform various operations, such as getting the grades of a student, inserting random lab modules and work groups, etc. The application was created using the JDBC driver for PostgreSQL. The Eclipse project of the application can be found in the [Java](Java) directory.

We were also given a backup with a much larger dataset in order to study the performance of the database using `EXPLAIN` and `EXPLAIN ANALYZE`. This backup can be found in the [SQL](SQL) directory.

A detailed description of the second phase can be found [here](Phase%20B.pdf).
