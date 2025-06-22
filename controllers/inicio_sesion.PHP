<?php
session_start();

// Conexión
$conexion = new mysqli("localhost", "root", "", "colegios");
if ($conexion->connect_error) {
    die("❌ Error de conexión: " . $conexion->connect_error);
}

// Recibir datos (con trim para evitar espacios invisibles)
$correo = trim($_POST['correo'] ?? '');
$contrasena = trim($_POST['contraseña'] ?? '');
$tipo = trim($_POST['tipo'] ?? '');

// Validar que no estén vacíos
if (empty($correo) || empty($contrasena) || empty($tipo)) {
    echo "<script>alert('⚠️ Todos los campos son obligatorios.'); window.history.back();</script>";
    exit();
}

// Asociar tipo con id_rol (persona = 3, institucion = 2)
$rol_id = ($tipo === 'persona') ? 3 : 2;

// DEBUG: Mostrar lo que se está recibiendo
echo "<strong>Depuración:</strong><br>";
echo "Correo recibido: $correo<br>";
echo "Contraseña recibida: $contrasena<br>";
echo "Tipo: $tipo<br>";
echo "Rol asociado: $rol_id<br>";

// Consulta
$sql = "SELECT * FROM usuarios WHERE correo = ? AND contraseña = ? AND id_rol = ?";
$stmt = $conexion->prepare($sql);
if (!$stmt) {
    die("❌ Error al preparar la consulta: " . $conexion->error);
}

$stmt->bind_param("ssi", $correo, $contrasena, $rol_id);
$stmt->execute();
$resultado = $stmt->get_result();

// Validar resultado
if ($resultado && $resultado->num_rows > 0) {
    $_SESSION['correo'] = $correo;

    echo "<p style='color:green;'>✅ Usuario autenticado correctamente.</p>";
    
    // Redirigir
    if ($tipo === 'persona') {
        header("Location: InterfazPu.html");
    } else {
        header("Location: InterfazP.html");
    }
    exit();
} else {
    echo "<p style='color:red;'>❌ Usuario o contraseña incorrectos</p>";
}

$stmt->close();
$conexion->close();
?>
