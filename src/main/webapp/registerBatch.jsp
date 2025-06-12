<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Registra Lotto</title></head>
<body>
    <h2>Registra un nuovo lotto</h2>
    <form action="registerBatch" method="post">
        <label for="batchID">Batch ID:</label>
        <input type="text" id="batchID" name="batchID" required><br><br>

        <label for="quantity">Quantità:</label>
        <input type="number" id="quantity" name="quantity" required><br><br>

        <label for="arrivalDate">Data Arrivo (YYYY-MM-DD):</label>
        <input type="date" id="arrivalDate" name="arrivalDate" required><br><br>

        <label for="productSN">Seriale Prodotto:</label>
        <input type="text" id="productSN" name="productSN" required><br><br>

        <label for="centerName">Centro:</label>
        <input type="text" id="centerName" name="centerName" required><br><br>

        <button type="submit">Registra Lotto</button>
    </form>
</body>
</html>
