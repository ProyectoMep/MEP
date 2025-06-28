-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-06-2025 a las 23:54:07
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `colegios`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `agendar_cita` (IN `fecha` DATE, IN `hora` TIME, IN `nombre_agenda` VARCHAR(100), IN `correo_agenda` VARCHAR(100), IN `telefono_agenda` VARCHAR(20), IN `cantidad` INT, IN `colegio` BIGINT, IN `sede` INT, IN `estado` VARCHAR(30))   BEGIN
    -- Verificar si ya existe una cita en esa fecha, hora y sede
    IF EXISTS (
        SELECT 1 FROM citas
        WHERE fecha_cita = fecha AND hora_cita = hora AND id_sede = sede
    ) THEN
        -- Lanzar error personalizado
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe una cita agendada en esta fecha, hora y sede.';
    ELSE
        -- Insertar nueva cita
        INSERT INTO citas (
            fecha_cita, hora_cita, nombre_agenda, correo_agenda, telefono_agenda,
            cantidad_citas, id_colegio, id_sede, estado
        )
        VALUES (
            fecha, hora, nombre_agenda, correo_agenda, telefono_agenda,
            cantidad, colegio, sede, estado
        );
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reducir_cupo` (IN `p_id_sede` INT, IN `p_id_grado` INT, IN `cantidad` INT)   BEGIN
    DECLARE cupos_disponibles INT;

    -- Calcular cupos disponibles actuales
    SELECT cupos_totales - cupos_ocupados
    INTO cupos_disponibles
    FROM cupos
    WHERE id_sede = p_id_sede AND id_grado = p_id_grado;

    -- Verificar si hay suficientes cupos
    IF cupos_disponibles >= cantidad THEN
        -- Reducir cupos disponibles (incrementar ocupados)
        UPDATE cupos
        SET cupos_ocupados = cupos_ocupados + cantidad
        WHERE id_sede = p_id_sede AND id_grado = p_id_grado;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficientes cupos disponibles';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

CREATE TABLE `citas` (
  `id_cita` int(11) NOT NULL,
  `fecha_cita` date NOT NULL,
  `hora_cita` time NOT NULL,
  `usuario_agenda` varchar(100) NOT NULL,
  `correo_agenda` varchar(150) NOT NULL,
  `estado_cita` varchar(50) NOT NULL,
  `id_institucion` int(11) NOT NULL,
  `nombre_institucion` varchar(150) NOT NULL,
  `id_sede` int(11) NOT NULL,
  `direccion_sede` varchar(200) NOT NULL,
  `documento_usuario` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `citas`
--

INSERT INTO `citas` (`id_cita`, `fecha_cita`, `hora_cita`, `usuario_agenda`, `correo_agenda`, `estado_cita`, `id_institucion`, `nombre_institucion`, `id_sede`, `direccion_sede`, `documento_usuario`) VALUES
(51, '2025-07-13', '16:00:00', 'Andrés Castro', 'andrés.castro@gmail.com', 'Reprogramada', 2147483647, 'COLEGIO ANDRES BELLO', 16, 'Calle 100 # 89-24', '10027890'),
(52, '2025-07-22', '13:30:00', 'Daniela Moreno', 'daniela.moreno@gmail.com', 'Confirmada', 2147483647, 'COLEGIO LICEO FEMENINO DE CUNDINAMARCA MERCEDES NARIÑO', 16, 'Calle 100 # 89-24', '10032345'),
(53, '2025-07-01', '13:00:00', 'Andrés Castro', 'andrés.castro@gmail.com', 'Cancelada', 2147483647, 'COLEGIO ATANASIO GIRARDOT (IED)', 16, 'Calle 100 # 89-24', '10027890'),
(54, '2025-07-03', '16:00:00', 'Daniela Moreno', 'daniela.moreno@gmail.com', 'Confirmada', 2147483647, 'COLEGIO ANDRES BELLO', 18, 'Carrera 30 # 45-67', '10032345'),
(55, '2025-07-28', '15:00:00', 'Carlos Ramírez', 'carlos.ramírez@gmail.com', 'Cancelada', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 15, 'Carrera 9 # 94A-24', '10007890'),
(56, '2025-07-19', '09:00:00', 'David Rojas', 'david.rojas@gmail.com', 'Pendiente', 2147483647, 'COLEGIO LICEO FEMENINO DE CUNDINAMARCA MERCEDES NARIÑO', 18, 'Carrera 30 # 45-67', '10021234'),
(57, '2025-07-14', '11:30:00', 'Camila López', 'camila.lópez@gmail.com', 'Reprogramada', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 13, 'Calle 72 # 10-34', '10018901'),
(58, '2025-07-17', '09:00:00', 'Carlos Ramírez', 'carlos.ramírez@gmail.com', 'Pendiente', 2147483647, 'COLEGIO ATANASIO GIRARDOT (IED)', 13, 'Calle 72 # 10-34', '10007890'),
(59, '2025-07-15', '11:30:00', 'Pedro García', 'pedro.garcía@gmail.com', 'Pendiente', 2147483647, 'COLEGIO LICEO FEMENINO DE CUNDINAMARCA MERCEDES NARIÑO', 18, 'Carrera 30 # 45-67', '10035678'),
(60, '2025-07-21', '08:00:00', 'Luis Torres', 'luis.torres@gmail.com', 'Pendiente', 2147483647, 'COLEGIO ATANASIO GIRARDOT (IED)', 15, 'Carrera 9 # 94A-24', '10015678'),
(61, '2025-07-12', '11:30:00', 'Ana Martínez', 'ana.martínez@gmail.com', 'Reprogramada', 2147483647, 'COLEGIO LICEO FEMENINO DE CUNDINAMARCA MERCEDES NARIÑO', 15, 'Carrera 9 # 94A-24', '10012345'),
(62, '2025-07-11', '10:00:00', 'Pedro García', 'pedro.garcía@gmail.com', 'Pendiente', 2147483647, 'COLEGIO ATANASIO GIRARDOT (IED)', 15, 'Carrera 9 # 94A-24', '10035678'),
(63, '2025-07-04', '13:30:00', 'Pedro García', 'pedro.garcía@gmail.com', 'Pendiente', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 15, 'Carrera 9 # 94A-24', '10035678'),
(64, '2025-07-06', '08:30:00', 'Laura Gómez', 'laura.gómez@gmail.com', 'Confirmada', 2147483647, 'COLEGIO LICEO FEMENINO DE CUNDINAMARCA MERCEDES NARIÑO', 18, 'Carrera 30 # 45-67', '10004567'),
(65, '2025-07-27', '09:00:00', 'Camila López', 'camila.lópez@gmail.com', 'Reprogramada', 2147483647, 'COLEGIO ANDRES BELLO', 15, 'Carrera 9 # 94A-24', '10018901'),
(66, '2025-07-10', '14:00:00', 'Juan Pérez', 'juan.pérez@gmail.com', 'Pendiente', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 16, 'Calle 100 # 89-24', '10001234'),
(67, '2025-07-24', '11:30:00', 'Luis Torres', 'luis.torres@gmail.com', 'Reprogramada', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 15, 'Carrera 9 # 94A-24', '10015678'),
(68, '2025-07-07', '15:00:00', 'Juan Pérez', 'juan.pérez@gmail.com', 'Cancelada', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 13, 'Calle 72 # 10-34', '10001234'),
(69, '2025-07-20', '09:30:00', 'Carlos Ramírez', 'carlos.ramírez@gmail.com', 'Confirmada', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 16, 'Calle 100 # 89-24', '10007890'),
(70, '2025-07-08', '08:00:00', 'Andrés Castro', 'andrés.castro@gmail.com', 'Confirmada', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 16, 'Calle 100 # 89-24', '10027890'),
(71, '2025-07-16', '10:30:00', 'María Hernández', 'maría.hernández@gmail.com', 'Confirmada', 2147483647, 'COLEGIO LICEO FEMENINO DE CUNDINAMARCA MERCEDES NARIÑO', 18, 'Carrera 30 # 45-67', '10024567'),
(72, '2025-07-26', '08:30:00', 'Ana Martínez', 'ana.martínez@gmail.com', 'Confirmada', 2147483647, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 13, 'Calle 72 # 10-34', '10012345'),
(73, '2025-07-23', '10:00:00', 'Laura Gómez', 'laura.gómez@gmail.com', 'Cancelada', 2147483647, 'COLEGIO ATANASIO GIRARDOT (IED)', 13, 'Calle 72 # 10-34', '10004567'),
(74, '2025-07-18', '13:00:00', 'David Rojas', 'david.rojas@gmail.com', 'Pendiente', 2147483647, 'COLEGIO LICEO FEMENINO DE CUNDINAMARCA MERCEDES NARIÑO', 18, 'Carrera 30 # 45-67', '10021234'),
(75, '2025-07-09', '14:00:00', 'Pedro García', 'pedro.garcía@gmail.com', 'Pendiente', 2147483647, 'COLEGIO ANDRES BELLO', 15, 'Carrera 9 # 94A-24', '10035678');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cupos`
--

CREATE TABLE `cupos` (
  `id_cupo` int(11) NOT NULL,
  `id_sede` bigint(20) UNSIGNED DEFAULT NULL,
  `id_grado` bigint(20) UNSIGNED DEFAULT NULL,
  `cupos_totales` int(11) NOT NULL,
  `cupos_ocupados` int(11) NOT NULL DEFAULT 0,
  `cupos_disponibles` int(11) GENERATED ALWAYS AS (`cupos_totales` - `cupos_ocupados`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cupos`
--

INSERT INTO `cupos` (`id_cupo`, `id_sede`, `id_grado`, `cupos_totales`, `cupos_ocupados`) VALUES
(1, 1, 1, 40, 40),
(2, 1, 2, 36, 36),
(3, 1, 3, 30, 29),
(4, 1, 4, 25, 14),
(5, 1, 5, 38, 21),
(6, 2, 1, 30, 1),
(7, 2, 2, 25, 6),
(8, 2, 3, 20, 13),
(9, 2, 4, 40, 29),
(10, 2, 5, 37, 16),
(11, 3, 1, 37, 33),
(12, 3, 2, 39, 29),
(13, 3, 3, 27, 19),
(14, 3, 4, 22, 2),
(15, 3, 5, 33, 21),
(16, 4, 1, 38, 29),
(17, 4, 2, 22, 4),
(18, 4, 3, 28, 5),
(19, 4, 4, 23, 23),
(20, 4, 5, 39, 13),
(21, 5, 1, 39, 2),
(22, 5, 2, 27, 13),
(23, 5, 3, 23, 0),
(24, 5, 4, 29, 18),
(25, 5, 5, 21, 1),
(26, 6, 1, 20, 2),
(27, 6, 2, 23, 14),
(28, 6, 3, 39, 4),
(29, 6, 4, 27, 5),
(30, 6, 5, 39, 6),
(31, 7, 1, 27, 13),
(32, 7, 2, 24, 9),
(33, 7, 3, 38, 13),
(34, 7, 4, 23, 8),
(35, 7, 5, 33, 1),
(36, 8, 1, 35, 6),
(37, 8, 2, 31, 8),
(38, 8, 3, 27, 7),
(39, 8, 4, 30, 10),
(40, 8, 5, 33, 9),
(41, 9, 1, 36, 24),
(42, 9, 2, 35, 29),
(43, 9, 3, 30, 2),
(44, 9, 4, 28, 3),
(45, 9, 5, 39, 20),
(46, 10, 1, 30, 1),
(47, 10, 2, 39, 35),
(48, 10, 3, 37, 11),
(49, 10, 4, 39, 35),
(50, 10, 5, 32, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos`
--

CREATE TABLE `eventos` (
  `id_evento` bigint(20) UNSIGNED NOT NULL,
  `nombre_evento` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_evento` date NOT NULL,
  `hora_evento` time NOT NULL,
  `id_colegio` bigint(20) DEFAULT NULL,
  `id_sede` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `eventos`
--

INSERT INTO `eventos` (`id_evento`, `nombre_evento`, `descripcion`, `fecha_evento`, `hora_evento`, `id_colegio`, `id_sede`) VALUES
(1, 'Día de la independencia', 'Celebración patriótica con actos cívicos y culturales.', '2025-05-06', '11:00:00', 111001011053, NULL),
(2, 'Día de la independencia', 'Celebración patriótica con actos cívicos y culturales.', '2025-05-11', '12:30:00', 111001086720, NULL),
(3, 'Día del niño', 'Actividades recreativas y culturales para los estudiantes.', '2025-04-12', '12:30:00', 111001035521, NULL),
(4, 'Día del hombre', 'Jornada de reflexión y actividades para el día del hombre.', '2025-05-04', '12:30:00', 111001011053, NULL),
(5, 'Día de la mujer', 'Homenaje y actividades para conmemorar a la mujer.', '2025-06-03', '13:30:00', 111265000408, NULL),
(6, 'Día del niño', 'Actividades recreativas y culturales para los estudiantes.', '2025-05-21', '10:00:00', NULL, 22),
(7, 'Día de la independencia', 'Celebración patriótica con actos cívicos y culturales.', '2025-06-03', '12:30:00', 111001011053, NULL),
(8, 'Entrega de calificaciones', 'Reunión con acudientes para entrega de boletines.', '2025-04-11', '08:30:00', NULL, 24),
(9, 'Día de la mujer', 'Homenaje y actividades para conmemorar a la mujer.', '2025-04-11', '12:00:00', 111001104388, NULL),
(10, 'Comparsa', 'Desfile artístico con participación de los estudiantes.', '2025-05-17', '13:30:00', 111001107069, NULL),
(11, 'Día de la mujer', 'Homenaje y actividades para conmemorar a la mujer.', '2025-05-21', '10:00:00', 111001104388, NULL),
(12, 'Día del hombre', 'Jornada de reflexión y actividades para el día del hombre.', '2025-04-18', '12:00:00', NULL, 10),
(13, 'Comparsa', 'Desfile artístico con participación de los estudiantes.', '2025-05-28', '13:30:00', 111001107859, NULL),
(14, 'Día del hombre', 'Jornada de reflexión y actividades para el día del hombre.', '2025-04-27', '11:00:00', 111001107077, NULL),
(15, 'Comparsa', 'Desfile artístico con participación de los estudiantes.', '2025-04-21', '10:30:00', 111001086720, NULL),
(16, 'Día de la mujer', 'Homenaje y actividades para conmemorar a la mujer.', '2025-04-15', '11:00:00', 111265000408, NULL),
(17, 'Día del hombre', 'Jornada de reflexión y actividades para el día del hombre.', '2025-05-24', '10:00:00', NULL, 8),
(18, 'Día de la independencia', 'Celebración patriótica con actos cívicos y culturales.', '2025-05-20', '12:00:00', 111001041611, NULL),
(19, 'Día del niño', 'Actividades recreativas y culturales para los estudiantes.', '2025-05-07', '14:30:00', NULL, 7),
(20, 'Día de la independencia', 'Celebración patriótica con actos cívicos y culturales.', '2025-04-10', '12:00:00', 111001011274, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grados`
--

CREATE TABLE `grados` (
  `id_grado` bigint(20) UNSIGNED NOT NULL,
  `id_sede` bigint(20) UNSIGNED DEFAULT NULL,
  `nombre_grado` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `grados`
--

INSERT INTO `grados` (`id_grado`, `id_sede`, `nombre_grado`) VALUES
(1, 1, 'Sexto'),
(2, 1, 'Séptimo'),
(3, 1, 'Octavo'),
(4, 1, 'Noveno'),
(5, 1, 'Décimo'),
(6, 1, 'Once'),
(7, 2, 'Sexto'),
(8, 2, 'Séptimo'),
(9, 2, 'Octavo'),
(10, 2, 'Noveno'),
(11, 2, 'Décimo'),
(12, 2, 'Once'),
(13, 3, 'Primero'),
(14, 3, 'Segundo'),
(15, 3, 'Tercero'),
(16, 3, 'Cuarto'),
(17, 3, 'Quinto'),
(18, 4, 'Sexto'),
(19, 4, 'Séptimo'),
(20, 4, 'Octavo'),
(21, 4, 'Noveno'),
(22, 4, 'Décimo'),
(23, 4, 'Once'),
(24, 5, 'Sexto'),
(25, 5, 'Séptimo'),
(26, 5, 'Octavo'),
(27, 5, 'Noveno'),
(28, 5, 'Décimo'),
(29, 5, 'Once'),
(30, 6, 'Sexto'),
(31, 6, 'Séptimo'),
(32, 6, 'Octavo'),
(33, 6, 'Noveno'),
(34, 6, 'Décimo'),
(35, 6, 'Once'),
(36, 7, 'Sexto'),
(37, 7, 'Séptimo'),
(38, 7, 'Octavo'),
(39, 7, 'Noveno'),
(40, 7, 'Décimo'),
(41, 7, 'Once'),
(42, 8, 'Sexto'),
(43, 8, 'Séptimo'),
(44, 8, 'Octavo'),
(45, 8, 'Noveno'),
(46, 8, 'Décimo'),
(47, 8, 'Once'),
(48, 9, 'Sexto'),
(49, 9, 'Séptimo'),
(50, 9, 'Octavo'),
(51, 9, 'Noveno'),
(52, 9, 'Décimo'),
(53, 9, 'Once'),
(54, 10, 'Primero'),
(55, 10, 'Segundo'),
(56, 10, 'Tercero'),
(57, 10, 'Cuarto'),
(58, 10, 'Quinto'),
(59, 11, 'Sexto'),
(60, 11, 'Séptimo'),
(61, 11, 'Octavo'),
(62, 11, 'Noveno'),
(63, 11, 'Décimo'),
(64, 11, 'Once'),
(65, 12, 'Sexto'),
(66, 12, 'Séptimo'),
(67, 12, 'Octavo'),
(68, 12, 'Noveno'),
(69, 12, 'Décimo'),
(70, 12, 'Once'),
(71, 13, 'Sexto'),
(72, 13, 'Séptimo'),
(73, 13, 'Octavo'),
(74, 13, 'Noveno'),
(75, 13, 'Décimo'),
(76, 13, 'Once'),
(77, 14, 'Sexto'),
(78, 14, 'Séptimo'),
(79, 14, 'Octavo'),
(80, 14, 'Noveno'),
(81, 14, 'Décimo'),
(82, 14, 'Once'),
(83, 15, 'Primero'),
(84, 15, 'Segundo'),
(85, 15, 'Tercero'),
(86, 15, 'Cuarto'),
(87, 15, 'Quinto'),
(88, 16, 'Sexto'),
(89, 16, 'Séptimo'),
(90, 16, 'Octavo'),
(91, 16, 'Noveno'),
(92, 16, 'Décimo'),
(93, 16, 'Once'),
(94, 17, 'Sexto'),
(95, 17, 'Séptimo'),
(96, 17, 'Octavo'),
(97, 17, 'Noveno'),
(98, 17, 'Décimo'),
(99, 17, 'Once'),
(100, 18, 'Primero'),
(101, 18, 'Segundo'),
(102, 18, 'Tercero'),
(103, 18, 'Cuarto'),
(104, 18, 'Quinto'),
(105, 19, 'Sexto'),
(106, 19, 'Séptimo'),
(107, 19, 'Octavo'),
(108, 19, 'Noveno'),
(109, 19, 'Décimo'),
(110, 19, 'Once'),
(111, 20, 'Sexto'),
(112, 20, 'Séptimo'),
(113, 20, 'Octavo'),
(114, 20, 'Noveno'),
(115, 20, 'Décimo'),
(116, 20, 'Once'),
(117, 21, 'Sexto'),
(118, 21, 'Séptimo'),
(119, 21, 'Octavo'),
(120, 21, 'Noveno'),
(121, 21, 'Décimo'),
(122, 21, 'Once'),
(123, 22, 'Sexto'),
(124, 22, 'Séptimo'),
(125, 22, 'Octavo'),
(126, 22, 'Noveno'),
(127, 22, 'Décimo'),
(128, 22, 'Once'),
(129, 23, 'Sexto'),
(130, 23, 'Séptimo'),
(131, 23, 'Octavo'),
(132, 23, 'Noveno'),
(133, 23, 'Décimo'),
(134, 23, 'Once'),
(135, 24, 'Sexto'),
(136, 24, 'Séptimo'),
(137, 24, 'Octavo'),
(138, 24, 'Noveno'),
(139, 24, 'Décimo'),
(140, 24, 'Once'),
(141, 25, 'Sexto'),
(142, 25, 'Séptimo'),
(143, 25, 'Octavo'),
(144, 25, 'Noveno'),
(145, 25, 'Décimo'),
(146, 25, 'Once'),
(147, 26, 'Sexto'),
(148, 26, 'Séptimo'),
(149, 26, 'Octavo'),
(150, 26, 'Noveno'),
(151, 26, 'Décimo'),
(152, 26, 'Once'),
(153, 27, 'Sexto'),
(154, 27, 'Séptimo'),
(155, 27, 'Octavo'),
(156, 27, 'Noveno'),
(157, 27, 'Décimo'),
(158, 27, 'Once'),
(159, 28, 'Sexto'),
(160, 28, 'Séptimo'),
(161, 28, 'Octavo'),
(162, 28, 'Noveno'),
(163, 28, 'Décimo'),
(164, 28, 'Once');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `instituciones`
--

CREATE TABLE `instituciones` (
  `Id_Colegio` bigint(20) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `localidad` varchar(100) DEFAULT NULL,
  `direccion_principal` varchar(255) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `cantidad_sedes` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `instituciones`
--

INSERT INTO `instituciones` (`Id_Colegio`, `nombre`, `localidad`, `direccion_principal`, `correo`, `telefono`, `cantidad_sedes`) VALUES
(111001011053, 'COLEGIO GUILLERMO LEON VALENCIA (IED)', 'Antonio Nariño', 'KR 22 # 16 - 03 SUR', 'coldiguillermoleon15@redp.edu.co', '2782716', 3),
(111001011274, 'COLEGIO ANDRES BELLO', 'Puente Aranda', 'CALLE 39 SUR NO. 51D-19', 'colnaandresbello16@redp.edu.co', '2381508', 2),
(111001011819, 'COLEGIO LICEO FEMENINO DE CUNDINAMARCA MERCEDES NARIÑO (IED)', 'Rafael Uribe Uribe', 'AV CARACAS # 23 - 24 SUR', 'lfemeninocund@educacionbogota.edu.co', '2726302', 1),
(111001012602, 'COLEGIO ATANASIO GIRARDOT (IED)', 'Antonio Nariño', 'CL 14 SUR # 28 - 06', 'coldiatanasiogirar15@redp.edu.co', '2020984', 3),
(111001013811, 'COLEGIO SAN AGUSTIN (IED)', 'Rafael Uribe Uribe', 'Calle 50A sur 5C 40', 'cedsanagustin18@educacionbogota.edu.co', '2793580', 2),
(111001035521, 'COL NESTOR FORERO ALCALA (IED)', 'Engativá', 'KR 70C BIS # 71-33', 'coldinestorforeroa10@redp.edu.co', '2245800', 3),
(111001035572, 'COL ACACIA II (IED)', 'Ciudad Bolívar', 'CL 62 SUR # 19 B 42', 'cedacaciasii19@redp.edu.co', '7911558', 2),
(111001041611, 'COLEGIO DIANA TURBAY (IED)', 'Rafael Uribe Uribe', 'Diagonal 48 Z Sur # 4B 10', 'coldianaturbay@educacionbogota.edu.co', '3057911124', 2),
(111001086720, 'COLEGIO TECNICO JAIME PARDO LEAL (IED)', 'Antonio Nariño', 'KR 10 A # 3 - 63 SUR', 'cedjaimepardoleal15@redp.edu.co', '2461459', 1),
(111001104388, 'COL GONZALO ARANGO (IED)', 'Suba', 'CL 130 C # 97 - 71', 'colgonzaloarango@redp.edu.co', '6857674', 2),
(111001107069, 'COL VIRGINIA GUTIERREZ DE PINEDA (IED)', 'Suba', 'CL 131 B # 94 F - 31', 'colvirginiagutipined@redp.edu.co', '6836225', 1),
(111001107077, 'COL VEINTIUN ANGELES (IED)', 'Suba', 'KR 90 # 154 A - 09', 'colventiunangeles11@redp.edu.co', '6838395', 4),
(111001107859, 'COL ANTONIO GARCIA (IED)', 'Ciudad Bolívar', 'KRA 17 F # 73 A 31 SUR', 'iedantoniogarcia@redp.edu.co', '7663708', 1),
(111265000408, 'COL NIDIA QUINTERO DE TURBAY (IED)', 'Engativá', 'CLL. 75 # 90-75', 'colnanidyaquintero10@redp.edu.co', '2523450', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jornadas`
--

CREATE TABLE `jornadas` (
  `id_jornada` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `jornadas`
--

INSERT INTO `jornadas` (`id_jornada`, `nombre`) VALUES
(5, 'Fin de semana'),
(1, 'Mañana'),
(4, 'Noche'),
(2, 'Tarde'),
(3, 'Única');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_por_rol`
--

CREATE TABLE `permisos_por_rol` (
  `id` int(11) NOT NULL,
  `id_rol` int(11) DEFAULT NULL,
  `permiso` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos_por_rol`
--

INSERT INTO `permisos_por_rol` (`id`, `id_rol`, `permiso`) VALUES
(1, 1, 'CREATE'),
(2, 1, 'DROP'),
(3, 1, 'DELETE'),
(4, 1, 'INSERT'),
(5, 1, 'SELECT'),
(6, 1, 'UPDATE'),
(7, 1, 'GRANT OPTION'),
(8, 1, 'SHOW DATABASE'),
(9, 2, 'INSERT'),
(10, 2, 'SELECT'),
(11, 2, 'UPDATE'),
(12, 2, 'DELETE'),
(13, 2, 'SHOW DATABASE'),
(14, 3, 'SELECT'),
(15, 3, 'INSERT'),
(16, 3, 'SHOW DATABASE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reseñas`
--

CREATE TABLE `reseñas` (
  `id_reseña` bigint(20) UNSIGNED NOT NULL,
  `calificacion` int(11) DEFAULT NULL CHECK (`calificacion` between 1 and 5),
  `descripcion` text DEFAULT NULL,
  `id_usuario` bigint(20) DEFAULT NULL,
  `cantidad_calificaciones` int(11) DEFAULT NULL,
  `id_sede` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `nombre_rol`) VALUES
(1, 'Administrador'),
(2, 'Gestor'),
(3, 'Tutor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sedes`
--

CREATE TABLE `sedes` (
  `id_sede` bigint(20) UNSIGNED NOT NULL,
  `id_colegio` bigint(20) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sedes`
--

INSERT INTO `sedes` (`id_sede`, `id_colegio`, `nombre`, `direccion`, `telefono`, `correo`) VALUES
(1, 111001035521, 'SEDE A', 'Calle 72 # 10-34', '300000001', 'sedea.nestor@ficticio.edu.co'),
(2, 111001035521, 'SEDE B', 'Carrera 9 # 94A-24', '300000002', 'sedeb.nestor@ficticio.edu.co'),
(3, 111001035521, 'SEDE C', 'Carrera 15 # 96-67', '300000003', 'sedec.nestor@ficticio.edu.co'),
(4, 111265000408, 'SEDE A', 'Calle 19 # 4-72', '300000001', 'sedea.nidia@ficticio.edu.co'),
(5, 111001104388, 'SEDE A', 'Calle 73 # 20C-45', '300000001', 'sedea.gonzalo@ficticio.edu.co'),
(6, 111001104388, 'SEDE B', 'Transversal 93 # 64C-41', '300000002', 'sedeb.gonzalo@ficticio.edu.co'),
(7, 111001107069, 'SEDE A', 'Calle 53 # 45-10', '300000001', 'sedea.virginia@ficticio.edu.co'),
(8, 111001107077, 'SEDE A', 'Calle 116 # 9-27', '300000001', 'sedea.veintiun@ficticio.edu.co'),
(9, 111001107077, 'SEDE B', 'Avenida Suba # 123-45', '300000002', 'sedeb.veintiun@ficticio.edu.co'),
(10, 111001107077, 'SEDE C', 'Carrera 50 # 54-80', '300000003', 'sedec.veintiun@ficticio.edu.co'),
(11, 111001107077, 'SEDE D', 'Calle 53 # 45-10', '300000004', 'seded.veintiun@ficticio.edu.co'),
(12, 111001086720, 'SEDE A', 'Carrera 68 # 80-90', '300000001', 'sedea.tecnico@ficticio.edu.co'),
(13, 111001011053, 'SEDE A', 'Calle 72 # 10-34', '300000001', 'sedea.guillermo@ficticio.edu.co'),
(14, 111001011053, 'SEDE B', 'Avenida Suba # 123-45', '300000002', 'sedeb.guillermo@ficticio.edu.co'),
(15, 111001011053, 'SEDE C', 'Carrera 9 # 94A-24', '300000003', 'sedec.guillermo@ficticio.edu.co'),
(16, 111001012602, 'SEDE A', 'Calle 80 # 69-20', '300000001', 'sedea.atanasio@ficticio.edu.co'),
(17, 111001012602, 'SEDE B', 'Carrera 15 # 96-67', '300000002', 'sedeb.atanasio@ficticio.edu.co'),
(18, 111001012602, 'SEDE C', 'Carrera 30 # 45-67', '300000003', 'sedec.atanasio@ficticio.edu.co'),
(19, 111001011274, 'SEDE A', 'Carrera 9 # 94A-24', '300000001', 'sedea.andres@ficticio.edu.co'),
(20, 111001011274, 'SEDE B', 'Calle 100 # 19-54', '300000002', 'sedeb.andres@ficticio.edu.co'),
(21, 111001011819, 'SEDE A', 'Carrera 13 # 85-24', '300000001', 'sedea.liceo@ficticio.edu.co'),
(22, 111001041611, 'SEDE A', 'Carrera 50 # 54-80', '300000001', 'sedea.diana@ficticio.edu.co'),
(23, 111001041611, 'SEDE B', 'Calle 93B # 13-54', '300000002', 'sedeb.diana@ficticio.edu.co'),
(24, 111001013811, 'SEDE A', 'Avenida Suba # 123-45', '300000001', 'sedea.san@ficticio.edu.co'),
(25, 111001013811, 'SEDE B', 'Carrera 13 # 85-24', '300000002', 'sedeb.san@ficticio.edu.co'),
(26, 111001035572, 'SEDE A', 'Carrera 68 # 80-90', '300000001', 'sedea.acacia@ficticio.edu.co'),
(27, 111001035572, 'SEDE B', 'Calle 73 # 20C-45', '300000002', 'sedeb.acacia@ficticio.edu.co'),
(28, 111001107859, 'SEDE A', 'Calle 26 # 92-32', '300000001', 'sedea.antonio@ficticio.edu.co');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sede_jornada`
--

CREATE TABLE `sede_jornada` (
  `id_sede` int(11) NOT NULL,
  `id_jornada` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sede_jornada`
--

INSERT INTO `sede_jornada` (`id_sede`, `id_jornada`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(4, 2),
(4, 3),
(4, 5),
(5, 1),
(5, 5),
(6, 3),
(6, 4),
(6, 5),
(7, 1),
(7, 2),
(7, 4),
(8, 1),
(8, 3),
(8, 4),
(9, 2),
(9, 4),
(9, 5),
(10, 1),
(10, 2),
(10, 3),
(10, 4),
(10, 5),
(11, 1),
(11, 2),
(11, 3),
(12, 4),
(12, 5),
(13, 1),
(13, 2),
(13, 4),
(14, 2),
(14, 4),
(15, 1),
(15, 2),
(15, 3),
(15, 4),
(15, 5),
(16, 1),
(16, 3),
(16, 4),
(16, 5),
(17, 1),
(17, 2),
(17, 4),
(18, 1),
(18, 4),
(18, 5),
(19, 2),
(19, 3),
(20, 3),
(20, 4),
(20, 5),
(21, 2),
(21, 5),
(22, 1),
(22, 2),
(22, 3),
(22, 4),
(23, 3),
(23, 4),
(23, 5),
(24, 1),
(24, 3),
(24, 4),
(24, 5),
(25, 1),
(25, 2),
(25, 5),
(26, 1),
(26, 2),
(26, 3),
(26, 4),
(27, 1),
(27, 2),
(27, 3),
(28, 2),
(28, 3),
(28, 4),
(28, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `tipo_documento` enum('Cédula de Ciudadanía','Cédula de Extranjería','Tarjeta de Identidad','Pasaporte') NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(100) DEFAULT NULL,
  `id_rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `tipo_documento`, `numero_documento`, `nombre`, `apellido`, `telefono`, `correo`, `contrasena`, `id_rol`) VALUES
(76, 'Cédula de Ciudadanía', '10001234', 'Juan', 'Pérez', '3200000000', 'juan.perez@gmail.com', 'Clave1!', 3),
(77, 'Tarjeta de Identidad', '10004567', 'Laura', 'Gómez', '3200000001', 'laura.gómez@gmail.com', 'Clave2!', 3),
(78, 'Cédula de Ciudadanía', '10007890', 'Carlos', 'Ramírez', '3200000002', 'carlos.ramírez@gmail.com', 'Clave3!', 3),
(79, 'Cédula de Extranjería', '10012345', 'Ana', 'Martínez', '3200000003', 'ana.martínez@gmail.com', 'Clave4!', 3),
(80, 'Cédula de Ciudadanía', '10015678', 'Luis', 'Torres', '3200000004', 'luis.torres@gmail.com', 'Clave5!', 3),
(81, 'Tarjeta de Identidad', '10018901', 'Camila', 'López', '3200000005', 'camila.lópez@gmail.com', 'Clave6!', 3),
(82, 'Cédula de Ciudadanía', '10021234', 'David', 'Rojas', '3200000006', 'david.rojas@gmail.com', 'Clave7!', 3),
(83, 'Cédula de Extranjería', '10024567', 'María', 'Hernández', '3200000007', 'maría.hernández@gmail.com', 'Clave8!', 3),
(84, 'Cédula de Ciudadanía', '10027890', 'Andrés', 'Castro', '3200000008', 'andrés.castro@gmail.com', 'Clave9!', 3),
(85, 'Tarjeta de Identidad', '10032345', 'Daniela', 'Moreno', '3200000009', 'daniela.moreno@gmail.com', 'Clave10!', 3),
(86, 'Cédula de Ciudadanía', '10035678', 'Pedro', 'García', '3200000010', 'pedro.garcía@gmail.com', 'Clave11!', 3),
(87, 'Cédula de Ciudadanía', '10038901', 'Mónica', 'Cárdenas', '3200000011', 'mónica.cárdenas@gmail.com', 'Clave12!', 3),
(88, 'Tarjeta de Identidad', '10041234', 'Santiago', 'Mora', '3200000012', 'santiago.mora@gmail.com', 'Clave13!', 3),
(89, 'Cédula de Extranjería', '10044567', 'Paula', 'Silva', '3200000013', 'paula.silva@gmail.com', 'Clave14!', 3),
(90, 'Cédula de Ciudadanía', '10047890', 'Jorge', 'Luna', '3200000014', 'jorge.luna@gmail.com', 'Clave15!', 3),
(91, 'Tarjeta de Identidad', '10052345', 'Luisa', 'Navarro', '3200000015', 'luisa.navarro@gmail.com', 'Clave16!', 3),
(92, 'Cédula de Ciudadanía', '10055678', 'Mateo', 'Vargas', '3200000016', 'mateo.vargas@gmail.com', 'Clave17!', 3),
(93, 'Cédula de Ciudadanía', '10058901', 'Natalia', 'Soto', '3200000017', 'natalia.soto@gmail.com', 'Clave18!', 1),
(94, 'Tarjeta de Identidad', '10061234', 'Tomás', 'Peña', '3200000018', 'tomás.peña@gmail.com', 'Clave19!', 2),
(95, 'Cédula de Extranjería', '10064567', 'Isabela', 'Montoya', '3200000019', 'isabela.montoya@gmail.com', 'Clave20!', 1),
(96, 'Cédula de Ciudadanía', '10067890', 'Emilio', 'Bravo', '3200000020', 'emilio.bravo@gmail.com', 'Clave21!', 2),
(97, 'Tarjeta de Identidad', '10072345', 'Valeria', 'Suárez', '3200000021', 'valeria.suárez@gmail.com', 'Clave22!', 1),
(98, 'Cédula de Extranjería', '10075678', 'Sebastián', 'Nieto', '3200000022', 'sebastián.nieto@gmail.com', 'Clave23!', 2),
(99, 'Cédula de Ciudadanía', '10078901', 'Gabriela', 'Pinto', '3200000023', 'gabriela.pinto@gmail.com', 'Clave24!', 1),
(100, 'Pasaporte', '10081234', 'Ricardo', 'Delgado', '3200000024', 'ricardo.delgado@gmail.com', 'Clave25!', 2),
(107, '', '1515421', 'BRIYITH STEFANY', 'RODRIGUEZ AMORTEGUI', '3204686377', 'diego.ca565o@gmail.com', 'Denver', 3),
(108, '', '1068978566', 'Daniela', 'Rodriguez', '320135165132', 'ed.rodri@gmail.com', 'Denver2022', 3);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `citas`
--
ALTER TABLE `citas`
  ADD PRIMARY KEY (`id_cita`);

--
-- Indices de la tabla `cupos`
--
ALTER TABLE `cupos`
  ADD PRIMARY KEY (`id_cupo`),
  ADD KEY `id_sede` (`id_sede`),
  ADD KEY `id_grado` (`id_grado`);

--
-- Indices de la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`id_evento`),
  ADD KEY `fk_eventos_institucion` (`id_colegio`);

--
-- Indices de la tabla `grados`
--
ALTER TABLE `grados`
  ADD PRIMARY KEY (`id_grado`),
  ADD KEY `fk_grados_sedes` (`id_sede`);

--
-- Indices de la tabla `instituciones`
--
ALTER TABLE `instituciones`
  ADD PRIMARY KEY (`Id_Colegio`);

--
-- Indices de la tabla `jornadas`
--
ALTER TABLE `jornadas`
  ADD PRIMARY KEY (`id_jornada`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `permisos_por_rol`
--
ALTER TABLE `permisos_por_rol`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `reseñas`
--
ALTER TABLE `reseñas`
  ADD PRIMARY KEY (`id_reseña`),
  ADD KEY `fk_reseñas_usuarios` (`id_usuario`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre_rol` (`nombre_rol`);

--
-- Indices de la tabla `sedes`
--
ALTER TABLE `sedes`
  ADD PRIMARY KEY (`id_sede`),
  ADD KEY `fk_sedes_instituciones` (`id_colegio`);

--
-- Indices de la tabla `sede_jornada`
--
ALTER TABLE `sede_jornada`
  ADD PRIMARY KEY (`id_sede`,`id_jornada`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `numero_documento` (`numero_documento`),
  ADD UNIQUE KEY `numero_documento_2` (`numero_documento`),
  ADD KEY `fk_usuario_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `citas`
--
ALTER TABLE `citas`
  MODIFY `id_cita` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT de la tabla `cupos`
--
ALTER TABLE `cupos`
  MODIFY `id_cupo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT de la tabla `eventos`
--
ALTER TABLE `eventos`
  MODIFY `id_evento` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `grados`
--
ALTER TABLE `grados`
  MODIFY `id_grado` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT de la tabla `jornadas`
--
ALTER TABLE `jornadas`
  MODIFY `id_jornada` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `permisos_por_rol`
--
ALTER TABLE `permisos_por_rol`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `reseñas`
--
ALTER TABLE `reseñas`
  MODIFY `id_reseña` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `sedes`
--
ALTER TABLE `sedes`
  MODIFY `id_sede` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
  ADD CONSTRAINT `fk_documento_usuario` FOREIGN KEY (`documento_usuario`) REFERENCES `usuario` (`numero_documento`);

--
-- Filtros para la tabla `cupos`
--
ALTER TABLE `cupos`
  ADD CONSTRAINT `cupos_ibfk_1` FOREIGN KEY (`id_sede`) REFERENCES `sedes` (`id_sede`),
  ADD CONSTRAINT `cupos_ibfk_2` FOREIGN KEY (`id_grado`) REFERENCES `grados` (`id_grado`);

--
-- Filtros para la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD CONSTRAINT `fk_eventos_institucion` FOREIGN KEY (`id_colegio`) REFERENCES `instituciones` (`Id_Colegio`);

--
-- Filtros para la tabla `grados`
--
ALTER TABLE `grados`
  ADD CONSTRAINT `fk_grados_sedes` FOREIGN KEY (`id_sede`) REFERENCES `sedes` (`id_sede`);

--
-- Filtros para la tabla `permisos_por_rol`
--
ALTER TABLE `permisos_por_rol`
  ADD CONSTRAINT `permisos_por_rol_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);

--
-- Filtros para la tabla `reseñas`
--
ALTER TABLE `reseñas`
  ADD CONSTRAINT `fk_reseñas_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `sedes`
--
ALTER TABLE `sedes`
  ADD CONSTRAINT `fk_sedes_instituciones` FOREIGN KEY (`id_colegio`) REFERENCES `instituciones` (`Id_Colegio`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
