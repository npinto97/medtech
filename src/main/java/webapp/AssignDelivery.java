package webapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import oracle.jdbc.OracleTypes;

public class AssignDelivery extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String teamID = request.getParameter("teamID");

        if (teamID == null || teamID.trim().isEmpty()) {
            out.println("<p>Errore: Il parametro teamID deve essere fornito.</p>");
            return;
        }

        Connection con = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            con = DriverManager.getConnection(url, "system", "oracle");

            // Chiamata alla funzione che ritorna SYS_REFCURSOR
            String call = "{ ? = call get_team_deliveries(?) }";
            cs = con.prepareCall(call);

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.setString(2, teamID);

            cs.execute();

            rs = (ResultSet) cs.getObject(1);

            out.println("<h2>Risultati consegne per team " + teamID + ":</h2>");
            out.println("<table border='1'>");
            out.println("<tr><th>Customer Code</th><th>Order ID</th><th>Status</th><th>Expected Delivery</th></tr>");

            while (rs.next()) {
                String customerCode = rs.getString("customerCode");
                String orderID = rs.getString("orderID");
                String status = rs.getString("status");
                Date expectedDelivery = rs.getDate("expectedDeliveryDate");

                out.println("<tr>");
                out.println("<td>" + customerCode + "</td>");
                out.println("<td>" + orderID + "</td>");
                out.println("<td>" + status + "</td>");
                out.println("<td>" + (expectedDelivery != null ? expectedDelivery.toString() : "") + "</td>");
                out.println("</tr>");
            }

            out.println("</table>");

        } catch (SQLException | ClassNotFoundException e) {
            out.println("<p>Errore durante la lettura delle consegne: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (cs != null) cs.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
