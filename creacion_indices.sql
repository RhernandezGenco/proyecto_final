--Creacion de indices
CREATE INDEX idx_fact_airline ON fact_flights(airline_id);
CREATE INDEX idx_fact_origin ON fact_flights(origin_airport_id);
CREATE INDEX idx_fact_dest ON fact_flights(destination_airport_id);
CREATE INDEX idx_fact_fecha ON fact_flights(fecha_id);