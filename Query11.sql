--¿Qué productos no presentan movimientos de inventario?

SELECT p.nombre_producto
FROM productos p
LEFT JOIN movimientos_inventario m ON p.id_producto = m.producto_id
WHERE m.id_movimiento IS NULL;

