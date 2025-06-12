package webapp;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Debug
        System.out.println("Tentativo di login con username: '" + username + "' e password: '" + password + "'");

        String role = getUserRole(username, password);

        if (role != null) {
            // Login riuscito
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", role);

            System.out.println("Login riuscito! Ruolo: " + role);
            response.sendRedirect("index.jsp");
        } else {
            // Login fallito
            request.setAttribute("errorMessage", "Username o password errati");
            System.out.println("Login fallito per username: " + username);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private String getUserRole(String username, String password) {
        String role = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            con = DriverManager.getConnection(url, "system", "oracle");

            String query = "SELECT role FROM USERS WHERE TRIM(LOWER(username)) = LOWER(TRIM(?)) AND TRIM(password) = TRIM(?)";
            ps = con.prepareStatement(query);
            ps.setString(1, username.trim());
            ps.setString(2, password.trim());

            rs = ps.executeQuery();

            if (rs.next()) {
                role = rs.getString("role");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        return role;
    }
}
