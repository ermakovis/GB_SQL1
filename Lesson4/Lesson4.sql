/*views*/
create definer = sa@`%` 
view avg_salary_by_department as
select `dept`.`dept_name` AS `dept_name`, 
	avg(`salary`.`salary`) AS `AVG(salary.salary)`
from (((`employees`.`dept_emp` 
	join `employees`.`departments` `dept` on ((`employees`.`dept_emp`.`dept_no` = `dept`.`dept_no`))) 
	join `employees`.`employees` `emp` on ((`employees`.`dept_emp`.`emp_no` = `emp`.`emp_no`)))
	join `employees`.`salaries` `salary` on ((`emp`.`emp_no` = `salary`.`emp_no`)))
group by `dept`.`dept_no`;

create definer = sa@`%` 
view employees_by_department as
select 	`dept`.`dept_name` AS `dept_name`, 
	count(`employees`.`dept_emp`.`emp_no`) AS `COUNT(dept_emp.emp_no)`
from (`employees`.`dept_emp`
         join `employees`.`departments` `dept` on ((`dept`.`dept_no` = `employees`.`dept_emp`.`dept_no`)))
group by `dept`.`dept_name`;

create definer = sa@`%` 
view max_salary as
select 	concat(`emp`.`first_name`, ' ', `emp`.`last_name`) AS `full_name`, 
	max(`salary`.`salary`) AS `max_salary`
from (`employees`.`salaries` `salary`
         join `employees`.`employees` `emp` on ((`emp`.`emp_no` = `salary`.`emp_no`)))
group by `full_name`
order by `max_salary` desc
limit 1;

create definer = sa@`%` 
view total_salary_by_department as
select 	`dept`.`dept_name` AS `dept_name`, 
	count(`employees`.`dept_emp`.`emp_no`) AS `COUNT(dept_emp.emp_no)`
from (`employees`.`dept_emp`
         join `employees`.`departments` `dept` on ((`dept`.`dept_no` = `employees`.`dept_emp`.`dept_no`)))
group by `dept`.`dept_no`;


/*function*/
create function get_manager_by_name_and_surname(first_name varchar(14), last_name varchar(16))
returns int
reads sql data
begin
    return (
        select dept_manager.emp_no from dept_manager
        join employees e on dept_manager.emp_no = e.emp_no
        where e.first_name = first_name and e.last_name = last_name
        limit 1
    );
end

/*trigger*/
create definer = sa@`%` trigger new_employee_welcome_bonus
    after insert
    on employees
    for each row
begin
    insert into employees.salaries (emp_no, salary, from_date, to_date)
    values (NEW.emp_no, 10000, NEW.hire_date, NEW.hire_date);
end;





