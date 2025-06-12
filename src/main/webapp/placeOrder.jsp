<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inserimento Nuovo Ordine</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 40px;
        }
        .form-box {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: auto;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="date"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
        }
        button {
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #1976d2;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #135ba1;
        }
    </style>
</head>
<body>
    <div class="form-box">
        <h2>Inserisci un Nuovo Ordine</h2>
        <form action="placeOrder" method="post">
            <label for="customerCode">Codice Cliente:</label>
            <input type="text" id="customerCode" name="customerCode" required>

            <label for="orderID">ID Ordine:</label>
            <input type="text" id="orderID" name="orderID" required>

            <label for="orderDate">Data Ordine:</label>
            <input type="date" id="orderDate" name="orderDate" required>

            <label for="deliveryDate">Data Consegna Prevista:</label>
            <input type="date" id="deliveryDate" name="deliveryDate" required>

            <label for="status">Stato Ordine:</label>
            <input type="text" id="status" name="status" required>

            <label for="batchIDs">Batch IDs (separa con virgole):</label>
            <input type="text" id="batchIDs" name="batchIDs" placeholder="Esempio: B001,B002,B003" required>

            <button type="submit">Inserisci Ordine</button>
        </form>
    </div>
</body>
</html>
