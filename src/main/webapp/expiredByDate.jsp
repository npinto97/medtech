<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lotti Scaduti</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f4;
        }
        h2 {
            color: #333;
        }
        .results-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            max-width: 800px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #1976d2;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px;
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
    <div class="results-container">
        <h2>Risultati ricerca lotti scaduti</h2>
        <div>
            ${expiredTable}
        </div>
        <a href="selectExpiryDate.jsp">← Torna alla ricerca</a>
    </div>
</body>
</html>
