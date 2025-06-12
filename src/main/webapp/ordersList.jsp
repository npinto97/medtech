<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Ordini Trovati</title>
</head>
<body>
    <h2>Risultati della Ricerca</h2>
    <div>
        <%= request.getAttribute("ordersTable") %>
    </div>
    <br>
    <a href="findOrdersByChief.jsp">Torna alla Ricerca</a>
</body>
</html>
