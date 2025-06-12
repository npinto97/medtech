package webapp;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class TeamDeliveriesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            Connection con = DriverManager.getConnection(url, "MEDTECH", "medtech");

            String query = "SELECT customerCode, orderID, status, expectedDeliveryDate, teamCode, chiefTaxCode FROM Team_Deliveries_VW";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            sb.append("<table border='1'>");
            sb.append("<tr><th>Codice Cliente</th><th>ID Ordine</th><th>Stato</th><th>Data Consegna Prevista</th><th>Codice Team</th><th>Codice Chief</th></tr>");

            boolean found = false;
            while (rs.next()) {
                found = true;
                sb.append("<tr>");
                sb.append("<td>").append(rs.getString("customerCode")).append("</td>");

                // Leggi orderID come stringa per evitare problemi di conversione
                sb.append("<td>").append(rs.getString("orderID")).append("</td>");

                sb.append("<td>").append(rs.getString("status")).append("</td>");

                // Controllo null sulle date
                Date expectedDate = rs.getDate("expectedDeliveryDate");
                sb.append("<td>").append(expectedDate != null ? expectedDate.toString() : "N/A").append("</td>");

                sb.append("<td>").append(rs.getString("teamCode")).append("</td>");
                sb.append("<td>").append(rs.getString("chiefTaxCode")).append("</td>");
                sb.append("</tr>");
            }
            sb.append("</table>");

            if (!found) {
                sb.setLength(0);
                sb.append("<p>Nessuna consegna trovata.</p>");
            }

            request.setAttribute("teamDeliveriesTable", sb.toString());

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("teamDeliveries.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Errore nel recupero consegne", e);
        }
    }
}
