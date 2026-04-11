

--¿Qué proveedor representa el mayor monto acumulado en compras?

SELECT TOP 1 p.nombre_proveedor, SUM(dc.subtotal) AS monto_total
FROM proveedores p
JOIN compra_proveedor c ON p.id_proveedor = c.proveedor_id
JOIN detalle_compra_proveedor dc ON c.id_compra = dc.compra_id
GROUP BY p.nombre_proveedor
ORDER BY monto_total DESC;
