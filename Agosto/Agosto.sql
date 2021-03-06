DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_png_usuarios$$
CREATE PROCEDURE `sp_sel_png_usuarios`(IN `porder` VARCHAR(100), IN `poffset` INT, IN `plimit` INT) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER BEGIN

  DECLARE statement varchar(255);

  SET statement := CONCAT(
    'SELECT id, nombres, apellidos, email, foto, usuario',
    'FROM png_usuario ',
    'ORDER BY ', porder,
    ' LIMIT ', poffset, ',', plimit
  );

  PREPARE statement FROM @statement;
  EXECUTE statement;
END$$

DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_sel_png_tipo_tabla`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_png_tipo_tabla`(IN `ptabla` TEXT) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
select *
from png_tipo
where tabla = ptabla$$
DELIMITER ;

DELIMITER $$
create TABLE png_opcion(
  id INT(11) AUTO_INCREMENT,
  nombre varchar(50) not null,
  descripcion TEXT,
  id_tipo INT(11) not null,
  PRIMARY KEY (id),
  FOREIGN KEY (id_tipo) REFERENCES png_tipo(id)
)$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS `fn_ins_png_opcion`$$

CREATE FUNCTION `fn_ins_png_opcion`(`pnombre` VARCHAR(50), `pdescripcion` TEXT, `pid_tipo` INT) RETURNS INT NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
BEGIN
INSERT INTO `png_opcion`(`id`, `nombre`, `descripcion`, `id_tipo`) 
VALUES (pnombre, pdescripcion, fn_get_id_tipo_db(pid_tipo, 'png_opcion'));
return last_insert_id();
END$$
DELIMITER ;

DELIMITER $$
INSERT INTO `png_tipo` (`id`, `tabla`, `descripcion`, `id_tipo`) 
VALUES (NULL, 'png_opcion', 'Menu', '1')$$

INSERT INTO `png_opcion` (`id`, `nombre`, `descripcion`, `id_tipo`) 
VALUES (NULL, 'Administracion', 'Acceso al menu de administracion', '3')$$
DELIMITER ;


DELIMITER $$
create TABLE png_rol_opcion(
  id INT(11) AUTO_INCREMENT,
  id_rol INT(11) not null,
  id_opcion INT(11) not null,
  PRIMARY KEY (id),
  FOREIGN KEY (id_rol) REFERENCES png_tipo(id),
  FOREIGN KEY (id_opcion) REFERENCES png_opcion(id),
  UNIQUE KEY (id_rol, id_opcion)
)$$
DELIMITER ;


DELIMITER $$

DROP FUNCTION IF EXISTS `fn_ins_png_rol_opcion`$$

CREATE FUNCTION `fn_ins_png_rol_opcion`(`pid_rol` INT, `pid_opcion` INT) RETURNS INT NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
BEGIN
INSERT INTO `png_rol_opcion`(`id_rol`, `id_opcion`) 
VALUES (fn_get_id_tipo_db(pid_rol, 'png_usuario'), pid_opcion);
return last_insert_id();
END$$
DELIMITER ;


DELIMITER $$

DROP FUNCTION IF EXISTS `fn_get_id_tipo_db`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_get_id_tipo_db`(`pid_tipo` INT, `ptabla` VARCHAR(50)) RETURNS INT NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER BEGIN
DECLARE v_id int(11);
SELECT id INTO v_id FROM png_tipo
WHERE ptabla = tabla
	and pid_tipo = id_tipo;
return v_id;
END$$
DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_del_png_rol_opcion`$$
CREATE PROCEDURE `sp_del_png_rol_opcion`(IN `pid_rol_opcion` INT) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
delete from png_rol_opcion where id = pid_rol_opcion $$

DELIMITER ;



DELIMITER $$

DROP FUNCTION IF EXISTS `fn_ins_png_tipo`$$

CREATE FUNCTION `fn_ins_png_tipo`(`pnombre` VARCHAR(50), `pdescripcion` TEXT, `ptable` TEXT) RETURNS INT NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
BEGIN
INSERT INTO `png_tipo`(`nombre`, `descripcion`, `tabla`, `id_tipo`)
VALUES (pnombre, pdescripcion, ptable, fn_get_next_id_tipo(ptable));
return last_insert_id();
END$$
DELIMITER ;


DELIMITER $$
DROP FUNCTION IF EXISTS `fn_get_next_id_tipo`$$
CREATE FUNCTION `fn_get_next_id_tipo`(`ptable` VARCHAR(50)) RETURNS INT NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
BEGIN
DECLARE v_next_id int(11);
SELECT id_tipo INTO v_next_id FROM `png_tipo` 
WHERE tabla = 'png_usuario' 
ORDER BY id_tipo DESC
LIMIT 0,1;
return v_next_id + 1;
END$$

DELIMITER ;

DELIMITER $$
ALTER TABLE `png_tipo` ADD `nombre` VARCHAR(50) NOT NULL DEFAULT 'Sin nombre' AFTER `id`$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_upd_png_tipo`$$
CREATE PROCEDURE `sp_upd_png_tipo`(IN `pid` INT, IN `pnombre` TEXT, IN `pdescripcion` TEXT, IN `ptabla` VARCHAR(50)) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
UPDATE png_tipo 
SET 
	descripcion = pdescripcion,
    nombre = pnombre,
    tabla = ptabla
WHERE id = pid$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS  `sp_sel_png_usuario`$$
CREATE PROCEDURE `sp_sel_png_usuario`(IN `pid_usuario` INT) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
SELECT a.id, a.usuario, a.nombres, a.apellidos, a.sexo,
a.fecha_nac, a.fecha_crea, a.id_pais, b.nombre nombre_pais,
a.email, a.id_tipo, c.nombre nombre_tipo,
a.foto, a.preferencias, a.telefono, a.estado
FROM `png_usuario` a
JOIN `png_pais` b ON b.id = a.id_pais
JOIN `png_tipo` c ON c.id = a.id_tipo
WHERE a.id = pid_usuario$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_upd_png_usuario`$$
CREATE PROCEDURE `sp_upd_png_usuario`(
  IN `pid` INT, IN `pusuario` VARCHAR(50),
  IN `pnombres` VARCHAR(30), IN `papellidos` VARCHAR(30),
  IN `pfecha_nac` DATETIME, IN `psexo` CHAR(1),
  IN `pemail` VARCHAR(50), IN `pid_pais` INT,
  IN `pid_tipo` INT, IN `ptelefono` VARCHAR(20),
  IN `pestado` INT 
) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
UPDATE png_usuario
SET 
  usuario = pusuario,
  nombres = pnombres,
  apellidos = papellidos,
  fecha_nac = pfecha_nac,
  sexo = psexo,
  email = pemail,
  id_pais = pid_pais,
  id_tipo = pid_tipo,
  telefono = ptelefono,
  estado = pestado
WHERE id = pid$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_sel_png_rol_opcion_tipo`$$
CREATE PROCEDURE `sp_sel_png_rol_opcion_tipo`(IN `pid_rol` INT, IN `pid_tipo` INT) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER SELECT b.id id_rol, b.nombre nombre_rol, d.id_tipo id_tipo, c.nombre nombre_opcion, c.descripcion FROM `png_rol_opcion` a
JOIN png_tipo b ON b.id = a.id_rol
JOIN png_opcion c ON c.id = a.id_opcion
JOIN png_tipo d ON d.id = c.id_tipo
WHERE a.id_rol = pid_rol AND d.id_tipo = pid_tipo$$

DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_usuario_conversaciones$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_usuario_conversaciones`(IN `pidusuario` INT)
    NO SQL
SELECT m.id, m.fecha, m.mensaje, u.usuario, u.nombres, u.apellidos, co.id as id_conversacion
FROM png_mensaje m 
INNER JOIN png_usuario u ON m.usuario_emisor = u.id
JOIN png_conversacion co ON co.id = m.id_conversacion
WHERE ( m.id in 
        ( SELECT Max(m.id)
          FROM png_usuario_conversacion uc INNER JOIN png_mensaje m 
            ON uc.id_conversacion = m.id_conversacion
          WHERE uc.id_usuario = pidusuario
          GROUP BY uc.id_conversacion
        )
      )$$
DELIMITER ;      

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_busqueda_usuario_chat$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_busqueda_usuario_chat`(IN `busqueda` VARCHAR(100))
    READS SQL DATA
BEGIN DECLARE userlike VARCHAR(100) ;

SET userlike = CONCAT('%',busqueda,'%') ;
SELECT id, usuario, nombres, apellidos, foto
FROM png_usuario 
WHERE usuario LIKE userlike
OR CONCAT( nombres, apellidos ) LIKE userlike;

END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_png_mensajes_conversacion$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_png_mensajes_conversacion`(IN `pidconversacion` INT)
    NO SQL
SELECT U.usuario, R.mensaje, DATE_FORMAT(R.fecha,'%d/%m/%Y') as fecha, U.id as id_usuario
FROM png_usuario U, png_mensaje R 
WHERE R.id_usuario = U.id AND R.id_conversacion= pidconversacion
ORDER BY R.id ASC$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_png_conversacion_id$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_png_conversacion_id`(IN `usuario1` INT, IN `usuario2` INT)
    NO SQL
SELECT DISTINCT c.id 
FROM png_mensaje r
JOIN png_conversacion c ON r.id_conversacion = c.id
WHERE c.usuario1 = usuario1 and c.usuario2 = usuario2$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_sel_png_conversaciones_usuario$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sel_png_conversaciones_usuario`(IN `idusuario` INT)
    READS SQL DATA
SELECT DISTINCT u.nombres,u.apellidos, m.mensaje, m.fecha,c.id as id_conversacion,u.usuario, u.id as id_usuario
FROM png_conversacion c
JOIN png_usuario u ON c.usuario2 = u.id
right JOIN png_mensaje m ON m.id_usuario = idusuario or u.id
WHERE (m.id in (select max(me.id) from png_conversacion c
     join png_mensaje me on me.id_conversacion = c.id 
     where c.usuario1 = idusuario and c.usuario2 = u.id
     group by c.id  ))
AND  (c.usuario1 = idusuario and c.usuario2 = u.id)
OR (c.usuario2 = idusuario and c.usuario1 = u.id)
group by u.id, m.id_usuario
union
SELECT DISTINCT u.nombres,u.apellidos, m.mensaje, m.fecha,c.id as id_conversacion,u.usuario, u.id as id_usuario
FROM png_conversacion c
JOIN png_usuario u ON c.usuario2 = u.id
left JOIN png_mensaje m ON m.id_usuario = idusuario or u.id
WHERE (m.id in (select max(me.id) from png_conversacion c
     join png_mensaje me on me.id_conversacion = c.id 
     where c.usuario1 = idusuario and c.usuario2 = u.id
     group by c.id  ))
AND  (c.usuario1 = idusuario and c.usuario2 = u.id)
OR (c.usuario2 = idusuario and c.usuario1 = u.id)
group by u.id, m.id_usuario$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS `fn_ins_png_conversacion`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_ins_png_conversacion`(`pusuario1` INT, `pusuario2` INT) RETURNS int(11)
    NO SQL
BEGIN
INSERT INTO `png_conversacion`(`usuario1`, `usuario2`)
VALUES (pusuario1,pusuario2);
return last_insert_id();
END$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ins_png_mensaje$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ins_png_mensaje`(IN `pmensaje` TEXT, IN `idemisor` INT, IN `idconversacion` INT)
    NO SQL
INSERT INTO `png_mensaje`(`mensaje`, `id_usuario`,
                                         `id_conversacion`)
VALUES (pmensaje, idemisor,idconversacion)$$
DELIMITER ;

DELIMITER $$
CREATE TABLE `png_conversacion` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `usuario1` int(11) NOT NULL,
 `usuario2` int(11) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1$$
DELIMITER ;


DELIMITER $$
CREATE TABLE `png_mensaje` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `mensaje` text NOT NULL,
 `id_usuario` int(11) NOT NULL,
 `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `id_conversacion` int(11) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1$$
DELIMITER ;
