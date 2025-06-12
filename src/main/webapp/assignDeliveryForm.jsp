<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assegna Consegna</title>
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
            max-width: 500px;
            margin: auto;
        }
        h1 {
            color: #0056b3;
            text-align: center;
        }
        form div {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"] {
            width: calc(100% - 22px); /* Per compensare padding e border */
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box; /* Include padding e border nel width */
        }
        input[type="submit"] {
            background-color: #28a745;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        input[type="submit"]:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Assegna una Consegna</h1>
        <form action="AssignDelivery" method="post">
            <div>
                <label for="customerCode">Codice Cliente:</label>
                <input type="text" id="customerCode" name="customerCode" required>
            </div>
            <div>
                <label for="orderID">ID Ordine:</label>
                <input type="text" id="orderID" name="orderID" required>
            </div>
            <div>
                <label for="teamID">ID Team di Consegna:</label>
                <input type="text" id="teamID" name="teamID" required>
            </div>
            <div>
                <input type="submit" value="Assegna Consegna">
            </div>
        </form>
    </div>
</body>
</html>