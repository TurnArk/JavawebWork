USE employee_management;
# 1.查询所有员工的姓名、邮箱和工作岗位。
SELECT first_name,last_name,email,job_title FROM employees;

# 2.查询所有部门的名称和位置。
SELECT dept_name,location FROM departments;

# 3.查询工资超过70000的员工姓名和工资。
SELECT first_name,last_name,salary FROM employees WHERE salary>=70000;

# 4.查询IT部门的所有员工。
SELECT * FROM employees JOIN departments ON employees.dept_id = departments.dept_id WHERE dept_name="IT";

# 5.查询入职日期在2020年之后的员工信息。
SELECT * FROM employees WHERE YEAR(hire_date)>=2020;

# 6.计算每个部门的平均工资。
SELECT employees.dept_id,dept_name,AVG(salary) FROM employees JOIN departments ON employees.dept_id = departments.dept_id GROUP BY employees.dept_id;

# 7.查询工资最高的前3名员工信息。
SELECT * FROM employees ORDER BY salary DESC LIMIT 3;

# 8.查询每个部门员工数量。
SELECT dept_name,COUNT(emp_id) FROM employees JOIN departments ON employees.dept_id = departments.dept_id GROUP BY dept_name;

# 9.查询没有分配部门的员工。
SELECT * FROM employees WHERE employees.dept_id NOT IN (SELECT departments.dept_id FROM departments);
# 测试例子里面妹有这么个人啊

# 10.查询参与项目数量最多的员工。
SELECT * FROM employees WHERE emp_id IN (
    SELECT employee_projects.emp_id FROM employee_projects GROUP BY emp_id HAVING COUNT(project_id) = (
        SELECT COUNT(project_id) FROM employee_projects GROUP BY emp_id LIMIT 1
        )
    );

# 11.计算所有员工的工资总和。
SELECT SUM(salary) FROM employees;

# 12.查询姓"Smith"的员工信息。
SELECT * FROM employees WHERE last_name="Smith";

# 13.查询即将在半年内到期的项目。
SELECT * FROM projects WHERE TIMESTAMPDIFF(MONTH ,CURDATE(),end_date)<6 AND TIMESTAMPDIFF(MONTH ,CURDATE(),end_date)>=0;

# 14.查询至少参与了两个项目的员工。
SELECT * FROM employees WHERE emp_id IN(
    SELECT employee_projects.emp_id FROM employee_projects GROUP BY emp_id HAVING COUNT(project_id)>=2
    );

# 15.查询没有参与任何项目的员工。
SELECT * FROM employees WHERE emp_id NOT IN(
    SELECT DISTINCT emp_id FROM employee_projects
    );

# 16.计算每个项目参与的员工数量。
SELECT projects.project_id,project_name,COUNT(emp_id) FROM projects LEFT JOIN employee_projects
    ON projects.project_id = employee_projects.project_id
         GROUP BY projects.project_id;

# 17.查询工资第二高的员工信息。
SELECT * FROM employees WHERE salary=(
    SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 1
    );

# 18.查询每个部门工资最高的员工。
WITH ranked_employed AS (
    SELECT e.* ,d.dept_name,
    RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC ) AS salary_rank
    FROM employees e
    JOIN departments d
    ON e.dept_id = d.dept_id
)SELECT *
FROM ranked_employed
WHERE salary_rank=1;

# 19.计算每个部门的工资总和,并按照工资总和降序排列。
SELECT departments.dept_id,departments.dept_name,SUM(salary) FROM departments JOIN employees
    ON departments.dept_id = employees.dept_id GROUP BY employees.dept_id;

# 20.查询员工姓名、部门名称和工资。
SELECT first_name,last_name,dept_name,salary FROM employees JOIN departments ON employees.dept_id = departments.dept_id;

# 21.查询每个员工的上级主管(假设emp_id小的是上级)。
WITH boss AS (
    SELECT e1.dept_id,e1.emp_id,e1.first_name,e1.last_name ,
    RANK() OVER (PARTITION BY e1.dept_id ORDER BY e1.emp_id) as boos_rank
    FROM employees e1
)SELECT * FROM employees e2 JOIN boss ON boss.dept_id=e2.dept_id WHERE boos_rank=1;

# 22.查询所有员工的工作岗位,不要重复
SELECT DISTINCT job_title FROM employees;

# 23.查询平均工资最高的部门。
WITH avg_de_sa AS (
    SELECT dept_id, AVG(salary) avg_sa FROM employees GROUP BY dept_id
)
SELECT * FROM departments JOIN avg_de_sa ON avg_de_sa.dept_id=departments.dept_id
         WHERE avg_sa=(
         SELECT avg_sa FROM avg_de_sa ORDER BY avg_sa DESC LIMIT 1
             );

# 24.查询工资高于其所在部门平均工资的员工。
SELECT e1.*,t1.avg_sa FROM employees e1 JOIN (
    SELECT d2.dept_id,AVG(e2.salary) avg_sa FROM employees e2 JOIN departments d2
    ON e2.dept_id = d2.dept_id GROUP BY d2.dept_id
) t1 ON e1.dept_id=t1.dept_id
WHERE e1.salary>t1.avg_sa;

# 25.查询每个部门工资前两名的员工。
WITH rank_table AS (
    SELECT e1.emp_id,
    RANK() OVER (PARTITION BY e1.dept_id ORDER BY e1.salary DESC ) rank_num
    FROM employees e1
)
SELECT e2.* FROM employees e2 JOIN rank_table ON e2.emp_id=rank_table.emp_id WHERE rank_num<=2;