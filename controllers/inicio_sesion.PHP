<?php
include './Conexion.php';

$correo = $_POST['correo'];
$contrasena = $_POST['contrasena'];
$tipoUsuario = $_POST['tipoUsuario'];


$sql = "SELECT * FROM usuario WHERE correo = ? AND contrasena = ?";

$stmt = $mysqli->prepare($sql);
$stmt->bind_param("ss", $correo, $contrasena);
$stmt->execute();
$result = $stmt->get_result();

if ($result-> num_rows > 0) {
    $url = "http://localhost/pagina_web_mep/views/procesoLogeo/interfazPu.html";
    echo "<script>window.location.href = '$url';</script>";
    exit();
} else {
    echo "Datos erróneos, por favor, revisar.";
    exit();
}

$stmt->close();
$mysqli->close();1

?>