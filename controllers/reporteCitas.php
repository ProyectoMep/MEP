<?php
include './Conexion.php';

if (isset($_GET['admin']) && $_GET['admin'] === 'true') {
    // Respuesta en JSON para el frontend
    header('Content-Type: application/json');

    $sql = "SELECT id_cita, fecha_cita, hora_cita, nombre_institucion, id_sede, grado, cantidad_estudiantes, motivo_cita, estado_cita FROM citas";
    $result = $mysqli->query($sql);

    $citas = [];
    while ($row = $result->fetch_assoc()) {
        $citas[] = $row;
    }

    echo json_encode($citas);
} else {
    // Exportar a Excel
    header("Content-Type: application/vnd.ms-excel");
    header("Content-Disposition: attachment; filename=reporte_citas.xls");
    header("Pragma: no-cache");
    header("Expires: 0");

    $sql = "SELECT id_cita, fecha_cita, hora_cita, nombre_institucion, id_sede, grado, cantidad_estudiantes, motivo_cita, estado_cita FROM citas";
    $result = $mysqli->query($sql);

    echo "<table border='1'>";
    echo "<tr>
            <th>ID</th><th>Fecha</th><th>Hora</th><th>Institución</th><th>Sede</th>
            <th>Grado</th><th>Cantidad</th><th>Motivo</th><th>Estado</th>
          </tr>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>{$row['id_cita']}</td>
                <td>{$row['fecha_cita']}</td>
                <td>{$row['hora_cita']}</td>
                <td>{$row['nombre_institucion']}</td>
                <td>{$row['id_sede']}</td>
                <td>{$row['grado']}</td>
                <td>{$row['cantidad_estudiantes']}</td>
                <td>{$row['motivo_cita']}</td>
                <td>{$row['estado_cita']}</td>
              </tr>";
    }
    echo "</table>";
}

$mysqli->close();
?>