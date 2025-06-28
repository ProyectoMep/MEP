<?php
include './Conexion.php';

// Asegura que la respuesta sea JSON
header('Content-Type: application/json');

// Validación básica
if (!isset($_POST['correo'], $_POST['contrasena'])) {
    echo json_encode([
        'success' => false,
        'mensaje' => 'Datos incompletos.'
    ]);
    exit();
}

$correo = $_POST['correo'];
$contrasena = $_POST['contrasena'];

$sql = "SELECT * FROM usuario WHERE correo = ? AND contrasena = ?";
$stmt = $mysqli->prepare($sql);
$stmt->bind_param("ss", $correo, $contrasena);
$stmt->execute();
$result = $stmt->get_result();

$response = [];

if ($result->num_rows > 0) {
    $usuario = $result->fetch_assoc();
    $response = [
        'success' => true,
        'documento' => $usuario['numero_documento']
    ];
} else {
    $response = [
        'success' => false,
        'mensaje' => 'Credenciales inválidas.'
    ];
}

// Devolver JSON limpio
echo json_encode($response);

// Cerrar conexiones
$stmt->close();
$mysqli->close();
