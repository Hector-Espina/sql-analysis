# Análisis SQL de E-Commerce — Maven Fuzzy Factory

Proyecto de análisis de datos desarrollado con **PostgreSQL** sobre un dataset de e-commerce de Maven Analytics.

El objetivo es analizar el rendimiento de un negocio online desde distintas perspectivas: ventas, productos, clientes, marketing, dispositivos, comportamiento web, funnel de conversión y devoluciones.

El proyecto cubre el proceso completo desde la creación de la base de datos y la validación y limpieza de los datos hasta el análisis avanzado y la extracción de insights de negocio.

---

## Objetivos del análisis

El análisis busca responder preguntas como:

- ¿Cuál es el rendimiento general del negocio?
- ¿Cómo evolucionan el revenue y los pedidos a lo largo del tiempo?
- ¿Qué productos generan más revenue y beneficio?
- ¿Qué canales y campañas de marketing presentan mejores resultados?
- ¿Existen diferencias importantes entre desktop y mobile?
- ¿Cómo se comportan los usuarios nuevos frente a los recurrentes?
- ¿Dónde se producen las principales pérdidas dentro del funnel de conversión?
- ¿Qué productos presentan mayores tasas de devolución?

---

## Dataset

El proyecto utiliza el dataset **Toy Store E-Commerce Database / Maven Fuzzy Factory**, disponible públicamente en Maven Analytics.

**Fuente:** https://mavenanalytics.io/data-playground/toy-store-e-commerce-database

El dataset contiene información sobre:

- sesiones web;
- páginas visitadas;
- pedidos;
- artículos vendidos;
- productos;
- devoluciones.

La base de datos utilizada en el proyecto contiene **1.735.068 registros** distribuidos entre las seis tablas analizadas.

Los archivos CSV originales no se incluyen en el repositorio debido a su tamaño. Pueden descargarse directamente desde la fuente indicada anteriormente.

---

## Tecnologías utilizadas

- **PostgreSQL**
- **SQL**
- **Git**
- **GitHub**
- **WSL2 / Ubuntu**
- **Visual Studio Code**

---

## Modelo de datos

La base de datos está formada por seis tablas principales:

- `website_sessions`
- `website_pageviews`
- `orders`
- `order_items`
- `order_item_refunds`
- `products`

El modelo relacional completo, incluyendo claves primarias, claves foráneas y relaciones entre las tablas, está documentado en:

**[Ver modelo de datos](docs/database_schema.md)**

---

## Estructura del proyecto

```text
sql-analysis/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── docs/
│
├── results/
│   └── key_insights.md
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_validation.sql
│   ├── 03_data_cleaning.sql
│   ├── 04_exploratory_analysis.sql
│   └── 05_advanced_analysis.sql
│
├── .gitignore
└── README.md
```

---

## Cómo reproducir el proyecto

### 1. Descargar el dataset

Descargar **Toy Store E-Commerce Database / Maven Fuzzy Factory** desde Maven Analytics:

https://mavenanalytics.io/data-playground/toy-store-e-commerce-database

Guardar los archivos CSV en:

```text
data/raw/
```

Los CSV están excluidos del control de versiones mediante `.gitignore`.

### 2. Crear la base de datos

Crear una base de datos PostgreSQL para el proyecto y conectarse a ella mediante `psql`.

### 3. Crear las tablas

Ejecutar:

```bash
psql -d sql_analysis -f sql/01_database_setup.sql
```

Este script crea las seis tablas y sus relaciones mediante claves primarias y foráneas.

### 4. Importar los datos

Desde `psql`, importar cada CSV mediante `\copy`.

Ejemplo:

```sql
\copy products FROM 'data/raw/products.csv' DELIMITER ',' CSV HEADER;
```

El mismo procedimiento debe aplicarse al resto de tablas respetando las dependencias entre claves foráneas.

### 5. Validar los datos

Ejecutar:

```bash
psql -d sql_analysis -f sql/02_data_validation.sql
```

Este script comprueba duplicados, valores nulos, rangos temporales, integridad referencial y reglas básicas de negocio.

### 6. Limpiar los datos

Ejecutar:

```bash
psql -d sql_analysis -f sql/03_data_cleaning.sql
```

El proceso normaliza los valores ausentes almacenados originalmente como la cadena de texto `'NULL'`.

### 7. Ejecutar los análisis

Análisis exploratorio:

```bash
psql -d sql_analysis -f sql/04_exploratory_analysis.sql
```

Análisis avanzado:

```bash
psql -d sql_analysis -f sql/05_advanced_analysis.sql
```

Los principales resultados e interpretaciones están documentados en:

**[Principales insights de negocio](results/key_insights.md)**


---

## Preparación y calidad de los datos

Antes de realizar el análisis se llevaron a cabo diferentes controles de calidad:

- comprobación del número de registros;
- detección de claves primarias duplicadas;
- análisis de valores nulos;
- validación de rangos de fechas;
- comprobación de valores categóricos;
- validación de integridad referencial;
- comprobación de reglas básicas de negocio.

Durante este proceso se detectó que determinados valores ausentes estaban almacenados como la cadena de texto `'NULL'` en lugar de utilizar valores `NULL` reales de SQL.

Estos valores fueron normalizados antes de realizar los análisis posteriores.

---

## Principales KPIs

| KPI | Resultado |
|---|---:|
| Usuarios únicos | 394.318 |
| Sesiones | 472.871 |
| Pedidos | 32.313 |
| Unidades vendidas | 40.025 |
| Tasa de conversión | 6,83 % |
| Revenue | $1.938.509,75 |
| Beneficio bruto | $1.216.139,50 |
| Margen bruto | 62,74 % |
| AOV | $59,99 |
| Tasa de devolución por artículo | 4,32 % |

---

## Principales insights

### Desktop supera ampliamente a mobile

Desktop alcanzó una tasa de conversión del **8,50 %**, frente al **3,09 % de mobile**.

Además, el revenue por sesión fue de **$5,09 en desktop frente a $1,87 en mobile**, lo que señala una posible oportunidad de optimización de la experiencia móvil.

### Los usuarios recurrentes convierten mejor

Las sesiones recurrentes alcanzaron una conversión del **7,83 %**, frente al **6,64 % de las sesiones nuevas**.

Esto sugiere que la recurrencia está asociada a una mayor intención de compra.

### Alta concentración del revenue en un producto

**The Original Mr. Fuzzy** generó aproximadamente el **62,47 % del revenue de productos**.

Esta concentración convierte al producto en una pieza fundamental del rendimiento comercial del negocio.

### El principal cuello de botella está antes del carrito

En el funnel analizado, solo el **45,17 %** de las sesiones que visitaron una página de producto llegaron posteriormente al carrito.

Esta transición representa la mayor pérdida de usuarios entre las etapas analizadas.

### Diferencias importantes entre campañas

La campaña **bsearch / brand** obtuvo una conversión del **8,86 %**, mientras que **socialbook / pilot** alcanzó únicamente un **1,08 %**.

Esto muestra diferencias sustanciales en la calidad y efectividad del tráfico adquirido.

### Las devoluciones varían considerablemente por producto

La tasa global de devolución por artículo fue del **4,32 %**.

**The Birthday Sugar Panda** presentó la mayor tasa de devolución, con un **6,04 %**, frente al **1,28 % de The Hudson River Mini Bear**.

---

## Funnel de conversión

El comportamiento observado de los usuarios a través del proceso de compra fue:

Products
   ↓ 80,47 %
Product page
   ↓ 45,17 %
Cart
   ↓ 67,91 %
Shipping
   ↓ 80,73 %
Billing
   ↓ 62,07 %
Order

La transición **Product page → Cart** representa el principal cuello de botella entre las etapas analizadas.

---

## SQL utilizado

El proyecto incluye consultas desde nivel fundamental hasta técnicas más avanzadas:

- `JOIN` y `LEFT JOIN`
- agregaciones con `GROUP BY`
- `CASE WHEN`
- subqueries
- CTEs (`WITH`)
- `COALESCE` y `NULLIF`
- análisis temporal con `DATE_TRUNC`
- window functions
- `LAG()`
- `RANK()` y `DENSE_RANK()`
- crecimiento Month-over-Month
- análisis de funnels
- análisis de conversión

---

## Ejemplo de SQL avanzado

Para analizar la evolución mensual del revenue se utiliza una CTE junto con la window function `LAG()`:

```sql
WITH monthly_performance AS (
    SELECT
        DATE_TRUNC('month', created_at)::DATE AS month,
        SUM(price_usd) AS revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', created_at)
)

SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
FROM monthly_performance
ORDER BY month;
```

Esto permite comparar cada mes con el inmediatamente anterior y calcular posteriormente el crecimiento Month-over-Month.

---

## Recomendaciones de negocio

A partir de los resultados obtenidos:

1. **Investigar y optimizar la experiencia de compra en mobile**, dada su menor tasa de conversión.
2. **Analizar las causas del abandono entre la página de producto y el carrito**, principal pérdida detectada en el funnel.
3. **Revisar la campaña socialbook / pilot**, debido a su baja tasa de conversión.
4. **Investigar la elevada tasa de devolución de The Birthday Sugar Panda**.
5. **Potenciar la recurrencia de los usuarios**, ya que las sesiones recurrentes presentan una mayor conversión.
6. **Incorporar la estacionalidad observada** en la planificación comercial.

---

## Periodo analizado

Los datos abarcan desde marzo de 2012 hasta marzo de 2015.

El último mes está incompleto, ya que el dataset finaliza el **19 de marzo de 2015**. Por este motivo, marzo de 2015 no debe compararse directamente con meses completos anteriores al interpretar las métricas mensuales.

---

## Autor

**Héctor Espina Antuña**

Proyecto desarrollado como parte de un portfolio de Data Analytics.