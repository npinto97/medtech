<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registra Lotto</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f9f9f9;
        }
        h2 {
            color: #1976d2;
        }
        form {
            background-color: white;
            padding: 20px;
            width: 350px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"],
        input[type="number"],
        input[type="date"] {
            width: 100%;
            padding: 8px 10px;
            margin-bottom: 15px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        button {
            background-color: #1976d2;
            color: white;
            border: none;
            padding: 10px 18px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 4px;
        }
        button:hover {
            background-color: #1565c0;
        }
    </style>
</head>
<body>
    <h2>Registra un nuovo lotto</h2>
    <form action="registerBatch" method="post">
        <label for="batchID">Batch ID:</label>
        <input type="text" id="batchID" name="batchID" required>

        <label for="quantity">Quantità:</label>
        <input type="number" id="quantity" name="quantity" required>

        <label for="arrivalDate">Data Arrivo (YYYY-MM-DD):</label>
        <input type="date" id="arrivalDate" name="arrivalDate" required>

        <label for="productSN">Seriale Prodotto:</label>
        <input type="text" id="productSN" name="productSN" required>

        <label for="centerName">Centro:</label>
        <input type="text" id="centerName" name="centerName" required>

        <button type="submit">Registra Lotto</button>
    </form>
</body>
</html>
