<?php

$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login Attempt</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .result {
            background: white;
            width: 400px;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }

        h2 {
            margin-top: 0;
        }

        .field {
            padding: 10px;
            margin-top: 10px;
            background: #f5f5f5;
            border-radius: 5px;
        }

        .label {
            font-weight: bold;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="result">

    <h2>Login Attempt</h2>

    <div class="field">
        <span class="label">Username:</span>
        <?php echo htmlspecialchars($username, ENT_QUOTES, 'UTF-8'); ?>
    </div>

    <div class="field">
        <span class="label">Password:</span>
        <?php echo htmlspecialchars($password, ENT_QUOTES, 'UTF-8'); ?>
    </div>

    <a href="login.html">← Back to Login</a>

</div>

</body>
</html>