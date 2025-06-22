<?php
http_response_code(500);
?>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Error 500 - MEP</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      text-align: center;
    }

    .navbar {
      background-color: #003366;
      color: white;
      padding: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .navbar img {
      width: 120px;
      margin-right: 15px;
    }

    .navbar h1 {
      font-size: 22px;
      margin: 0;
    }

    .error-container {
      padding: 60px 20px;
    }

    .error-code {
      font-size: 100px;
      color: #db6521;
      font-weight: bold;
      margin-bottom: 10px;
    }

    .error-message {
      font-size: 24px;
      color: #333;
      margin-bottom: 20px;
    }

    .explanation {
      color: #666;
      font-size: 18px;
      margin-bottom: 30px;
    }

    .back-button {
      padding: 12px 25px;
      background-color: #005baa;
      color: white;
      text-decoration: none;
      border-radius: 8px;
      font-weight: bold;
      transition: background-color 0.3s ease;
    }

    .back-button:hover {
      background-color: #003366;
    }

    .illustration {
      width: 280px;
      margin-top: 30px;
    }
  </style>
</head>
<body>

  <!-- Encabezado -->
  <div class="navbar">
    <img src="logo png.png" alt="Logo MEP">
    <h1>MEP - Matrículas y Educación Pública</h1>
  </div>

  <!-- Contenido de error -->
  <div class="error-container">
    <div class="error-code">500</div>
    <div class="error-message">¡Error interno del servidor!</div>
    <div class="explanation">Lo sentimos, algo salió mal en nuestros servidores. Estamos trabajando para solucionarlo.</div>
    <a href="InterfazPu.html" class="back-button">Volver al inicio</a>
    <div>
      <img class="illustration" src="https://cdn-icons-png.flaticon.com/512/564/564619.png" alt="Error ilustración">
    </div>
  </div>

</body>
</html>
