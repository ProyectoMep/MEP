<?php
// Conexión
include './Conexion.php';

// Recibir y sanitizar datos del formulario
$tipo_documento    = htmlspecialchars(trim($_POST['tipo_documento']));
$numero_documento  = htmlspecialchars(trim($_POST['numero_documento']));
$nombre            = htmlspecialchars(trim($_POST['nombre']));
$apellido          = htmlspecialchars(trim($_POST['apellido']));
$telefono          = htmlspecialchars(trim($_POST['telefono']));
$correo            = htmlspecialchars(trim($_POST['correo']));

// Validar campos vacíos
if (empty($tipo_documento) || empty($numero_documento) || empty($nombre) || empty($apellido) || empty($telefono) || empty($correo)) {
    echo "<script>alert('Todos los campos son obligatorios.'); window.history.back();</script>";
    exit();
}

// Validar formato del correo electrónico
if (!filter_var($correo, FILTER_VALIDATE_EMAIL)) {
    echo "<script>alert('El correo electrónico no es válido.'); window.history.back();</script>";
    exit();
}

// Verificar si el documento o correo ya están registrados
$verificar = $mysqli->prepare("SELECT id_usuario FROM usuario WHERE numero_documento = ? OR correo = ?");
$verificar->bind_param("ss", $numero_documento, $correo);
$verificar->execute();
$verificar->store_result();

if ($verificar->num_rows > 0) {
    echo "<script>alert('El número de documento o correo ya están registrados.'); window.history.back();</script>";
    $verificar->close();
    exit();
}
$verificar->close();

// Insertar en la tabla usuario
$sql = "INSERT INTO usuario (tipo_documento, numero_documento, nombre, apellido, telefono, correo, id_rol) VALUES (?, ?, ?, ?, ?, ?, 3)";
$stmt = $mysqli->prepare($sql);
$stmt->bind_param("ssssss", $tipo_documento, $numero_documento, $nombre, $apellido, $telefono, $correo);

if ($stmt->execute()) {
    // Redirigir al formulario de contraseña con el documento
    header("Location: http://localhost/pagina_web_mep/views/procesoLogeo/Contrasena.html?numero_documento=" . urlencode($numero_documento));
    exit();
} else {
    error_log("Error al registrar usuario: " . $mysqli->error);
    echo "<script>alert('Hubo un error al registrar. Intente más tarde.'); window.history.back();</script>";
}

$stmt->close();
$mysqli->close();
?>
