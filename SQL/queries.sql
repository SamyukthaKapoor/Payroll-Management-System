-- queries.sql - Sample Analytical Queries for Payroll Management System

-- 1. Department-wise Payroll Cost Analysis
SELECT 
    d.department_name,
    SUM(f.base_pay) AS total_base_pay,
    SUM(f.overtime_cost) AS total_overtime_cost,
    SUM(f.deduction_amount) AS total_deductions,
    SUM(f.net_pay) AS total_net_pay,
    COUNT(DISTINCT f.employee_id) AS employee_count,
    SUM(f.net_pay) / COUNT(DISTINCT f.employee_id) AS avg_employee_cost
FROM 
    dw.fact_payroll f
JOIN 
    dw.dim_department d ON f.department_id = d.department_id
JOIN 
    dw.dim_date dt ON f.date_id = dt.date_id
WHERE 
    dt.year = 2024
GROUP BY 
    d.department_name
ORDER BY 
    total_net_pay DESC;

-- 2. Attrition Rate by Department
WITH terminated_employees AS (
    SELECT 
        d.department_id,
        d.department_name,
        COUNT(DISTINCT e.employee_id) AS terminated_count
    FROM 
        dw.dim_employee e
    JOIN 
        dw.dim_department d ON e.department_id = d.department_id
    WHERE 
        e.termination_date IS NOT NULL
    GROUP BY 
        d.department_id, d.department_name
),
total_employees AS (
    SELECT 
        d.department_id,
        d.department_name,
        COUNT(DISTINCT e.employee_id) AS total_count
    FROM 
        dw.dim_employee e
    JOIN 
        dw.dim_department d ON e.department_id = d.department_id
    GROUP BY 
        d.department_id, d.department_name
)
SELECT 
    t.department_name,
    COALESCE(te.terminated_count, 0) AS terminated_employees,
    t.total_count AS total_employees,
    ROUND((COALESCE(te.terminated_count, 0)::DECIMAL / t.total_count) * 100, 1) AS attrition_rate
FROM 
    total_employees t
LEFT JOIN 
    terminated_employees te ON t.department_id = te.department_id
ORDER BY 
    attrition_rate DESC;

-- 3. Monthly Deduction Analysis by Department
SELECT 
    dept.department_name,
    date_part('month', dt.date) AS month,
    date_part('year', dt.date) AS year,
    SUM(ded.deduction_amount) AS total_deductions
FROM 
    dw.dim_deduction ded
JOIN 
    dw.dim_employee emp ON ded.employee_id = emp.employee_id
JOIN 
    dw.dim_department dept ON emp.department_id = dept.department_id
JOIN 
    dw.dim_date dt ON ded.deduction_date = dt.date
WHERE 
    date_part('year', dt.date) = 2024
GROUP BY 
    dept.department_name, date_part('month', dt.date), date_part('year', dt.date)
ORDER BY 
    dept.department_name, date_part('year', dt.date), date_part('month', dt.date);

-- 4. Average Base Pay by Position and Department
SELECT 
    des.designation_name,
    dept.department_name,
    AVG(fp.base_pay) AS avg_base_pay
FROM 
    dw.fact_payroll fp
JOIN 
    dw.dim_employee emp ON fp.employee_id = emp.employee_id
JOIN 
    dw.dim_department dept ON fp.department_id = dept.department_id
JOIN 
    dw.dim_designation des ON fp.designation_id = des.designation_id
GROUP BY 
    des.designation_name, dept.department_name
ORDER BY 
    avg_base_pay DESC;

-- 5. Overtime Analysis by Quarter and Department
SELECT 
    dept.department_name,
    dt.quarter,
    SUM(ot.overtime_hours) AS total_overtime_hours,
    SUM(ot.overtime_hours * ot.overtime_rate) AS total_overtime_cost,
    COUNT(DISTINCT ot.employee_id) AS employees_with_overtime,
    SUM(ot.overtime_hours * ot.overtime_rate) / SUM(ot.overtime_hours) AS avg_overtime_rate
FROM 
    dw.dim_overtime ot
JOIN 
    dw.dim_employee emp ON ot.employee_id = emp.employee_id
JOIN 
    dw.dim_department dept ON emp.department_id = dept.department_id
JOIN 
    dw.dim_date dt ON ot.overtime_date = dt.date
WHERE 
    date_part('year', dt.date) = 2024
GROUP BY 
    dept.department_name, dt.quarter
ORDER BY 
    dept.department_name, dt.quarter;

-- 6. Geographical Pay Analysis
SELECT 
    s.state_name,
    c.city_name,
    COUNT(DISTINCT fp.employee_id) AS employee_count,
    SUM(fp.base_pay) AS total_base_pay,
    SUM(fp.net_pay) AS total_net_pay,
    AVG(fp.base_pay) AS avg_base_pay
FROM 
    dw.fact_payroll fp
JOIN 
    dw.dim_branch b ON fp.branch_id = b.branch_id
JOIN 
    dw.dim_city c ON b.branch_city = c.city_id
JOIN 
    dw.dim_state s ON b.branch_state = s.state_id
GROUP BY 
    s.state_name, c.city_name
ORDER BY 
    total_net_pay DESC;

-- 7. Compensation Structure Analysis
WITH salary_bands AS (
    SELECT 
        designation_id,
        CASE 
            WHEN base_pay < 50000 THEN 'Low'
            WHEN base_pay BETWEEN 50000 AND 100000 THEN 'Medium'
            WHEN base_pay BETWEEN 100001 AND 150000 THEN 'High'
            ELSE 'Very High'
        END AS salary_band,
        COUNT(*) AS employee_count
    FROM 
        dw.fact_payroll
    GROUP BY 
        designation_id, salary_band
)
SELECT 
    d.designation_name,
    sb.salary_band,
    sb.employee_count,
    ROUND((sb.employee_count::DECIMAL / SUM(sb.employee_count) OVER (PARTITION BY d.designation_id)) * 100, 2) AS percentage
FROM 
    salary_bands sb
JOIN 
    dw.dim_designation d ON sb.designation_id = d.designation_id
ORDER BY 
    d.designation_name, 
    CASE 
        WHEN sb.salary_band = 'Low' THEN 1
        WHEN sb.salary_band = 'Medium' THEN 2
        WHEN sb.salary_band = 'High' THEN 3
        WHEN sb.salary_band = 'Very High' THEN 4
    END;

-- 8. Payroll Trend Analysis by Month
SELECT 
    date_part('year', dt.date) AS year,
    date_part('month', dt.date) AS month,
    SUM(fp.base_pay) AS total_base_pay,
    SUM(fp.overtime_cost) AS total_overtime,
    SUM(fp.deduction_amount) AS total_deductions,
    SUM(fp.net_pay) AS total_net_pay,
    SUM(fp.net_pay) / SUM(fp.base_pay) AS net_to_base_ratio
FROM 
    dw.fact_payroll fp
JOIN 
    dw.dim_date dt ON fp.date_id = dt.date_id
GROUP BY 
    date_part('year', dt.date), date_part('month', dt.date)
ORDER BY 
    date_part('year', dt.date), date_part('month', dt.date);
