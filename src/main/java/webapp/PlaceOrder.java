package webapp;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class PlaceOrder extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String customerCode = request.getParameter("customerCode");
        String orderID = request.getParameter("orderID");
        String orderDate = request.getParameter("orderDate");
        String deliveryDate = request.getParameter("deliveryDate");
        String status = request.getParameter("status");
        String[] batchIDs = request.getParameterValues("batchIDs");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/orcl", "system", "oracle");

            StringBuilder batchIdString = new StringBuilder();
            if (batchIDs != null) {
                for (int i = 0; i < batchIDs.length; i++) {
                    if (i > 0) batchIdString.append(",");
                    batchIdString.append(batchIDs[i].trim());
                }
            }
            
            CallableStatement cs = con.prepareCall("{call place_order(?, ?, TO_DATE(?, 'YYYY-MM-DD'), TO_DATE(?, 'YYYY-MM-DD'), ?, ?)}");
            cs.setString(1, customerCode);
            cs.setString(2, orderID);
            cs.setString(3, orderDate);
            cs.setString(4, deliveryDate);
            cs.setString(5, status);
            cs.setString(6, batchIdString.toString());

            cs.execute();
            cs.close();
            con.close();

            request.setAttribute("message", "Ordine inserito con successo.");
        } catch (SQLException e) {
            request.setAttribute("message", "Errore durante l'inserimento dell'ordine: " + e.getMessage());
            e.printStackTrace(out);
        } catch (Exception e) {
            request.setAttribute("message", "Errore generale: " + e.getMessage());
            e.printStackTrace(out);
        }

        request.getRequestDispatcher("placeOrderResult.jsp").forward(request, response);
    }
}
