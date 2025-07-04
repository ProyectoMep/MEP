<?php
include './Conexion.php';

// Asegura que la respuesta sea JSON
header('Content-Type: application/json');

// Validación de entrada
if (!isset($_POST['correo'], $_POST['contrasena'])) {
    echo json_encode([
        'success' => false,
        'mensaje' => 'Datos incompletos.'
    ]);
    exit();
}

$correo = $_POST['correo'];
$contrasena = $_POST['contrasena'];

// Consulta para validar usuario y contraseña
$sql = "SELECT numero_documento, id_rol FROM usuario WHERE correo = ? AND contrasena = ?";
$stmt = $mysqli->prepare($sql);

if (!$stmt) {
    echo json_encode([
        'success' => false,
        'mensaje' => 'Error al preparar la consulta.'
    ]);
    exit();
}

$stmt->bind_param("ss", $correo, $contrasena);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $usuario = $result->fetch_assoc();
    echo json_encode([
        'success' => true,
        'documento' => $usuario['numero_documento'],
        'rol' => $usuario['id_rol']
    ]);
} else {
    echo json_encode([
        'success' => false,
        'mensaje' => 'Credenciales inválidas.'
    ]);
}

// Cerrar recursos
$stmt->close();
$mysqli->close();
