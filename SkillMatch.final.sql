-- مشروع SkillMatch: مقارنة مهارات الطالب مع متطلبات الوظائف (MySQL 8)


-- الخطوة 1: إنشاء قاعدة البيانات 
DROP DATABASE IF EXISTS SkillMatch;

CREATE DATABASE SkillMatch
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE SkillMatch;

SET NAMES utf8mb4;


-- الخطوة 2: إنشاء الجداول (ON DELETE CASCADE يحذف البيانات المرتبطة تلقائياً)

-- جدول المستخدمين
CREATE TABLE Users (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Major VARCHAR(100) NOT NULL,
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- جدول التصنيفات
CREATE TABLE Categories (
    Category_ID INT AUTO_INCREMENT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);

-- جدول المهارات (كل مهارة تابعة لتصنيف)
CREATE TABLE Skills (
    Skill_ID INT AUTO_INCREMENT PRIMARY KEY,
    Skill_Name VARCHAR(100) NOT NULL UNIQUE,
    Category_ID INT NOT NULL,
    Description VARCHAR(255),

    FOREIGN KEY (Category_ID)
        REFERENCES Categories(Category_ID)
);

-- جدول مهارات المستخدمين (ترتيب المستويات مهم: مبتدئ 1، متوسط 2، متقدم 3)
CREATE TABLE User_Skills (
    User_Skill_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,
    Skill_ID INT NOT NULL,
    Proficiency_Level ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL,

    FOREIGN KEY (User_ID)
        REFERENCES Users(User_ID) ON DELETE CASCADE,
    FOREIGN KEY (Skill_ID)
        REFERENCES Skills(Skill_ID) ON DELETE CASCADE,

    UNIQUE (User_ID, Skill_ID)
);

-- جدول الوظائف
CREATE TABLE Jobs (
    Job_ID INT AUTO_INCREMENT PRIMARY KEY,
    Job_Title VARCHAR(150) NOT NULL,
    Job_Description TEXT,
    Industry VARCHAR(100),
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- جدول مهارات الوظائف (المهارة المطلوبة ومستواها)
CREATE TABLE Job_Skills (
    Job_Skill_ID INT AUTO_INCREMENT PRIMARY KEY,
    Job_ID INT NOT NULL,
    Skill_ID INT NOT NULL,
    Required_Level ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL,

    FOREIGN KEY (Job_ID)
        REFERENCES Jobs(Job_ID) ON DELETE CASCADE,
    FOREIGN KEY (Skill_ID)
        REFERENCES Skills(Skill_ID) ON DELETE CASCADE,

    UNIQUE (Job_ID, Skill_ID)
);

-- جدول نتائج التحليل (مؤهل / تحتاج تطوير / ناقصة + نسبة التوافق، وصف واحد لكل مستخدم ووظيفة)
CREATE TABLE User_Job_Analysis (
    Analysis_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,
    Job_ID INT NOT NULL,
    Matched_Skills INT DEFAULT 0,
    Improve_Skills INT DEFAULT 0,
    Missing_Skills INT DEFAULT 0,
    Match_Percentage DECIMAL(5,2) DEFAULT 0.00,
    Analysis_Date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (User_ID)
        REFERENCES Users(User_ID) ON DELETE CASCADE,
    FOREIGN KEY (Job_ID)
        REFERENCES Jobs(Job_ID) ON DELETE CASCADE,

    UNIQUE (User_ID, Job_ID)
);


-- الخطوة 3: فهارس تسرّع عمليات الربط (JOIN)
CREATE INDEX idx_user_skills_skill ON User_Skills(Skill_ID);
CREATE INDEX idx_job_skills_skill  ON Job_Skills(Skill_ID);
CREATE INDEX idx_skills_category   ON Skills(Category_ID);


-- الخطوة 4: إدخال التصنيفات
INSERT INTO Categories (Category_Name, Description)
VALUES
('Programming',     'لغات البرمجة وأدوات التطوير'),
('Database',        'إدارة قواعد البيانات ولغة SQL'),
('Cybersecurity',   'أمن المعلومات وأمن الشبكات'),
('Networking',      'الشبكات والبنية التحتية'),
('Web Development', 'تقنيات تطوير المواقع'),
('Artificial Intelligence', 'الذكاء الاصطناعي وتحليل البيانات');


-- الخطوة 5: إدخال المهارات
INSERT INTO Skills (Skill_Name, Category_ID, Description)
VALUES
('Python',           1, 'لغة بايثون'),
('Java',             1, 'لغة جافا'),
('SQL',              2, 'لغة الاستعلام عن قواعد البيانات'),
('MySQL',            2, 'نظام إدارة قواعد البيانات MySQL'),
('Network Security', 3, 'حماية الشبكات'),
('Linux',            4, 'نظام لينكس وإدارة الخوادم'),
('HTML',             5, 'هيكلة صفحات الويب'),
('CSS',              5, 'تنسيق صفحات الويب'),
('JavaScript',       5, 'برمجة تفاعل صفحات الويب'),
('Ethical Hacking',  3, 'الاختراق الأخلاقي واختبار الاختراق'),
('Cryptography',     3, 'التشفير وحماية البيانات'),
('TCP/IP',           4, 'بروتوكولات الشبكات'),
('Machine Learning', 6, 'تعلّم الآلة'),
('Data Analysis',    6, 'تحليل البيانات'),
('Git',              1, 'إدارة نسخ الكود');


-- الخطوة 6: إدخال المستخدمين
INSERT INTO Users (Full_Name, Email, Major)
VALUES
('Fahad', 'fahad@example.com', 'Computer Science'),
('Ahmed', 'ahmed@example.com', 'Information Technology'),
('Sara',  'sara@example.com',  'Computer Science');


-- الخطوة 7: إدخال الوظائف
INSERT INTO Jobs (Job_Title, Job_Description, Industry)
VALUES
('Python Developer',       'تطوير تطبيقات باستخدام بايثون',        'Software Development'),
('Database Administrator', 'إدارة وصيانة قواعد البيانات',          'Database'),
('Cybersecurity Analyst',  'مراقبة الأنظمة وحمايتها من التهديدات', 'Cybersecurity'),
('Network Engineer',       'إدارة وصيانة الشبكات',                  'Networking'),
('Web Developer',          'بناء المواقع وصيانتها',                 'Web Development'),
('Penetration Tester',     'اختبار الأنظمة واكتشاف الثغرات',       'Cybersecurity'),
('Machine Learning Engineer', 'بناء نماذج الذكاء الاصطناعي',        'Artificial Intelligence'),
('Data Analyst',           'تحليل البيانات واستخراج النتائج',       'Artificial Intelligence');


-- الخطوة 8: إدخال مهارات الوظائف (رقم الوظيفة، رقم المهارة، المستوى المطلوب)
INSERT INTO Job_Skills (Job_ID, Skill_ID, Required_Level)
VALUES
-- Python Developer
(1, 1,  'Advanced'),
(1, 3,  'Intermediate'),
(1, 15, 'Beginner'),

-- Database Administrator
(2, 3,  'Advanced'),
(2, 4,  'Advanced'),
(2, 6,  'Intermediate'),

-- Cybersecurity Analyst
(3, 6,  'Intermediate'),
(3, 5,  'Advanced'),
(3, 3,  'Beginner'),
(3, 11, 'Intermediate'),

-- Network Engineer
(4, 6,  'Advanced'),
(4, 5,  'Intermediate'),
(4, 12, 'Advanced'),

-- Web Developer
(5, 7,  'Intermediate'),
(5, 8,  'Intermediate'),
(5, 9,  'Intermediate'),
(5, 1,  'Beginner'),

-- Penetration Tester
(6, 10, 'Advanced'),
(6, 6,  'Advanced'),
(6, 5,  'Intermediate'),
(6, 1,  'Intermediate'),

-- Machine Learning Engineer
(7, 1,  'Advanced'),
(7, 13, 'Advanced'),
(7, 14, 'Intermediate'),
(7, 3,  'Beginner'),

-- Data Analyst
(8, 14, 'Advanced'),
(8, 3,  'Intermediate'),
(8, 1,  'Intermediate');


-- الخطوة 9: إدخال مهارات المستخدمين (اللي يملكونها فعلياً)
INSERT INTO User_Skills (User_ID, Skill_ID, Proficiency_Level)
VALUES
-- Fahad
(1, 1,  'Intermediate'),
(1, 3,  'Beginner'),
(1, 6,  'Beginner'),
(1, 7,  'Intermediate'),
(1, 5,  'Beginner'),
(1, 15, 'Beginner'),

-- Ahmed
(2, 3,  'Advanced'),
(2, 4,  'Intermediate'),
(2, 6,  'Intermediate'),
(2, 12, 'Intermediate'),

-- Sara
(3, 1,  'Advanced'),
(3, 7,  'Advanced'),
(3, 8,  'Intermediate'),
(3, 9,  'Intermediate'),
(3, 13, 'Intermediate'),
(3, 14, 'Intermediate');


-- الخطوة 10: View يصنف كل مهارة مطلوبة (Qualified مؤهل / Needs Improvement تحتاج تطوير / Missing ناقصة)
-- Points: المؤهل 1، الناقصة 0، واللي يحتاج تطوير = مستواه ÷ المطلوب (و+0 تحول ENUM لرقم)
CREATE VIEW Skill_Status_View AS
SELECT
    U.User_ID,
    U.Full_Name,
    J.Job_ID,
    J.Job_Title,
    S.Skill_ID,
    S.Skill_Name,
    US.Proficiency_Level AS User_Level,
    JS.Required_Level,

    CASE
        WHEN US.Skill_ID IS NULL THEN 'Missing'
        WHEN (US.Proficiency_Level + 0) < (JS.Required_Level + 0) THEN 'Needs Improvement'
        ELSE 'Qualified'
    END AS Skill_Status,

    CASE
        WHEN US.Skill_ID IS NULL THEN 'ناقصة'
        WHEN (US.Proficiency_Level + 0) < (JS.Required_Level + 0) THEN 'تحتاج تطوير'
        ELSE 'مؤهل'
    END AS Skill_Status_AR,

    CASE
        WHEN US.Skill_ID IS NULL THEN 0
        WHEN (US.Proficiency_Level + 0) < (JS.Required_Level + 0)
            THEN (US.Proficiency_Level + 0) / (JS.Required_Level + 0)
        ELSE 1
    END AS Points

FROM Users U
CROSS JOIN Jobs J
JOIN Job_Skills JS ON JS.Job_ID = J.Job_ID
JOIN Skills S ON S.Skill_ID = JS.Skill_ID
LEFT JOIN User_Skills US
    ON US.Skill_ID = JS.Skill_ID
    AND US.User_ID = U.User_ID;


-- الخطوة 11: عرض البيانات للتأكد إنها انحفظت
SELECT * FROM Users;
SELECT * FROM Categories;
SELECT * FROM Skills;
SELECT * FROM Jobs;
SELECT * FROM Job_Skills;
SELECT * FROM User_Skills;


-- الخطوة 12: إجراء يعرض كل مهارة مطلوبة وحالتها، مثال: CALL Analyze_User_Job(1, 1);
DELIMITER //

CREATE PROCEDURE Analyze_User_Job(IN p_user_id INT, IN p_job_id INT)
BEGIN
    SELECT
        Full_Name,
        Job_Title,
        Skill_Name,
        User_Level,
        Required_Level,
        Skill_Status,
        Skill_Status_AR
    FROM Skill_Status_View
    WHERE User_ID = p_user_id
      AND Job_ID = p_job_id
    ORDER BY Skill_ID;
END //


-- الخطوة 13: إجراء يحسب نسبة التوافق (مجموع النقاط ÷ عدد المهارات × 100)، مثال: CALL Match_Percentage_For(1, 1);
CREATE PROCEDURE Match_Percentage_For(IN p_user_id INT, IN p_job_id INT)
BEGIN
    SELECT
        Full_Name,
        Job_Title,
        COUNT(*) AS Total_Required_Skills,
        SUM(Skill_Status = 'Qualified') AS Qualified_Skills,
        SUM(Skill_Status = 'Needs Improvement') AS Improve_Skills,
        SUM(Skill_Status = 'Missing') AS Missing_Skills,
        ROUND(SUM(Points) / COUNT(*) * 100, 2) AS Match_Percentage
    FROM Skill_Status_View
    WHERE User_ID = p_user_id
      AND Job_ID = p_job_id
    GROUP BY User_ID, Job_ID;
END //


-- الخطوة 14: إجراء يحفظ التحليل لكل المستخدمين مع كل الوظائف ويحدّثه لو موجود، مثال: CALL Save_All_Analysis();
CREATE PROCEDURE Save_All_Analysis()
BEGIN
    INSERT INTO User_Job_Analysis
        (User_ID, Job_ID, Matched_Skills, Improve_Skills, Missing_Skills, Match_Percentage)
    SELECT
        User_ID,
        Job_ID,
        SUM(Skill_Status = 'Qualified'),
        SUM(Skill_Status = 'Needs Improvement'),
        SUM(Skill_Status = 'Missing'),
        ROUND(SUM(Points) / COUNT(*) * 100, 2)
    FROM Skill_Status_View
    GROUP BY User_ID, Job_ID
    ON DUPLICATE KEY UPDATE
        Matched_Skills   = VALUES(Matched_Skills),
        Improve_Skills   = VALUES(Improve_Skills),
        Missing_Skills   = VALUES(Missing_Skills),
        Match_Percentage = VALUES(Match_Percentage),
        Analysis_Date    = CURRENT_TIMESTAMP;
END //


-- الخطوة 15: إجراء يعرض أنسب الوظائف لمستخدم من الأعلى للأقل، مثال: CALL Best_Jobs_For_User(1);
CREATE PROCEDURE Best_Jobs_For_User(IN p_user_id INT)
BEGIN
    SELECT
        U.Full_Name,
        J.Job_Title,
        A.Matched_Skills,
        A.Improve_Skills,
        A.Missing_Skills,
        A.Match_Percentage
    FROM User_Job_Analysis A
    JOIN Users U ON U.User_ID = A.User_ID
    JOIN Jobs J ON J.Job_ID = A.Job_ID
    WHERE A.User_ID = p_user_id
    ORDER BY A.Match_Percentage DESC;
END //

DELIMITER ;


-- الخطوة 16: تجربة المشروع

-- حالة كل مهارة لفهد مع وظيفة Python Developer
CALL Analyze_User_Job(1, 1);

-- نسبة توافق فهد مع Python Developer
CALL Match_Percentage_For(1, 1);

-- حفظ التحليل لكل المستخدمين مع كل الوظائف
CALL Save_All_Analysis();

-- أنسب الوظائف لفهد
CALL Best_Jobs_For_User(1);

-- أنسب الوظائف لكل مستخدم
SELECT
    U.Full_Name,
    J.Job_Title,
    A.Match_Percentage
FROM User_Job_Analysis A
JOIN Users U ON U.User_ID = A.User_ID
JOIN Jobs J ON J.Job_ID = A.Job_ID
ORDER BY U.Full_Name, A.Match_Percentage DESC;

-- المهارات الناقصة أو اللي تحتاج تطوير لكل مستخدم
SELECT
    Full_Name,
    Job_Title,
    Skill_Name,
    User_Level,
    Required_Level,
    Skill_Status,
    Skill_Status_AR
FROM Skill_Status_View
WHERE Skill_Status <> 'Qualified'
ORDER BY Full_Name, Job_Title, Skill_Name;

-- عدد التحليلات المحفوظة
SELECT COUNT(*) AS Total_Analyses
FROM User_Job_Analysis;
