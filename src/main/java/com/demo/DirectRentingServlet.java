package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DirectRentingServlet")
public class DirectRentingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String[] hotelRoom = request.getParameter("hotelIdRoom").split("_");
            int hotelId = Integer.parseInt(hotelRoom[0]);
            int roomNumber = Integer.parseInt(hotelRoom[1]);
            int custId = Integer.parseInt(request.getParameter("custId"));
            int employeeSSN = Integer.parseInt(request.getParameter("employeeSSN")); // TEMP
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = Date.valueOf(request.getParameter("endDate"));

            ConnectionDB db = new ConnectionDB();
            Connection con = db.getConnection();

            String sql = "INSERT INTO Renting (Start_Date, End_Date, Hotel_ID, RoomNumber, Cust_ID, SSN) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            ps.setInt(3, hotelId);
            ps.setInt(4, roomNumber);
            ps.setInt(5, custId);
            ps.setInt(6, employeeSSN);
            ps.executeUpdate();

            ps.close();
            db.close();

            response.sendRedirect("directRenting.jsp?message=Room+rented+successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("directRenting.jsp?error=Error:+" + e.getMessage());
        }
    }
}