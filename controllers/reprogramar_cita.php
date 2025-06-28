<?php
include './Conexion.php';
header('Content-Type: application/json');

$idCita = $_POST['id_cita'] ?? null;
$nuevaFecha = $_POST['fecha_cita'] ?? null;
$nuevaHora = $_POST['hora_cita'] ?? null;

if (!$idCita || !$nuevaFecha || !$nuevaHora) {
    echo json_encode(['success' => false, 'mensaje' => 'Faltan datos.']);
    exit;
}

// Consultar datos anteriores
$sqlOld = "SELECT documento_usuario, nombre_institucion, direccion_sede FROM citas WHERE id_cita = ?";
$stmtOld = $mysqli->prepare($sqlOld);
$stmtOld->bind_param('i', $idCita);
$stmtOld->execute();
$res = $stmtOld->get_result();

if (!$res || $res->num_rows === 0) {
    echo json_encode(['success' => false, 'mensaje' => 'Cita original no encontrada.']);
    exit;
}

$previa = $res->fetch_assoc();

// Insertar nueva cita
$sqlInsert = "INSERT INTO citas (documento_usuario, fecha_cita, hora_cita, estado_cita, nombre_institucion, direccion_sede)
              VALUES (?, ?, ?, 'Reprogramada', ?, ?)";
$stmtNew = $mysqli->prepare($sqlInsert);
$stmtNew->bind_param('sssss', $previa['documento_usuario'], $nuevaFecha, $nuevaHora, $previa['nombre_institucion'], $previa['direccion_sede']);

if ($stmtNew->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'mensaje' => 'Error al insertar nueva cita.']);
}

$stmtNew->close();
$stmtOld->close();
$mysqli->close();
