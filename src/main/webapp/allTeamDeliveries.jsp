<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Team Deliveries</title>
</head>
<body>
    <h2>Consegne Team</h2>

    <div>
        <%= request.getAttribute("teamDeliveriesTable") != null ? request.getAttribute("teamDeliveriesTable") : "<p>Nessuna consegna disponibile.</p>" %>
    </div>

    <p><a href="index.jsp">Torna alla Home</a></p>
</body>
</html>
