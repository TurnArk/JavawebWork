USE employee_management;

# 1.查询所有学生的信息。
SELECT * FROM student;

# 2.查询所有课程的信息。
SELECT * FROM course;

# 3.查询所有学生的姓名、学号和班级。
SELECT name,student_id,my_class FROM student;

# 4.查询所有教师的姓名和职称。
SELECT name,title FROM teacher;

# 5.查询不同课程的平均分数。
SELECT score.course_id,course_name,AVG(score) FROM score JOIN course ON score.course_id = course.course_id GROUP BY course_id;

# 6. 查询每个学生的平均分数。
SELECT student.student_id,name,AVG(score) FROM student LEFT JOIN score ON student.student_id = score.student_id GROUP BY student.student_id;

# 7. 查询分数大于85分的学生学号和课程号。
SELECT student_id,course_id FROM score WHERE score>85;

# 8. 查询每门课程的选课人数。
SELECT course.course_id,course_name,COUNT(student_id) FROM course LEFT JOIN  score
    ON course.course_id = score.course_id GROUP BY course.course_id;

# 9. 查询选修了"高等数学"课程的学生姓名和分数。
SELECT name,score FROM student,course,score
                  WHERE score.student_id=student.student_id AND score.course_id=course.course_id AND course.course_name="高等数学";

# 10. 查询没有选修"大学物理"课程的学生姓名。
SELECT name FROM student WHERE student_id NOT IN (
    SELECT student_id FROM score JOIN course ON score.course_id = course.course_id
                      WHERE course_name="大学物理"
    );

# 11. 查询C001比C002课程成绩高的学生信息及课程分数。
SELECT * FROM student,(
    SELECT s1.student_id sid ,s1.score s1sc,s2.score s2sc FROM score s1 JOIN score s2 ON s1.student_id=s2.student_id
             WHERE s1.course_id="C001" AND s2.course_id="C002" AND s1.score>s2.score
        )t1 WHERE student.student_id=t1.sid;

# 12. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
SELECT score.course_id,course_name,
       COUNT(CASE WHEN score BETWEEN 85 AND 100 THEN 1 END) "[100,85]",
       COUNT(CASE WHEN score BETWEEN 70 AND 85 THEN 1 END) "[85,70]",
       COUNT(CASE WHEN score BETWEEN 60 AND 70 THEN 1 END) "[70,60]",
       COUNT(CASE WHEN score BETWEEN 0 AND 60 THEN 1 END) "[60,0]"
    FROM score JOIN course ON score.course_id = course.course_id GROUP BY score.course_id;

# 13. 查询选择C002课程但没选择C004课程的成绩情况(不存在时显示为 null )。
SELECT * FROM score WHERE student_id IN (
    SELECT student_id FROM score WHERE course_id="C002"
    ) AND score.student_id NOT IN (
    SELECT student_id FROM score WHERE course_id="C004"
    );

# 14. 查询平均分数最高的学生姓名和平均分数。
WITH avg_sc AS (
    SELECT student_id,AVG(score) num FROM score GROUP BY student_id
)
SELECT name,num FROM student JOIN avg_sc ON avg_sc.student_id=student.student_id
    WHERE num=(SELECT MAX(num) FROM avg_sc);

# 15. 查询总分最高的前三名学生的姓名和总分。
WITH sum_sc AS (
    SELECT student_id,SUM(score) num FROM score GROUP BY student_id
)
SELECT  name,num FROM student JOIN sum_sc ON sum_sc.student_id=student.student_id ORDER BY num DESC LIMIT 3;

# 16. 查询各科成绩最高分、最低分和平均分。要求如下：
# 以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
# 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
# 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
WITH max_sc AS (
    SELECT course_id ,score a_sc,
    RANK() OVER (PARTITION BY course_id ORDER BY score DESC ) as max_rank
    FROM score
),
min_sc AS (
    SELECT course_id ,score b_sc,
    RANK() OVER (PARTITION BY course_id ORDER BY score ASC ) as min_rank
    FROM score
),
total AS(
    SELECT course.course_id,COUNT(student_id) cou
    FROM course LEFT JOIN score ON course.course_id=score.course_id
    GROUP BY course.course_id
)
SELECT course.course_id,course_name, a_sc "最高分",b_sc "最低分",AVG(score),
       FORMAT(COUNT(CASE WHEN score>=60 THEN 1 END)*100/cou,2) "及格率",
       FORMAT(COUNT(CASE WHEN score BETWEEN 70 AND 80 THEN 1 END)/cou,2) "中等率",
       FORMAT(COUNT(CASE WHEN score BETWEEN 80 AND 90 THEN 1 END)/cou,2) "优良率",
       FORMAT(COUNT(CASE WHEN score>=90 THEN 1 END)/cou,2) "优秀率"
FROM course,max_sc,min_sc,score,total
WHERE course.course_id=max_sc.course_id AND course.course_id = min_sc.course_id
  AND course.course_id=score.course_id AND total.course_id=course.course_id
  AND max_sc.max_rank=1 AND min_sc.min_rank=1
GROUP BY course.course_id,course_name, a_sc, b_sc, total.cou
ORDER BY cou DESC,course_id ASC;
#这句查询指令真的是依托屎山呐

# 17. 查询男生和女生的人数。
SELECT COUNT(CASE WHEN gender="男" THEN 1 END) "男的",
       COUNT(CASE WHEN gender="女" THEN 1 END) "女的"
FROM student;

# 18. 查询年龄最大的学生姓名。
SELECT name FROM student WHERE UNIX_TIMESTAMP(birth_date)=(
    SELECT MIN(UNIX_TIMESTAMP(birth_date))FROM student
    );

# 19. 查询年龄最小的教师姓名。
SELECT name FROM teacher WHERE UNIX_TIMESTAMP(birth_date)=(
    SELECT MAX(UNIX_TIMESTAMP(birth_date))FROM teacher
    );

# 20. 查询学过「张教授」授课的同学的信息。
SELECT * FROM student WHERE student_id IN (
    SELECT student_id FROM score JOIN course ON score.course_id = course.course_id
                      JOIN teacher  ON course.teacher_id = teacher.teacher_id
                      WHERE teacher.name="张教授"
    );

# 21. 查询查询至少有一门课与学号为"2021001"的同学所学相同的同学的信息。
SELECT * FROM student WHERE student_id IN (
    SELECT student_id FROM score WHERE course_id IN (
        SELECT course_id FROM score WHERE score.student_id="2021001"
        )
    );

# 22. 查询每门课程的平均分数，并按平均分数降序排列。
WITH avg_sc AS (
    SELECT course_id,AVG(score) a FROM score GROUP BY course_id
)
SELECT course.*,avg_sc.a FROM course JOIN avg_sc ON avg_sc.course_id=course.course_id
ORDER BY a DESC ;

# 23. 查询学号为"2021001"的学生所有课程的分数。
SELECT score FROM score WHERE student_id="2021001";

# 24. 查询所有学生的姓名、选修的课程名称和分数。
SELECT student.name,course_name,score FROM student
    JOIN score ON student.student_id = score.student_id
    JOIN course ON score.course_id = course.course_id;

# 25. 查询每个教师所教授课程的平均分数。
SELECT teacher.* ,a FROM teacher JOIN (
        SELECT teacher_id,AVG(score) a FROM course JOIN score ON course.course_id = score.course_id
        GROUP BY teacher_id
)t ON t.teacher_id=teacher.teacher_id;

# 26. 查询分数在80到90之间的学生姓名和课程名称。
SELECT name,course_name FROM student JOIN score ON student.student_id = score.student_id
    JOIN course ON score.course_id = course.course_id
    WHERE score>=80 AND score<=90;

# 27. 查询每个班级的平均分数。
SELECT my_class,AVG(score) FROM student JOIN score ON student.student_id = score.student_id GROUP BY my_class;

# 28. 查询没学过"王讲师"老师讲授的任一门课程的学生姓名。
SELECT name FROM student WHERE student_id NOT IN (
    SELECT student_id FROM score JOIN course    ON score.course_id = course.course_id
                      JOIN teacher ON course.teacher_id = teacher.teacher_id
                      WHERE teacher.name="王讲师"
    );

# 29. 查询两门及其以上小于85分的同学的学号，姓名及其平均成绩。
SELECT student.student_id,name,AVG(score) FROM student JOIN score ON student.student_id = score.student_id
GROUP BY score.student_id HAVING COUNT(CASE WHEN score<85 THEN 1 END )>=2;

# 30. 查询所有学生的总分并按降序排列。
WITH total AS (
    SELECT student_id,SUM(score) s FROM score GROUP BY student_id
)
SELECT student.student_id,name,s FROM student JOIN total ON total.student_id=student.student_id ORDER BY s DESC ;

# 31. 查询平均分数超过85分的课程名称。
SELECT course_name FROM course JOIN score ON course.course_id = score.course_id
GROUP BY course.course_id HAVING AVG(score)>=85;

# 32. 查询每个学生的平均成绩排名。
WITH total AS (
    SELECT student_id,AVG(score) s FROM score GROUP BY student_id
)
SELECT student.student_id,name,s FROM student JOIN total ON total.student_id=student.student_id ORDER BY s DESC ;
# 33. 查询每门课程分数最高的学生姓名和分数。
WITH total AS (
    SELECT student_id,score,
    rank() OVER (PARTITION BY course_id ORDER BY score DESC ) a
    FROM score
)
SELECT name,score FROM student JOIN total ON total.student_id=student.student_id WHERE a=1;

# 34. 查询选修了"高等数学"和"大学物理"的学生姓名。
WITH gs AS (
    SELECT course_id FROM course WHERE course_name="高等数学"
),
dw AS (
    SELECT course_id FROM course WHERE course_name="大学物理"
)
SELECT name FROM student WHERE student_id IN (
    SELECT student_id FROM score JOIN gs ON gs.course_id=score.course_id WHERE score.student_id IN (
        SELECT student_id FROM score JOIN dw ON dw.course_id=score.course_id
        )
    );

# 35. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩（没有选课则为空）。
WITH total AS (
    SELECT student_id,AVG(score) a FROM score GROUP BY student_id
)
SELECT student.student_id,name,course_name,score,a FROM student LEFT JOIN score ON student.student_id = score.student_id
    LEFT JOIN course ON score.course_id = course.course_id
    LEFT JOIN total ON total.student_id=student.student_id
    ORDER BY a DESC;

# 36. 查询分数最高和最低的学生姓名及其分数。
WITH total AS (
    SELECT student_id,SUM(score) s FROM score GROUP BY student_id
)
(SELECT name,s FROM student JOIN total ON total.student_id=student.student_id
ORDER BY s DESC LIMIT 1)
UNION ALL
(SELECT name,s FROM student JOIN total ON total.student_id=student.student_id
ORDER BY s LIMIT 1);


# 37. 查询每个班级的最高分和最低分。
WITH total AS (
    SELECT student_id,SUM(score) s FROM score GROUP BY student_id
),
rank_total AS (
    SELECT student.student_id,s,student.my_class,
           RANK() OVER (PARTITION BY my_class ORDER BY s DESC ) ran
    FROM student JOIN total ON total.student_id=student.student_id
),
rank_total2 AS (
    SELECT student.student_id,s,student.my_class,
           RANK() OVER (PARTITION BY my_class ORDER BY s ) ran
    FROM student JOIN total ON total.student_id=student.student_id
)
SELECT my_class,s FROM rank_total WHERE ran=1
UNION ALL
SELECT my_class,s FROM rank_total2 WHERE ran=1;
# 38. 查询每门课程的优秀率（优秀为90分）。
WITH total AS (
    SELECT course_id,COUNT(student_id) c FROM score GROUP BY course_id
)
SELECT score.course_id,
       FORMAT(COUNT(CASE WHEN score >=90 THEN 1 END )*100/c,2) "优秀率"
       FROM score JOIN total ON total.course_id=score.course_id GROUP BY score.course_id;
# 39. 查询平均分数超过班级平均分数的学生。
WITH total AS (
    SELECT student_id,AVG(score) a FROM score GROUP BY student_id
),
class AS (
    SELECT my_class,AVG(a) ac FROM student JOIN total ON total.student_id=student.student_id GROUP BY my_class
)
SELECT * FROM student JOIN total ON total.student_id=student.student_id
         JOIN class ON class.my_class=student.my_class WHERE a>ac;

# 40. 查询每个学生的分数及其与课程平均分的差值。
WITH total AS (
    SELECT course_id,AVG(score) a FROM score GROUP BY course_id
)
SELECT student.student_id,name,score-a "差值",score,a FROM student JOIN score ON student.student_id = score.student_id
    JOIN total ON total.course_id=score.course_id;