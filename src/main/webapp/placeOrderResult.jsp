<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Risultato Inserimento Ordine</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 40px;
        }
        .result-box {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: auto;
        }
        h2 {
            color: #1976d2;
        }
        p {
            font-size: 16px;
            color: #333;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #1976d2;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a:hover {
            background-color: #135ba1;
        }
    </style>
</head>
<body>
    <div class="result-box">
        <h2>Risultato Inserimento Ordine</h2>
        <p><%= request.getAttribute("message") %></p>
        <a href="placeOrder.jsp">Torna al modulo di inserimento</a>
    </div>
</body>
</html>
