# Payroll Management System Data Warehouse

## Project Overview
This project implements a comprehensive data warehouse solution for payroll management, developed as part of the Data Warehousing & Integration course (IE 6750, Fall 2024) at Northeastern University. The system integrates multiple data sources, implements ETL processes using Talend, and provides analytical dashboards for payroll optimization.

## Problem Statement
How can organizations optimize compensation structures to balance cost efficiency and employee satisfaction while minimizing attrition, considering departmental and positional trends?

## Objectives
1. Optimize payroll structures for cost-effectiveness and employee satisfaction
2. Reduce attrition rates using compensation-related insights
3. Analyze overtime, deductions, and salary trends for actionable recommendations
4. Create a unified data warehouse integrating multiple payroll data sources
5. Implement efficient ETL processes for data integration and transformation

## Team Members (Group 9)
- Samyuktha Kapoor (rajeshkapoor.s@northeastern.edu)
- Harshitha Chandrashekar (chandrashekar.h@northeastern.edu)

## Technologies Used
- **PostgreSQL**: Primary database for the data warehouse
- **Talend Open Studio**: ETL tool for data integration and transformation
- **Power BI**: Dashboard visualization and reporting

## Key Findings
- **Attrition Analysis**: R&D department has the highest attrition rate at 5.0%, followed by Legal at 4.0%, IT at 3.3%, Engineering at 2.9%, and HR at 2.5%, while Finance has the lowest at 0.0%
- **Payroll Costs**: Finance, IT, Legal, and HR departments have the highest payroll costs
- **Compensation Structure**: Lead positions in Operations, Finance, and Legal have the highest base pay at $160,000
- **Deductions Trend**: Finance department consistently shows the highest monthly deductions, with peaks in March ($4,856) and July ($4,771)
- **Overtime Costs**: Q3 shows significant overtime expenditure across departments, particularly in IT and Logistics

## Data Architecture
The data warehouse follows a star schema design with:
- 8 dimension tables (Employee, Department, Designation, Branch, Date, Deduction, Overtime, State/City)
- 1 fact table (Payroll)

## Data Sources
As documented in our project, we utilized:
- CSV file for Date Dimension
- CSV file for State and City Dimensions
- PostgreSQL Database with statically generated data

## Installation & Setup

### Prerequisites
- PostgreSQL 14 or higher
- Talend Open Studio for Data Integration 8.0 or higher
- Tableau (for dashboard visualization)

### Database Setup
1. Clone this repository
2. Run the schema creation scripts from the `SQL/schema` directory
3. Import the dimension and fact table definitions

### ETL Process Setup
1. Import the Talend project files from the `ETL/talend_jobs` directory
2. Configure connection parameters to match your environment
3. Execute the `DWH_controlflow` job to run the complete ETL process

### Dashboard Setup
1. Open the Power BI template provided in the `Dashboard` directory
2. Connect to your PostgreSQL data warehouse
3. Refresh the data to visualize current insights

## Repository Structure
- `/Documentation`: Detailed project documentation
- `/SQL`: Database schema and query definitions
- `/ETL`: Talend job exports and transformation scripts
- `/Dashboard`: Power BI templates and exported visualizations
- `/Data`: Sample data files and data dictionary
