package webapp;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class CustomerOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            Connection con = DriverManager.getConnection(url, "system", "oracle");

            String query = "SELECT customerCode, orderID, status, orderDate, expectedDeliveryDate FROM Customer_Orders_VW";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            sb.append("<table border='1'>");
            sb.append("<tr><th>Codice Cliente</th><th>ID Ordine</th><th>Stato</th><th>Data Ordine</th><th>Data Consegna Prevista</th></tr>");

            boolean found = false;
            while (rs.next()) {
                found = true;
                sb.append("<tr>");
                sb.append("<td>").append(rs.getString("customerCode")).append("</td>");

                // leggi orderID come stringa per evitare errori di conversione
                sb.append("<td>").append(rs.getString("orderID")).append("</td>");

                sb.append("<td>").append(rs.getString("status")).append("</td>");

                // gestisci date null
                Date orderDate = rs.getDate("orderDate");
                sb.append("<td>").append(orderDate != null ? orderDate.toString() : "N/A").append("</td>");

                Date expectedDate = rs.getDate("expectedDeliveryDate");
                sb.append("<td>").append(expectedDate != null ? expectedDate.toString() : "N/A").append("</td>");

                sb.append("</tr>");
            }
            sb.append("</table>");

            if (!found) {
                sb.setLength(0);
                sb.append("<p>Nessun ordine trovato.</p>");
            }

            request.setAttribute("customerOrdersTable", sb.toString());

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("customerOrders.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Errore nel recupero ordini clienti", e);
        }
    }
}
