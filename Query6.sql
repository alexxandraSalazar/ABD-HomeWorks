--¿Qué productos han tenido más salidas de inventario?

SELECT p.nombre_producto, ABS(SUM(m.cantidad)) AS total_salidas
FROM productos p
JOIN movimientos_inventario m ON p.id_producto = m.producto_id
WHERE m.cantidad < 0
GROUP BY p.nombre_producto
ORDER BY total_salidas DESC;