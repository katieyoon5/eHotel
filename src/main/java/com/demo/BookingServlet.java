package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if ("delete".equals(action)) {

                int bookId = Integer.parseInt(request.getParameter("bookId"));

                Booking b = Booking.getBookingById(bookId);

                java.util.Date today = new java.util.Date();

                if (b.getEndDate().before(today)) {
                    // booking already ended THEN do NOT allow delete
                    response.sendRedirect("viewBookings.jsp?error=expired");
                    return;
                }

                Booking.deleteBooking(bookId);

                response.sendRedirect("viewBookings.jsp?success=deleted");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("BookingServlet error: " + e.getMessage());
        }
    }
}