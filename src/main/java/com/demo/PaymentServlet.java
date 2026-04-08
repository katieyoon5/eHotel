package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int rentId = Integer.parseInt(request.getParameter("rentId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        try {
            ConnectionDB db = new ConnectionDB();
            Connection con = db.getConnection();

            String sql = "INSERT INTO Payment (Rent_ID, Amount, Payment_Date) VALUES (?, ?, CURRENT_DATE)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, rentId);
            ps.setDouble(2, amount);
            ps.executeUpdate();
            ps.close();
            db.close();
            response.sendRedirect("payment.jsp?message=Payment+submitted+successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("payment.jsp?error=Error+submitting+payment");
        }
    }
}