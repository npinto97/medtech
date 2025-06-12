<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>MedTech Logistics - Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f9f9f9;
            color: #333;
        }
        h1 {
            color: #1976d2;
            margin-bottom: 5px;
        }
        h2 {
            color: #1976d2;
            margin-top: 0;
            margin-bottom: 20px;
            font-weight: normal;
        }
        p.description {
            max-width: 450px;
            line-height: 1.4;
            margin-bottom: 30px;
            color: #555;
        }
        form {
            background-color: white;
            padding: 20px;
            width: 320px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-shadow: 1px 1px 5px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-bottom: 12px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 8px 10px;
            margin-top: 4px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #1976d2;
            outline: none;
        }
        button {
            background-color: #1976d2;
            color: white;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 4px;
            margin-top: 10px;
            width: 100%;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #1565c0;
        }
        p.error {
            color: red;
            margin-top: 15px;
            font-weight: bold;
            min-height: 24px;
        }
    </style>
</head>
<body>
    <h1>MedTech Logistics</h1>
    <h2>Accedi al sistema di gestione distribuzione</h2>
    <p class="description">
        Gestisci la distribuzione di apparecchiature mediche, ordini, consegne e reclami per ospedali e cliniche.
        Accedi con le tue credenziali per iniziare.
    </p>
    <form method="post" action="login">
        <label>Username:
            <input type="text" name="username" required autocomplete="username">
        </label>
        <label>Password:
            <input type="password" name="password" required autocomplete="current-password">
        </label>
        <button type="submit">Accedi</button>
    </form>
    <p class="error">
        <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
    </p>
</body>
</html>
