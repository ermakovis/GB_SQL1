/* База данных «Страны и города мира»: */
/* 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна. */
SELECT 
    city.title city_title,
    region.title region_title,
    country.title country_title
FROM
    geodata._cities city  
        JOIN
    geodata._regions region ON region.id = city.region_id
        JOIN
    geodata._countries country ON country.id = city.country_id
    
/* 2. Выбрать все города из Московской области. */
SELECT 
    city.title
FROM
    geodata._cities AS city
WHERE
    city.region_id IN (SELECT 
            region.id
        FROM
            geodata._regions AS region
        WHERE
            region.title = 'Московская область')
            
/* База данных «Сотрудники»: */
/* Во всех задачах про сотрудников не указан период, за который считать
   максимальную-среднюю зарплату, поэтому считаю по всем записям вообще, 
   даже уже уволенных сотрудников */
/* 1. Выбрать среднюю зарплату по отделам.*/
SELECT 
    dept.dept_name, 
    AVG(salary.salary)
FROM
    employees.dept_emp AS dept_emp
        JOIN
    employees.departments AS dept ON dept_emp.dept_no = dept.dept_no
        JOIN
    employees.employees AS emp ON dept_emp.emp_no = emp.emp_no
        JOIN
    employees.salaries AS salary ON emp.emp_no = salary.emp_no
GROUP BY dept.dept_name

/* 2. Выбрать максимальную зарплату у сотрудника.*/
/* У каждого сотрудника */
SELECT 
    CONCAT(emp.last_name, ' ', emp.first_name) AS full_name,
    MAX(salary.salary) AS max_salary
FROM
    employees.employees AS emp
        JOIN
    employees.salaries AS salary ON emp.emp_no = salary.emp_no
GROUP BY full_name

/* Максимальную среди всех сотрудников */
DELETE FROM employees.employees AS emp
WHERE

SELECT 
    CONCAT(emp.first_name, ' ', emp.last_name) AS full_name,
    MAX(salary.salary) AS max_salary
FROM
    employees.salaries AS salary
        JOIN
    employees.employees AS emp ON emp.emp_no = salary.emp_no
GROUP BY full_name
ORDER BY max_salary DESC
LIMIT 1

/* 3. Удалить одного сотрудника, у которого максимальная зарплата.*/
DELETE FROM 
    employees.employees AS emp 
WHERE emp.emp_no = (SELECT 
        salary.emp_no
    FROM 
        employees.salaries AS salary
    WHERE salary.salary = (SELECT
        MAX(salary.salary) AS max_salary
    FROM
        employees.salaries AS salary
    )
)
/* Пришлось делать двойной SELECT потому что LIMIT 1 не поддерживается в subquery */

/* 4. Посчитать количество сотрудников во всех отделах.*/
SELECT
    dept.dept_name,
    COUNT(dept_emp.emp_no)
FROM
    employees.dept_emp AS dept_emp
        JOIN
    employees.departments AS dept ON dept.dept_no = dept_emp.dept_no
GROUP BY
    dept.dept_name
	
	
/* 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.*/
SELECT
    dept.dept_name,
    SUM(salary.salary)
FROM
    employees.dept_emp AS dept_emp
        JOIN
    employees.departments AS dept ON dept_emp.dept_no = dept.dept_no
        JOIN
    employees.employees AS emp ON emp.emp_no = dept_emp.emp_no
        JOIN
    employees.salaries AS salary ON emp.emp_no = salary.emp_no
GROUP BY
    dept.dept_name   
