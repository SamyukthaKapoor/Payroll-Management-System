# ETL Implementation with Talend

This directory contains all the Talend jobs and components used for implementing the ETL processes in our Payroll Management System Data Warehouse.

## Directory Structure

- `/jobs` - Contains exported Talend job files
- `/screenshots` - Visual documentation of job designs
- `/configs` - Configuration files for database connections
- `/scripts` - Additional scripts used in transformations

## Job Hierarchy

Our ETL implementation follows this job hierarchy:

1. `DWH_controlflow.job` - Master job orchestrating the entire ETL process
   - `load_dimensions.job` - Loads all dimension tables
     - `load_employee_dim.job`
     - `load_department_dim.job`
     - `load_designation_dim.job`
     - `load_branch_dim.job`
     - `load_date_dim.job`
     - `load_deduction_dim.job`
     - `load_overtime_dim.job`
     - `load_statecity_dim.job`
   - `load_facts.job` - Loads fact tables after dimensions
     - `load_payroll_fact.job`

## Transformation Logic

The ETL processes implement these key transformations:

1. **Sequential to Primary Key Transformation**: Converting sequential IDs to surrogate keys
2. **Date Format Standardization**: Converting all dates to YYYY-MM-DD format
3. **Data Type Conversion**: Ensuring appropriate data types for all fields
4. **Calculated Fields**: Creating derived values including:
   - Average Base Pay
   - Average Deductions
   - Overtime Cost (overtime_hours * overtime_rate)
   - Net Pay (base_pay + overtime_cost - deduction_amount)

## Running the ETL Jobs

To run the ETL jobs:

1. Import the `.item` files into Talend Open Studio
2. Update connection parameters in the context variables
3. Run the master job `DWH_controlflow.job`

## Error Handling

Error handling is implemented through:

1. Rejection flows for records with missing key fields
2. Error logging for failed transformations
3. Email notifications for job failures
