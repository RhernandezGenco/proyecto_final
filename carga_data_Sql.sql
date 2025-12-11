SELECT DISTINCT
    TRY_CONVERT(smallint, src.Year)              AS Year,
    TRY_CONVERT(tinyint,  src.Month)             AS Month,
    TRY_CONVERT(tinyint,  src.DayofMonth)        AS DayofMonth,
    TRY_CONVERT(tinyint,  src.DayOfWeek)         AS DayOfWeek,
    TRY_CONVERT(date,     src.FlightDate)        AS FlightDate,

    NULLIF(src.Reporting_Airline, '')            AS Reporting_Airline,

    TRY_CONVERT(int,      src.OriginAirportID)   AS OriginAirportID,
    NULLIF(src.Origin, '')                       AS Origin,
    NULLIF(src.OriginCityName, '')               AS OriginCityName,
    NULLIF(src.OriginState, '')                  AS OriginState,
    TRY_CONVERT(smallint, src.OriginWac)         AS OriginWac,

    TRY_CONVERT(int,      src.DestAirportID)     AS DestAirportID,
    NULLIF(src.Dest, '')                         AS Dest,
    NULLIF(src.DestCityName, '')                 AS DestCityName,
    NULLIF(src.DestState, '')                    AS DestState,
    TRY_CONVERT(smallint, src.DestWac)           AS DestWac,

    TRY_CONVERT(int,      src.CRSDepTime)        AS CRSDepTime,
    TRY_CONVERT(int,      src.DepTime)           AS DepTime,
    TRY_CONVERT(int,      src.DepDelayMinutes)   AS DepDelayMinutes,
    TRY_CONVERT(tinyint,  src.DepDel15)          AS DepDel15,
    NULLIF(src.DepTimeBlk, '')                   AS DepTimeBlk,
    TRY_CONVERT(int,      src.TaxiOut)           AS TaxiOut,

    TRY_CONVERT(int,      src.CRSArrTime)        AS CRSArrTime,
    TRY_CONVERT(int,      src.ArrTime)           AS ArrTime,
    TRY_CONVERT(int,      src.ArrDelayMinutes)   AS ArrDelayMinutes,
    TRY_CONVERT(tinyint,  src.ArrDel15)          AS ArrDel15,
    NULLIF(src.ArrTimeBlk, '')                   AS ArrTimeBlk,
    TRY_CONVERT(int,      src.TaxiIn)            AS TaxiIn,

    TRY_CONVERT(int,      src.CRSElapsedTime)    AS CRSElapsedTime,
    TRY_CONVERT(int,      src.ActualElapsedTime) AS ActualElapsedTime,
    TRY_CONVERT(int,      src.Flights)           AS Flights,
    TRY_CONVERT(int,      src.Distance)          AS Distance,

    TRY_CONVERT(tinyint,  src.Cancelled)         AS Cancelled,
    NULLIF(src.CancellationCode, '')             AS CancellationCode,
    TRY_CONVERT(tinyint,  src.Diverted)          AS Diverted,

    ISNULL(TRY_CONVERT(int, src.CarrierDelay),      0) AS CarrierDelay,
    ISNULL(TRY_CONVERT(int, src.WeatherDelay),      0) AS WeatherDelay,
    ISNULL(TRY_CONVERT(int, src.NASDelay),          0) AS NASDelay,
    ISNULL(TRY_CONVERT(int, src.SecurityDelay),     0) AS SecurityDelay,
    ISNULL(TRY_CONVERT(int, src.LateAircraftDelay), 0) AS LateAircraftDelay
INTO dbo.vuelos_clean
FROM OPENROWSET(
        BULK '/var/opt/mssql/data/dd.parquet',  
        FORMAT = 'PARQUET'
     ) AS src
WHERE
    TRY_CONVERT(date, src.FlightDate) IS NOT NULL
    AND src.Reporting_Airline IS NOT NULL
    AND src.Origin IS NOT NULL
    AND src.Dest   IS NOT NULL;

	