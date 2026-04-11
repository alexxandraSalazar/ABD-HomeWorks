--¿Qué empleado ha procesado más devoluciones?

SELECT TOP 1 e.nombre, e.apellido, COUNT(dv.id_devolucion) AS devoluciones_procesadas
FROM empleados e
JOIN devolucion_venta dv ON e.id_empleado = dv.empleado_id
GROUP BY e.nombre, e.apellido
ORDER BY devoluciones_procesadas DESC;

