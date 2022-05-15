--Creating Student Table
USE Vietnamedu;
GO
CREATE TABLE [dbo].[Studentdata](
UNIQUEID [nvarchar] (50) not null,
SCHOOLID int not null,
CLASSID smallint not null,
STUDENTID int not null,
YLCHILDID [nvarchar] (50),
DISTRICTCODE smallint,
LOCALITY smallint,
GENDER smallint,
AGE int,
ETHNICITY int,
ABSENT_DAYS int,
MOM_READ bit,
MOM_EDUC smallint,
DAD_READ bit,
DAD_EDUC smallint,
MATH_RAWSCORE int,
ENG_RAWSCORE int);

ALTER TABLE dbo.Studentdata ADD CONSTRAINT
	PK_Studentdata PRIMARY KEY CLUSTERED 
	(
	UNIQUEID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

INSERT INTO Vietnamedu.dbo.Studentdata
(UNIQUEID,SCHOOLID,CLASSID,STUDENTID,YLCHILDID,DISTRICTCODE,LOCALITY,GENDER,AGE,
ETHNICITY,ABSENT_DAYS,MOM_READ,MOM_EDUC,DAD_READ,DAD_EDUC,MATH_RAWSCORE,ENG_RAWSCORE)
SELECT UNIQUEID,SCHOOLID,CLASSID,STUDENTID,YLCHILDID,DISTRICTCODE,LOCALITY,GENDER,AGE,
ETHNICITY,ABSENT_DAYS,MOM_READ,MOM_EDUC,DAD_READ,DAD_EDUC,MATH_RAWSCORE,ENG_RAWSCORE
FROM Vietnamedu.dbo.vietnam_wave_1


--Creating school_class table
CREATE TABLE [dbo].[school_class](
ID int IDENTITY(1,1) not null,
SCHOOLID int not null,
PROVINCE int not null,
TOTALNUMBEROFSTUDENTS int not null,
TOTALNUMBEROFCLASS int not null,
CONSTRAINT
	PK_Student_class PRIMARY KEY CLUSTERED 
	(
	ID ASC
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY]
GO

INSERT INTO Vietnamedu.dbo.[school_class]
(PROVINCE, SCHOOLID, TOTALNUMBEROFCLASS, TOTALNUMBEROFSTUDENTS)
SELECT DISTINCT  A.SCHOOLID,A.PROVINCE, B.NUMBER_OF_STUDENTS, B.NUMBER_OF_CLASSES
FROM Vietnamedu.dbo.vietnam_wave_1 A
LEFT JOIN
(SELECT SCHOOLID, COUNT (DISTINCT(CLASSID)) AS NUMBER_OF_CLASSES,
COUNT (UNIQUEID) AS NUMBER_OF_STUDENTS
FROM Vietnamedu.dbo.vietnam_wave_1
GROUP BY SCHOOLID) AS B
ON A.SCHOOLID = B.SCHOOLID
ORDER BY SCHOOLID ASC


VIEWS
--STUDENTS WITH HIGHEST RESULT
CREATE VIEW STUDENTS_WITH_HIGHEST_RESULT AS
SELECT DISTRICTCODE, COUNT (DISTRICTCODE) AS FREQUENCY
FROM Vietnamedu.dbo.vietnam_wave_1
WHERE ENG_RAWSCORE>=35 AND MATH_RAWSCORE>=35
GROUP BY DISTRICTCODE


--Students With Minimum Result 
CREATE View Students_With_Min_Result AS
SELECT DISTRICTCODE, COUNT (DISTRICTCODE) AS FREQUENCY
FROM Vietnamedu.dbo.vietnam_wave_1
WHERE ENG_RAWSCORE<=10 AND MATH_RAWSCORE<=10
GROUP BY DISTRICTCODE


--Student_Gender_By_District
CREATE VIEW Student_Gender_ByDistrict AS
SELECT A.DISTRICTCODE, A.MALE, B.FEMALE
FROM 
(SELECT DISTRICTCODE, COUNT(GENDER) AS MALE
FROM dbo.Studentdata
WHERE GENDER = 1
GROUP BY DISTRICTCODE) AS A
LEFT JOIN
(SELECT DISTRICTCODE, COUNT(GENDER) AS FEMALE
FROM dbo.Studentdata
WHERE GENDER = 2
GROUP BY DISTRICTCODE) AS B
ON A.DISTRICTCODE=B.DISTRICTCODE



--Create views at the same filtering the data to remove rows with empty values---

USE Vietnamedu;
--creating view by protecting modification of data through the use of union and condition was used --
CREATE VIEW VietnamSchool1 AS
SELECT UNIQUEID,SCHOOLID, CLASSID,PROVINCE,DISTRICTCODE,LOCALITY,GENDER,AGE,ETHNICITY,ABSENT_DAYS,MOM_READ,MOM_EDUC,DAD_READ,DAD_EDUC,
    STDLIV,STDMEAL
FROM Vietnamedu.dbo.vietnam_wave_1 WHERE UNIQUEID !=''and SCHOOLID!=''and CLASSID!=''and PROVINCE!=''and DISTRICTCODE!=''and LOCALITY!=''
and GENDER!=''and AGE!=''and ETHNICITY!=''and ABSENT_DAYS!='' and MOM_READ!=''and MOM_EDUC!=''and DAD_READ!=''and DAD_EDUC!=''
and STDLIV!=''and STDMEAL!=''
UNION 
SELECT UNIQUEID,SCHOOLID, CLASSID,PROVINCE,DISTRICTCODE,LOCALITY,GENDER,AGE,ETHNICITY,ABSENT_DAYS,MOM_READ,MOM_EDUC,DAD_READ,DAD_EDUC,
    STDLIV,STDMEAL
FROM Vietnamedu.dbo.vietnam_wave_1
WHERE 1 =2



USE Vietnamedu;
--creating view to protect modification of data union and condition was used --
CREATE VIEW VietnamSchool2 AS
SELECT UNIQUEID,SCHOOLID, CLASSID,STNTCMP, STMTHWRK,STMWRKCH,STMWRKCM,STETHWRK,STEWRKCH,STEWRKCM,STTMMWRK,STTMEWRK,STCMPHME,STCMPSCH
     ,STCMPOTH,STLTESCH,STMSSDAY,STMSSCLS
FROM Vietnamedu.dbo.vietnam_wave_2 WHERE UNIQUEID !=''and SCHOOLID!=''and CLASSID!=''and STNTCMP!=''and STMTHWRK!=''and STMWRKCH!=''and 
STMWRKCM!=''and STETHWRK!=''and STEWRKCH!=''and STEWRKCM!=''and STTMMWRK!=''and STTMEWRK!=''and STCMPHME!=''and STCMPSCH !=''and
     STCMPOTH!=''and STLTESCH !=''and STMSSDAY !=''and STMSSCLS !=''
UNION 
SELECT UNIQUEID,SCHOOLID, CLASSID,STNTCMP, STMTHWRK,STMWRKCH,STMWRKCM,STETHWRK,STEWRKCH,STEWRKCM,STTMMWRK,STTMEWRK,STCMPHME,STCMPSCH
     ,STCMPOTH,STLTESCH,STMSSDAY,STMSSCLS
FROM Vietnamedu.dbo.vietnam_wave_2
WHERE 1 =2


--creating various reports using grouping ---

--Getting Reports on number of schools in each province--
--creating various reports using grouping ---
SELECT  COUNT (DISTINCT (SCHOOLID)) AS Number_of_schools, PROVINCE
FROM VietnamSchool1 
Group by PROVINCE

-- defined function to convert chsex --
create function Gender(@chsex int) returns varchar(6) as
begin 
	DECLARE @gen varchar(6)
	if (@chsex = 1) 
	SET  @gen = 'male';
	else
	SET @gen = 'female';
	return @gen;
end;


--Create report to get number of Student in each province based on gender--
SELECT count(*) AS Number_of_Students, PROVINCE, Vietnamedu.[dbo].[Gender](GENDER) as GENDER
FROM VietnamSchool1 
Group by PROVINCE, GENDER order by PROVINCE


--Report for number of students in each school based on gender and province--
SELECT count(*) AS Number_of_Students, SCHOOLID AS SCHOOL, PROVINCE, Vietnamedu.[dbo].[Gender](GENDER) as GENDER
FROM VietnamSchool1 
Group by PROVINCE, GENDER,SCHOOLID order by SCHOOLID

