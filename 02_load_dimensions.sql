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