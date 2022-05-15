--crime data union all
Select * into [GMPolice].[dbo].[GMS_2017_2018]
From [GMPolice].[dbo].[2017_01_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_02_GMS] Union All
Select * From [GMPolice].[dbo].[2017_03_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_04_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_05_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_06_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_07_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_08_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_09_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_10_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_11_GMS] Union All 
Select * From [GMPolice].[dbo].[2017_12_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_01_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_02_GMS] Union All  
Select * From [GMPolice].[dbo].[2018_03_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_04_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_05_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_06_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_07_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_08_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_09_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_10_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_11_GMS] Union All 
Select * From [GMPolice].[dbo].[2018_12_GMS];



--LSOA union all
SELECT * INTO [LSOA_2017_2018]
FROM [DBO].[LSOA_2017]
UNION ALL
SELECT * FROM [DBO].[LSOA_2018];

--GMS and LSOAa joinning
SELECT A.*, B.[All_Ages] as Total_Population
INTO GMSlsoa2
FROM [GMPolice].[dbo].[GMS_2017_2018] A
Inner join [GMPolice].[dbo].[LSOA_2017_2018] B
ON A.[LSOA_name] = B.[sub_Area_Names];



--adding key and constraint
USE GMPolice;

ALTER TABLE [dbo].[GMS_2017_2018]
ADD ID INT IDENTITY;

ALTER TABLE [dbo].[GMS_2017_2018]
ALTER COLUMN LSOA_code NVARCHAR (255);

ALTER TABLE [dbo].[GMS_2017_2018]
ADD CONSTRAINT PK_Id PRIMARY KEY NONCLUSTERED (ID);
GO

ALTER TABLE [dbo].[GMS_2017_2018]
ADD [GeoLocation] GEOGRAPHY
GO

UPDATE [dbo].[GMS_2017_2018]
SET [GeoLocation] = geography::Point([Latitude], [Longitude], 4326)
WHERE [Longitude] IS NOT NULL and [Latitude] IS NOT NULL
GO


--Creation of views for the crime type

--Salford Anti-social behaviour
CREATE VIEW [dbo].[Salford_Anti_Social]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Anti-social behaviour' AND [GeoLocation] IS NOT NULL AND [LSOA_name] like 'salford%'
GO

--Anti-social behaviour
CREATE VIEW [dbo].[Anti_Social_Behaviour]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Anti-social behaviour' AND [GeoLocation] IS NOT NULL 
GO

 -- Vehicle crime
CREATE VIEW [dbo].[Vehicle_crime1]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMSlsoa2]
  WHERE [Crime_type]='Vehicle crime' AND [GeoLocation] IS NOT NULL
GO

--Bicycle theft
CREATE VIEW [dbo].[Bicycle_theft]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Bicycle theft' AND [GeoLocation] IS NOT NULL
GO

--Burglary
CREATE VIEW [dbo].[Burglary]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Burglary' AND [GeoLocation] IS NOT NULL
GO

--Violence and sexual offences
CREATE VIEW [dbo].[Violence_sexual_offences]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Violence and sexual offences' AND [GeoLocation] IS NOT NULL
GO

--Public order
CREATE VIEW [dbo].[Public_order]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Public order' AND [GeoLocation] IS NOT NULL
GO

--Criminal damage and arson
CREATE VIEW [dbo].[Criminal_damage_arson]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Criminal damage and arson' AND [GeoLocation] IS NOT NULL
GO

--Theft from the person
CREATE VIEW [dbo].[Theft_from_the_person]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Theft from the person' AND [GeoLocation] IS NOT NULL
GO

--Possession of weapons
CREATE VIEW [dbo].[Possession_of_weapons]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Possession of weapons' AND [GeoLocation] IS NOT NULL
GO
--Shoplifting
CREATE VIEW [dbo].[Shoplifting]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Shoplifting' AND [GeoLocation] IS NOT NULL
GO
--Drugs
CREATE VIEW [dbo].[Drugs]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Drugs' AND [GeoLocation] IS NOT NULL
GO
--Robbery
CREATE VIEW [dbo].[Robbery]
AS
  SELECT *
  FROM [GMPolice].[dbo].[GMS_2017_2018]
  WHERE [Crime_type]='Robbery' AND [GeoLocation] IS NOT NULL
GO

--Crimes based on location
CREATE VIEW Crimes_Location AS
SELECT Location, count(Location) AS FREQUENCY, Longitude, Latitude
FROM GMPolice.dbo.GMS_2017_2018
GROUP BY Location, Longitude, Latitude

--Crimes based on Types
CREATE VIEW Crimes_per_Types AS
SELECT Location, Crime_type, count(Crime_type) as frequency
FROM GMPolice.dbo.GMS_2017_2018
GROUP BY Location, Crime_type



--**********************************************************
CREATE VIEW Drugscrime AS
SELECT TOP 10 Location, count(Location) AS  FREQUENCY, Longitude, Latitude
FROM GMPolice.dbo.GMS_2017_2018
WHERE Crime_type = 'Drugs'
GROUP BY Location,Longitude, Latitude
ORDER BY FREQUENCY DESC



CREATE VIEW [dbo].[outcome_category]
AS
  SELECT Location, crime_type, last_outcome_category,  count(last_outcome_category) AS  FREQUENCY
  FROM [GMPolice].[dbo].[GMS_2017_2018]
 GROUP BY Location,crime_type, last_outcome_category
GO


SELECT Location, Crime_type , count('Crime_type') AS  FREQUENCY
  FROM [GMPolice].[dbo].[GMS_2017_2018]
 -- WHERE [Crime_type]='Violence_and_sexual_offences' 
GROUP BY Location,Crime_type