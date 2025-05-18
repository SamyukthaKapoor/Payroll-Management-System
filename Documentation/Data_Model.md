# Data Model Documentation

This document describes the dimensional data model implemented for our Payroll Management System Data Warehouse.

## Overview

Our data warehouse follows a star schema design optimized for analytical queries related to payroll management, employee compensation, and workforce analytics. The model consists of:

- 8 dimension tables providing contextual information
- 1 fact table containing quantitative measures

## Star Schema Diagram

The following diagram illustrates the relationships between our fact and dimension tables:

![Star Schema Diagram](./images/architecture_diagram.png)
