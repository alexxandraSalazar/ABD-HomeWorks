--¿Qué ventas han tenido devoluciones asociadas?

SELECT v.id_venta, v.fecha_venta, v.total, dv.fecha_devolucion, dv.motivo
FROM ventas v
JOIN devolucion_venta dv ON v.id_venta = dv.venta_id;
