<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Risultato Assegnazione Consegna</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
            color: #333;
        }
        .container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: auto;
        }
        h1 {
            color: #0056b3;
        }
        .message.success {
            color: green;
            font-weight: bold;
        }
        .message.error {
            color: red;
            font-weight: bold;
        }
        a {
            display: block;
            margin-top: 20px;
            color: #0056b3;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Risultato Assegnazione Consegna</h1>
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
                if (message.startsWith("Errore:")) {
        %>
                    <p class="message error"><%= message %></p>
        <%
                } else {
        %>
                    <p class="message success"><%= message %></p>
        <%
                }
            } else {
        %>
                <p>Nessun messaggio disponibile.</p>
        <%
            }
        %>
        <a href="index.html">Torna alla pagina principale</a> <%-- O alla pagina da cui proviene la richiesta --%>
    </div>
</body>
</html>