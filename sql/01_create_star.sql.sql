------------------------
-- DIMENSIÓN AEROLÍNEA --
-------------------------
IF OBJECT_ID('dim_airline', 'U') IS NOT NULL
    DROP TABLE dim_airline;
GO

CREATE TABLE dim_airline (
    airline_id INT IDENTITY(1,1) PRIMARY KEY,
    carrier_code VARCHAR(10) NOT NULL,
    airline_name VARCHAR(255) NULL
);
GO

--------------------------
-- DIMENSIÓN AEROPUERTO --
--------------------------
IF OBJECT_ID('dim_airport', 'U') IS NOT NULL
    DROP TABLE dim_airport;
GO

CREATE TABLE dim_airport (
    airport_id INT IDENTITY(1,1) PRIMARY KEY,
    airport_code VARCHAR(10) NOT NULL,
    airport_name VARCHAR(255) NULL,
    city VARCHAR(255) NULL,
    state VARCHAR(10) NULL
);
GO

----------------------
-- DIMENSIÓN FECHA  --
----------------------
IF OBJECT_ID('dim_date', 'U') IS NOT NULL
    DROP TABLE dim_date;
GO

CREATE TABLE dim_date (
    fecha_id INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    [year] INT NOT NULL,
    [month] INT NOT NULL,
    [day] INT NOT NULL,
    quarter INT NOT NULL,
    weekday INT NOT NULL,
    is_holiday BIT NOT NULL DEFAULT(0)
);
GO

--------------------
-- TABLA DE HECHOS --
--------------------
IF OBJECT_ID('fact_flights', 'U') IS NOT NULL
    DROP TABLE fact_flights;
GO

CREATE TABLE fact_flights (
    fact_id BIGINT IDENTITY(1,1) PRIMARY KEY,

    airline_id INT NOT NULL,
    origin_airport_id INT NOT NULL,
    destination_airport_id INT NOT NULL,
    fecha_id INT NOT NULL,

    dep_delay INT NULL,
    arr_delay INT NULL,
    total_delay INT NULL,
    distance INT NULL,
    flight_status VARCHAR(50) NULL
);
GO

ALTER TABLE fact_flights
ADD CONSTRAINT FK_fact_airline
    FOREIGN KEY (airline_id) REFERENCES dim_airline(airline_id);

ALTER TABLE fact_flights
ADD CONSTRAINT FK_fact_origin_airport
    FOREIGN KEY (origin_airport_id) REFERENCES dim_airport(airport_id);

ALTER TABLE fact_flights
ADD CONSTRAINT FK_fact_dest_airport
    FOREIGN KEY (destination_airport_id) REFERENCES dim_airport(airport_id);

ALTER TABLE fact_flights
ADD CONSTRAINT FK_fact_fecha
    FOREIGN KEY (fecha_id) REFERENCES dim_date(fecha_id);
GO

