CREATE DATABASE Billups;
GO

USE Billups;
GO

CREATE TABLE Countries (
    CountryCode NVARCHAR(10) PRIMARY KEY
);

CREATE TABLE Regions (
    RegionCode NVARCHAR(10),
    CountryCode NVARCHAR(10),
    PRIMARY KEY (RegionCode, CountryCode),
    FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode)
);

CREATE TABLE Cities (
    CityId INT IDENTITY PRIMARY KEY,
    CityName NVARCHAR(100),
    RegionCode NVARCHAR(10),
    CountryCode NVARCHAR(10),
    FOREIGN KEY (RegionCode, CountryCode)
        REFERENCES Regions(RegionCode, CountryCode)
);

CREATE TABLE Brands (
    BrandId NVARCHAR(max) PRIMARY KEY,
    BrandName NVARCHAR(200)
);

CREATE TABLE Categories (
    CategoryId INT IDENTITY PRIMARY KEY,
    TopCategory NVARCHAR(200),
    SubCategory NVARCHAR(200),
    CategoryTags NVARCHAR(500)
);

CREATE TABLE POI (
    Id NVARCHAR(50) PRIMARY KEY,
    ParentId NVARCHAR(50),
    BrandId NVARCHAR(max),
    CategoryId INT,
    CityId INT,
    PostalCode NVARCHAR(20),
    LocationName NVARCHAR(200),
    Latitude FLOAT,
    Longitude FLOAT,
    Location GEOGRAPHY,
    GeometryType NVARCHAR(20),
    Polygon GEOGRAPHY,
    OperationHours NVARCHAR(500)
);