<?php 
// Conexión
include './Conexion.php';

// Obtener datos del formulario
$numero_documento = trim($_POST['numero_documento'] ?? '');
$contrasena       = trim($_POST['contrasena'] ?? '');
$confirmar        = trim($_POST['confirmar'] ?? '');

// Validar campos vacíos
if (empty($numero_documento) || empty($contrasena) || empty($confirmar)) {
    echo "<script>alert('Todos los campos son obligatorios.'); window.history.back();</script>";
    exit();
}

// Validar coincidencia de contraseñas
if ($contrasena !== $confirmar) {
    echo "<script>alert('Las contraseñas no coinciden.'); window.history.back();</script>";
    exit();
}

// Guardar la contraseña en texto plano (NO RECOMENDADO para producción)
$sql = "UPDATE usuario SET contrasena = ? WHERE numero_documento = ?";
$stmt = $mysqli->prepare($sql);

if ($stmt) {
    $stmt->bind_param("ss", $contrasena, $numero_documento);

    if ($stmt->execute()) {
        echo "<script>
            alert('Contraseña guardada exitosamente.');
            window.location.href = '../views/procesoLogeo/RegistroExiU.HTML';
        </script>";
    } else {
        error_log("Error al ejecutar el UPDATE: " . $stmt->error);
        echo "<script>alert('Error al guardar la contraseña.'); window.history.back();</script>";
    }

    $stmt->close();
} else {
    error_log("Error en prepare(): " . $mysqli->error);
    echo "<script>alert('Error interno del servidor.'); window.history.back();</script>";
}

$mysqli->close();
?>
