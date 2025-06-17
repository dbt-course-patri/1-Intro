# 1-Intro

1. [¿Qué es dbt y para qué sirve?](#schema1)
2. [Diferencia entre ETL y ELT](#schema2)
3. [Arquitectura de dbt](#schema3)
4. [Practica con Docker](#schema4)
5. [Cómo trabajar con dbt usando PostgreSQL instalado localmente](#schema5)


21. [Notas](#schemanotas)


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
cd mi_proyecti_dbt
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

