USE Assessment

/*CREATING SCHEMA 
Given the Information contained in the Datasets, Four main schemas were created to ensure Data Security and Privacy. 
These includes:
	- AllChildInfo: It contains non-sensitive information about each child
	- HealthInfo: This contains Health information about each child and would be accessed only by a health personnel
	- EduInfo: This contains information about the child's education and would be accessed by the Education personnel
	- HouseHoldInfo: This contains the household information which can be assessed by anyone but would strictly be on request
*/
CREATE SCHEMA [EduInfo]
GO

CREATE SCHEMA [AllChildInfo]
GO

CREATE SCHEMA [HealthInfo]
GO

CREATE SCHEMA [HouseHoldInfo]
GO

/*
	STORED PROCEDURES
The Stored procedures was created so as to ease the table creation and data loading into a table 
*/

	-- Creating a new table
CREATE PROC [dbo].[spNewTab]
	@NewTableName NVARCHAR(30), --new table name
	@columns NVARCHAR(max), -- columns to be inserted
	@oldTable NVARCHAR(30) --the old table name
AS
	EXEC('SELECT ' + @columns + ' INTO '  + @NewTableName + ' FROM ' + @oldTable + ' ORDER BY childid')
GO

	--Data loading into an existing table
CREATE PROC [dbo].[spIntoExistTab]
	@InsertTableName NVARCHAR(30), --Existing Table name
	@columnInsert NVARCHAR(max), -- Column names in the new table
	@columns NVARCHAR(max), -- Columns to be inserted
	@TableRead NVARCHAR(30) --Table to be read from
AS
	EXEC('INSERT INTO ' + @InsertTableName + '(' + @columnInsert + ')' + ' SELECT ' + @columns +  ' FROM ' + @TableRead)
-------------------------END------------------------
GO


USE Assessment
/*
==================NEW SCHEMA===================
	POPULATING THE GENERAL CHILD INFORMATION INTO THE SCHEMA
*/

-- General Data of the Child
EXEC spNewTab 'AllChildInfo.Basic_data', 'DISTINCT [childid], [round], [yc],[agemon],[chethnic], [chldrel],[chsex], [chlang]', 'dbo.ethiopia_data';
EXEC spIntoExistTab 'AllChildInfo.Basic_data', 
	'[childid], [round],[yc],[agemon],[chethnic], [chldrel],[chsex], [chlang]',
	'DISTINCT [childid], [round],[yc],[agemon],[chethnic], [chldrel],[chsex], [chlang]', 'dbo.india_data';

EXEC spIntoExistTab 'AllChildInfo.Basic_data', '[childid], [round],[yc],[agemon],[chethnic], [chldrel],[chsex], [chlang]',
	'DISTINCT [childid], [round],[yc],[agemon],[chethnic], [chldrel],[chsex], [chlang]', 'dbo.vietnam_data';

EXEC spIntoExistTab  'AllChildInfo.Basic_data', '[childid], [round],[yc],[agemon],[chethnic], [chldrel],[chsex], [chlang]', 
	'DISTINCT [childid], [round],[yc],[agemon],[chethnic], [chldrel],[chsex], [chlang]', 'dbo.peru_data';


ALTER TABLE AllChildInfo.Basic_data
ALTER COLUMN childid VARCHAR(15) NOT NULL;


ALTER TABLE AllChildInfo.Basic_data
ALTER COLUMN [round] VARCHAR(10) NOT NULL;

ALTER TABLE AllChildInfo.Basic_data
ADD PRIMARY KEY(childid, [round]);


-- SURVEY ROUND INFORMATION
EXEC spNewTab 'AllChildInfo.SurvRoundInfo', 
'[childid], [round], [inround],	[panel], [deceased], [dint], [commid], [clustid], [region],	[typesite],	[childloc]', 
'dbo.ethiopia_data';

EXEC spIntoExistTab 'AllChildInfo.SurvRoundInfo', 
'[childid], [round], [inround],	[panel], [deceased], [dint], [commid], [clustid], [region],	[typesite],	[childloc]', 
'[childid], [round],	[inround],	[panel12345],	[deceased],	[dint],	[commid],	[clustid],	[region],	[typesite],	[childloc]', 
'dbo.india_data';

EXEC spIntoExistTab 'AllChildInfo.SurvRoundInfo',
'[childid], [round], [inround],	[panel], [deceased], [dint], [commid],	[clustid], [region], [typesite], [childloc]', 
'[childid], [round], [inround],	[panel12345], [deceased], [dint], [commid],	[clustid],	[region], [typesite], [childloc]',
'dbo.vietnam_data';

EXEC spIntoExistTab  'AllChildInfo.SurvRoundInfo', 
'[childid], [round], [inround],	[panel], [deceased], [dint], [commid], [clustid], [region],	[typesite],	[childloc]',
'[childid], [round],	[inround],	[panel12345],	[deceased],	[dint],	[placeid],	[clustid],	[region],	[typesite],	[childloc]', 
'dbo.peru_data';


ALTER TABLE AllChildInfo.SurvRoundInfo
ALTER COLUMN childid VARCHAR(15) NOT NULL;

ALTER TABLE AllChildInfo.SurvRoundInfo
ALTER COLUMN round VARCHAR(10) NOT NULL;

ALTER TABLE AllChildInfo.SurvRoundInfo
ADD PRIMARY KEY(childid, round);

--CREATING A FOREIGN KEY
ALTER TABLE AllChildInfo.SurvRoundInfo  WITH CHECK ADD CONSTRAINT FK_SurvRoundInfo 
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.Basic_data(childid, round);
ALTER TABLE AllChildInfo.SurvRoundInfo CHECK CONSTRAINT FK_SurvRoundInfo;



-- INFORMATION ABOUT HOW THE TIME IS BEING USED : Holds information about the child's time use
SELECT 
	[childid], [round], [hsleep], 	[hcare], [hchore],  [htask],
	[hwork], [hschool], [hstudy], [hplay], [commwork], [commsch]
INTO
	AllChildInfo.TimeUsage
FROM 
	dbo.india_data
WHERE 
	hsleep NOT LIKE '';
INSERT INTO
	AllChildInfo.TimeUsage
	(
	[childid], [round], [hsleep], 	[hcare], [hchore],  [htask],
	[hwork], [hschool], [hstudy], [hplay], [commwork], [commsch]
	)
SELECT 
	[childid], [round], [hsleep], 	[hcare], [hchore],  [htask],
	[hwork], [hschool], [hstudy], [hplay], [commwork], [commsch]
FROM 
	dbo.ethiopia_data
WHERE 
	hsleep NOT LIKE '';
INSERT INTO
	AllChildInfo.TimeUsage
	(
	[childid], [round], [hsleep], 	[hcare], [hchore],  [htask],
	[hwork], [hschool], [hstudy], [hplay], [commwork], [commsch]
	)
SELECT 
	[childid], [round], [hsleep], 	[hcare], [hchore],  [htask],
	[hwork], [hschool], [hstudy], [hplay], [commwork], [commsch]
FROM dbo.peru_data
WHERE hsleep NOT LIKE '';
INSERT INTO
	AllChildInfo.TimeUsage
	(
	[childid], [round], [hsleep], 	[hcare], [hchore],  [htask],
	[hwork], [hschool], [hstudy], [hplay], [commwork], [commsch]
	)
SELECT 
	[childid], [round], [hsleep], 	[hcare], [hchore],  [htask],
	[hwork], [hschool], [hstudy], [hplay], [commwork], [commsch]
FROM dbo.vietnam_data
WHERE hsleep NOT LIKE '';
ALTER TABLE AllChildInfo.TimeUsage
ALTER COLUMN childid VARCHAR(15) NOT NULL;
ALTER TABLE AllChildInfo.TimeUsage
ALTER COLUMN [round] VARCHAR(10) NOT NULL;
ALTER TABLE AllChildInfo.TimeUsage
ADD ID INT IDENTITY NOT NULL;
--CREATING A FOREIGN KEY
ALTER TABLE AllChildInfo.TimeUsage  WITH CHECK ADD CONSTRAINT FK_TimeUsage 
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.SurvRoundInfo(childid, round);
ALTER TABLE AllChildInfo.TimeUsage CHECK CONSTRAINT FK_TimeUsage;


--MARRIAGE/COHABITATION TABLE
SELECT
	[childid],
	[round],
	[marrcohab],
	[marrcohab_age],
	[birth],
	[birth_age]
INTO
	AllChildInfo.MarrCohab
FROM 
	dbo.ethiopia_data

INSERT INTO
	AllChildInfo.MarrCohab
SELECT
	[childid], [round], [marrcohab],
	[marrcohab_age], [birth], [birth_age]
FROM 
	dbo.india_data

INSERT INTO
	AllChildInfo.MarrCohab
SELECT
	[childid], [round], [marrcohab],
	[marrcohab_age], [birth], [birth_age]
FROM 
	dbo.peru_data

INSERT INTO
	AllChildInfo.MarrCohab
SELECT
	[childid], [round], [marrcohab],
	[marrcohab_age], [birth], [birth_age]
FROM 
	dbo.vietnam_data

ALTER TABLE AllChildInfo.MarrCohab
ALTER COLUMN childid VARCHAR(15) NOT NULL;
ALTER TABLE AllChildInfo.MarrCohab
ALTER COLUMN [round] VARCHAR(10) NOT NULL;
--CREATING A FOREIGN KEY
ALTER TABLE AllChildInfo.MarrCohab  WITH CHECK ADD CONSTRAINT FK_MarrCohab
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.SurvRoundInfo(childid, round);
ALTER TABLE AllChildInfo.MarrCohab CHECK CONSTRAINT FK_MarrCohab;

/*
===================NEW SCHEMA=======================
	POPULATING THE HEALTH INFORMATION SCHEMA
*/

-----BirthInfo Table: This was recorded only for younger cohorts
SELECT
	DISTINCT childid,[round], [yc], [bwght], [bwdoc], [numante], [delivery], [tetanus] 
INTO
	HealthInfo.Birthdetails
FROM
	dbo.india_data
WHERE 
	yc = 1 AND (bwdoc NOT LIKE '' OR numante NOT LIKE '');
INSERT INTO
	HealthInfo.Birthdetails (childid,[round], [yc], [bwght], [bwdoc], [numante], [delivery], [tetanus])
SELECT
	DISTINCT childid,[round], [yc], [bwght], [bwdoc], [numante], [delivery], [tetanus] 
FROM
	dbo.ethiopia_data
WHERE 
	yc = 1 AND (bwdoc NOT LIKE '' OR numante NOT LIKE '');
INSERT INTO
	HealthInfo.Birthdetails (childid,[round], [yc], [bwght], [bwdoc], [numante], [delivery], [tetanus])
SELECT
	DISTINCT childid,[round], [yc], [bwght], [bwdoc], [numante], [delivery], [tetanus] 
FROM
	dbo.peru_data
WHERE yc = 1 AND (bwdoc NOT LIKE '' OR numante NOT LIKE '');
INSERT INTO
	HealthInfo.Birthdetails (childid,[round], [yc], [bwght], [bwdoc], [numante], [delivery], [tetanus])
SELECT
	DISTINCT childid,[round], [yc], [bwght], [bwdoc], [numante], [delivery], [tetanus] 
FROM
	dbo.vietnam_data
WHERE 
	yc = 1 AND (bwdoc NOT LIKE '' OR numante NOT LIKE '');
	
ALTER TABLE HealthInfo.Birthdetails
ALTER COLUMN childid VARCHAR(15) NOT NULL;


ALTER TABLE HealthInfo.Birthdetails
ALTER COLUMN [round] VARCHAR(10) NOT NULL;


ALTER TABLE HealthInfo.Birthdetails  WITH CHECK ADD CONSTRAINT FK_Birthdetails
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.Basic_data(childid, round);
ALTER TABLE HealthInfo.Birthdetails CHECK CONSTRAINT FK_Birthdetails;


-- Health Problems
SELECT
	[childid], [round], [chmightdie], [chillness], [chinjury],
	[chhprob], [chdisability], [chdisscale] 
INTO
	HealthInfo.HealthProblems
FROM 
	dbo.ethiopia_data

INSERT INTO
	HealthInfo.HealthProblems
SELECT
	[childid], [round], [chmightdie], [chillness],
	[chinjury], [chhprob], [chdisability], [chdisscale]
FROM 
	dbo.india_data

INSERT INTO
	HealthInfo.HealthProblems
SELECT
	[childid], [round], [chmightdie], [chillness],
	[chinjury], [chhprob], [chdisability], [chdisscale]
FROM 
	dbo.peru_data

INSERT INTO
	HealthInfo.HealthProblems
SELECT
	[childid], [round], [chmightdie], [chillness],
	[chinjury], [chhprob], [chdisability], [chdisscale]
FROM 
	dbo.vietnam_data

ALTER TABLE HealthInfo.HealthProblems
ALTER COLUMN childid VARCHAR(15) NOT NULL;
ALTER TABLE HealthInfo.HealthProblems
ALTER COLUMN [round] VARCHAR(10) NOT NULL;

ALTER TABLE HealthInfo.HealthProblems  WITH NOCHECK  ADD CONSTRAINT FK_HealthProblems
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.SurvRoundInfo (childid, round)
ALTER TABLE HealthInfo.HealthProblems CHECK CONSTRAINT FK_HealthProblems;

-- Stature Table
SELECT 
	[childid], [round], [chweight], [chheight], [bmi], [zwfa], [zhfa], [zbfa], [zwfl], 
	[fwfl], [fhfa], [fwfa], [fbfa], [underweight], [stunting], [thinness]
INTO 
	HealthInfo.Stature
FROM 
	dbo.ethiopia_data;
INSERT INTO 
	HealthInfo.Stature
SELECT 
	[childid], [round], [chweight], [chheight], [bmi], [zwfa], [zhfa], [zbfa], [zwfl], 
	[fwfl], [fhfa], [fwfa], [fbfa], [underweight], [stunting], [thinness]
FROM 
	dbo.india_data;
INSERT INTO 
	HealthInfo.Stature
SELECT 
	[childid], [round], [chweight], [chheight], [bmi], [zwfa], [zhfa], [zbfa], [zwfl], 
	[fwfl], [fhfa], [fwfa], [fbfa], [underweight], [stunting], [thinness]
FROM 
	dbo.peru_data;
INSERT INTO 
	HealthInfo.Stature
SELECT 
	[childid], [round], [chweight], [chheight], [bmi], [zwfa], [zhfa], [zbfa], [zwfl], 
	[fwfl], [fhfa], [fwfa], [fbfa], [underweight], [stunting], [thinness]
FROM 
	dbo.vietnam_data

ALTER TABLE HealthInfo.Stature
ALTER COLUMN childid VARCHAR(15) NOT NULL;
ALTER TABLE HealthInfo.Stature
ALTER COLUMN [round] VARCHAR(10) NOT NULL;

ALTER TABLE HealthInfo.Stature  WITH NOCHECK ADD CONSTRAINT FK_Stature
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.SurvRoundInfo (childid, round)
Alter table HealthInfo.Stature check constraint FK_Stature;

----- CHILD VACCINATION INFORMATION 
SELECT
	[childid],
	[round],
	[bcg],
	[measles],
	[dpt],
	[polio],
	[hib]
INTO
	HealthInfo.VaccineInfo
FROM 
	dbo.ethiopia_data
WHERE 
	bcg not like ''

INSERT INTO
	HealthInfo.VaccineInfo
SELECT
	[childid],
	[round],
	[bcg],
	[measles],
	[dpt],
	[polio],
	[hib]
FROM 
	dbo.india_data
WHERE 
	bcg not like ''

INSERT INTO
	HealthInfo.VaccineInfo
SELECT
	[childid],
	[round],
	[bcg],
	[measles],
	[dpt],
	[polio],
	[hib]
FROM 
	dbo.peru_data
WHERE 
	bcg not like ''

INSERT INTO
	HealthInfo.VaccineInfo
SELECT
	[childid],
	[round],
	[bcg],
	[measles],
	[dpt],
	[polio],
	[hib]
FROM 
	dbo.vietnam_data
WHERE 
	bcg not like ''


ALTER TABLE HealthInfo.VaccineInfo
ALTER COLUMN childid VARCHAR(15) NOT NULL;

ALTER TABLE HealthInfo.VaccineInfo
ALTER COLUMN [round] VARCHAR(10) NOT NULL;


ALTER TABLE HealthInfo.VaccineInfo  WITH NOCHECK ADD CONSTRAINT FK_VaccineInfo
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.SurvRoundInfo (childid, round)
Alter table HealthInfo.VaccineInfo check constraint FK_VaccineInfo;


--General Health Information
SELECT 
	[childid], [round], [chrephealth1], [chrephealth2], [chrephealth3],
	[chrephealth4], [chhrel], [chhealth], [cladder], [chsmoke], [chalcohol]
INTO
	HealthInfo.GenHealthInfo
FROM
	dbo.ethiopia_data

INSERT INTO
	HealthInfo.GenHealthInfo
SELECT 
	[childid], [round], [chrephealth1], [chrephealth2], [chrephealth3],
	[chrephealth4], [chhrel], [chhealth], [cladder], [chsmoke], [chalcohol]
FROM
	dbo.india_data

INSERT INTO
	HealthInfo.GenHealthInfo
SELECT 
	[childid], [round], [chrephealth1], [chrephealth2], [chrephealth3],
	[chrephealth4], [chhrel], [chhealth], [cladder], [chsmoke], [chalcohol]
FROM
	dbo.peru_data

INSERT INTO
	HealthInfo.GenHealthInfo
SELECT 
	[childid], [round], [chrephealth1], [chrephealth2], [chrephealth3],
	[chrephealth4], [chhrel], [chhealth], [cladder], [chsmoke], [chalcohol]
FROM
	dbo.vietnam_data

ALTER TABLE HealthInfo.GenHealthInfo
ALTER COLUMN childid VARCHAR(15) NOT NULL;

ALTER TABLE HealthInfo.GenHealthInfo
ALTER COLUMN [round] VARCHAR(10) NOT NULL;

ALTER TABLE HealthInfo.GenHealthInfo  WITH NOCHECK ADD CONSTRAINT FK_GenHealthInfo
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.Basic_data (childid, round)
Alter table HealthInfo.GenHealthInfo check constraint FK_GenHealthInfo;



/*
====================================NEW SCHEMA===================
	POPULATING THE EDUCATION INFORMATION SCHEMA
*/

--- Child Education History
SELECT 
	[childid], [round], [preprim], [agegr1],
	[enrol], [engrade], [entype], [hghgrade],
	[timesch]
INTO
	EduInfo.EduHistory
FROM
	dbo.ethiopia_data

INSERT INTO
	EduInfo.EduHistory
SELECT 
	[childid], [round], [preprim], [agegr1],
	[enrol], [engrade], [entype], [hghgrade],
	[timesch]
FROM
	dbo.india_data

INSERT INTO
	EduInfo.EduHistory
	(
	[childid], [round], [preprim], [agegr1],
	[enrol], [engrade],	[entype], [timesch]
	)
SELECT 
	[childid], 	[round], [preprim], [agegr1],
	[enrol], [engrade], [entype], [timesch]
FROM
	dbo.peru_data

INSERT INTO
	EduInfo.EduHistory
SELECT 
	[childid], [round], [preprim], [agegr1],
	[enrol], [engrade], [entype], [hghgrade],
	[timesch]
FROM
	dbo.vietnam_data

ALTER TABLE EduInfo.EduHistory
ALTER COLUMN childid VARCHAR(15) NOT NULL;

ALTER TABLE EduInfo.EduHistory
ALTER COLUMN [round] VARCHAR(10) NOT NULL;

ALTER TABLE EduInfo.EduHistory  WITH NOCHECK ADD FOREIGN KEY([childid], [round])
REFERENCES AllChildInfo.Basic_data(childid, [round]);

ALTER TABLE EduInfo.EduHistory  WITH NOCHECK ADD CONSTRAINT FK_EduHistory
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.SurvRoundInfo (childid, round)
Alter table EduInfo.EduHistory check constraint FK_EduHistory;


---EDUCATIONAL ABILITY
SELECT
	[childid], [round], [levlread], [levlwrit], [literate]
INTO
	EduInfo.EduAbility
FROM
	dbo.ethiopia_data


INSERT INTO
	EduInfo.EduAbility
SELECT
	[childid], [round], [levlread], [levlwrit], [literate]
FROM
	dbo.india_data


INSERT INTO
	EduInfo.EduAbility
SELECT
	[childid], [round], [levlread], [levlwrit], [literate]
FROM
	dbo.peru_data


INSERT INTO
	EduInfo.EduAbility
SELECT
	[childid], [round], [levlread], [levlwrit], [literate]
FROM
	dbo.vietnam_data


ALTER TABLE EduInfo.EduAbility 
ALTER COLUMN childid VARCHAR(15) NOT NULL;

ALTER TABLE EduInfo.EduAbility
ALTER COLUMN [round] VARCHAR(10) NOT NULL;

ALTER TABLE EduInfo.EduAbility  WITH NOCHECK ADD FOREIGN KEY([childid], [round])
REFERENCES AllChildInfo.Basic_Data(childid, [round]);


/*
	POPULATING THE HOUSEHOLD SCHEMA
*/
-- HOUSEHOLD INFORMATION: This would act as a reference table to majority of the tables on the HouseHoldSchema
EXEC spNewTab 'HouseHoldinfo.HouseHoldbasicdata', 
'[childid], [round], [inround], [commid], [clustid], [region],	[childloc]', 
'dbo.ethiopia_data';

EXEC spIntoExistTab 'HouseHoldinfo.HouseHoldbasicdata', 
'[childid], [round], [inround], [commid], [clustid], [region],	[childloc]',
'[childid], [round], [inround], [commid], [clustid], [region],	[childloc]', 
'dbo.india_data';

EXEC spIntoExistTab 'HouseHoldinfo.HouseHoldbasicdata', 
'[childid], [round], [inround], [commid], [clustid], [region],	[childloc]',
'[childid], [round], [inround], [commid], [clustid], [region],	[childloc]', 
'dbo.vietnam_data';

EXEC spIntoExistTab  'HouseHoldinfo.HouseHoldbasicdata', 
'[childid], [round], [inround], [commid], [clustid], [region],	[childloc]',
'[childid], [round], [inround], [clustid], [clustid], [region],	[childloc]', 
'dbo.peru_data';
 

 select *
 from HouseHoldinfo.HouseHoldbasicda

ALTER TABLE HouseHoldinfo.HouseHoldbasicda
ALTER COLUMN childid VARCHAR(15) NOT NULL;

ALTER TABLE HouseHoldinfo.HouseHoldbasicda
ALTER COLUMN round VARCHAR(10) NOT NULL;

ALTER TABLE HouseHoldinfo.HouseHoldbasicda
ADD PRIMARY KEY(childid, round);

--CREATING A FOREIGN KEY
ALTER TABLE HouseHoldinfo.HouseHoldbasicda  WITH CHECK ADD CONSTRAINT FK_HouseHoldbasicda
FOREIGN KEY (childid, round) REFERENCES AllChildInfo.Basic_data(childid, round);
ALTER TABLE HouseHoldinfo.HouseHoldbasicda CHECK CONSTRAINT FK_HouseHoldbasicda;



-- PARENT AND CAREGIVER TABLE

-- HOUSEHOLD INFORMATION: This holds information about the individuals in the household 
EXEC spNewTab 'HouseHoldinfo.HouseHoldComp', 
'[childid],	[Headid],[round], [Headedu], 	[Headage], 	[Headsex], 	[Headrel],	[Hhsize],	[Male05],	[Male612],	[Male1317],
[Male1860],	[Male61],	[feMale05],	[feMale612],	[feMale1317],	[feMale1860],	[feMale61]',
'dbo.ethiopia_data';

EXEC spIntoExistTab 'HouseHoldinfo.HouseHoldComp',  
'[childid],	[Headid], [round],	[Headedu], 	[Headage], 	[Headsex], 	[Headrel],	[Hhsize],	[Male05],	[Male612],	[Male1317],
[Male1860],	[Male61],	[feMale05],	[feMale612],	[feMale1317],	[feMale1860],	[feMale61]',

'[childid],	[Headid],[round], 	[Headedu], 	[Headage], 	[Headsex], 	[Headrel],	[Hhsize],	[Male05],	[Male612],	[Male1317],
[Male1860],	[Male61],	[feMale05],	[feMale612],	[feMale1317],	[feMale1860],	[feMale61]',
'dbo.india_data';

EXEC spIntoExistTab 'HouseHoldinfo.HouseHoldComp', 
'[childid],	[Headid], [round],	[Headedu], 	[Headage], 	[Headsex], 	[Headrel],	[Hhsize],	[Male05],	[Male612],	[Male1317],
[Male1860],	[Male61],	[feMale05],	[feMale612],	[feMale1317],	[feMale1860],	[feMale61]',

'[childid],	[Headid],[round], 	[Headedu], 	[Headage], 	[Headsex], 	[Headrel],	[Hhsize],	[Male05],	[Male612],	[Male1317],
[Male1860],	[Male61],	[feMale05],	[feMale612],	[feMale1317],	[feMale1860],	[feMale61]', 

'dbo.vietnam_data';

EXEC spIntoExistTab  'HouseHoldinfo.HouseHoldComp', 
'[childid],	[Headid], [round],	[Headedu], 	[Headage], 	[Headsex], 	[Headrel],	[Hhsize],	[Male05],	[Male612],	[Male1317],
[Male1860],	[Male61],	[feMale05],	[feMale612],	[feMale1317],	[feMale1860],	[feMale61]',

'[childid],	[Headid], [round],	[Headedudu], 	[Headage], 	[Headsex], 	[Headrel],	[Hhsize],	[Male05],	[Male612],	[Male1317],
[Male1860],	[Male61],[round],	[feMale05],	[feMale612],	[feMale1317],	[feMale1860],	[feMale61]',
'dbo.peru_data';

ALTER TABLE HouseHoldinfo.HouseHoldComp
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.HouseHoldComp
ALTER COLUMN round VARCHAR(10) NOT NULL; 

-- ENFORCING CONSTRAINTS ON THE FOREIGN KEYS
ALTER TABLE HouseHoldinfo.HouseHoldComp  WITH CHECK ADD CONSTRAINT FK_HouseHoldComp
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.HouseHoldComp CHECK CONSTRAINT FK_HouseHoldComp;

---- BASIC FACILITIES ---
EXEC spNewTab 'HouseHoldInfo.BasicFacilities', 
'[childid],	[round],[headid],	[wi],	[hq], [sv],	[cd],	[drwaterq],	[toiletq],	[elecq],[cookingq]', 
'dbo.india_data';

EXEC spIntoExistTab 'HouseHoldInfo.BasicFacilities', 
'[childid],	[round],[headid],	[wi],	[hq], [sv],	[cd],	[drwaterq],	[toiletq],	[elecq],[cookingq]',
'[childid],	[round],[headid],	[wi_new],	[hq_new], [sv_new],	[cd_new],	[drwaterq_new],	[toiletq_new],	[elecq_new],[cookingq_new]', 
'dbo.ethiopia_data';

EXEC spIntoExistTab 'HouseHoldInfo.BasicFacilities', 
'[childid],	[round],[headid],	[wi],	[hq], [sv],	[cd],	[drwaterq],	[toiletq],	[elecq],[cookingq]',
'[childid],	[round],[headid],	[wi_new],	[hq_new], [sv_new],	[cd_new],	[drwaterq_new],	[toiletq_new],	[elecq_new],[cookingq_new]',  
'dbo.vietnam_data';

EXEC spIntoExistTab  'HouseHoldInfo.BasicFacilities', '
[childid],	[round],[headid],	[wi],	[hq], [sv],	[cd],	[drwaterq],	[toiletq],	[elecq],[cookingq]', 
'[childid],[round],	[headid],	[wi],	[hq], [sv],	[cd],	[drwaterq],	[toiletq],	[elecq],[cookingq]', 
'dbo.peru_data';

ALTER TABLE HouseHoldinfo.BasicFacilities
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.BasicFacilities
ALTER COLUMN round VARCHAR(10) NOT NULL; 
-- FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.BasicFacilities  WITH CHECK ADD CONSTRAINT FK_BasicFacilities
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.BasicFacilities CHECK CONSTRAINT FK_BasicFacilities;



----- HOUSEHOLD AGRICULTURE
EXEC spNewTab 'HouseHoldInfo.HouseHoldAgric', 
	'childid, 	[round], headid,	aniany, animilk, anidrau, anirumi, anispec, anicowm, anicowt,
	anicalv, anibufm, anibuft, aniheif, anibull, anihebu, anidonk, aniybul, anishee, anigoat, anipigs, anipoul, anirabb,
	anibeeh, anifish, anishri, anifshr,	aniothr, ownlandhse, ownhouse',
	'dbo.india_data';

-- Adding Columns to accomodate Column names in all the countries
ALTER TABLE HouseHoldInfo.HouseHoldAgric
ADD
	anioxen VARCHAR(5) NULL,
	anicaml VARCHAR(5) NULL,
	anillam VARCHAR(5) NULL,
	aniguin VARCHAR(5) NULL,
	anisnai VARCHAR(5) NULL


 EXEC spIntoExistTab 'HouseHoldInfo.HouseHoldAgric', 
	 'childid, 	[round],headid, aniany, animilk, anidrau, anirumi, anispec, anicowt, anioxen, anidonk, anishee, anigoat, anipigs, 
	 anipoul, anirabb, anillam, aniguin, anisnai, anibeeh, anifish, anishri, anifshr, aniothr, ownlandhse, ownhouse', 
	 'childid, 	[round],headid, aniany, animilk, anidrau, anirumi, anispec, anicowt, anioxen, anidonk, anishee, anigoat, anipigs, 
	 anipoul, anirabb, anillam, aniguin, anisnai, anibeeh, anifish, anishri, anifshr, aniothr, ownlandhse, ownhouse', 
	 'dbo.peru_data';

 -- ETHIOPIA
 EXEC spIntoExistTab 'HouseHoldInfo.HouseHoldAgric', 
	'childid, 	[round],headid, aniany, animilk, anidrau, anirumi, anicowm, anicowt, anicalv, anibufm, anibuft, anibull, anihebu, anioxen, 
	anicaml, anidonk, anishee, anigoat, anipigs, anipoul, anirabb, anispec, aniheif, aniybul, anibeeh, aniothr, ownlandhse, ownhouse',
	'childid, 	[round],headid, aniany, animilk, anidrau, anirumi, anicowm, anicowt, anicalv, anibufm, anibuft, anibull, anihebu, anioxen, 
	anicaml, anidonk, anishee, anigoat, anipigs, anipoul, anirabb, anispec, aniheif, aniybul, anibeeh, aniothr, ownlandhse, ownhouse', 
	'dbo.ethiopia_data';

 -- VIETNAM
 EXEC spIntoExistTab 'HouseHoldInfo.HouseHoldAgric', 
	'childid, 	[round],headid, aniany, animilk, anidrau, anirumi, anicowm, anicowt, anicalv, anibufm, anibuft, anibull, anihebu, 
	anidonk, anishee, anigoat, anipigs, anipoul, anirabb, anispec, aniothr, ownlandhse, ownhouse',
	'childid, 	[round],headid,aniany, animilk, anidrau, anirumi, anicowm, anicowt, anicalv, anibufm, anibuft, anibull, anihebu, 
	anidonk, anishee, anigoat, anipigs, anipoul, anirabb, anispec, aniothr, ownlandhse, ownhouse',
	 'dbo.vietnam_data';

ALTER TABLE HouseHoldinfo.HouseHoldAgric
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.HouseHoldAgric
ALTER COLUMN round VARCHAR(10) NOT NULL; 
-- FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.HouseHoldAgric  WITH CHECK ADD CONSTRAINT FK_HouseHoldAgric
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.HouseHoldAgric CHECK CONSTRAINT FK_HouseHoldAgric;



-- GOVERNMENT INTERVENTION
EXEC spNewTab  'HouseHoldInfo.vietnam_intervention', 
'childid, [round], headid, molisa06, molisa09, molisa10, molisa11, molisa12, molisa13, molisa14, molisa15, molisa16', 
'dbo.vietnam_data';

ALTER TABLE HouseHoldinfo.vietnam_interven
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.vietnam_interven
ALTER COLUMN round VARCHAR(10) NOT NULL;  

--FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.vietnam_interven  WITH CHECK ADD CONSTRAINT FK_vietnam_interven
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.vietnam_interven CHECK CONSTRAINT FK_vietnam_interven;


EXEC spNewTab 'HouseHoldInfo.peru_interven', 
'childid, [round], headid, juntos, bonograt, sisgrat_yl, minsa_yl, insur_yl, beca_yl, projoven_yl', 
'dbo.peru_data';

ALTER TABLE HouseHoldinfo.peru_interven
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.peru_interven
ALTER COLUMN round VARCHAR(10) NOT NULL; 
--FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.peru_interven  WITH CHECK ADD CONSTRAINT FK_peru_interven
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.peru_interven CHECK CONSTRAINT FK_peru_interven;


EXEC spNewTab 'HouseHoldInfo.india_interven', 
'childid, [round], headid, pds, nregs, nregs_work, nregs_allow, rajiv, sabla, sabla_yl, ikp, ikp_child', 
'dbo.india_data';

ALTER TABLE HouseHoldinfo.india_interven
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.india_interven
ALTER COLUMN round VARCHAR(10) NOT NULL; 
--FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.india_interven  WITH CHECK ADD CONSTRAINT FK_india_interven
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.india_interven CHECK CONSTRAINT FK_india_interven;


EXEC spNewTab 'HouseHoldInfo.eth_interven', 
'childid, [round], headid, psnp_pw, psnp_ds, othprog, hep, resettled, eap, credit', 'dbo.ethiopia_data';

ALTER TABLE HouseHoldinfo.eth_interven
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.eth_interven
ALTER COLUMN round VARCHAR(10) NOT NULL; 
--FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.eth_interven  WITH CHECK ADD CONSTRAINT FK_eth_interven
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.eth_interven CHECK CONSTRAINT FK_eth_interven;


-- SHOCKING CRIMES TABLE

EXEC spNewTab 'HouseHoldInfo.ShCrimes', 
'[childid], [round], [headid], [Shcrime1], [Shcrime2],[Shcrime3], [Shcrime4], [Shcrime5], [Shcrime6],[Shcrime7], [Shcrime8]', 
'dbo.ethiopia_data';
EXEC spIntoExistTab 'HouseHoldInfo.ShCrimes', 
'[childid], [round], [headid], [Shcrime1], [Shcrime2],[Shcrime3], [Shcrime4], [Shcrime5], [Shcrime6],[Shcrime7], [Shcrime8]', 
'[childid],[round], [headid], [Shcrime1], [Shcrime2],[Shcrime3], [Shcrime4], [Shcrime5], [Shcrime6],[Shcrime7], [Shcrime8]',
'dbo.india_data';
EXEC spIntoExistTab 'HouseHoldInfo.ShCrimes', 
'[childid],[round], [headid], [Shcrime1], [Shcrime2],[Shcrime3], [Shcrime4], [Shcrime5], [Shcrime6],[Shcrime7], [Shcrime8]', 
'[childid], [round],[headid], [Shcrime1], [Shcrime2],[Shcrime3], [Shcrime4], [Shcrime5], [Shcrime6],[Shcrime7], [Shcrime8]',
'dbo.vietnam_data';

EXEC spIntoExistTab  'HouseHoldInfo.ShCrimes', 
'[childid],[round], [headid], [Shcrime1], [Shcrime2],[Shcrime3], [Shcrime4], [Shcrime5], [Shcrime6], [Shcrime8]', 
'[childid], [round],[headid], [Shcrime1], [Shcrime2],[Shcrime3], [Shcrime4], [Shcrime5], [Shcrime6], [Shcrime8]', 
'dbo.peru_data';

ALTER TABLE HouseHoldinfo.ShCrimes
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.ShCrimes
ALTER COLUMN round VARCHAR(10) NOT NULL; 
--FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.ShCrimes  WITH CHECK ADD CONSTRAINT FK_ShCrimes
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.ShCrimes CHECK CONSTRAINT FK_ShCrimes;



--- ENVIRONMENTAL DISASTERS
EXEC spNewTab 'HouseHoldInfo.ShockingDisaster',
	'childid,[round], headid, shenv1,  shenv2, shenv3, shenv4, shenv5, shenv6, shenv7, shenv8, shenv9, shenv13, shhouse1, shhouse2, shhouse3',
	'dbo.vietnam_data';

EXEC spIntoExistTab 'HouseHoldInfo.ShockingDisaster',
	'childid, [round],headid, shenv1,  shenv2, shenv3, shenv4, shenv5, shenv6, shenv7, shenv8, shenv9, shhouse1, shhouse2, shhouse3',
	'childid,[round], headid, shenv1,  shenv2, shenv3, shenv4, shenv5, shenv6, shenv7, shenv8, shenv9, shhouse1, shhouse2, shhouse3',
	'dbo.ethiopia_data';

EXEC spIntoExistTab 'HouseHoldInfo.ShockingDisaster',
	'childid,[round], headid, shenv1,  shenv2, shenv3, shenv4, shenv5, shenv6, shenv7, shenv8, shenv9, shhouse1, shhouse2, shhouse3',
	'childid, [round],headid, shenv1,  shenv2, shenv3, shenv4, shenv5, shenv6, shenv7, shenv8, shenv9, shhouse1, shhouse2, shhouse3',
	'dbo.india_data';

EXEC spIntoExistTab 'HouseHoldInfo.ShockingDisaster',
	'childid,[round], headid, shenv1,  shenv2, shenv3, shenv4, shenv5, shenv6, shenv7, shenv8, shenv9, shhouse1, shhouse2, shhouse3',
	'childid,[round], headid, shenv1,  shenv2, shenv3, shenv4, shenv5, shenv6, shenv7, shenv8, shenv9, shhouse1, shhouse2, shhouse3',
	'dbo.peru_data';

ALTER TABLE HouseHoldinfo.ShockingDisaster
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.ShockingDisaster
ALTER COLUMN round VARCHAR(10) NOT NULL; 
--FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.ShockingDisaster  WITH CHECK ADD CONSTRAINT FK_ShockingDisaster
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.ShockingDisaster CHECK CONSTRAINT FK_ShockingDisaster;



-- SHOCKING INCIDENTS INVOLVING FAMILY MEMBERS 
EXEC spNewTab 'HouseHoldinfo.ShockingFamMemb',

	'childid,[round], headid, shfam1,  shfam2, shfam3, shfam4, shfam5, shfam6, shfam7,
	shfam8, shfam9, shfam10,  shfam11, shfam12, shfam13, shfam14, shfam18, shother',
	'dbo.vietnam_data'

EXEC spIntoExistTab 'HouseHoldinfo.ShockingFamMemb',
	'childid,[round], headid, shfam1,  shfam2, shfam3, shfam4, shfam5, shfam6, shfam7,
	shfam8, shfam9, shfam10,  shfam11, shfam12, shfam13, shfam14, shfam18, shother',
	'childid,[round], headid, shfam1, shfam2, shfam3, shfam4, shfam5, shfam6, shfam7, shfam8, shfam9, shfam10, shfam11, shfam12, 
	shfam13, shfam14, shfam18, shother',
	'dbo.india_data';

EXEC spIntoExistTab 'HouseHoldinfo.ShockingFamMemb',
	'childid,[round], headid, shfam1,  shfam2, shfam3, shfam4, shfam5, shfam6, shfam7, shfam8, shfam9, shfam10, shfam12, 
	 shfam13, shfam14, shfam18, shother',
	
	'childid,[round], headid, shfam1,  shfam2, shfam3, shfam4, shfam5, shfam6, shfam7, shfam8, shfam9, shfam10, shfam12, 
	shfam13, shfam14, shfam18, shother',
	'dbo.peru_data'
	

EXEC spIntoExistTab 'HouseHoldinfo.ShockingFamMemb',
	'childid,[round], headid, shfam1,  shfam2, shfam3, shfam4, shfam5, shfam6, shfam7, shfam8, shfam9, shfam10, shfam11, shfam12, 
	 shfam13, shfam14, shfam18, shother',
	
	'childid,[round], headid, shfam1,  shfam2, shfam3, shfam4, shfam5, shfam6, shfam7, shfam8, shfam9, shfam10, shfam11, shfam12, 
	shfam13, shfam14, shfam18, shother',
	'dbo.ethiopia_data'

ALTER TABLE HouseHoldinfo.ShockingFamMemb
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.ShockingFamMemb
ALTER COLUMN round VARCHAR(10) NOT NULL; 
--FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.ShockingFamMemb  WITH CHECK ADD CONSTRAINT FK_ShockingFamMemb
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.ShockingFamMemb CHECK CONSTRAINT FK_ShockingFamMemb;




EXEC spNewTab 'HouseHoldinfo.ShockingReg', 
'childid,[round], headid, shregul1, shregul2, shregul3, shregul4, shregul5, shecon1, shecon2, shecon3, shecon4, shecon5, shecon6, shecon7, 
shecon8, shecon9, shecon10, shecon11, shecon12, shecon13,shecon14',
'dbo.vietnam_data';

-- ADDING COLUMNS TO ACCOMMODATE THE ALL ITEMS IN PERU
ALTER TABLE [HouseHoldinfo].[ShockingReg]
ADD 
shfam15 VARCHAR(10) NULL, 
shfam16 VARCHAR(10) NULL, 
shfam17 VARCHAR(10) NULL;

 EXEC spIntoExistTab '[HouseHoldinfo].ShockingReg', 
 'childid,[round], headid, shregul1, shregul2, shregul4, shregul5,  shecon1, shecon2, shecon3, shecon4, shecon5, shecon6, 
 shecon7, shecon8, shecon9, shecon10, shecon11, shecon12, shecon14',

 'childid,[round], headid, shregul1, shregul2, shregul4, shregul5, shecon1, shecon2, shecon3, shecon4, shecon5, shecon6, 
  shecon7, shecon8, shecon9, shecon10, shecon11, shecon12, shecon14',

 'dbo.peru_data';

 EXEC spIntoExistTab 'HouseHoldinfo.ShockingReg', 
 'childid,[round], headid, shregul1, shregul2, shregul4, shregul5, shecon1, shecon2, shecon3, shecon4, shecon5, shecon6, 
 shecon7, shecon8, shecon9, shecon10, shecon11, shecon12, shecon13, shecon14',

 'childid,[round], headid, shregul1, shregul2, shregul4, shregul5, shecon1, shecon2, shecon3, shecon4, shecon5, shecon6, 
 shecon7, shecon8, shecon9, shecon10, shecon11, shecon12, shecon13, shecon14',
 'dbo.ethiopia_data';

 EXEC spIntoExistTab 'HouseHoldinfo.ShockingReg', 
 'childid,[round], headid, shregul1, shregul2,shregul3, shregul4, shregul5, shecon1, shecon2, shecon3, shecon4, shecon5, shecon6, 
shecon7, shecon8, shecon9, shecon10, shecon11, shecon12, shecon13, shecon14',

 'childid,[round], headid, shregul1, shregul2,shregul3, shregul4, shregul5, shecon1, shecon2, shecon3, shecon4, shecon5, shecon6, 
shecon7, shecon8, shecon9, shecon10, shecon11, shecon12, shecon13, shecon14', 
 'dbo.india_data';


 ALTER TABLE HouseHoldinfo.ShockingReg
ALTER COLUMN childid VARCHAR(15) NOT NULL; 
ALTER TABLE HouseHoldinfo.ShockingReg
ALTER COLUMN round VARCHAR(10) NOT NULL; 
--FOREIGN KEY CONSTRAINTS
ALTER TABLE HouseHoldinfo.ShockingReg  WITH CHECK ADD CONSTRAINT FK_ShockingReg
FOREIGN KEY (childid, round) REFERENCES HouseHoldinfo.HouseHoldbasicda(childid, round);
ALTER TABLE HouseHoldinfo.ShockingReg CHECK CONSTRAINT FK_ShockingReg;

--CREATION OF VIEWS FOR ALL THE ROUNDS
--VIEW CREATION FOR ETHIOPIA
CREATE VIEW Ethiopia_Round1 AS
SELECT *
FROM dbo.ethiopia_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new != ''  and cookingq_new != '' and round = '1'
UNION 
SELECT * FROM dbo.ethiopia_data where 1 =2

CREATE VIEW Ethiopia_Round2 AS
SELECT *
FROM dbo.ethiopia_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new != ''  and cookingq_new != '' and round = '2'
UNION 
SELECT * FROM dbo.ethiopia_data  where 1 =2

CREATE VIEW Ethiopia_Round3 as
SELECT *
from dbo.ethiopia_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new != ''  and cookingq_new != '' and round = '3'
UNION 
SELECT * FROM dbo.ethiopia_data where 1 =2

CREATE VIEW Ethiopia_Round4 as
SELECT *
from dbo.ethiopia_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new != ''  and cookingq_new != '' and round = '4'
UNION 
SELECT * FROM dbo.ethiopia_data  where 1 =2

CREATE VIEW Ethiopia_Round5 as
SELECT *
from dbo.ethiopia_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new != ''  and cookingq_new != '' and round = '5'
UNION 
SELECT * FROM dbo.ethiopia_data where 1 =2


CREATE VIEW  India_Round1 as
select *
from Assessment.dbo.india_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '1'
UNION 
SELECT * FROM Assessment.dbo.india_data where 1 =2


CREATE VIEW  India_Round2 as
select *
from Assessment.dbo.india_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '2'
UNION 
SELECT * FROM Assessment.dbo.india_data  where 1 =2

CREATE VIEW  India_Round3 as
select *
from Assessment.dbo.india_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '3'
UNION 
SELECT * FROM Assessment.dbo.india_data  where 1 =2

CREATE VIEW  India_Round4 as
select *
from Assessment.dbo.india_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '4'
UNION 
SELECT * FROM Assessment.dbo.india_data where 1 =2

CREATE VIEW  India_Round5 as
select *
from Assessment.dbo.india_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '5'
UNION 
SELECT * FROM Assessment.dbo.india_data where 1 =2

CREATE VIEW  Peru_Round1 as
select *
from Assessment.dbo.peru_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '1'
UNION 
SELECT * FROM Assessment.dbo.peru_data where 1 =2

CREATE VIEW  Peru_Round2 as
select *
from Assessment.dbo.peru_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '2'
UNION 
SELECT * FROM Assessment.dbo.peru_data where 1 =2

CREATE VIEW  Peru_Round3 as
select *
from Assessment.dbo.peru_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '3'
UNION 
SELECT * FROM Assessment.dbo.peru_data where 1 =2

CREATE VIEW  Peru_Round4 as
select *
from Assessment.dbo.peru_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '4'
UNION 
SELECT * FROM Assessment.dbo.peru_data where 1 =2

CREATE VIEW  Peru_Round5 as
select *
from Assessment.dbo.peru_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq!= ''  and cookingq != '' and round = '5'
UNION 
SELECT * FROM Assessment.dbo.peru_data where 1 =2

CREATE VIEW  Vietnam_Round1 as
select *
from Assessment.dbo.vietnam_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new!= ''  and cookingq_new != '' and round = '1'
UNION 
SELECT * FROM Assessment.dbo.vietnam_data where 1 =2

CREATE VIEW  Vietnam_Round2 as
select *
from Assessment.dbo.vietnam_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new!= ''  and cookingq_new != '' and round = '2'
UNION 
SELECT * FROM Assessment.dbo.vietnam_data where 1 =2


CREATE VIEW  Vietnam_Round3 as
select *
from Assessment.dbo.vietnam_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new!= ''  and cookingq_new != '' and round = '3'
UNION 
SELECT * FROM Assessment.dbo.vietnam_data where 1 =2

CREATE VIEW  Vietnam_Round4 as
select *
from Assessment.dbo.vietnam_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new!= ''  and cookingq_new != '' and round = '4'
UNION 
SELECT * FROM Assessment.dbo.vietnam_data where 1 =2

CREATE VIEW  Vietnam_Round5 as
select *
from Assessment.dbo.vietnam_data where region != '' and chethnic != '' and bmi !='' and dadlive != '' and dadage !=''and momlive !=''
 and momage !='' and drwaterq_new!= ''  and cookingq_new != '' and round = '5'
UNION 
SELECT * FROM Assessment.dbo.vietnam_data  where 1 =2
