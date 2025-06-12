<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Prodotti</title>
</head>
<body>
    <h2>Elenco Prodotti</h2>
    <div>
        <%= request.getAttribute("productTable") %>
    </div>
</body>
</html>
