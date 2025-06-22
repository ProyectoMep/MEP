<?php
// Conexión a la base de datos
$conexion = new mysqli("localhost", "root", "", "colegios");
if ($conexion->connect_error) {
    die("Error de conexión: " . $conexion->connect_error);
}

// Obtener los datos del formulario
$contrasena = $_POST['contrasena'] ?? '';
$confirmar  = $_POST['confirmar'] ?? '';

// Validar que los campos no estén vacíos
if (empty($contrasena) || empty($confirmar)) {
    echo "<script>alert('Todos los campos son obligatorios.'); window.history.back();</script>";
    exit();
}

// Validar que las contraseñas coincidan
if ($contrasena !== $confirmar) {
    echo "<script>alert('❌ Las contraseñas no coinciden.'); window.history.back();</script>";
    exit();
}

// (Opcional) Cifrar contraseña con password_hash
// $contrasena = password_hash($contrasena, PASSWORD_DEFAULT);

// Obtener el último usuario registrado
$sql = "SELECT id_usuario FROM usuarios ORDER BY id_usuario DESC LIMIT 1";
$resultado = $conexion->query($sql);

if ($resultado && $resultado->num_rows > 0) {
    $fila = $resultado->fetch_assoc();
    $ultimo_id = $fila['id_usuario'];

    // Actualizar la contraseña del último usuario
    $sql_update = "UPDATE usuarios SET contraseña = ? WHERE id_usuario = ?";
    $stmt = $conexion->prepare($sql_update);
    $stmt->bind_param("si", $contrasena, $ultimo_id);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        header("Location: InterfazPu.HTML");
        exit();
    } else {
        echo "<script>alert('Error al guardar la contraseña.'); window.history.back();</script>";
    }

    $stmt->close();
} else {
    echo "<script>alert('No se encontró ningún usuario para actualizar.'); window.history.back();</script>";
}

$conexion->close();
?>
