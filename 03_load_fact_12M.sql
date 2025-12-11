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

