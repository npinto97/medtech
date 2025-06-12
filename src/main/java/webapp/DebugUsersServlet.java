package webapp;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class DebugUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        response.setContentType("text/html;charset=UTF-8");
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            con = DriverManager.getConnection(url, "medtech", "medtech");

            String query = "SELECT username, password, role FROM USERS";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            sb.append("<html><head><title>Debug Users</title>");
            sb.append("<style>");
            sb.append("table {border-collapse: collapse; width: 50%;}");
            sb.append("th, td {border: 1px solid #ccc; padding: 8px; text-align: left;}");
            sb.append("th {background-color: #1976d2; color: white;}");
            sb.append("</style>");
            sb.append("</head><body>");
            sb.append("<h1>Elenco utenti nel database</h1>");
            sb.append("<table>");
            sb.append("<tr><th>Username</th><th>Password</th><th>Ruolo</th></tr>");

            while (rs.next()) {
                sb.append("<tr>");
                sb.append("<td>").append(rs.getString("username")).append("</td>");
                sb.append("<td>").append(rs.getString("password")).append("</td>");
                sb.append("<td>").append(rs.getString("role")).append("</td>");
                sb.append("</tr>");
            }

            sb.append("</table>");
            sb.append("</body></html>");

            response.getWriter().print(sb.toString());

        } catch (Exception e) {
            throw new ServletException("Errore durante il recupero utenti", e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
