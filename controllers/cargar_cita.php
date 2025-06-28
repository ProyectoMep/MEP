<?php
include './Conexion.php';
header('Content-Type: application/json');

$id = $_GET['id'] ?? null;

if (!$id) {
    echo json_encode(['success' => false]);
    exit;
}

$sql = "SELECT nombre_institucion, direccion_sede FROM citas WHERE id_cita = ?";
$stmt = $mysqli->prepare($sql);
$stmt->bind_param('i', $id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(['success' => true, 'cita' => $row]);
} else {
    echo json_encode(['success' => false]);
}

$stmt->close();
$mysqli->close();
