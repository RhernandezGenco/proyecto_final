INSERT INTO dim_airline (carrier_code, airline_name)
SELECT DISTINCT Reporting_Airline, NULL
FROM Vuelos_clean;

-- ORIGIN AIRPORTS
INSERT INTO dim_airport (airport_code, airport_name, city, state)
SELECT DISTINCT 
    Origin,
    NULL,                 -- No tenemos nombre del aeropuerto
    OriginCityName,
    OriginState
FROM Vuelos_clean;

-- DESTINATION AIRPORTS
INSERT INTO dim_airport (airport_code, airport_name, city, state)
SELECT DISTINCT
    Dest,
    NULL,                 -- No tenemos nombre del aeropuerto
    DestCityName,
    DestState
FROM Vuelos_clean
WHERE Dest NOT IN (SELECT airport_code FROM dim_airport);

INSERT INTO dim_date (fecha, year, month, day, quarter, weekday)
SELECT DISTINCT
    FlightDate,
    YEAR(FlightDate),
    MONTH(FlightDate),
    DAY(FlightDate),
    DATEPART(QUARTER, FlightDate),
    DATEPART(WEEKDAY, FlightDate)
FROM Vuelos_clean
WHERE FlightDate IS NOT NULL
ORDER BY FlightDate;



INSERT INTO fact_flights (
    airline_id,
    origin_airport_id,
    destination_airport_id,
    fecha_id,
    dep_delay,
    arr_delay,
    total_delay,
    distance,
    flight_status
)
SELECT
    da.airline_id,
    ao.airport_id,
    ad.airport_id,
    dd.fecha_id,
    f.DepDelayMinutes,
    f.ArrDelayMinutes,
    (f.DepDelayMinutes + f.ArrDelayMinutes),
    f.Distance,
    CASE
        WHEN f.Cancelled = 1 THEN 'Cancelled'
        WHEN f.Diverted = 1 THEN 'Diverted'
        ELSE 'Completed'
    END
FROM Vuelos_clean f
JOIN dim_airline da 
    ON da.carrier_code = f.Reporting_Airline
JOIN dim_airport ao 
    ON ao.airport_code = f.Origin
JOIN dim_airport ad 
    ON ad.airport_code = f.Dest
JOIN dim_date dd 
    ON dd.fecha = f.FlightDate
WHERE f.DepDel15 = 1;   --  solo vuelos con 15+ minutos de   retraso

select top(10) [Reporting_Airline]
from Vuelos_clean

select top(10) *
from Vuelos_clean

exec sp_columns Vuelos_clean