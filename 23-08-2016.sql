DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_png_conversaciones_usuario$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_png_conversaciones_usuario`(IN `idusuario` INT)
    READS SQL DATA
select a.id, max(c.fecha) as fecha, ba.id as id1, ba.nombres as nombres1, ba.apellidos as apellidos1, ba.usuario as usuario1, bb.usuario as usuario2, bb.id as id2, bb.nombres as nombres2, bb.apellidos as apellidos2 from png_conversacion a 
inner join png_usuario ba on a.usuario1 = ba.id 
inner join png_usuario bb on a.usuario2 = bb.id
join png_mensaje c on c.id_conversacion = a.id
where a.usuario1 = idusuario
group by a.id 
union
select a.id, max(c.fecha) as fecha, ba.id as id1, ba.nombres as nombres1, ba.apellidos as apellidos1, ba.usuario as usuario1, bb.usuario as usuario2, bb.id as id2,  bb.nombres as nombres2, bb.apellidos as apellidos2 from png_conversacion a 
inner join png_usuario ba on a.usuario1 = ba.id 
inner join png_usuario bb on a.usuario2 = bb.id
join png_mensaje c on c.id_conversacion = a.id
where a.usuario2 = idusuario
group by a.id$$
DELIMITER ;



DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_png_conversacion_id$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_png_conversacion_id`(IN `usuario1` INT, IN `usuario2` INT)
    NO SQL
SELECT DISTINCT c.id 
FROM png_mensaje r
JOIN png_conversacion c ON r.id_conversacion = c.id
WHERE c.usuario1 = usuario1 and c.usuario2 = usuario2
union 
SELECT DISTINCT c.id 
FROM png_mensaje r
JOIN png_conversacion c ON r.id_conversacion = c.id
WHERE c.usuario1 = usuario2 and c.usuario2 = usuario1$$
DELIMITER ;
