# SQL Developer Internship - Task 6: Subqueries and Nested Queries

## Task Overview

# Objective: Master advanced SQL query logic using subqueries in SELECT, WHERE, and FROM clauses

# Tools Used:-
- DB Browser for SQLite
- MySQL Workbench (compatible)

# Key Concepts:-
 Subqueries, Nested Queries, Correlated Subqueries, Derived Tables

## Learning Outcomes

- Understanding different types of subqueries
- Implementing scalar and correlated subqueries
- Using subqueries with IN, EXISTS, and comparison operators
- Performance considerations for nested queries
- Advanced query logic skills

## Repository Structure

```
sql-subqueries-task6/
│
├── README.md                 # This file
├── subqueries_complete.sql   # Main SQL file with all examples
├── sample_data/
│   ├── create_tables.sql     # Table creation scripts
│   └── insert_data.sql       # Sample data insertion

```

## Database Schema:-

# Tables Used:-

1. employees - Employee information (id, name, department, salary, hire_date, manager_id)
2. departments - Department details (id, name, location, budget)
3. projects - Project information (id, name, department, budget, dates)

##  Query Categories Implemented:-

# 1. Scalar Subqueries
- Queries returning single values
- Used in SELECT and WHERE clauses
- Example: Finding employees earning above average salary

# 2. Subqueries with IN/NOT IN
- Filtering based on lists of values
- Department-based filtering examples

# 3. Correlated Subqueries
- Inner query references outer query
- Department-wise comparisons
- Finding top performers per department

# 4. EXISTS/NOT EXISTS
- Checking for existence of related records
- Finding managers and departments with employees

# 5. Derived Tables (Subqueries in FROM)
- Using subqueries as temporary tables
- Complex aggregations and rankings

# 6. ANY/ALL Operators
- Comparing against multiple values
- Salary comparisons across departments

# 7. Multi-level Nested Queries
- Subqueries within subqueries
- Advanced filtering logic

##  Key Examples Covered

# Example 1: Employees Earning Above Average
  Query:-
       SELECT emp_name, salary
       FROM employees
       WHERE salary > (SELECT AVG(salary) FROM employees);


# Example 2: Correlated Subquery - Department Comparison
  Query:-
       SELECT emp_name, department, salary
       FROM employees e1
       WHERE salary > (
       SELECT AVG(salary)
       FROM employees e2
        WHERE e2.department = e1.department
       );

# Example 3: EXISTS - Finding Managers
  Query:-
      SELECT emp_name, department
      FROM employees e1
      WHERE EXISTS (
         SELECT 1
         FROM employees e2
         WHERE e2.manager_id = e1.emp_id
         );

# Example 4: Derived Table - Department Rankings
  Query:-
   SELECT department, emp_count
   FROM (
    SELECT department, COUNT(*) AS emp_count
    FROM employees
    GROUP BY department
) AS dept_summary;


##  Performance Notes:-

- Scalar subqueries: Generally efficient for single value lookups
- Correlated subqueries: Can be slow with large datasets
- EXISTS vs IN: EXISTS is often faster for checking existence
- Derived tables: Useful for complex calculations, may need indexing

##  Tools and Environment:-

- Database: SQLite (primary), MySQL compatible
- IDE: DB Browser for SQLite, MySQL Workbench
- Version Control: Git/GitHub
- Documentation: Markdown

## Results and Insights:-

The SQL script demonstrates:
- 18+ different subquery patterns
- Performance comparison between subqueries and JOINs
- Real-world scenarios using employee/department data
- Progressive complexity from basic to advanced queries



## 👨‍💻 Author

Name: Abhishek Tiwari  
Internship: SQL Developer  
Task: 6 - Subqueries and Nested Queries  
Date: 13-08-2025 

##  Notes

- All queries are tested and working
- Sample data included for immediate testing
- Comments explain each query type and purpose
- Ready for interview discussions

---

**Task Completion Status:**  Complete  
