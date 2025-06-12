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
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .content-box {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            max-width: 800px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #1976d2;
            color: white;
        }
        a.button {
            display: inline-block;
            padding: 12px 20px;
            background-color: #1976d2;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        a.button:hover {
            background-color: #135ba1;
        }
    </style>
</head>
<body>
    <h1>Lotti di prodotti scaduti</h1>
    <div class="content-box">
        ${expiredBatchesTable}
    </div>
    <a href="index.jsp" class="button">Torna alla home</a>
</body>
</html>
