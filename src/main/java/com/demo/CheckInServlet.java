package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CheckInServlet")
public class CheckInServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int employeeSSN = Integer.parseInt(request.getParameter("employeeSSN"));

        try {
            Booking.convertToRenting(bookId, employeeSSN);
            response.sendRedirect("checkIn.jsp?message=Customer+checked+in+successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkIn.jsp?error=Error+checking+in+customer:+" + e.getMessage());
        }
    }
}