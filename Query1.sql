--¿Qué proveedor está asociado con la mayor cantidad de compras?

SELECT TOP 1 p.nombre_proveedor, COUNT(c.id_compra) AS total_compras
FROM proveedores p
JOIN compra_proveedor c ON p.id_proveedor = c.proveedor_id
GROUP BY p.nombre_proveedor
ORDER BY total_compras DESC;