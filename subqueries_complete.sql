-- SQL DEVELOPER INTERNSHIP - TASK 6: SUBQUERIES AND NESTED QUERIES
-- Objective: Use subqueries in SELECT, WHERE, and FROM clauses
-- Created by: [Your Name]
-- Date: [Current Date]

-- =====================================================
-- SAMPLE DATABASE SETUP (SQLite Compatible)
-- =====================================================

-- Create sample tables for demonstration
CREATE TABLE IF NOT EXISTS employees (
    emp_id INTEGER PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INTEGER
);

CREATE TABLE IF NOT EXISTS departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(100),
    budget DECIMAL(15,2)
);

CREATE TABLE IF NOT EXISTS projects (
    project_id INTEGER PRIMARY KEY,
    project_name VARCHAR(100),
    department VARCHAR(50),
    budget DECIMAL(12,2),
    start_date DATE,
    end_date DATE
);

-- Insert sample data
INSERT INTO employees (emp_id, emp_name, department, salary, hire_date, manager_id) VALUES
(1, 'John Smith', 'IT', 75000, '2020-01-15', NULL),
(2, 'Jane Doe', 'IT', 65000, '2021-03-20', 1),
(3, 'Bob Johnson', 'HR', 60000, '2019-07-10', NULL),
(4, 'Alice Brown', 'Finance', 70000, '2020-11-05', NULL),
(5, 'Charlie Davis', 'IT', 55000, '2022-02-14', 1),
(6, 'Eva Wilson', 'Marketing', 62000, '2021-06-18', NULL),
(7, 'Frank Miller', 'Finance', 68000, '2020-09-22', 4),
(8, 'Grace Lee', 'HR', 58000, '2021-12-01', 3),
(9, 'Henry Taylor', 'IT', 72000, '2019-05-30', 1),
(10, 'Ivy Chen', 'Marketing', 64000, '2022-01-10', 6);

INSERT INTO departments (dept_id, dept_name, location, budget) VALUES
(1, 'IT', 'Building A', 500000),
(2, 'HR', 'Building B', 300000),
(3, 'Finance', 'Building C', 400000),
(4, 'Marketing', 'Building D', 350000);

INSERT INTO projects (project_id, project_name, department, budget, start_date, end_date) VALUES
(1, 'Website Redesign', 'IT', 150000, '2023-01-01', '2023-06-30'),
(2, 'Employee Training', 'HR', 80000, '2023-02-01', '2023-04-30'),
(3, 'Financial Audit', 'Finance', 120000, '2023-03-01', '2023-08-31'),
(4, 'Marketing Campaign', 'Marketing', 200000, '2023-01-15', '2023-12-31'),
(5, 'System Upgrade', 'IT', 300000, '2023-04-01', '2023-10-31');

-- =====================================================
-- 1. SCALAR SUBQUERIES
-- =====================================================

-- Example 1: Find employees earning more than the average salary
SELECT emp_name, salary,
       (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Example 2: Show each employee's salary compared to their department average
SELECT emp_name, department, salary,
       (SELECT AVG(salary) 
        FROM employees e2 
        WHERE e2.department = e1.department) AS dept_avg_salary
FROM employees e1;

-- =====================================================
-- 2. SUBQUERIES WITH IN OPERATOR
-- =====================================================

-- Example 3: Find employees working in departments with budget > 350000
SELECT emp_name, department
FROM employees
WHERE department IN (
    SELECT dept_name 
    FROM departments 
    WHERE budget > 350000
);

-- Example 4: Find employees not working in IT or HR
SELECT emp_name, department
FROM employees
WHERE department NOT IN ('IT', 'HR');

-- =====================================================
-- 3. CORRELATED SUBQUERIES
-- =====================================================

-- Example 5: Find employees who earn more than the average in their department
SELECT e1.emp_name, e1.department, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e1.department
);

-- Example 6: Find the highest paid employee in each department
SELECT emp_name, department, salary
FROM employees e1
WHERE salary = (
    SELECT MAX(salary)
    FROM employees e2
    WHERE e2.department = e1.department
);

-- =====================================================
-- 4. EXISTS SUBQUERIES
-- =====================================================

-- Example 7: Find departments that have employees
SELECT dept_name, location
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department = d.dept_name
);

-- Example 8: Find employees who are managers (have subordinates)
SELECT emp_name, department
FROM employees e1
WHERE EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.manager_id = e1.emp_id
);

-- =====================================================
-- 5. SUBQUERIES IN FROM CLAUSE (DERIVED TABLES)
-- =====================================================

-- Example 9: Find departments with above-average employee count
SELECT dept_summary.department, dept_summary.emp_count
FROM (
    SELECT department, COUNT(*) AS emp_count
    FROM employees
    GROUP BY department
) AS dept_summary
WHERE dept_summary.emp_count > (
    SELECT AVG(emp_count)
    FROM (
        SELECT COUNT(*) AS emp_count
        FROM employees
        GROUP BY department
    )
);

-- Example 10: Rank employees by salary within their department
SELECT emp_name, department, salary, salary_rank
FROM (
    SELECT emp_name, department, salary,
           ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employees
) AS ranked_employees
WHERE salary_rank <= 2;

-- =====================================================
-- 6. COMPLEX NESTED SUBQUERIES
-- =====================================================

-- Example 11: Find employees in departments that have projects with budget > 150000
SELECT DISTINCT emp_name, e.department
FROM employees e
WHERE e.department IN (
    SELECT p.department
    FROM projects p
    WHERE p.budget > (
        SELECT AVG(budget)
        FROM projects
    )
);

-- Example 12: Multi-level subquery - Find employees earning more than 
-- the average of the highest-paid employee in each department
SELECT emp_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(max_dept_salary)
    FROM (
        SELECT MAX(salary) AS max_dept_salary
        FROM employees
        GROUP BY department
    ) AS dept_max
);

-- =====================================================
-- 7. SUBQUERIES WITH MULTIPLE COLUMNS
-- =====================================================

-- Example 13: Find employees with the same department and hire year as employee with ID 2
SELECT emp_name, department, hire_date
FROM employees
WHERE (department, strftime('%Y', hire_date)) = (
    SELECT department, strftime('%Y', hire_date)
    FROM employees
    WHERE emp_id = 2
)
AND emp_id != 2;

-- =====================================================
-- 8. ANY/ALL SUBQUERIES
-- =====================================================

-- Example 14: Find employees earning more than ANY employee in HR
SELECT emp_name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'HR'
);

-- Example 15: Find employees earning more than ALL employees in HR
SELECT emp_name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department = 'HR'
);

-- =====================================================
-- 9. PERFORMANCE ANALYSIS QUERIES
-- =====================================================

-- Example 16: Compare subquery vs JOIN performance
-- Subquery approach
SELECT emp_name, department
FROM employees
WHERE department IN (
    SELECT dept_name
    FROM departments
    WHERE budget > 400000
);

-- Equivalent JOIN approach
SELECT DISTINCT e.emp_name, e.department
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE d.budget > 400000;

-- =====================================================
-- 10. ADVANCED SUBQUERY PATTERNS
-- =====================================================

-- Example 17: Running totals using correlated subquery
SELECT emp_name, salary,
       (SELECT SUM(salary)
        FROM employees e2
        WHERE e2.emp_id <= e1.emp_id) AS running_total
FROM employees e1
ORDER BY emp_id;

-- Example 18: Find nth highest salary using subquery
SELECT DISTINCT salary
FROM employees e1
WHERE 3 = (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.salary >= e1.salary
);

-- =====================================================
-- CLEANUP (Optional)
-- =====================================================

-- Uncomment below lines if you want to clean up the tables after testing
-- DROP TABLE IF EXISTS employees;
-- DROP TABLE IF EXISTS departments;
-- DROP TABLE IF EXISTS projects;