package webapp;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ListProducts extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public class Product {
        public String serialNumber;
        public String productName;
        public String productCategory;
        public Date expiryDate;

        public Product(String serialNumber, String productName, String productCategory, Date expiryDate) {
            this.serialNumber = serialNumber;
            this.productName = productName;
            this.productCategory = productCategory;
            this.expiryDate = expiryDate;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521/orcl";
            con = DriverManager.getConnection(url, "system", "oracle");
            
            String query = "SELECT p.serialNumber, p.productName, p.productCategory, p.expiryDate FROM Product p";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                String serial = rs.getString("serialNumber");
                String name = rs.getString("productName");
                String category = rs.getString("productCategory");
                Date expiry = rs.getDate("expiryDate");

                products.add(new Product(serial, name, category, expiry));
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Errore durante il recupero dei prodotti: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("products", products);
        RequestDispatcher dispatcher = request.getRequestDispatcher("listProducts.jsp");
        dispatcher.forward(request, response);
    }
}
