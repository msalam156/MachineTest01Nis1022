CREATE DATABASE MachineTest01

USE MachineTest01

CREATE TABLE Tbl_Employee_NIS1022 (    
	EmployeeId INT PRIMARY KEY IDENTITY,   
	EmpName VARCHAR(20),   
	Phone VARCHAR(15),Email NVARCHAR(20)
);

CREATE TABLE Tbl_Manufacturer_NIS1022 ( 
	MfName VARCHAR(20) PRIMARY KEY,   
	City VARCHAR(15),State VARCHAR(15)
);

CREATE TABLE Tbl_Computer_NIS1022 (SerialNumber INT PRIMARY KEY IDENTITY, 
	MfName VARCHAR(20)        
	CONSTRAINT fk_manufacturer_computer      
	FOREIGN KEY (MfName)       
	REFERENCES Tbl_Manufacturer_NIS1022 (MfName),   
	Model VARCHAR(15),Weight NUMERIC(5, 2),    
	EmployeeID INT        
	CONSTRAINT fk_employee_computer        
	FOREIGN KEY (EmployeeId)        
	REFERENCES Tbl_Employee_NIS1022 (EmployeeId),
);

INSERT INTO Tbl_Manufacturer_NIS1022 VALUES    ('Acer', 'Hsinchu', 'Taiwan'),
												('HP', 'California', 'US'),
												('Dell', 'Shanghai', 'China'), 
												('Lenovo', 'Beijing', 'China'),
												('Asus', 'South Dakota', 'US');

INSERT INTO Tbl_Employee_NIS1022 VALUES    ('Rajat', '0983690376', 'rajat@gmail.com'),
											('Srikant','995424578458','srikant@gmail.com'), 
											('Ajinkiya','99542536376','ajinkiya@gmail.com'),
											('Sameeran','9954263636','sameeran@gmail.com'), 
											('Simran', '0945879036', 'simran@gmail.com');

INSERT INTO Tbl_Computer_NIS1022 VALUES    ('Acer', 'AC58967TR', 5, 1),
											('Asus', 'AS48375GF', 3.2, 2),
											('Dell', 'DL49835TA', 3.5, 3), 
											('HP', 'HP09875KL', 2.8, 4),  
											('Asus', 'AS48645GF', 3.7, 5);
	ALTER TABLE Tbl_Employee_NIS1022 ADD Area_code VARCHAR(6);
	UPDATE Tbl_Employee_NIS1022  SET Area_code = 23323 where EmployeeId = 2
	UPDATE Tbl_Employee_NIS1022  SET Area_code =  35435 where EmployeeId = 3
	UPDATE Tbl_Employee_NIS1022  SET Area_code = 9886 where EmployeeId = 4
	UPDATE Tbl_Employee_NIS1022  SET Area_code = 837487 where EmployeeId = 5

/* 1. List the manufacturers’ names that are located in South Dakota. */

SELECT MfName
FROM Tbl_Manufacturer_NIS1022
WHERE City LIKE 'South Dakota';


/* 2. Calculate the average weight of the computers in use. */

SELECT AVG(Weight) AS [Average Weight]
FROM Tbl_Computer_NIS1022;


/* 3. List the employee names for employees whose area_code starts with 2 */

SELECT * FROM Tbl_Employee_NIS1022
	WHERE Area_Code LIKE '2%';


/* 4. List the serial numbers for computers that have a weight below
average */

SELECT * FROM Tbl_Computer_NIS1022
	WHERE Weight < (SELECT AVG(Weight)
	FROM Tbl_Computer_NIS1022);

/* 5. List the manufacturer names of companies that do not have any
computers in use. Use a subquery */



SELECT MfName
FROM Tbl_Manufacturer_NIS1022
	WHERE MfName NOT IN 
	(SELECT MfName FROM Tbl_Computer_NIS1022);




/* 6. Create a VIEW with the list of employee name, their computer serial
number, and the city that they were manufactured in. Use a join. */
CREATE VIEW vw_employee_list
AS
    SELECT emp.EmpName, comp.SerialNumber, manf.City
    FROM Tbl_Employee_NIS1022 AS emp
    INNER JOIN Tbl_Computer_NIS1022 AS comp
    ON emp.EmployeeId = comp.EmployeeID
    INNER JOIN Tbl_Manufacturer_NIS1022 AS manf
    ON comp.MfName = manf.MfName;
SELECT * FROM vw_employee_list




/* 7. Write a Stored Procedure to accept EmployeeId as parameter and
List the serial number, manufacturer name, model, and weight of
computer that belong to the specified Employeeid. */
CREATE PROCEDURE sp_computer_details @EmpId INT
AS
    BEGIN
        SELECT SerialNumber, MfName, Model, Weight
        FROM Tbl_Computer_NIS1022
        WHERE EmployeeID = @EmpId
    END;
EXEC sp_computer_details 3