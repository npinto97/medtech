package webapp;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ListChiefOrders extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String taxCode = request.getParameter("taxcode");

        if (taxCode == null || taxCode.trim().isEmpty()) {
            out.println("<p>Errore: è necessario fornire un codice fiscale (taxcode).</p>");
            return;
        }

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521/orcl", "system", "oracle");

            String query = 
                "SELECT c.code, o.orderID, o.orderDate, o.expectedDeliveryDate, o.status " +
                "FROM Customer c, TABLE(c.orders) o, LogisticsTeam lt " +
                "WHERE lt.chief.taxCode = ? AND o.managedBy = REF(lt)";

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, taxCode);
            ResultSet rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            sb.append("<table border='1'>");
            sb.append("<tr><th>Codice Cliente</th><th>ID Ordine</th><th>Data Ordine</th>")
              .append("<th>Data Consegna Prevista</th><th>Stato</th></tr>");

            boolean found = false;
            while (rs.next()) {
                found = true;

                String customerCode = rs.getString(1);
                String orderId = rs.getString(2);
                Timestamp orderDate = rs.getTimestamp(3);
                Timestamp deliveryDate = rs.getTimestamp(4);
                String status = rs.getString(5);

                sb.append("<tr>")
                  .append("<td>").append(customerCode).append("</td>")
                  .append("<td>").append(orderId).append("</td>")
                  .append("<td>").append(orderDate.toString().substring(0, 10)).append("</td>")
                  .append("<td>").append(deliveryDate.toString().substring(0, 10)).append("</td>")
                  .append("<td>").append(status).append("</td>")
                  .append("</tr>");
            }

            sb.append("</table>");

            if (!found) {
                sb.setLength(0);
                sb.append("<p>Nessun ordine trovato per il ChiefLogisticsOfficer con codice fiscale: ").append(taxCode).append("</p>");
            }

            request.setAttribute("chiefOrders", sb.toString());

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("chiefOrders.jsp").forward(request, response);

        } catch (Exception e) {
            out.println("<p>Errore: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }
}
