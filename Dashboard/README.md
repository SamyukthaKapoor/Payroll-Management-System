# Payroll Analysis Dashboard

This directory contains the Power BI dashboard files and assets for the Payroll Management System Data Warehouse.

## Files

- `Payroll_Analysis Dashboard Link` - 

## Dashboard Components

The dashboard includes these main visualizations:

1. **Payroll Cost by Department** - Bubble chart showing departmental costs
2. **Attrition Rates by Department** - Bar chart showing attrition percentages
3. **Total Deduction Analysis** - Table of monthly deductions by department
4. **Average Base Pay** - Heatmap of compensation by position and department
5. **Overtime Cost by Month** - Scatter plot of quarterly overtime costs
6. **Total Pay Quarterly** - Bar chart of compensation by department and quarter

## Filters and Controls

Interactive filters include:

1. **Department Name** dropdown - Filter by specific department
2. **Attrition Rate** slider - Filter by attrition rate range (0.0 to 5.0)
3. **Quarter of Overtime** dropdown - Focus on specific quarters
4. **City Name** dropdown - Filter by location

## Data Connections

The dashboard connects to the PostgreSQL data warehouse using:

1. Direct query for dimensional data
2. Import mode for fact table analysis

## Refresh Schedule

The dashboard is configured for:

- Manual refresh: Available through the Refresh button

## Using the Dashboard

1. Open the link of the file in Tableau Desktop or website
2. Update the data source connection to your PostgreSQL instance
3. Refresh data to see current insights
