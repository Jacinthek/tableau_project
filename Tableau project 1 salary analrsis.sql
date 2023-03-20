use employees_mod;

SELECT 
    YEAR(d.from_date) AS calendar_year,
    e.gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp d ON d.emp_no = e.emp_no
GROUP BY calendar_year , e.gender
Having calendar_year >= 1990;

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year ,
    CASE
        WHEN
            YEAR(dm.to_date) >= e.calendar_year 
                AND YEAR(dm.from_date) <= e.calendar_year  THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no , calendar_year;


SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;

select * from     (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;

SELECT 
    e.gender,    
    d.dept_name,
    ROUND(AVG(s.salary),2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no= de.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no;

select Min(salary) from t_salaries;
select MAX(salary) FROM t_salaries;

DELIMITER $$
CREATE procedure filter_salary (IN p_min_salary FLOAT , IN p_max_salary FLOAT)
BEGIN
select
	e.gender,    
    d.dept_name,
    AVG(s.salary) AS Avg_salary
FROM
t_employees e
Join
t_salaries s on s.emp_no= e.emp_no
join
t_dept_emp de on e.emp_no=de.emp_no
join
t_departments d on de.dept_no = d.dept_no
where s.salary between p_min_salary and p_max_salary
GROUP BY d.dept_no, e.gender;
END$$

DELIMITER ;
CALL FILTER_SALARY (50000, 90000);