<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
    <title>MedTech Home</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f9f9f9;
        }
        h1 {
            color: #1976d2;
        }
        .menu a {
            display: block;
            margin: 5px 0;
            color: #1976d2;
            text-decoration: none;
        }
        .menu a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Benvenuto, <%= username %>!</h1>
    <div class="menu">
        <h2>Menu principale</h2>

        <% if ("admin".equals(role)) { %>
            <a href="listAllProducts">Tutti i Prodotti</a>
            <a href="registerBatch.jsp">Registra Lotto</a>
            <a href="placeOrder.jsp">Effettua Ordine</a>
            <a href="assignDeliveryForm.jsp">Assegna Consegna</a>
            <a href="inputChiefTaxCode.jsp">Ordini per ChiefLogisticsOfficer</a>
            <a href="selectExpiryDate.jsp">Lotti Scaduti per Data</a>
            <a href="expiredBatches.jsp">Lotti Scaduti (Vista)</a>
            <a href="customerOrders">Ordini Clienti (Vista)</a>
            <a href="teamDeliveries">Consegne Team (Vista)</a>
            <a href="allComplaints">Reclami Clienti (Vista)</a>
        <% } else if ("customer".equals(role)) { %>
            <a href="placeOrder.jsp">Effettua Ordine</a>
            <a href="customerOrders">I miei Ordini</a>
            <a href="allComplaints">I miei Reclami</a>
        <% } %>

        <a href="logout">Logout</a>
    </div>
</body>
</html>
