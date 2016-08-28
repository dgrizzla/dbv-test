DELIMITER $$
DROP FUNCTION IF EXISTS `fn_ins_png_opcion`$$

CREATE FUNCTION `fn_ins_png_opcion`(`pnombre` VARCHAR(50), `pdescripcion` TEXT, `pid_tipo` INT) RETURNS INT NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
BEGIN
INSERT INTO `png_opcion`(`nombre`, `descripcion`, `id_tipo`) 
VALUES (pnombre, pdescripcion, fn_get_id_tipo_db(pid_tipo, 'png_opcion'));
return last_insert_id();
END$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_upd_png_opcion`$$
CREATE PROCEDURE `sp_upd_png_opcion`(IN `pid` INT, IN `pnombre` TEXT, IN `pdescripcion` TEXT, IN `pid_tipo` VARCHAR(50)) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
UPDATE png_opcion 
SET 
    descripcion = pdescripcion,
    nombre = pnombre,
    id_tipo = fn_get_id_tipo_db(pid_tipo, 'png_opcion')
WHERE id = pid$$
DELIMITER ;
