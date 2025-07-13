<?php
include './Conexion.php';
header('Content-Type: application/json');

// Verificar si los datos necesarios existen
if (!isset($_POST['id_cita'], $_POST['fecha_cita'], $_POST['hora_cita'])) {
    echo json_encode(['success' => false, 'mensaje' => 'Faltan datos requeridos.']);
    exit;
}

// Sanitizar entrada
$id_cita = intval($_POST['id_cita']);
$fecha_cita = $_POST['fecha_cita'];
$hora_cita = $_POST['hora_cita'];

// Validaciones básicas
if (!$id_cita || !$fecha_cita || !$hora_cita) {
    echo json_encode(['success' => false, 'mensaje' => 'Datos inválidos.']);
    exit;
}

require_once '../../config/conexion.php'; // Ajusta esta ruta a tu estructura real

$conn = conectar(); // Supongo que tienes una función conectar() en ese archivo

if ($conn->connect_error) {
    echo json_encode(['success' => false, 'mensaje' => 'Error de conexión a la base de datos.']);
    exit;
}

// Preparar y ejecutar el UPDATE
$stmt = $conn->prepare("UPDATE citas SET fecha_cita = ?, hora_cita = ? WHERE id = ?");
if (!$stmt) {
    echo json_encode(['success' => false, 'mensaje' => 'Error al preparar consulta.']);
    exit;
}

$stmt->bind_param("ssi", $fecha_cita, $hora_cita, $id_cita);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'mensaje' => 'No se pudo actualizar la cita.']);
}

$stmt->close();
$conn->close();
