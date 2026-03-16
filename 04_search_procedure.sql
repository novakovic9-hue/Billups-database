CREATE PROCEDURE SearchPOI
@json NVARCHAR(MAX)
AS
BEGIN

DECLARE @Country NVARCHAR(10)
DECLARE @Region NVARCHAR(20)
DECLARE @City NVARCHAR(100)
DECLARE @Category NVARCHAR(200)
DECLARE @Name NVARCHAR(200)
DECLARE @Lat FLOAT
DECLARE @Lon FLOAT
DECLARE @Radius INT
DECLARE @Polygon NVARCHAR(MAX)

SELECT
@Country = JSON_VALUE(@json,'$.country'),
@Region = JSON_VALUE(@json,'$.region'),
@City = JSON_VALUE(@json,'$.city'),
@Category = JSON_VALUE(@json,'$.category'),
@Name = JSON_VALUE(@json,'$.name'),
@Lat = JSON_VALUE(@json,'$.latitude'),
@Lon = JSON_VALUE(@json,'$.longitude'),
@Radius = JSON_VALUE(@json,'$.radius'),
@Polygon = JSON_VALUE(@json,'$.polygon')

DECLARE @Location GEOGRAPHY
DECLARE @Poly GEOGRAPHY

IF @Lat IS NOT NULL
SET @Location = geography::Point(@Lat,@Lon,4326)

IF @Polygon IS NOT NULL
SET @Poly = geography::STGeomFromText(@Polygon,4326)

SELECT
p.Id,
p.ParentId,
c.CountryCode,
r.RegionCode,
ci.CityName,
p.Latitude,
p.Longitude,
cat.TopCategory,
cat.SubCategory,
p.Polygon.STAsText() AS WKTPolygon,
p.LocationName,
p.PostalCode,
p.OperationHours
FROM POI p
JOIN Cities ci ON p.CityId = ci.CityId
JOIN Regions r ON ci.RegionCode = r.RegionCode
JOIN Countries c ON r.CountryCode = c.CountryCode
JOIN Categories cat ON p.CategoryId = cat.CategoryId

WHERE
(@Country IS NULL OR c.CountryCode = @Country)
AND (@Region IS NULL OR r.RegionCode = @Region)
AND (@City IS NULL OR ci.CityName = @City)
AND (@Category IS NULL OR cat.TopCategory = @Category)
AND (@Name IS NULL OR p.LocationName LIKE '%' + @Name + '%')

AND
(
@Location IS NULL
OR p.Location.STDistance(@Location) <= ISNULL(@Radius,200)
)

AND
(
@Poly IS NULL
OR p.Location.STWithin(@Poly) = 1
)

FOR JSON PATH

END