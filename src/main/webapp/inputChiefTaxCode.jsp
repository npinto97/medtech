<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inserisci Codice Fiscale</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f4;
        }
        h2 {
            color: #333;
        }
        .form-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            max-width: 400px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        input[type="submit"] {
            background-color: #1976d2;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #135ba1;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Ricerca Ordini per Chief Logistics Officer</h2>
        <form action="ListChiefOrders" method="get">
            <label for="taxcode">Codice Fiscale:</label>
            <input type="text" id="taxcode" name="taxcode" required maxlength="20"/>
            <input type="submit" value="Cerca Ordini"/>
        </form>
    </div>
</body>
</html>
