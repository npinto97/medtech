package webapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.SimpleDateFormat;

import javax.servlet.*;
import javax.servlet.http.*;

public class ExpiredBatchesByDate extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String inputDate = request.getParameter("expiryDate");

        try {
            // Parsing della data
            java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(inputDate);
            java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());

            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            Connection con = DriverManager.getConnection(url, "system", "oracle");

            String query = """
                SELECT b.batchID, b.quantity, b.arrivalDate, p.productName, p.expiryDate
                FROM Batch_TABLE b, Product p
                WHERE b.productRef = REF(p)
                  AND p.expiryDate IS NOT NULL
                  AND p.expiryDate < ?
            """;

            PreparedStatement ps = con.prepareStatement(query);
            ps.setDate(1, sqlDate);
            ResultSet rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            sb.append("<table border='1'>");
            sb.append("<tr><th>Batch ID</th><th>Quantità</th><th>Data Arrivo</th><th>Prodotto</th><th>Scadenza</th></tr>");

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
                sb.append("<p>Nessun lotto scaduto entro la data specificata.</p>");
            }

            request.setAttribute("expiredTable", sb.toString());

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("expiredByDate.jsp").forward(request, response);

        } catch (Exception e) {
            out.println("<p>Errore: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }
}
