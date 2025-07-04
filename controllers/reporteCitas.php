<?php
include './Conexion.php';

$esAdmin = isset($_GET['admin']) && $_GET['admin'] === 'true';

// Filtros opcionales
$institucion = $_GET['institucion'] ?? '';
$estado      = $_GET['estado'] ?? '';
$jornada     = $_GET['jornada'] ?? '';
$fecha       = $_GET['fecha'] ?? '';

// Construir SQL dinámico 
$sql = "SELECT id_cita, fecha_cita, hora_cita, nombre_institucion, id_sede, grado, cantidad_estudiantes, motivo_cita, jornada, estado_cita FROM citas WHERE 1=1";

if (!empty($institucion)) $sql .= " AND nombre_institucion = '" . $mysqli->real_escape_string($institucion) . "'";
if (!empty($estado))      $sql .= " AND estado_cita = '" . $mysqli->real_escape_string($estado) . "'";
if (!empty($jornada))     $sql .= " AND jornada = '" . $mysqli->real_escape_string($jornada) . "'";
if (!empty($fecha))       $sql .= " AND fecha_cita = '" . $mysqli->real_escape_string($fecha) . "'";

$result = $mysqli->query($sql);

if ($esAdmin) {
    // Devolver datos en JSON para frontend
    header('Content-Type: application/json');

    $citas = [];
    while ($row = $result->fetch_assoc()) {
        $citas[] = $row;
    }

    echo json_encode($citas);
} else {
    // Exportar en formato "Excel" (HTML con headers)
    header("Content-Type: application/vnd.ms-excel");
    header("Content-Disposition: attachment; filename=reporte_citas.xls");
    header("Pragma: no-cache");
    header("Expires: 0");

    echo "<table border='1'>";
    echo "<tr>
            <th>ID</th><th>Fecha</th><th>Hora</th><th>Institución</th><th>Sede</th>
            <th>Grado</th><th>Cantidad</th><th>Motivo</th><th>Jornada</th><th>Estado</th>
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
                <td>{$row['jornada']}</td>
                <td>{$row['estado_cita']}</td>
              </tr>";
    }

    echo "</table>";
}

$mysqli->close();
?>
