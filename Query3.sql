
--¿Qué productos han sido comprados en mayor cantidad?

SELECT p.nombre_producto, SUM(dc.cantidad) AS cantidad_total
FROM productos p
INNER JOIN detalle_compra_proveedor dc ON p.id_producto = dc.producto_id
GROUP BY p.nombre_producto
HAVING SUM(dc.cantidad) > 2 -- Filtra solo los que tienen volumen considerable
ORDER BY cantidad_total DESC;