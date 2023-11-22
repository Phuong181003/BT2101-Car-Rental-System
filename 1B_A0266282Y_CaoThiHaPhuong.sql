Use ACRES; 

-- Question 1
SELECT CarID, LPlate, CarClassID 
FROM car
WHERE Make = "Toyota" 
ORDER BY CarID;

-- Question 2
SELECT DISTINCT p.DLicenseNum 
FROM person p
INNER JOIN rental r
ON p.DLicenseNum = r.DLicenseNum 
WHERE "2022-05-01" <= r.FromDate AND r.ToDate <= "2022-06-30";

-- Question 3
SELECT CarID, AVG(DATEDIFF(ToDate, FromDate)) AS AverageRentalDays 
FROM rental 
GROUP BY CarID
ORDER BY AverageRentalDays DESC
LIMIT 5;

-- Question 4
SELECT DISTINCT r.RentalID, (r.RetOdom - r.IniOdom) AS Distance
FROM rental r
INNER JOIN drop_off_charge d ON r.FromLoc = d.FromLoc
                            AND r.ToLoc = d.ToLoc
WHERE r.FromDate >= '2022-05-01' AND r.ToDate <= '2022-05-31'
ORDER BY Distance DESC;

-- Question 5
SELECT CarID, COUNT(rentalID) AS NumberOfRentals
FROM rental 
WHERE ToLOc = 'AID229'
GROUP BY CarID
ORDER BY NumberOfRentals DESC;

-- Question 6
SELECT p.DLicenseNum, Fname, Lname, PhoneNum
FROM person p
INNER JOIN customer c ON p.DLicenseNum = c.DLicenseNum
WHERE FName LIKE '%m%' OR FName LIKE '%M%'
ORDER BY p.DLicenseNum;

-- Question 7
SELECT CarID, COUNT(CarID) AS NumberOfRentals 
FROM rental
GROUP BY CarID
ORDER BY NumberOfRentals DESC 
LIMIT 5;

-- Question 8
SELECT p.DLicenseNum, CONCAT(FName,' ', MName, ' ', LName) AS FullName, WorkLoc 
FROM person p 
INNER JOIN employee e ON p.DLicenseNum = e.DLicenseNum 
WHERE EmpType = 'manager'
ORDER BY p.DLicenseNum;

-- Question 9
SELECT CarID, City
FROM car
INNER JOIN address ON address.AddressID = car.CarLoc
WHERE CarClassID = 'l' AND Make = 'Tesla'
ORDER BY CarID;

-- Question 10
SELECT City, 
		SUM(NumberOfCustomerPerAdd) AS NumberOfCustomers, 
        SUM(NumberOfEmployeePerAdd) AS NumberOfEmployees
FROM address
INNER JOIN 
	(SELECT AddressID, 
		COUNT(c.DLicenseNum) AS NumberOfCustomerPerAdd,
		COUNT(e.DLicenseNum) AS NumberOfEmployeePerAdd
	 FROM person p
	 LEFT JOIN customer c ON p.DLicenseNum = c.DLicenseNum
	 LEFT JOIN employee e ON p.DLicenseNum = e.DLicenseNum
     GROUP BY AddressID) dt
ON address.AddressID = dt.AddressID
GROUP BY City
ORDER BY City;

-- Question 11
SELECT e.DLicenseNum, a1.City, a2.City
FROM employee e
INNER JOIN person p ON e.DLicenseNum = p.DLicenseNum
INNER JOIN address a1 ON a1.AddressID = p.AddressID
INNER JOIN address a2 ON a2.AddressID = e.WorkLoc
WHERE a1.City <> a2.City
ORDER BY e.DLicenseNum 
LIMIT 5;

-- Question 12
SELECT emp.*, MAX(FromDate) AS LatestRentalDate
FROM rental 
INNER JOIN 
	(SELECT e.DLicenseNum, FName, LName
	FROM person p
	INNER JOIN employee e ON e.DLicenseNum = p.DLicenseNum
	INNER JOIN address a ON e.WorkLoc = a.AddressID
	WHERE City = 'Sydney') emp 
    ON rental.DLicenseNum = emp.DLicenseNum
GROUP BY emp.DLicenseNum;

-- Question 13
SELECT ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM rental) , 2) AS CrossCityPercent
FROM (
	SELECT r.RentalID, a1.City AS FromCity, a2.City AS ToCity
	FROM rental r
	INNER JOIN address a1 ON a1.AddressID = r.FromLoc 
	INNER JOIN address a2 ON a2.AddressID = r.ToLoc
	WHERE a1.City != a2.City) AS cr;

-- Question 14
SELECT r.RentalID, cl.DLicenseNum, (r.RetOdom - r.IniOdom) AS RentalDistance
FROM rental r
INNER JOIN 
	(SELECT * 
	 FROM employee
	 WHERE EmpType = 'clerk') cl ON cl.DLicenseNum = r.DLicenseNum 
WHERE DATEDIFF(r.ToDate, r.FromDate) < 14
ORDER BY RentalDistance DESC;

-- Question 15
SELECT CarClassID, AVG(DATEDIFF(ToDate, FromDate)) AS AvgRentalDuration
FROM rental r
INNER JOIN car ON car.CarID = r.CarID
WHERE DATEDIFF(ToDate, FromDate) > 0
GROUP BY CarClassID
ORDER BY AvgRentalDuration;

-- Question 16
SELECT CONCAT(Fname, ' ', MName, ' ', LName) AS FullName, 
		COUNT(CarClassID) AS LuxuryRentalCount
FROM person p 
INNER JOIN rental r ON r.DLicenseNum = p.DLicenseNum 
INNER JOIN car c ON r.CarID = c.CarID 
WHERE CarClassID = 'l' 
	AND p.DLicenseNum NOT IN
    (SELECT DISTINCT r.DLicenseNum 
    FROM rental r
    INNER JOIN car c ON c.CarID = r.CarID
    WHERE CarClassID != 'l')
GROUP BY FullName
ORDER BY FullName;

-- Question 17
SELECT CONCAT(FName, ' ', MName, ' ', LName) AS EmployeeName,
		CarID, COUNT(CarID) AS RentalCount
FROM employee e
INNER JOIN person p ON p.DLicenseNum = e.DLicenseNum 
INNER JOIN rental r ON r.DLicenseNum = e.DLicenseNum
GROUP BY EmployeeName, CarID
HAVING RentalCount >= 2
ORDER BY EmployeeName;


