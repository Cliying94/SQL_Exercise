--CREATE TABLE GRADES (CLASSID NVARCHAR(1),CATEGORY NVARCHAR(2) COLLATE Chinese_PRC_CI_AS, STUDENTID NVARCHAR(4), GRADE int)
----SELECT DATABASEPROPERTYEX('(localdb)MSSQLLocalDB','collation')

--ALTER TABLE GRADES
--ALTER COLUMN CATEGORY NVARCHAR(2) COLLATE Chinese_PRC_CI_AS

--INSERT INTO GRADES (CLASSID, CATEGORY,STUDENTID,GRADE)
--VALUES ('A',N'國文','A001',86),('A',N'數學','A001',97),('A',N'英文','A001',100),
--('A',N'國文','A002',33),('A',N'數學','A002',50),('A',N'英文','A002',77),
--('A',N'國文','A003',100),('A',N'數學','A003',30),('A',N'英文','A003',99),
--('B',N'國文','B001',50),('B',N'數學','B001',60),('B',N'英文','B001',70),
--('B',N'國文','B002',55),('B',N'數學','B002',100),('B',N'英文','B002',98),
--('B',N'國文','B003',1),('B',N'數學','B003',50),('B',N'英文','B003',99)


SELECT * FROM grades

DECLARE @StudentHigh int = 80
DECLARE @StudenPass int = 60


;WITH CTE_a(A班科目, A級人數80分以上,[B級人數60~79],[C級人數0~59]) AS(
 SELECT category,
 COUNT(CASE WHEN grade > @StudentHigh THEN grade ELSE NULL END) as N'A級人數80分以上',
 COUNT(CASE WHEN grade BETWEEN @StudenPass AND @StudentHigh THEN grade ELSE NULL END) AS N'B級人數60~79',
 COUNT(CASE WHEN grade < @StudenPass THEN grade ELSE NULL END) AS N'C級人數0~59'
 FROM GRADES  WHERE classID = 'A' group by category
),

CTE_b(A班科目,A級平均分數80分以上,[B級平均分數60~79],[C級平均分數0~59]) AS(
 SELECT 
 	CATEGORY,
 	AVG(CASE WHEN grade > @StudentHigh THEN grade ELSE NULL END )AS N'A級平均分數80分以上',
 	AVG(CASE WHEN grade BETWEEN @StudenPass AND @StudentHigh THEN grade ELSE null END) as N'B級平均分數60~79',
 	AVG(CASE WHEN GRADE < @StudenPass THEN grade ELSE null END) as N'C級平均分數0~59'
 FROM grades group by CATEGORY
 )

SELECT CTE_a.A班科目, A級人數80分以上,[B級人數60~79],[C級人數0~59],A級平均分數80分以上,[B級平均分數60~79],[C級平均分數0~59] FROM CTE_a 
INNER JOIN CTE_b 
ON CTE_a.A班科目 = CTE_b.A班科目
