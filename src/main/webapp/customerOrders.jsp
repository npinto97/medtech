<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ordini Clienti</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f9f9f9;
        }
        h1 {
            color: #1976d2;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px 12px;
            text-align: left;
        }
        th {
            background-color: #1976d2;
            color: white;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            color: #1976d2;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Ordini Clienti</h1>
    <div>
        <%= request.getAttribute("customerOrdersTable") %>
    </div>
    <a href="index.jsp">Torna alla Home</a>
</body>
</html>
