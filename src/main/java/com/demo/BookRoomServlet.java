package com.demo;
import com.demo.Booking;
import com.demo.Room;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/BookRoomServlet")
public class BookRoomServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("hotelId=" + request.getParameter("hotelId"));
        System.out.println("roomNumber=" + request.getParameter("roomNumber"));
        System.out.println("checkin=" + request.getParameter("checkin"));
        System.out.println("checkout=" + request.getParameter("checkout"));
        System.out.println("guests=" + request.getParameter("guests"));
        try {
            int userId = (Integer) request.getSession().getAttribute("userID");

            int hotelId = Integer.parseInt(request.getParameter("hotelId"));
            int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
            int guests = Integer.parseInt(request.getParameter("guests"));

            // CONVERT STRING TO DATE
            Date startDate = Date.valueOf(request.getParameter("checkin"));
            Date endDate = Date.valueOf(request.getParameter("checkout"));

            // INSERT BOOKING
            Booking.insertBooking(startDate, endDate, hotelId, roomNumber, userId);

            //INSERT IN PAYMENT

            response.sendRedirect("customerDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}