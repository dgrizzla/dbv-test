DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_png_usuario_busqueda$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_png_usuario_busqueda`(IN `pidusuario` INT(11))
    NO SQL
SELECT bu.id, bu.producto, bu.descripcion, bu.id_cat, bu.id_subcat, bu.id_ssubcat, bu.id_estado, bu.id_img_destacada, bu.precio_del, bu.precio_al,DATE_FORMAT(bu.fecha_ingreso,'%d/%m/%Y') as fecha_ingreso, bu.fecha_limite,  dep.nombre as nombre_departamento, ui.url_img, ui.orden, bu.id_gps, cat.nombre as nombre_categoria
FROM png_usuario_busqueda bu
LEFT JOIN png_usuario_imagen ui ON bu.id = ui.id_busqueda
LEFT JOIN png_subcat_articulo cat ON cat.id = bu.id_subcat
LEFT JOIN png_cat_articulo dep ON dep.id = bu.id_cat
LEFT JOIN png_ssubcat_articulo subcat ON subcat.id = bu.id_ssubcat
WHERE id_usuario = pidusuario
AND ui.orden = 1
ORDER BY bu.fecha_ingreso DESC$$
DELIMITER ;
