-- schema.sql - Database Schema Definition for Payroll Management System Data Warehouse

-- Create Database
CREATE DATABASE payroll_data_warehouse;

-- Connect to Database
\c payroll_data_warehouse

-- Create Schemas
CREATE SCHEMA staging;
CREATE SCHEMA dw;

-- Set Search Path
SET search_path TO dw, staging, public;

-- Create Sequence for IDs
CREATE SEQUENCE dw.seq_id START 1000;

-- Create Dimension Tables
-- Date Dimension
CREATE TABLE dw.dim_date (
    date_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,
    day_of_month INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    quarter VARCHAR(2) NOT NULL,
    CONSTRAINT date_unique UNIQUE (date)
);

-- Employee Dimension
CREATE TABLE dw.dim_employee (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department_id INTEGER NOT NULL,
    designation_id INTEGER NOT NULL,
    branch_id INTEGER NOT NULL,
    date_of_birth DATE NOT NULL,
    hire_date DATE NOT NULL,
    termination_date DATE,
    email VARCHAR(150),
    phone VARCHAR(15),
    is_active BOOLEAN DEFAULT TRUE,
    effective_start_date DATE NOT NULL,
    effective_end_date DATE
);

-- Department Dimension
CREATE TABLE dw.dim_department (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    no_of_employees INTEGER NOT NULL
);

-- Designation Dimension
CREATE TABLE dw.dim_designation (
    designation_id SERIAL PRIMARY KEY,
    designation_name VARCHAR(100) NOT NULL,
    job_level INTEGER NOT NULL,
    job_grade VARCHAR(10) NOT NULL
);

-- Branch Dimension
CREATE TABLE dw.dim_branch (
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_city INTEGER NOT NULL,
    branch_state INTEGER NOT NULL
);

-- State Dimension
CREATE TABLE dw.dim_state (
    state_id SERIAL PRIMARY KEY,
    state_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

-- City Dimension
CREATE TABLE dw.dim_city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL,
    state_id INTEGER NOT NULL,
    CONSTRAINT fk_state FOREIGN KEY (state_id) REFERENCES dw.dim_state(state_id)
);

-- Deductions Dimension
CREATE TABLE dw.dim_deduction (
    deduction_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    deduction_type VARCHAR(50) NOT NULL,
    deduction_date DATE NOT NULL,
    deduction_amount DECIMAL(10,2) NOT NULL
);

-- Overtime Dimension
CREATE TABLE dw.dim_overtime (
    overtime_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    overtime_date DATE NOT NULL,
    overtime_hours DECIMAL(10,2) NOT NULL,
    overtime_rate DECIMAL(10,2) NOT NULL
);

-- Create Fact Table
CREATE TABLE dw.fact_payroll (
    payroll_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    department_id INTEGER NOT NULL,
    designation_id INTEGER NOT NULL,
    overtime_id INTEGER,
    deduction_id INTEGER,
    date_id INTEGER NOT NULL,
    branch_id INTEGER NOT NULL,
    base_pay DECIMAL(10,2) NOT NULL,
    overtime_cost DECIMAL(10,2),
    deduction_amount DECIMAL(10,2),
    net_pay DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES dw.dim_employee(employee_id),
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES dw.dim_department(department_id),
    CONSTRAINT fk_designation FOREIGN KEY (designation_id) REFERENCES dw.dim_designation(designation_id),
    CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES dw.dim_date(date_id),
    CONSTRAINT fk_branch FOREIGN KEY (branch_id) REFERENCES dw.dim_branch(branch_id),
    CONSTRAINT fk_overtime FOREIGN KEY (overtime_id) REFERENCES dw.dim_overtime(overtime_id),
    CONSTRAINT fk_deduction FOREIGN KEY (deduction_id) REFERENCES dw.dim_deduction(deduction_id)
);

-- Create Staging Tables
CREATE TABLE staging.stg_employee (
    employee_id INTEGER NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department_id INTEGER NOT NULL,
    designation_id INTEGER NOT NULL,
    branch_id INTEGER NOT NULL,
    date_of_birth DATE NOT NULL,
    hire_date DATE NOT NULL,
    termination_date DATE,
    email VARCHAR(150),
    phone VARCHAR(15)
);

CREATE TABLE staging.stg_payroll (
    payroll_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    pay_date DATE NOT NULL,
    base_pay DECIMAL(10,2) NOT NULL,
    overtime_hours DECIMAL(10,2),
    overtime_rate DECIMAL(10,2),
    deduction_amount DECIMAL(10,2)
);

-- Create Indexes
CREATE INDEX idx_employee_department ON dw.dim_employee(department_id);
CREATE INDEX idx_employee_designation ON dw.dim_employee(designation_id);
CREATE INDEX idx_employee_branch ON dw.dim_employee(branch_id);
CREATE INDEX idx_branch_city ON dw.dim_branch(branch_city);
CREATE INDEX idx_branch_state ON dw.dim_branch(branch_state);
CREATE INDEX idx_payroll_employee ON dw.fact_payroll(employee_id);
CREATE INDEX idx_payroll_department ON dw.fact_payroll(department_id);
CREATE INDEX idx_payroll_date ON dw.fact_payroll(date_id);
CREATE INDEX idx_deduction_employee ON dw.dim_deduction(employee_id);
CREATE INDEX idx_overtime_employee ON dw.dim_overtime(employee_id);
