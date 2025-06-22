<?php
// Conexión a la base de datos
$conexion = new mysqli("localhost", "root", "", "colegios");
if ($conexion->connect_error) {
    die("Error de conexión: " . $conexion->connect_error);
}

// Recibir datos del formulario
$nombre     = $_POST['nombre']     ?? '';
$apellido   = $_POST['apellido']   ?? '';
$documento  = $_POST['documento']  ?? ''; // ← se guarda en id_usuario
$telefono   = $_POST['telefono']   ?? '';
$email      = $_POST['email']      ?? '';

// Validar campos vacíos
if (empty($nombre) || empty($apellido) || empty($documento) || empty($telefono) || empty($email)) {
    echo "<script>alert('Todos los campos son obligatorios.'); window.history.back();</script>";
    exit();
}

// Insertar en la tabla usuarios
$sql = "INSERT INTO usuarios (id_usuario, nombre, apellido, telefono, correo) VALUES (?, ?, ?, ?, ?)";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("sssss", $documento, $nombre, $apellido, $telefono, $email);

if ($stmt->execute()) {
    // Registro exitoso, redirige a Contrasena.HTML
    header("Location: Contrasena.HTML");
    exit();
} else {
    echo "<script>alert('❌ Error al registrar el usuario. Verifica que no esté repetido.'); window.history.back();</script>";
}

$stmt->close();
$conexion->close();
?>

