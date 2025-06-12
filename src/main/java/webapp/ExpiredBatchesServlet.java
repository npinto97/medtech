package webapp;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ExpiredBatchesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            Connection con = DriverManager.getConnection(url, "MEDTECH", "medtech");

            String query = "SELECT batchID, quantity, arrivalDate, productName, expiryDate FROM Expired_Batches_VW";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            sb.append("<table border='1'>");
            sb.append("<tr><th>Batch ID</th><th>Quantità</th><th>Data Arrivo</th><th>Nome Prodotto</th><th>Data Scadenza</th></tr>");

            boolean found = false;
            while (rs.next()) {
                found = true;
                sb.append("<tr>");
                sb.append("<td>").append(rs.getString("batchID")).append("</td>");
                sb.append("<td>").append(rs.getInt("quantity")).append("</td>");
                sb.append("<td>").append(rs.getDate("arrivalDate")).append("</td>");
                sb.append("<td>").append(rs.getString("productName")).append("</td>");
                sb.append("<td>").append(rs.getDate("expiryDate")).append("</td>");
                sb.append("</tr>");
            }
            sb.append("</table>");

            if (!found) {
                sb.setLength(0);
                sb.append("<p>Nessun lotto scaduto trovato.</p>");
            }

            request.setAttribute("expiredBatchesTable", sb.toString());

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("expiredBatches.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Errore nel recupero dati", e);
        }
    }
}
