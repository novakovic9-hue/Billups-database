
INSERT INTO Countries (CountryCode)
SELECT DISTINCT country_code
FROM POI_Staging;

INSERT INTO Regions (RegionCode, CountryCode)
SELECT DISTINCT region, country_code
FROM POI_Staging;

INSERT INTO Cities (CityName, RegionCode, CountryCode)
SELECT DISTINCT city, region, country_code
FROM POI_Staging;

INSERT INTO Brands (BrandId, BrandName)
SELECT DISTINCT brand_id, brand
FROM POI_Staging
WHERE brand_id IS NOT NULL;

INSERT INTO Categories (TopCategory, SubCategory, CategoryTags)
SELECT DISTINCT top_category, sub_category, category_tags
FROM POI_Staging;


INSERT INTO POI
(
Id,
ParentId,
BrandId,
CategoryId,
CityId,
PostalCode,
LocationName,
Latitude,
Longitude,
Location,
GeometryType,
Polygon,
OperationHours
)
SELECT  
s.id,
s.parent_id,
s.brand_id,
c.CategoryId,
ci.CityId,
s.postal_code,
s.location_name,

TRY_CAST(s.latitude AS FLOAT),
TRY_CAST(s.longitude AS FLOAT),

CASE
WHEN TRY_CAST(s.latitude AS FLOAT) BETWEEN -90 AND 90
AND TRY_CAST(s.longitude AS FLOAT) BETWEEN -180 AND 180
THEN geography::Point(
TRY_CAST(s.latitude AS FLOAT),
TRY_CAST(s.longitude AS FLOAT),
4326
)
END,

s.geometry_type,

CASE
WHEN s.polygon_wkt IS NOT NULL
AND s.polygon_wkt LIKE 'POLYGON%'
THEN geography::STGeomFromText(s.polygon_wkt,4326)
END,

s.operation_hours

FROM Staging s
left JOIN Cities ci
ON s.city = ci.CityName
and s.country_code = ci.countryCode
and s.region = ci.RegionCode

left JOIN Categories c
ON s.top_category = c.TopCategory
AND ISNULL(s.sub_category,'') = ISNULL(c.SubCategory,'')
AND ISNULL(s.category_tags,'') = ISNULL(c.CategoryTags,'')


WHERE
TRY_CAST(s.latitude AS FLOAT) IS NOT NULL
AND TRY_CAST(s.longitude AS FLOAT) IS NOT NULL

