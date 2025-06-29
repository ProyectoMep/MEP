<?php
include './Conexion.php';

header('Content-Type: application/json');

$sql = "SELECT 
            id_cita,
            fecha_cita,
            hora_cita,
            nombre_institucion,
            id_sede,
            grado,
            cantidad_estudiantes,
            motivo_cita,
            estado_cita
        FROM citas
        ORDER BY fecha_cita DESC, hora_cita DESC";

$result = $mysqli->query($sql);

$citas = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $citas[] = $row;
    }
}

echo json_encode($citas);

$mysqli->close();
?>
