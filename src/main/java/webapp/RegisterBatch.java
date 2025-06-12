package webapp;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RegisterBatch extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String batchID = request.getParameter("batchID");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String arrivalDate = request.getParameter("arrivalDate"); // formato: YYYY-MM-DD
        String productSN = request.getParameter("productSN");
        String centerName = request.getParameter("centerName");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/orcl", "system", "oracle");

            CallableStatement cs = con.prepareCall("{call register_new_batch(?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?)}");
            cs.setString(1, batchID);
            cs.setInt(2, quantity);
            cs.setString(3, arrivalDate);
            cs.setString(4, productSN);
            cs.setString(5, centerName);

            cs.execute();
            cs.close();
            con.close();

            request.setAttribute("message", "Batch registrato con successo.");
        } catch (SQLException e) {
            request.setAttribute("message", "Errore durante la registrazione del batch: " + e.getMessage());
            e.printStackTrace(out);
        } catch (Exception e) {
            request.setAttribute("message", "Errore generale: " + e.getMessage());
            e.printStackTrace(out);
        }

        request.getRequestDispatcher("registerBatchResult.jsp").forward(request, response);
    }
}
