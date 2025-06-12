package webapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import oracle.sql.STRUCT;

public class ListAllProducts extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            Connection con = DriverManager.getConnection(url, "system", "oracle");

            String query = "SELECT VALUE(p) FROM Product p";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            sb.append("<table border='1'>");
            sb.append("<tr><th>Serial Number</th><th>Nome</th><th>Categoria</th><th>Data di Scadenza</th></tr>");

            boolean found = false;
            while (rs.next()) {
                found = true;

                STRUCT struct = (STRUCT) rs.getObject(1);
                Object[] attrs = struct.getAttributes();

                String serialNumber = (String) attrs[0];
                String productName = (String) attrs[1];
                String category = (String) attrs[2];
                Timestamp ts = (Timestamp) attrs[3];

                String expiryStr = (ts != null) ? ts.toLocalDateTime().toLocalDate().toString() : "N/A";

                sb.append("<tr>");
                sb.append("<td>").append(serialNumber).append("</td>");
                sb.append("<td>").append(productName).append("</td>");
                sb.append("<td>").append(category).append("</td>");
                sb.append("<td>").append(expiryStr).append("</td>");
                sb.append("</tr>");
            }
            sb.append("</table>");

            if (!found) {
                sb.setLength(0);
                sb.append("<p>Nessun prodotto presente nel database.</p>");
            }

            request.setAttribute("allProductsTable", sb.toString());

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("listAllProducts.jsp").forward(request, response);

        } catch (Exception e) {
            out.println("<p>Errore: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }
}
