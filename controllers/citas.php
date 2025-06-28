<?php
include './Conexion.php';
header('Content-Type: application/json');

// Obtener el documento desde el GET
$documento = isset($_GET['documento']) ? trim($_GET['documento']) : '';

if (empty($documento)) {
    echo json_encode([]);
    exit;
}

// Consulta SQL: prioridad de estados
$sql = "SELECT id_cita, fecha_cita, hora_cita, estado_cita, nombre_institucion, direccion_sede
        FROM citas
        WHERE documento_usuario = ?
        ORDER BY 
          CASE 
            WHEN estado_cita = 'Pendiente' THEN 0
            WHEN estado_cita = 'Confirmada' THEN 1
            WHEN estado_cita = 'Reprogramada' THEN 2
            WHEN estado_cita = 'Cancelada' THEN 3
            ELSE 4
          END,
          fecha_cita DESC,
          hora_cita DESC";

$stmt = $mysqli->prepare($sql);
$stmt->bind_param('s', $documento);
$stmt->execute();
$result = $stmt->get_result();

$citas = [];

while ($row = $result->fetch_assoc()) {
    // Motivo personalizado
    $motivo = in_array($row['estado_cita'], ['Proceso de matrícula', 'Atención al usuario'])
        ? $row['estado_cita'] . ' ' . $row['fecha_cita']
        : $row['estado_cita'];

    // Solo editable si está en pendiente o confirmada
    $editable = in_array(strtolower($row['estado_cita']), ['pendiente', 'confirmada']);

    $citas[] = [
        'id_cita' => $row['id_cita'],
        'fecha_cita' => $row['fecha_cita'],
        'hora_cita' => $row['hora_cita'],
        'estado_cita' => $row['estado_cita'],
        'nombre_institucion' => $row['nombre_institucion'],
        'direccion_sede' => $row['direccion_sede'],
        'motivo' => $motivo,
        'editable' => $editable
    ];
}

$stmt->close();
$mysqli->close();

echo json_encode($citas);
?>
