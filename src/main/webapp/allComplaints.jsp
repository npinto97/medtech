<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reclami Clienti</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f4;
        }
        h2 {
            text-align: center;
            color: #1976d2;
        }
        table {
            margin: 20px auto;
            border-collapse: collapse;
            width: 90%;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #1976d2;
            color: white;
        }
    </style>
</head>
<body>

<h2>Elenco Reclami Clienti</h2>

<table>
    <tr>
        <th>Codice Cliente</th>
        <th>ID Reclamo</th>
        <th>Data Reclamo</th>
        <th>Motivo</th>
        <th>Descrizione</th>
    </tr>
<%
    List<String[]> complaints = (List<String[]>) request.getAttribute("complaintsList");

    if (complaints != null && !complaints.isEmpty()) {
        for (String[] row : complaints) {
%>
    <tr>
        <td><%= row[0] %></td>
        <td><%= row[1] %></td>
        <td><%= row[2] %></td>
        <td><%= row[3] %></td>
        <td><%= row[4] %></td>
    </tr>
<%
        }
    } else {
%>
    <tr>
        <td colspan="5">Nessun reclamo presente nel sistema.</td>
    </tr>
<%
    }
%>
</table>

</body>
</html>
