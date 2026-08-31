# Principales Insights de Negocio

Este documento resume los principales hallazgos obtenidos durante el análisis del dataset de e-commerce Maven Fuzzy Factory.

## 1. Visión general del negocio

- El sitio web registró **472.871 sesiones** correspondientes a **394.318 usuarios únicos**.
- Se completaron **32.313 pedidos**.
- La tasa de conversión global de sesión a pedido fue del **6,83 %**.
- El negocio generó **$1.938.509,75 de revenue**.
- El beneficio bruto alcanzó **$1.216.139,50**, equivalente a un **margen bruto del 62,74 %**.
- El valor medio del pedido (AOV) fue de **$59,99**.
- Se vendieron **40.025 unidades**.

## 2. Rendimiento por producto

- **The Original Mr. Fuzzy** fue el producto con mayor peso en el negocio, generando **$1.211.057,74**, equivalente al **62,47 % del revenue total de productos**.
- The Forever Love Bear ocupó la segunda posición, con un **17,94 % del revenue**.
- The Birthday Sugar Panda y The Hudson River Mini Bear representaron el **11,83 %** y el **7,76 %**, respectivamente.
- El **23,87 % de los pedidos contenía dos artículos**, lo que demuestra la existencia de compras multiproducto.

## 3. Usuarios nuevos vs. recurrentes

- Las sesiones nuevas tuvieron una tasa de conversión del **6,64 %**.
- Las sesiones recurrentes alcanzaron una conversión del **7,83 %**.
- Por tanto, los visitantes recurrentes mostraron una mayor propensión a realizar una compra.
- El AOV también fue ligeramente superior en las sesiones recurrentes: **$60,54 frente a $59,86**.

## 4. Rendimiento por dispositivo

- Desktop generó **327.027 sesiones** y obtuvo una tasa de conversión del **8,50 %**.
- Mobile generó **145.844 sesiones**, pero convirtió únicamente al **3,09 %**.
- El revenue por sesión fue de **$5,09 en desktop frente a $1,87 en mobile**.
- Esta diferencia indica una posible oportunidad de optimización de la experiencia de compra en dispositivos móviles.

## 5. Rendimiento de marketing

- **gsearch** fue la principal fuente de tráfico, con **316.035 sesiones**, y generó aproximadamente **$1,28 millones de revenue**.
- El tráfico direct / organic obtuvo una tasa de conversión del **7,34 %**.
- bsearch convirtió al **7,19 %**.
- socialbook presentó un rendimiento considerablemente inferior, con una conversión del **3,21 %**.

### Rendimiento por campaña

- **gsearch / nonbrand** fue la campaña con mayor volumen, generando más de **$1,12 millones de revenue**.
- **bsearch / brand** consiguió la mayor tasa de conversión entre las campañas analizadas: **8,86 %**.
- **socialbook / pilot** presentó el peor rendimiento, con una conversión de apenas **1,08 %**.

## 6. Funnel de conversión

El funnel observado fue:

- **261.231** sesiones llegaron al listado de productos.
- **210.214** visitaron la página de un producto.
- **94.953** llegaron al carrito.
- **64.484** llegaron al proceso de envío.
- **52.058** alcanzaron la etapa de facturación.
- **32.313** completaron un pedido.

Tasas de conversión entre etapas:

- Products → Product page: **80,47 %**
- Product page → Cart: **45,17 %**
- Cart → Shipping: **67,91 %**
- Shipping → Billing: **80,73 %**
- Billing → Order: **62,07 %**

La mayor pérdida observada dentro del funnel se produce entre la **página de producto y el carrito**, donde solo el **45,17 %** de las sesiones continúa hacia la siguiente etapa.

## 7. Análisis de devoluciones

- Se registraron **1.731 artículos reembolsados**.
- El importe total reembolsado fue de **$85.338,69**.
- La tasa global de devolución por artículo fue del **4,32 %**.
- **The Birthday Sugar Panda** presentó la mayor tasa de devolución, con un **6,04 %**.
- **The Hudson River Mini Bear** obtuvo la menor tasa, con un **1,28 %**.

## 8. Evolución del revenue

- El negocio presenta un crecimiento considerable a lo largo del periodo analizado.
- Se observa una aceleración del revenue durante los últimos meses de 2013 y 2014.
- Noviembre y diciembre presentan un rendimiento especialmente elevado, lo que sugiere un posible componente estacional.
- **Diciembre de 2014 alcanzó aproximadamente $144,8K de revenue**, siendo el mes con mayor facturación del dataset.
- Marzo de 2015 no debe compararse directamente con meses completos anteriores, ya que los datos finalizan el **19 de marzo de 2015**.

## 9. Recomendaciones de negocio

A partir de los resultados obtenidos:

1. **Investigar la baja conversión en mobile**, dada la importante diferencia frente a desktop.
2. **Optimizar la transición entre página de producto y carrito**, principal punto de abandono detectado en el funnel.
3. **Revisar la campaña socialbook / pilot**, debido a su baja tasa de conversión.
4. **Investigar la elevada tasa de devolución de The Birthday Sugar Panda**, evaluando posibles problemas de producto, expectativas del cliente o fulfillment.
5. **Potenciar la retención y recurrencia**, ya que las sesiones recurrentes presentan una mayor tasa de conversión.
6. **Considerar la estacionalidad en la planificación comercial**, especialmente ante el fuerte rendimiento observado al final del año.