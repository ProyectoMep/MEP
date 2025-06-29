<?php
include './Conexion.php';
header('Content-Type: application/json');
ini_set('display_errors', 1);
error_reporting(E_ALL);

$idCita = $_POST['id_cita'] ?? null;

if (!$idCita) {
    echo json_encode(['success' => false, 'mensaje' => 'ID de cita no proporcionado.']);
    exit;
}

$sql = "UPDATE citas SET estado_cita = 'Cancelada' WHERE id_cita = ?";
$stmt = $mysqli->prepare($sql);

if (!$stmt) {
    echo json_encode(['success' => false, 'mensaje' => 'Error al preparar la consulta: ' . $mysqli->error]);
    exit;
}

$stmt->bind_param("i", $idCita);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'mensaje' => 'Error al cancelar la cita: ' . $stmt->error]);
}

$stmt->close();
$mysqli->close();
?>
