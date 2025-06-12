# MedtechWebapp Project

This repository contains the MedtechWebapp project, a web application developed to manage products, orders, batches, and deliveries for a medical logistics system. The project uses an Oracle database and Java servlets for backend functionality.

## SQLScripts Folder

Inside the `SQLScripts` folder, you will find four important SQL scripts used to set up and manage the database:

* **Viste.sql**
  This script creates all the necessary database views used by the application. Views are used to simplify complex queries and organize data presentation.

* **medtech.sql**
  This is the main script for creating the entire database schema. It defines all tables, types, procedures, and other database objects under the user `medtech`.

* **query.sql**
  This file contains various test queries. Some are based on the five operations described in the project requirements. They help verify the correct behavior of database features like triggers, views, and stored procedures.

* **system.sql**
  This script is run by the `system` user and is responsible for creating the `medtech` user. It grants all necessary privileges to `medtech`. Additionally, this script creates a table to store registered users' credentials — including usernames, passwords, and roles.
