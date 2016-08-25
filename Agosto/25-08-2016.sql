
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_count_usuarios_existentes$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_count_usuarios_existentes`()
    NO SQL
SELECT COUNT(*) as numUsuarios from png_usuario$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_count_conversaciones_usuario$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_count_conversaciones_usuario`(IN `idusuario` INT)
    NO SQL
SELECT COUNT(*) as numConversaciones FROM (select a.id, max(c.fecha) as fecha, ba.id as id1, ba.nombres as nombres1, ba.apellidos as apellidos1, ba.usuario as usuario1, bb.usuario as usuario2, bb.id as id2, bb.nombres as nombres2, bb.apellidos as apellidos2 from png_conversacion a 
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
group by a.id) a$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_png_conversaciones_usuario$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_png_conversaciones_usuario`(IN `idusuario` INT)
    READS SQL DATA
select a.id, DATE_FORMAT(max(c.fecha),'%d-%m-%Y') as fecha, ba.id as id1, ba.nombres as nombres1, ba.apellidos as apellidos1, ba.usuario as usuario1, bb.usuario as usuario2, bb.id as id2, bb.nombres as nombres2, bb.apellidos as apellidos2 from png_conversacion a 
inner join png_usuario ba on a.usuario1 = ba.id 
inner join png_usuario bb on a.usuario2 = bb.id
join png_mensaje c on c.id_conversacion = a.id
where a.usuario1 = idusuario
group by a.id 
union
select a.id, DATE_FORMAT(max(c.fecha),'%d-%m-%Y') as fecha, ba.id as id1, ba.nombres as nombres1, ba.apellidos as apellidos1, ba.usuario as usuario1, bb.usuario as usuario2, bb.id as id2,  bb.nombres as nombres2, bb.apellidos as apellidos2 from png_conversacion a 
inner join png_usuario ba on a.usuario1 = ba.id 
inner join png_usuario bb on a.usuario2 = bb.id
join png_mensaje c on c.id_conversacion = a.id
where a.usuario2 = idusuario
group by a.id$$
DELIMITER ;
