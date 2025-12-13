# Proyecto Análisis de Vuelos

Este repositorio contiene los recursos usados para construir un modelo de datos y un panel sobre retrasos de vuelos en EE. UU. Incluye scripts SQL para crear el esquema estrella, archivos de datos procesados, materiales de documentación y notebooks de preparación.

## Estructura del repositorio

- `Contenedores/`: instrucciones y referencia visual para levantar el contenedor de SQL Server usado en el proyecto.
- `data/`: extractos de los datos limpios (`vuelos_clean.txt`, tablas dimensionales y muestra reducida) que pueden usarse para pruebas o cargas manuales.
- `docs/`: documentación de soporte (diccionario de datos y diagrama visual).
- `export/`: ejemplos exportados desde notebooks (diccionario HTML, muestra en CSV y listado de columnas).
- `notebooks/`: notebook `Extraccion.ipynb` con el flujo de limpieza y preparación de los datos.
- `sql/`: scripts SQL para crear el modelo estrella, cargar dimensiones y hechos, y añadir índices.
- Archivos de Power BI (`proyecto_analisis_final.pbix` y `proyecto_analisis_final_DASHBOARD.pdf`) con el dashboard final.

## Requisitos previos

- Docker con acceso a las imágenes públicas de Microsoft SQL Server.
- Cliente SQL que permita ejecutar scripts T-SQL (por ejemplo, Azure Data Studio o SQLCMD).
- (Opcional) Power BI Desktop para abrir el archivo `.pbix`.

## Puesta en marcha local

1. **Crear el contenedor de SQL Server.** Ejecuta el comando siguiente para levantar una instancia local (ajusta las credenciales si lo deseas):
   ```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Admin123!" \
  -p 1433:1433 --name sql2022 \
  -v sql2022_data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest
   ```

2. **Preparar los datos.** Copia el archivo Parquet con los vuelos (no incluido en el repo) al volumen del contenedor en la ruta `/var/opt/mssql/data/dd.parquet`, o ajusta la ruta en `sql/carga_data_Sql.sql` según tu ubicación.

3. **Cargar la tabla de staging.** Conéctate a la base de datos y ejecuta `sql/carga_data_Sql.sql` para crear la tabla `vuelos_clean` a partir del archivo Parquet.

4. **Crear el modelo estrella.** Ejecuta los scripts en este orden:
   - `sql/01_create_star.sql.sql`: crea las tablas de dimensiones y la tabla de hechos.
   - `sql/02_load_dimensions.sql`: carga `dim_airline`, `dim_airport` y `dim_date` desde `vuelos_clean`.
   - `sql/03_load_fact_12M.sql`: inserta los registros de hechos filtrando los vuelos con 15+ minutos de retraso.
   - `sql/04_indexes.sql`: añade índices para acelerar las consultas.

5. **Explorar y visualizar.**
   - Usa el cliente SQL para validar las tablas y correr tus consultas.
   - Abre `proyecto_analisis_final.pbix` en Power BI Desktop y apunta las conexiones a tu instancia local si deseas reproducir el dashboard.

## Datos de referencia incluidos

- `data/vuelos_clean.txt`: extracto de la tabla de staging con todas las columnas principales.
- `data/dim_airline.txt`, `data/dim_airport.txt`, `data/dim_date.txt`: ejemplos de dimensiones generadas.
- `data/fact_flights.txt`: extracto de la tabla de hechos.
- `data/sample_100000.txt`: subconjunto reducido para pruebas rápidas.

## Notas

- Los scripts asumen el uso de SQL Server 2022 en Linux; si usas otra versión, verifica compatibilidad de tipos y funciones.
- Si cambias la ubicación del archivo Parquet o el nombre de la base de datos, actualiza las rutas en los scripts correspondientes.
