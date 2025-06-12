package webapp;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;

public class AllComplaintsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<String[]> complaints = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
        	Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            con = DriverManager.getConnection(url, "system", "oracle");

            String query = "select * from All_Complaints_VW";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            System.out.println("prova 1" );

            while (rs.next()) {
            	System.out.println("prova 2" );
                String[] row = new String[5];
                row[0] = rs.getString("customerCode");
                row[1] = rs.getString("complaintID");
                row[2] = rs.getDate("compliantDate").toString();
                row[3] = rs.getString("reason");
                row[4] = rs.getString("complaintDescription");
                complaints.add(row);
            }

        } catch (Exception e) {
            throw new ServletException("Errore durante l'accesso ai dati dei reclami", e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }

        request.setAttribute("complaintsList", complaints);
        System.out.println("Numero reclami trovati: " + complaints.size());

        request.getRequestDispatcher("allComplaints.jsp").forward(request, response);
    }
}
