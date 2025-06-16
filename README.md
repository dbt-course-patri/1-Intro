# 1-Intro

1. [¿Qué es dbt y para qué sirve?](#schema1)


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