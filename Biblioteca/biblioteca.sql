/*-- ============================================================
-- Sistema de administración de biblioteca escolar
-- Base de datos: poo_biblioteca
-- MySQL 8.x
-- ============================================================

CREATE DATABASE IF NOT EXISTS poo_biblioteca
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE poo_biblioteca;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS detalle_prestamo;
DROP TABLE IF EXISTS prestamos;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS autores;
DROP TABLE IF EXISTS alumnos;

-- ============================================================
-- ALUMNOS
-- ============================================================
CREATE TABLE alumnos (
    id          INT NOT NULL AUTO_INCREMENT,
    matricula   VARCHAR(20) NOT NULL,
    nombre      VARCHAR(100) NOT NULL,
    apellidos   VARCHAR(100) NOT NULL,
    carrera     VARCHAR(100) NOT NULL,
    activo      INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_alumnos_matricula (matricula)
) ENGINE=InnoDB;

-- ============================================================
-- AUTORES
-- ============================================================
CREATE TABLE autores (
    id           INT NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100) NOT NULL,
    apellidos    VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ============================================================
-- CATEGORIAS
-- ============================================================
CREATE TABLE categorias (
    id          INT NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_categorias_nombre (nombre)
) ENGINE=InnoDB;

-- ============================================================
-- LIBROS
-- ============================================================
CREATE TABLE libros (
    id           INT NOT NULL AUTO_INCREMENT,
    isbn         VARCHAR(20) NOT NULL,
    titulo       VARCHAR(150) NOT NULL,
    id_autor     INT NOT NULL,
    id_categoria INT NOT NULL,
    existencia   INT NOT NULL DEFAULT 0,
    activo       INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_libros_isbn (isbn),
    KEY idx_libros_autor (id_autor),
    KEY idx_libros_categoria (id_categoria),
    CONSTRAINT fk_libros_autor
        FOREIGN KEY (id_autor) REFERENCES autores (id),
    CONSTRAINT fk_libros_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias (id)
) ENGINE=InnoDB;

-- ============================================================
-- PRESTAMOS
-- ============================================================
CREATE TABLE prestamos (
    id             INT NOT NULL AUTO_INCREMENT,
    id_alumno      INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_limite   DATE NOT NULL,
    estado         VARCHAR(20) NOT NULL DEFAULT 'Activo',
    PRIMARY KEY (id),
    KEY idx_prestamos_alumno (id_alumno),
    CONSTRAINT fk_prestamos_alumno
        FOREIGN KEY (id_alumno) REFERENCES alumnos (id)
) ENGINE=InnoDB;

-- ============================================================
-- DETALLE PRESTAMO
-- ============================================================
CREATE TABLE detalle_prestamo (
    id          INT NOT NULL AUTO_INCREMENT,
    id_prestamo INT NOT NULL,
    id_libro    INT NOT NULL,
    cantidad    INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_detalle_prestamo_libro (id_prestamo, id_libro),
    KEY idx_detalle_libro (id_libro),
    CONSTRAINT fk_detalle_prestamo
        FOREIGN KEY (id_prestamo) REFERENCES prestamos (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_detalle_libro
        FOREIGN KEY (id_libro) REFERENCES libros (id)
) ENGINE=InnoDB;

-- ============================================================
-- DATOS INICIALES
-- ============================================================

INSERT INTO alumnos (matricula, nombre, apellidos, carrera, activo) VALUES
('A001', 'Juan', 'Pérez García', 'Ingeniería en Sistemas', 1),
('A002', 'María', 'López Martínez', 'Contabilidad', 1),
('A003', 'Carlos', 'González Rodríguez', 'Ingeniería en Sistemas', 1),
('A004', 'Ana', 'Hernández Sánchez', 'Derecho', 1),
('A005', 'Luis', 'Ramírez Torres', 'Administración', 1),
('A006', 'Sofía', 'Flores Rivera', 'Psicología', 1),
('A007', 'Diego', 'Mendoza Castro', 'Ingeniería Industrial', 1),
('A008', 'Valeria', 'Ortiz Núñez', 'Medicina', 1),
('A009', 'Jorge', 'Castillo Reyes', 'Ingeniería en Sistemas', 0),
('A010', 'Camila', 'Moreno Jiménez', 'Contabilidad', 1),
('A011', 'Ricardo', 'Vargas Silva', 'Derecho', 1),
('A012', 'Fernanda', 'Rojas Medina', 'Ingeniería Industrial', 1),
('A013', 'Miguel Ángel', 'Torres Luna', 'Administración', 0),
('A014', 'Paula', 'Domínguez Vega', 'Psicología', 1),
('A015', 'Andrés', 'Navarro Ponce', 'Medicina', 1);

INSERT INTO autores (nombre, apellidos, nacionalidad) VALUES
('Gabriel', 'García Márquez', 'Colombia'),
('Isabel', 'Allende', 'Chile'),
('Mario', 'Vargas Llosa', 'Perú'),
('Jorge Luis', 'Borges', 'Argentina'),
('Julio', 'Cortázar', 'Argentina'),
('Octavio', 'Paz', 'México'),
('Miguel de', 'Cervantes', 'España'),
('Antoine de', 'Saint-Exupéry', 'Francia');

INSERT INTO categorias (nombre, descripcion) VALUES
('Novela', 'Obras narrativas de ficción extensas'),
('Cuento', 'Narraciones breves de ficción'),
('Poesía', 'Obras escritas en verso'),
('Ensayo', 'Textos de reflexión y análisis'),
('Teatro', 'Obras dramáticas para representación'),
('Infantil', 'Literatura dirigida a niños');

INSERT INTO libros (isbn, titulo, id_autor, id_categoria, existencia, activo) VALUES
('978-030-735-043-6', 'Cien años de soledad', 1, 1, 5, 1),
('978-006-112-803-8', 'La casa de los espíritus', 2, 1, 3, 1),
('978-842-043-335-4', 'La ciudad y los perros', 3, 1, 2, 1),
('978-842-043-430-6', 'Ficciones', 4, 2, 3, 1),
('978-843-760-430-0', 'Rayuela', 5, 1, 1, 1),
('978-968-160-791-9', 'El laberinto de la soledad', 6, 4, 2, 1),
('978-842-041-610-4', 'Don Quijote de la Mancha', 7, 1, 5, 1),
('978-015-601-398-0', 'El principito', 8, 6, 6, 1),
('978-030-747-958-7', 'Crónica de una muerte anunciada', 1, 1, 4, 1),
('978-840-124-253-1', 'Eva Luna', 2, 1, 3, 1),
('978-842-047-706-8', 'La fiesta del Chivo', 3, 1, 2, 1),
('978-849-908-973-5', 'El Aleph', 4, 2, 3, 1),
('978-843-760-317-4', 'Bestiario', 5, 2, 2, 1),
('978-968-160-792-6', 'Piedra de sol', 6, 3, 3, 1),
('978-842-067-451-1', 'Novelas ejemplares', 7, 1, 2, 1),
('978-987-566-506-9', 'Vuelo nocturno', 8, 1, 1, 1),
('978-030-738-829-3', 'El amor en los tiempos del cólera', 1, 1, 4, 1),
('978-950-731-497-8', 'De amor y de sombra', 2, 1, 2, 1),
('978-842-043-337-8', 'Conversación en La Catedral', 3, 1, 1, 1),
('978-842-063-475-1', 'Historia universal de la infamia', 4, 2, 3, 1),
('978-843-760-322-8', 'Las armas secretas', 5, 2, 2, 1),
('978-968-160-793-3', 'El arco y la lira', 6, 4, 2, 1),
('978-842-041-611-1', 'La gitanilla', 7, 5, 2, 1),
('978-987-566-507-6', 'Tierra de hombres', 8, 4, 1, 1),
('978-970-731-098-1', 'Los relatos de la selva', 8, 6, 2, 0);

INSERT INTO prestamos (id_alumno, fecha_prestamo, fecha_limite, estado) VALUES
(1, '2026-08-20', '2026-09-03', 'Devuelto'),
(2, '2026-09-01', '2026-09-15', 'Devuelto'),
(3, '2026-09-15', '2026-09-29', 'Devuelto'),
(4, '2026-10-05', '2026-10-19', 'Activo'),
(5, '2026-10-10', '2026-10-24', 'Activo'),
(6, '2026-10-15', '2026-10-29', 'Activo');

INSERT INTO detalle_prestamo (id_prestamo, id_libro, cantidad) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(3, 4, 1),
(4, 5, 1),
(4, 8, 2),
(5, 3, 2),
(6, 7, 1);
*/