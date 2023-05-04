--Question 1
--Create the Database

CREATE DATABASE PrescriptionsDB

USE PrescriptionsDB;
GO

--Adding foreign key constraints to the tables
ALTER TABLE Prescriptions
ADD CONSTRAINT FK_Prescriptions_Medical_Practice 
FOREIGN KEY (PRACTICE_CODE) REFERENCES Medical_Practice(PRACTICE_CODE);

ALTER TABLE Prescriptions
ADD CONSTRAINT FK_Prescriptions_Drugs 
FOREIGN KEY (BNF_CODE) REFERENCES Drugs(BNF_CODE);

--Question 2
SELECT * FROM Drugs WHERE BNF_DESCRIPTION LIKE '%tablet%' 
OR BNF_DESCRIPTION LIKE '%capsule%'

--Question 3
SELECT PRESCRIPTION_CODE, ROUND(QUANTITY * ITEMS, 0) AS TOTAL_QUANTITY
FROM Prescriptions

--Question 4
SELECT DISTINCT CHEMICAL_SUBSTANCE_BNF_DESCR
FROM Drugs;

--Question 5
SELECT 
  d.BNF_CHAPTER_PLUS_CODE,
  COUNT(p.PRESCRIPTION_CODE) AS num_prescriptions,
  AVG(p.ACTUAL_COST) AS avg_cost,
  MIN(p.ACTUAL_COST) AS min_cost,
  MAX(p.ACTUAL_COST) AS max_cost
FROM 
  Drugs d
  INNER JOIN Prescriptions p ON d.BNF_CODE = p.BNF_CODE
GROUP BY 
  d.BNF_CHAPTER_PLUS_CODE;

--Question 6.
SELECT Medical_Practice.PRACTICE_NAME, Prescriptions.ACTUAL_COST
FROM Medical_Practice
JOIN Prescriptions ON Medical_Practice.PRACTICE_CODE = Prescriptions.PRACTICE_CODE
WHERE Prescriptions.ACTUAL_COST = (
  SELECT MAX(ACTUAL_COST)
  FROM Prescriptions
  WHERE PRACTICE_CODE = Medical_Practice.PRACTICE_CODE
)
AND Prescriptions.ACTUAL_COST > 4000
ORDER BY Prescriptions.ACTUAL_COST DESC;

--Question 7a

--List the names of medical practice in a particular postcode.

SELECT PRACTICE_NAME
FROM Medical_Practice
WHERE POSTCODE = 'BL4 8EP';

--Question 7b
--Calculate the total cost of prescriptions for a particular practice

SELECT SUM(ACTUAL_COST) AS TOTAL_COST
FROM Prescriptions
WHERE PRACTICE_CODE = 'P82034';

--Question 7c
--Find the top 5 most frequently prescribed drugs and their total quantities.

SELECT BNF_DESCRIPTION, SUM(QUANTITY * ITEMS) AS TOTAL_QUANTITY
FROM Prescriptions
INNER JOIN Drugs ON Prescriptions.BNF_CODE = Drugs.BNF_CODE
GROUP BY BNF_DESCRIPTION
ORDER BY TOTAL_QUANTITY DESC

--Question 7d.
--Calculate the average cost per item of prescriptions for a particular practice.
SELECT AVG(ACTUAL_COST / ITEMS) AS AVG_COST_PER_ITEM
FROM Prescriptions
WHERE PRACTICE_CODE = 'P82652';


--Question 7e.
-- List the top 10 most frequently prescribed drugs along with the total number of prescriptions for each drug

SELECT TOP 10 Drugs.BNF_DESCRIPTION, COUNT(Prescriptions.PRESCRIPTION_CODE) AS TOTAL_PRESCRIPTIONS
FROM Drugs
INNER JOIN Prescriptions ON Drugs.BNF_CODE = Prescriptions.BNF_CODE
GROUP BY Drugs.BNF_DESCRIPTION
ORDER BY TOTAL_PRESCRIPTIONS DESC;
