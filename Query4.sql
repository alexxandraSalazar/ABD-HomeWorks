--¿Qué empleado ha registrado más compras?

SELECT TOP 1 e.nombre, e.apellido, COUNT(c.id_compra) AS registros_compra
FROM empleados e
JOIN compra_proveedor c ON e.id_empleado = c.empleado_id
GROUP BY e.nombre, e.apellido
ORDER BY registros_compra DESC;