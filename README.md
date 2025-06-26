# 1-Intro

1. [¿Qué es dbt y para qué sirve?](#schema1)
2. [Diferencia entre ETL y ELT](#schema2)
3. [Arquitectura de dbt](#schema3)
4. [Practica con Docker](#schema4)
5. [Cómo trabajar con dbt usando PostgreSQL instalado localmente](#schema5)
6. [Arrancar el contenedor Docker de PostgreSQL](#schema6)
7. [Ejercicio paso a paso](#schema7)





<hr>
<a name='schema1'></a>

## 1. ¿Qué es dbt y para qué sirve?
- `dbt`(data build tool) es una herramienta de código abierto que permite a los analistas e ingenieros de datos transformar datos en su almacén de datos mediante SQL y código modular.
- `dbt` permite:
    - Versionar códgio de transformación de datos como si fuera software (como Git)
    - Crear transformación reproducibles y testeables.
    - Generar documentación automática y trazabilidad (lineage)
- ¿Para qué sirve?
    - Reemplaza la parte de transformación en  pipelines de datos tradicionales.
    - Permite pasar de un enfoque ETL a ELT: Extaer -> Cargar -> Transformar en el data warehouse

<hr>
<a name='schema2'></a>

## 2. Diferencia entre ETL y ELT

| Proceso              | ETL (Extract, Transform, Load) | ELT (Extract, Load, Transform) |
| -------------------- | ------------------------------ | ------------------------------ |
| Transformación       | Antes de cargar                | Después de cargar              |
| Herramientas comunes | Talend, Informatica, SSIS      | dbt, Spark SQL, BigQuery SQL   |
| Uso común            | Data Lakes, entornos legacy    | Data Warehouses modernos       |


dbt se enfoca en el paso de Transform dentro de la arquitectura ELT.

<hr>
<a name='schema3'></a>

## 3. Arquitectura de dbt
- **Modelos:** `.sql`que definen transformaciones; se almacenana en `models/`. Son la unidad del trabajo de `dbt`
- **Marcos:** Fragmentos de lógica reutilizable escritos en Jinja(un lenguaje de templates).
- **Seeds:** Archivos `.csv`que se cargan como tablas al warehouse, ideales para data de referencia.
- **Snaphots:** Permiten mantener historial de cambios en los datos (control de versiones).
- **Tests:** Validaciones que garantizan integridad de los datos, como verificar unicidad o que haya nulos.


<hr>
<a name='schema4'></a>

## 4. Práctica con docker
1. Crear un proyecto desde cero
```bash
dbt init mi_proyecto_dbt
cd mi_proyecto_dbt
```
- Nombre del proyecto.
- Tipo de conexión.
- Datos de conexión a tu base de datos.

1. Concetar dbt a Postgres en Docker
```bash
docker run --name postgres-dbt \
  -e POSTGRES_USER=patricia \
  -e POSTGRES_PASSWORD=1234 \
  -e POSTGRES_DB=dbt_tutorial \
  -p 5432:5432 \
  -d postgres
```
| Parámetro                     | Función                                         |
| ----------------------------- | ----------------------------------------------- |
| `--name postgres-dbt`         | Nombra el contenedor                            |
| `-e POSTGRES_USER=patricia`   | Crea el usuario `patricia`                      |
| `-e POSTGRES_PASSWORD=1234`   | Le pone contraseña al usuario                   |
| `-e POSTGRES_DB=dbt_tutorial` | Crea la base de datos automáticamente           |
| `-p 5432:5432`                | Expone el puerto para conectarte desde fuera    |
| `-d postgres`                 | Usa la imagen oficial de Postgres en modo fondo |


2. Verifica que puedes acceder a la base de datos

```bash
psql -h localhost -U patricia -d dbt_tutorial
```
3. ¿Por qué usar Docker si ya tienes PostgreSQL instalado localmente?

Para tener un entorno limpio, controlado, portátil y fácil de resetear.

4. Ventajas de usar PostgreSQL en Docker (aunque ya tengas una instalación local):

| Ventaja                           | Explicación                                                                                                                      |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Aislamiento total**             | No te arriesgas a romper tu instalación local de Postgres haciendo pruebas o cambios.                                            |
| **Entorno limpio y reproducible** | Siempre puedes eliminar y volver a crear el contenedor si algo falla. Ideal para practicar y proyectos temporales.               |
| **Portabilidad**                  | Puedes compartir tu configuración con otros (por ejemplo, en un equipo) sin que ellos tengan que configurar Postgres localmente. |
| **Evitas conflictos**             | No interfieres con bases de datos reales o configuraciones sensibles de tu máquina.                                              |
| **Versión controlada**            | Puedes definir y usar exactamente la versión de PostgreSQL que quieras (por ejemplo `postgres:15`).                              |


5. ¿Cuándo es mejor usar tu instalación local de Postgres?
- Cuando ya tienes varias bases de datos activas y necesitas integrarlas directamente con apps locales.

- Si no quieres tener que iniciar Docker cada vez.

- Si estás trabajando con volúmenes grandes de datos o rendimiento alto y prefieres evitar la capa de virtualización.

6. Verificar el archivo `dbt_project.yml`
- Donde dice el perfil a usar.
```yml
name: 'mi_proyecto_dbt'
version: '1.0.0'

profile: 'mi_proyecto_dbt'

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:
  - "target"
  - "dbt_packages"

models:
  mi_proyecto_dbt:
    +materialized: view
```

7. Comprobar el `~/.dbt/profiles.yml`
- Dice cómo conectarse (credenciales, base de datos, etc.).

```yml
mi_proyecto_dbt:
  outputs:
    dev:
      type: postgres
      host: localhost
      user: patricia
      password: "1234"
      port: 5432
      dbname: dbt_tutorial
      schema: public
  target: dev
```

8. Ahí creas un archivo SQL, por ejemplo: `my_first_dbt_model.sql`.

```sql
select 1 as id, 'Hola dbt' as mensaje
```
9. Ejecutar el comando en tu terminal 
```bash
dbt run
```
- El modelo es el archivo `.sql` que escribes en dbt.
    - Un modelo es simplemente un archivo .sql que contiene una consulta. Esa consulta puede ser:

       - Una selección de columnas,

      - Una agregación (agrupaciones),

      - Una transformación compleja de datos.

- El modelo se convierte en una tabla o vista real cuando ejecutas dbt run.
  - Lee tus modelos (.sql).

  - Transforma el contenido según tu configuración (por ejemplo, los convierte en tablas o vistas en tu base de datos).

  - Ejecuta esas queries en tu base de datos (en tu caso, Postgres).

  - Crea una tabla o vista con el nombre del archivo en la base de datos.

- Esa tabla o vista está en la base de datos y puedes consultarla como cualquier otra tabla.

10. Verifica el modelo en Postgres
Entra al shell de Postgres para revisar la tabla/vista que creaste:

```bash
psql -h localhost -U patricia -d dbt_tutorial
```
11. Una vez dentro, ejecuta la consulta para ver los datos del modelo que generaste. Por ejemplo, si tu modelo se llama my_first_dbt_model:

```sql
select * from public.my_first_dbt_model;
```

<hr>
<a name='schema5'></a>

## 5. Cómo trabajar con dbt usando PostgreSQL instalado localmente

1. Verifica que PostgreSQL esté instalado y corriendo

```bash
brew services list
```

2. Crea usuario, base de datos y otorga permisos
Abre la consola de Postgres (puede ser con psql):

```bash
psql -U postgres
```
Ejecuta estos comandos para crear el usuario y la base de datos (ajusta el nombre y contraseña):

```sql
CREATE USER patricia WITH PASSWORD '1234';
CREATE DATABASE dbt_tutorial OWNER patricia;
GRANT ALL PRIVILEGES ON DATABASE dbt_tutorial TO patricia;
```
Luego sal con \q.

3. Configura tu archivo profiles.yml de dbt
El archivo suele estar en:

- macOS/Linux: ~/.dbt/profiles.yml


Ejemplo básico de configuración para Postgres local:

```yaml
dbt_tutorial:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: patricia
      password: '1234'
      port: 5432
      dbname: dbt_tutorial
      schema: public
```

4. Prueba la conexión con dbt
Desde la raíz de tu proyecto:

```bash
dbt debug
```
Si sale OK, estás conectada a tu base local.

5. Crea modelos dbt y ejecútalos
- En tu proyecto dbt, dentro de la carpeta models/, crea un archivo SQL con tu consulta.

- Ejecuta:

```bash
dbt run
```
- Consulta en Postgres para ver resultados:

```bash
psql -h localhost -U patricia -d dbt_tutorial
select * from nombre_de_tu_modelo;
```
6. Ventajas y consideraciones
- Si usas local, cuida las versiones de Postgres para que dbt sea compatible.
- Si tienes varias bases de datos o proyectos, usa diferentes schemas para aislar datos.
- Es recomendable usar un entorno virtual para instalar dbt y sus dependencias, para evitar conflictos.


<hr>
<a name='schema6'></a>

## 6. Arrancar el contenedor Docker de PostgreSQL
- Arrancar Docker Desktop.
```bash
docker start postgres-dbt
docker ps  # para verificar que esté corriendo
```

7. Activar el entorno virtual de Python donde instalaste dbt
```bash
source venv_dbt/bin/activate
```
7. Verificar conexión con dbt
- Navegar hasta la carpeta del proyecto y ejecutar:
```bash
dbt debug
```
<hr>
<a name='schema7'></a>

## 7. Ejercicio paso a paso

1. Comprobar paso [6](#6-arrancar-el-contenedor-docker-de-postgresql)

2. Crear un archivo CSV para poblar datos (seed)
- Crea el archivo `seeds/employees.csv` con este contenido:

```csv
id,first_name,last_name,department
1,Ana,López,Marketing
2,Luis,García,Finance
3,Carmen,Pérez,Engineering
```
3. Ejecutar el comando para cargar el seed
Desde la raíz del proyecto:

```bash
dbt seed
```
Verás que se crea una tabla employees en la base de datos dbt_tutorial.
4. Abre tu terminal y conéctate a tu base de datos de Postgres (asegúrate de que Docker esté corriendo y el contenedor activo):

```bash

psql -h localhost -U patricia -d dbt_tutorial
```
Si te pide contraseña, escribe la que configuraste (por ejemplo, 1234).

5. Ya dentro del prompt de psql, ejecuta:

```sql
\dt
```
Esto mostrará todas las tablas disponibles. Deberías ver una como esta:

```pgsql
 public | employees | table | patricia
 ```
6. Para ver el contenido de la tabla:

```sql
select * from employees;
```
7. Crear un modelo
Crea el archivo `models/employee_summary.sql` con esta query:
```sql
-- models/employee_summary.sql
select
  department,
  count(*) as total_employees
from {{ ref('employees') }}
group by department
```
8. Ejecutar el modelo
```bash
dbt run
```
Esto creará una tabla o vista en tu base de datos llamada `employee_summary`.

9. ¿Qué hace dbt compile?
`dbt compile` traduce tus modelos `.sql` con Jinja (como `{{ ref('otro_modelo') }}` o `{{ config(...) }`}) a SQL puro que será ejecutado contra tu base de datos.

- No ejecuta nada en tu base de datos.
  - Solo convierte tus archivos .sql en código SQL final y los guarda en la carpeta target/compiled.

- ¿Por qué es útil?
  - Te permite ver exactamente qué SQL genera dbt antes de que lo ejecute.

  - Ideal para depurar errores de sintaxis o entender lo que se ejecutará.

- ¿Cómo se usa?
  - Desde la raíz de tu proyecto (donde está dbt_project.yml), ejecuta:

```bash
dbt compile
```
- ¿Dónde ver el SQL compilado?
  - Después de compilar, puedes ir a la carpeta:


`target/compiled/mi_proyecto_dbt/models/`
- Ahí verás un archivo .sql que es el resultado final de tu modelo (por ejemplo, first_model.sql) ya sin Jinja, solo SQL puro.


10. Paso a paso completo con lo que llevas:
- Ya tienes tu modelo en `models/my_first_model.sql`.

- Ejecutaste `dbt run` → esto ya creó la tabla en Postgres.

Ejecuta ahora:

```bash
dbt compile
```
- Opcional: Abre el archivo compilado si quieres ver el SQL final.

- Para verificar que tu conexión está bien:

```bash
dbt debug
```

10. Verificar los datos en Postgres
Conéctate a tu base de datos:

```bash
psql -h localhost -U patricia -d dbt_tutorial
```
Y luego ejecuta:

```sql
select * from employees_summary;
```


11. ¿Cuál es el orden recomendado en proyectos reales?
  1. `dbt run` → es el comando principal que se usa normalmente, porque:

    - Internamente ya hace el `compile` automáticamente.

    - Ejecuta el SQL final en tu base de datos y crea las tablas o vistas.

  2. Por eso, no necesitas correr `dbt compile` antes de `dbt run`, salvo que quieras ver el SQL antes de ejecutarlo.

12. Entonces… ¿para qué usar `dbt compile`?
1. Lo usas solo si quieres revisar o depurar el SQL que se va a ejecutar, sin hacer cambios en tu base de datos. Por ejemplo:

  - Para asegurarte de que el código Jinja genera SQL correcto.

  - Para ver cómo se resuelven los `{{ ref() }}` o configuraciones.

13. Ejemplo de flujo típico en desarrollo
1. Creas o modificas un modelo: `models/my_model.sql`.

2. Ejecutas `dbt compile` para revisar qué SQL generó.

3. Verificas que esté bien (opcional).

4. Ejecutas `dbt run` para aplicarlo a la base de datos.

14. onclusión
- En producción: solo usas `dbt run`, porque ya incluye `compile`.

- En desarrollo: puedes hacer `compile` antes si quieres ver el SQL final sin afectar nada.

