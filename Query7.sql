--¿Qué productos han sido devueltos con mayor frecuencia?

SELECT p.nombre_producto, COUNT(dd.id_detalle) AS veces_devuelto, SUM(dd.cantidad) AS cantidad_total
FROM productos p
JOIN detalle_devolucion dd ON p.id_producto = dd.producto_id
GROUP BY p.nombre_producto
ORDER BY veces_devuelto DESC;

