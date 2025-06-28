<?php
include './Conexion.php';
header('Content-Type: application/json');

$idCita = $_POST['id_cita'] ?? null;

if (!$idCita) {
    echo json_encode(['success' => false, 'mensaje' => 'ID de cita no proporcionado.']);
    exit;
}

$sql = "UPDATE citas SET estado_cita = 'Cancelada' WHERE id_cita = ?";
$stmt = $mysqli->prepare($sql);
$stmt->bind_param("i", $idCita);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'mensaje' => 'Error al cancelar la cita.']);
}

$stmt->close();
$mysqli->close();
?>
