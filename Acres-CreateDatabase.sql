CREATE SCHEMA ACRES;
use ACRES;

-- address
CREATE TABLE address (
    AddressID varchar(30) NOT NULL,
    UnitNum varchar(30),
    StreetName varchar(30),
    City varchar(30),
    PostCode varchar(30),
    PRIMARY KEY (AddressID)
);
-- person
CREATE TABLE person (
    DLicenseNum varchar(30) NOT NULL,
    FName varchar(30),
    MName varchar(30),
    LName varchar(30),
    PhoneNum varchar(30),
    AddressID varchar(30),
    PRIMARY KEY (DLicenseNum),
    FOREIGN KEY (AddressID) REFERENCES address (AddressID)
);
-- car class
CREATE TABLE car_class(
     CarClassID varchar(30) NOT NULL,
     `Description` varchar(255) NOT NULL,
     Price float,
     PRIMARY KEY (CarClassID)
);
-- car
CREATE TABLE car (
    CarID varchar(30) NOT NULL,
    LPlate varchar(30),
    Make varchar(30),
    Model varchar(30),
    `Year` year,
    Colour varchar(30),
    CarLoc varchar(30),
    CarClassID varchar(30),
    PRIMARY KEY (CarID),
    FOREIGN KEY (CarLoc) REFERENCES address (AddressID),
    FOREIGN KEY (CarClassID) REFERENCES car_class (CarClassID)
);
-- customer
CREATE TABLE customer (
	DLicenseNum varchar(30) PRIMARY KEY,
    FOREIGN KEY (DLicenseNum) REFERENCES person (DLicenseNum)
);
-- employee
CREATE TABLE employee (
    DLicenseNum varchar(30) PRIMARY KEY,
    EmpType varchar(30),
    WorkLoc varchar(30),
    FOREIGN KEY (WorkLoc) REFERENCES address (AddressID)
);
-- drop off charge
CREATE TABLE drop_off_charge (
	CarClassID varchar(30) NOT NULL,
    FromLoc varchar(30) NOT NULL,
    ToLoc varchar(30) NOT NULL,
    Charge float,
    PRIMARY KEY (CarClassID, FromLoc, ToLoc),
    FOREIGN KEY (CarClassID) REFERENCES car_class (CarClassID),
    FOREIGN KEY (FromLoc) REFERENCES address (AddressID),
    FOREIGN KEY (ToLoc) REFERENCES address (AddressID)
);
-- rental
CREATE TABLE rental (
    RentalID varchar(30) NOT NULL,
    FromDate date NOT NULL,
    ToDate date NOT NULL,
    TankStatus int NOT NULL,
    IniOdom int NOT NULL,
    RetOdom int NOT NULL,
    DLicenseNum varchar(30) NOT NULL,
    FromLoc varchar(30),
    ToLoc varchar(30),
    CarID varchar(30),
    PRIMARY KEY (RentalID),
    FOREIGN KEY (DLicenseNum) REFERENCES person (DLicenseNum),
    FOREIGN KEY (ToLoc) REFERENCES address (AddressID),
    FOREIGN KEY (ToLoc) REFERENCES address (AddressID),
    FOREIGN KEY (CarID) REFERENCES car (CarID)
);
