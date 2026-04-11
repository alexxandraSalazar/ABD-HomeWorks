--¿Qué productos han tenido más entradas de inventario?

SELECT p.nombre_producto, SUM(m.cantidad) AS total_entradas
FROM productos p
JOIN movimientos_inventario m ON p.id_producto = m.producto_id
WHERE m.cantidad > 0
GROUP BY p.nombre_producto
ORDER BY total_entradas DESC;