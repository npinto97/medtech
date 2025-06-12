<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Risultato Registrazione Lotto</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f9f9f9;
        }
        h2 {
            color: #333;
        }
        .message {
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
            font-size: 1.1em;
            width: fit-content;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #1976d2;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h2>Risultato Registrazione Lotto</h2>

    <%
        String message = (String) request.getAttribute("message");
        if (message != null) {
            // Se il messaggio contiene "Errore", mettiamo stile errore, altrimenti successo
            boolean isError = message.toLowerCase().contains("errore");
    %>
        <div class="message <%= isError ? "error" : "success" %>">
            <%= message %>
        </div>
    <%
        } else {
    %>
        <p>Nessun messaggio da mostrare.</p>
    <%
        }
    %>

    <a href="registerBatch.jsp">Torna al modulo di registrazione</a>
</body>
</html>
