# 1-Intro

1. [¿Qué es dbt y para qué sirve?](#schema1)
2. [Diferencia entre ETL y ELT](#schema2)
3. [3. Arquitectura de dbt](#schema3)


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