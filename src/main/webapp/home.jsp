<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
%>


<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
</head>
<body>
    <h1>Benvenuto <%= username %></h1>
    <h2>Ruolo: <%= role %></h2>

    <div class="menu">
        <h3>Menu principale</h3>
        <% if ("admin".equals(role)) { %>
            <a href="registerBatch.jsp">Registra Lotto</a><br>
            <a href="assignDeliveryForm.jsp">Assegna Consegna</a><br>
            <a href="allComplaints">Reclami Clienti (Vista)</a><br>
            <!-- altre funzioni admin -->
        <% } %>

        <% if ("customer".equals(role)) { %>
            <a href="customerOrders">Ordini Clienti (Vista)</a><br>
            <a href="teamDeliveries">Consegne Team (Vista)</a><br>
            <!-- altre funzioni customer -->
        <% } %>

        <a href="logout">Logout</a>
    </div>
</body>
</html>
