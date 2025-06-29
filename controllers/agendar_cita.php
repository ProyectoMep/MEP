<?php
include './Conexion.php';
header('Content-Type: application/json');
ini_set('display_errors', 1);
error_reporting(E_ALL);

$documento = $_POST['documento_usuario'] ?? null;
$institucion = $_POST['institucion'] ?? null;
$id_sede = $_POST['sede'] ?? null;
$fecha = $_POST['fecha'] ?? null;
$hora = $_POST['hora'] ?? null;
$cantidad = $_POST['cantidad'] ?? null;
$grado = $_POST['grado'] ?? null;
$jornada = $_POST['jornada'] ?? null;
$motivo = $_POST['motivo_cita'] ?? null;

// Validación básica
if (!$documento || !$institucion || !$fecha || !$hora || !$motivo) {
    echo json_encode(['success' => false, 'mensaje' => 'Faltan campos obligatorios.']);
    exit;
}

$sql = "INSERT INTO citas (
    documento_usuario,
    nombre_institucion,
    id_sede,
    fecha_cita,
    hora_cita,
    cantidad_estudiantes,
    grado,
    jornada,
    motivo_cita,
    estado_cita
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pendiente')";

$stmt = $mysqli->prepare($sql);

if (!$stmt) {
    echo json_encode(['success' => false, 'mensaje' => 'Error al preparar la consulta: ' . $mysqli->error]);
    exit;
}

$stmt->bind_param(
    "sssssssss",
    $documento,
    $institucion,
    $id_sede,
    $fecha,
    $hora,
    $cantidad,
    $grado,
    $jornada,
    $motivo
);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'mensaje' => 'Error al guardar la cita: ' . $stmt->error]);
}

$stmt->close();
$mysqli->close();
?>
