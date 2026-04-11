--¿Qué productos no aparecen todavía en registros de compra?

SELECT p.nombre_producto
FROM productos p
LEFT JOIN detalle_compra_proveedor dc ON p.id_producto = dc.producto_id
WHERE dc.id_detalle IS NULL;