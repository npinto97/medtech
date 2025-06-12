<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Batch di Prodotti Scaduti</title>
</head>
<body>
    <h2>Elenco dei batch con prodotti scaduti</h2>
    <div>
        <%= request.getAttribute("expiredBatchesTable") %>
    </div>
</body>
</html>
