## Setup

1. Place staging.csv in data folder.

2. Extract staging.zip and Billups.zip files

3. import staging.csv using tasks -> import flat file

4. Run scripts in order:

01_schema.sql
03_transform_data.sql
04_search_procedure.sql
05_spatial_index.sql


## Example search

EXEC SearchPOI
@json = '
{
"city":"Phoenix",
"category":"Grocery Stores",
"latitude":33.4484,
"longitude":-112.0740,
"radius":500
}
'

## Restore

RESTORE DATABASE Billups
FROM DISK = 'backup/Billups.bak'
