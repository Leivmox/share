### **请自己设计表**

下面是示例

满足对模拟数据中包含**缺失值、异常值、重复值、非法格式数据**的要求

### ✅ 1. 学生信息表（**students.csv**）

| student_id | student_name | student_gender | major            |
| ---------- | ------------ | -------------- | ---------------- |
| S001       | 张伟         | 男             | 计算机科学与应用 |
| S002       | 李@娜        | 女             | 软件工程         |
| S003       | 王磊         | NULL           | 网络工程         |
| S004       | 赵敏         | 女             | 物联网           |
| S005       | 张伟         | 男             | 计算机科学与应用 |
| S006       | 刘强东       | 男             | 网络工程         |
| S007       | 王一博       | 女             | 物联网           |

🔍 **脏数据说明**：

- S002 姓名含非法字符“@”
- S003 性别缺失（NULL）
- S005 是 S001 的重复记录（测试去重）



### ✅ 2. 课程信息表（**courses.csv**）

| course_id | course_name    | course_type | course_credit |
| --------- | -------------- | ----------- | ------------- |
| C001      | 软件项目管理   | 必修        | 3             |
| C002      | 人工智能导论   | 选修        | 2             |
| C003      | 大数据技术基础 | 必修        | 3             |
| C004      | 系统分析与设计 | xuanxiu     | 2             |
| C005      | 数据结构与算法 | 必修        | 3             |

🔍 **脏数据说明**：

- C004 的课程类型为拼音 `xuanxiu`，非标准“选修”

------



### ✅ 3. 选课信息表（**enrollments.csv**）

| enrollment_id | student_id | course_id |
| ------------- | ---------- | --------- |
| E001          | S001       | C001      |
| E002          | S001       | C002      |
| E003          | S002       | C001      |
| E004          | S002       | C002      |
| E005          | S003       | C001      |
| E006          | S004       | C003      |
| E007          | S004       | C004      |
| E008          | S006       | C003      |
| E009          | S006       | C004      |
| E010          | S007       | C005      |
| E011          | S007       | C003      |
| E012          | S001       | C001      |

🔍 **脏数据说明**：

- E012 是 S001 重复选 C001，模拟重复选课

📉 缩减说明：原本数据表可能有 16 条左右，现在精简为 12 条。



### ✅ 4. 成绩信息表（**grades.csv**）

| grade_id | enrollment_id | grade |
| -------- | ------------- | ----- |
| G001     | E001          | 88    |
| G002     | E002          | 95    |
| G003     | E003          | 108   |
| G004     | E004          | 0     |
| G005     | E005          |       |
| G006     | E006          | 76    |
| G007     | E007          | 83    |
| G008     | E008          | 90    |
| G009     | E009          | 67    |
| G010     | E010          | 79    |
| G011     | E011          | 81    |
| G012     | E012          | 88    |

### 📂 附加说明：

- 所有数据表建议另存为 UTF-8 编码的 `.csv` 文件，字段使用英文半角逗号分隔。
- 表头应保留，避免 Hive 导入时字段错位。
- 可通过 `hdfs dfs -put` 命令上传至 Hadoop，再使用 Hive `LOAD DATA` 加载。

如需我生成这些 `.csv` 文件内容或提供 Hive 建表语句、清洗 SQL，请告诉我，我可以继续帮你完成后续部分。





## ✅ 一、把 `.xls` 文件保存为 `.csv` 文件

你可以用 **WPS / Excel** 等工具打开 `.xls` 文件后按以下操作：

### **步骤**（适用于 Excel 或 WPS 表格）：

1. 打开你的 `.xls` 文件。
2. 点击左上角的【文件】 > 【另存为】。
3. 在弹出的保存窗口中：
   - **文件类型选择为**：`CSV（逗号分隔）（*.csv）`
   - **文件名建议用英文**，如：`students.csv`、`courses.csv` 等。
   - 编码选择 UTF-8（如果提示的话）。
4. 保存后，使用文本编辑器（如 Notepad++ 或 VS Code）打开 `.csv` 文件确认格式正确（无中文乱码，字段用逗号分隔，首行为表头）。







## ✅ 三、是否要运行 Hive 初始化仓库？

如果你是第一次运行 Hive，并且还没有初始化元数据库（metastore），请先检查是否需要初始化。

### 👇 判断方法：

在终端输入：

```
schematool -dbType derby -initSchema

```

- 如果返回 `schemaTool completed`，说明初始化成功；
- 如果返回已经初始化过，就不需要再执行了。

⚠️ 注意：

- 如果你用的是 **默认的 Derby 数据库**，这个初始化只需执行一次。
- 如果后期改成 MySQL 或其他元数据库，需要不同的初始化方式。

------

## ✅ 四、准备把 CSV 数据导入 Hive 表

你需要：

1. 创建 Hive 表结构（DDL），字段要和你 `.csv` 中的表头一一对应。
2. 使用 `LOAD DATA` 或 `INSERT` 命令把 `.csv` 文件中的数据导入 Hive 表。

------



### 第一步：创建 Hive 数据库

在 Hive 命令行中输入：

注:这里的student_scores为自己创建的数据库名字,可以不一样

```
CREATE DATABASE IF NOT EXISTS student_scores;
USE student_scores;

```

### 第二步：创建 Hive 表结构

#### 1. 学生信息表 `students`

```
CREATE TABLE IF NOT EXISTS students (
    student_id STRING,
    student_name STRING,
    student_gender STRING,
    major STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

```

#### 2. 课程信息表 `courses`

```
CREATE TABLE IF NOT EXISTS courses (
    course_id STRING,
    course_name STRING,
    course_type STRING,
    course_credit INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

```

#### 3. 选课信息表 `enrollments`

```
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id STRING,
    student_id STRING,
    course_id STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

```

#### 4. 成绩信息表 `grades`

```
CREATE TABLE IF NOT EXISTS grades (
    grade_id STRING,
    enrollment_id STRING,
    grade INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

```

### 第三步：上传 CSV 文件到 HDFS

> 假设你的文件在虚拟机的 `/home/hadoop/data/` 目录，文件名如 `courses.csv`。

#### 1. 把本地文件上传到 HDFS：

注:student_scores为数据库名字,得和之前的保持一致

```
hdfs dfs -mkdir -p /user/hive/warehouse/student_scores/courses
hdfs dfs -put (你的表文件位置)courses.csv /user/hive/warehouse/student_scores/courses/

```

（注意其他表也要建文件夹并上传对应 CSV）

```
hdfs dfs -mkdir -p /user/hive/warehouse/student_scores/grades
hdfs dfs -put (你的表文件位置)grade.csv /user/hive/warehouse/student_scores/grades/

hdfs dfs -mkdir -p /user/hive/warehouse/student_scores/courses
hdfs dfs -put (你的表文件位置)students.csv /user/hive/warehouse/student_scores/students/

hdfs dfs -mkdir -p /user/hive/warehouse/student_scores/courses
hdfs dfs -put (你的表文件位置)enrollments.csv /user/hive/warehouse/student_scores/enrollments/
```



------

### 第四步：将数据导入 Hive 表（外部数据文件方式）

> 前面你已创建好表，现在让 Hive 读取 HDFS 上的数据

```
LOAD DATA INPATH '/user/hive/warehouse/student_scores/courses/courses.csv'
INTO TABLE courses;

```



对其他表也按此格式执行：

```
LOAD DATA INPATH '/user/hive/warehouse/student_scores/students/students.csv'
INTO TABLE students;

LOAD DATA INPATH '/user/hive/warehouse/student_scores/enrollments/enrollments.csv'
INTO TABLE enrollments;

LOAD DATA INPATH '/user/hive/warehouse/student_scores/grades/grades.csv'
INTO TABLE grades;

```

## ✅ 验证数据是否成功导入

你可以执行以下语句查看数据：

```
SELECT * FROM courses LIMIT 10;
SELECT COUNT(*) FROM students;

```

## ✅ 正确操作流程（确保 CSV 文件上传到 HDFS 正确目录）

你需要：

------

### 🔹 第一步：确保文件已上传到 HDFS

请在你的虚拟机 Linux 终端运行以下命令，确认文件存在：

```
hdfs dfs -ls /user/hive/warehouse/student_scores/grades/

```



如果你看到 `grades.csv` 文件在里面，说明文件存在。

> 



### 🔹 第四步：回到 Hive 执行导入命令

```
USE student_scores;

LOAD DATA INPATH '/user/hive/warehouse/student_scores/grades/grades.csv'
INTO TABLE grades;

```





## ✅ 五、数据清洗与修复

# **这里的代码请根据自己的表设计的缺陷设计**

# **!!!不能直接抄用!!!**

# **请根据自己的表的错误,去设计查询和清洗语句**

------

### 🔹 5.1 缺失值处理（Missing Values）

**目的**：找出表中字段为 `NULL` 或空字符串的记录，并决定是否填补、删除或保留。

#### ✅ 示例：查找缺失性别的学生记录

```
SELECT * FROM students WHERE student_gender IS NULL OR TRIM(student_gender) = '';

```

如有缺失，可根据业务需求执行：

> Hive 默认是**不可更新的**（除非使用 ACID 表），所以可以用 **CTAS 或 INSERT OVERWRITE** 方式创建新表：

```
CREATE TABLE students_cleaned AS
SELECT 
  student_id, 
  student_name, 
  COALESCE(NULLIF(TRIM(student_gender), ''), '未知') AS student_gender, 
  major
FROM students;

```



### 🔹 5.2 异常值检测与修正（Outliers）

**目的**：识别不合理的数值，例如 `grade < 0` 或 `grade > 100`。

#### ✅ 示例：找出成绩异常的记录

```
SELECT * FROM grades WHERE grade < 0 OR grade > 100;

```

你可选择**过滤掉异常数据**或**将其替换为 NULL 以便后续处理**：

```
CREATE TABLE grades_cleaned AS
SELECT 
  grade_id, 
  enrollment_id,
  CASE 
    WHEN grade >= 0 AND grade <= 100 THEN grade
    ELSE NULL
  END AS grade
FROM grades;

```

### 🔹 5.3 重复值识别与去重（Duplicates）

**目的**：避免重复影响统计结果，比如学生重复选课。

#### ✅ 示例：找出重复选课（同一个学生选了同一门课多次）

```
SELECT student_id, course_id, COUNT(*)
FROM enrollments
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

```

如需去重，可保留一条记录，方法如下：

```
CREATE TABLE enrollments_dedup AS
SELECT enrollment_id, student_id, course_id
FROM (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY student_id, course_id ORDER BY enrollment_id) AS rn
  FROM enrollments
) t
WHERE rn = 1;

```



### 🔹 5.4 清洗后的数据验证

**目的**：确认清洗是否成功，表结构合理、无异常。

#### ✅ 示例：验证清洗后无 NULL 成绩

```sql
SELECT * FROM grades_cleaned WHERE grade IS NULL;

```

#### ✅ 示例：验证 student_gender 无空值

```sql
SELECT * FROM students_cleaned WHERE student_gender IS NULL OR TRIM(student_gender) = '';

```

#### ✅ 示例：验证重复数据是否处理完毕

```sql
SELECT student_id, course_id, COUNT(*)
FROM enrollments_dedup
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

```

✅ 六、数据分析与查询实现



# 这里清洗后是重新创建了新的表

# 查询用的是新的表名

# 请根据自己的表名进行查询

### 🔹 6.1 查询一：统计每门课程的选课人数

**目标**：每门课程被多少学生选修。

#### ✅ HiveQL 查询语句：

```sql
SELECT 
  c.course_id,
  c.course_name,
  COUNT(DISTINCT e.student_id) AS enrollment_count
FROM 
  courses c
JOIN 
  enrollments_dedup e ON c.course_id = e.course_id
GROUP BY 
  c.course_id, c.course_name
ORDER BY 
  enrollment_count DESC;

```

### 🔹 6.2 查询二：找出平均成绩最高的前 5 门课程

**目标**：根据成绩表，统计每门课程的平均成绩，并返回前 5 名。

#### ✅ HiveQL 查询语句：

```sql
SELECT 
  c.course_id,
  c.course_name,
  ROUND(AVG(g.grade), 2) AS avg_grade
FROM 
  grades_cleaned g
JOIN 
  enrollments_dedup e ON g.enrollment_id = e.enrollment_id
JOIN 
  courses c ON e.course_id = c.course_id
WHERE 
  g.grade IS NOT NULL
GROUP BY 
  c.course_id, c.course_name
ORDER BY 
  avg_grade DESC
LIMIT 5;

```

### 🔹 6.3 查询三：分析不同专业学生的平均成绩分布

**目标**：每个专业的学生平均成绩。

#### ✅ HiveQL 查询语句：

```sql
SELECT 
  s.major,
  ROUND(AVG(g.grade), 2) AS avg_grade
FROM 
  grades_cleaned g
JOIN 
  enrollments_dedup e ON g.enrollment_id = e.enrollment_id
JOIN 
  students_cleaned s ON e.student_id = s.student_id
WHERE 
  g.grade IS NOT NULL
GROUP BY 
  s.major
ORDER BY 
  avg_grade DESC;

```