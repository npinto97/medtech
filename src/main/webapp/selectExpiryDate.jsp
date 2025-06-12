<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Seleziona Data di Scadenza</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f4;
        }
        h2 {
            color: #333;
        }
        .form-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            max-width: 400px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="date"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        input[type="submit"] {
            background-color: #1976d2;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #135ba1;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Visualizza lotti scaduti entro una data</h2>
        <form action="expiredByDate" method="post">
            <label for="expiryDate">Inserisci la data (YYYY-MM-DD):</label>
            <input type="date" name="expiryDate" required />
            <input type="submit" value="Cerca lotti scaduti" />
        </form>
    </div>
</body>
</html>
