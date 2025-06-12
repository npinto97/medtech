package webapp;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.math.BigDecimal;


public class ExpiredBatches extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/orcl", "system", "oracle");

            String query = "SELECT VALUE(b) FROM Batch_TABLE b WHERE b.productref.expiryDate < SYSDATE";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            sb.append("<table border='1'>");
            sb.append("<tr><th>ID Batch</th><th>Quantità</th><th>Data Arrivo</th><th>Prodotto</th><th>Scadenza</th></tr>");

            boolean found = false;
            while (rs.next()) {
                found = true;

                Struct struct = (Struct) rs.getObject(1);
                Object[] attrs = struct.getAttributes();

                String idBatch = (String) attrs[0];
                int quantita = ((BigDecimal) attrs[1]).intValue();
                Timestamp dataArrivo = (Timestamp) attrs[2];

                Struct prodotto = (Struct) attrs[3];
                Object[] prodAttrs = prodotto.getAttributes();
                String nomeProdotto = (String) prodAttrs[1];
                Timestamp scadenza = (Timestamp) prodAttrs[3];

                sb.append("<tr>")
                  .append("<td>").append(idBatch).append("</td>")
                  .append("<td>").append(quantita).append("</td>")
                  .append("<td>").append(dataArrivo.toString().substring(0, 10)).append("</td>")
                  .append("<td>").append(nomeProdotto).append("</td>")
                  .append("<td>").append(scadenza.toString().substring(0, 10)).append("</td>")
                  .append("</tr>");
            }

            sb.append("</table>");

            if (!found) {
                sb.setLength(0);
                sb.append("<p>Nessun batch scaduto trovato.</p>");
            }

            request.setAttribute("expiredBatches", sb.toString());

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("expiredBatches.jsp").forward(request, response);

        } catch (Exception e) {
            out.println("<p>Errore: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }
}
