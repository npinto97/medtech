<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ordini del Chief Logistics Officer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f4;
        }
        h2 {
            color: #333;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            max-width: 800px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        a.back-link {
            display: inline-block;
            margin-bottom: 20px;
            padding: 8px 12px;
            background-color: #1976d2;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a.back-link:hover {
            background-color: #135ba1;
        }
        .results {
            margin-top: 20px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ccc;
        }
        th {
            background-color: #1976d2;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Risultati Ricerca</h2>
        <a href="inputChiefTaxCode.jsp" class="back-link">← Nuova ricerca</a>
        <div class="results">
            <%= request.getAttribute("chiefOrders") != null ? request.getAttribute("chiefOrders") : "<p>Nessun dato presente.</p>" %>
        </div>
    </div>
</body>
</html>
