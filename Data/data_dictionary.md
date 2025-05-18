# Data Dictionary

This document provides detailed information about each field in our data warehouse.

## Dimension Tables

### Employee Dimension (dim_employee)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| employee_id | INTEGER | Primary key | 1001 |
| first_name | VARCHAR(100) | Employee's first name | John |
| last_name | VARCHAR(100) | Employee's last name | Smith |
| department_id | INTEGER | Foreign key to department dimension | 5 |
| designation_id | INTEGER | Foreign key to designation dimension | 3 |
| branch_id | INTEGER | Foreign key to branch dimension | 2 |
| date_of_birth | DATE | Employee's birth date | 1985-03-15 |
| hire_date | DATE | Date employee was hired | 2020-06-01 |
| termination_date | DATE | Date employee left (null if still employed) | 2023-12-15 |
| email | VARCHAR(150) | Employee's email address | john.smith@company.com |
| phone | VARCHAR(15) | Contact phone number | 555-123-4567 |
| is_active | BOOLEAN | Whether employee is currently active | TRUE |
| effective_start_date | DATE | Start date of record validity | 2020-06-01 |
| effective_end_date | DATE | End date of record validity (null if current) | NULL |

### Department Dimension (dim_department)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| department_id | INTEGER | Primary key | 5 |
| department_name | VARCHAR(100) | Department name | Finance |
| no_of_employees | INTEGER | Number of employees in department | 42 |

### Designation Dimension (dim_designation)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| designation_id | INTEGER | Primary key | 3 |
| designation_name | VARCHAR(100) | Job title/position name | Lead Finance |
| job_level | INTEGER | Hierarchical job level (higher = more senior) | 4 |
| job_grade | VARCHAR(10) | Salary grade code | G5 |

### Branch Dimension (dim_branch)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| branch_id | INTEGER | Primary key | 2 |
| branch_name | VARCHAR(100) | Name of the branch | New York HQ |
| branch_city | INTEGER | Foreign key to city dimension | 15 |
| branch_state | INTEGER | Foreign key to state dimension | 4 |

### Date Dimension (dim_date)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| date_id | INTEGER | Primary key | 20240115 |
| date | DATE | Calendar date | 2024-01-15 |
| month | INTEGER | Month number (1-12) | 1 |
| year | INTEGER | Year | 2024 |
| day_of_month | INTEGER | Day of month (1-31) | 15 |
| day_of_week | INTEGER | Day of week (1=Monday, 7=Sunday) | 2 |
| is_weekend | BOOLEAN | Whether date is a weekend | FALSE |
| quarter | VARCHAR(2) | Quarter identifier | Q1 |

### Deductions Dimension (dim_deduction)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| deduction_id | INTEGER | Primary key | 5001 |
| employee_id | INTEGER | Foreign key to employee | 1001 |
| deduction_type | VARCHAR(50) | Type of deduction | Tax |
| deduction_date | DATE | Date of deduction | 2024-01-31 |
| deduction_amount | DECIMAL(10,2) | Amount deducted | 1250.00 |

### Overtime Dimension (dim_overtime)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| overtime_id | INTEGER | Primary key | 7001 |
| employee_id | INTEGER | Foreign key to employee | 1001 |
| overtime_date | DATE | Date overtime was worked | 2024-01-15 |
| overtime_hours | DECIMAL(10,2) | Hours of overtime | 3.5 |
| overtime_rate | DECIMAL(10,2) | Hourly overtime rate | 30.00 |

### State Dimension (dim_state)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| state_id | INTEGER | Primary key | 4 |
| state_name | VARCHAR(50) | Name of state | New York |
| country | VARCHAR(50) | Country name | USA |

### City Dimension (dim_city)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| city_id | INTEGER | Primary key | 15 |
| city_name | VARCHAR(50) | Name of city | New York City |
| state_id | INTEGER | Foreign key to state | 4 |

## Fact Table

### Payroll Fact Table (fact_payroll)

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| payroll_id | INTEGER | Primary key | 10001 |
| employee_id | INTEGER | Foreign key to employee | 1001 |
| department_id | INTEGER | Foreign key to department | 5 |
| designation_id | INTEGER | Foreign key to designation | 3 |
| overtime_id | INTEGER | Foreign key to overtime | 7001 |
| deduction_id | INTEGER | Foreign key to deduction | 5001 |
| date_id | INTEGER | Foreign key to date | 20240131 |
| branch_id | INTEGER | Foreign key to branch | 2 |
| base_pay | DECIMAL(10,2) | Base salary amount | 8500.00 |
| overtime_cost | DECIMAL(10,2) | Cost of overtime (hours * rate) | 105.00 |
| deduction_amount | DECIMAL(10,2) | Total deductions | 1250.00 |
| net_pay | DECIMAL(10,2) | Net pay after deductions | 7355.00 |
