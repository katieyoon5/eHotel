package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RoomServlet")
public class RoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action.equals("insert")) {
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                int chainId = Integer.parseInt(request.getParameter("chainId"));
                int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
                float price = Float.parseFloat(request.getParameter("price"));
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                String view = request.getParameter("view");
                boolean extendable = Boolean.parseBoolean(request.getParameter("extendable"));
                Room.insertRoom(hotelId, chainId, roomNumber, price, capacity, view, extendable);
                response.sendRedirect("manageRooms.jsp?message=Room+added+successfully!");

            } else if (action.equals("update")) {
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
                float price = Float.parseFloat(request.getParameter("price"));
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                String view = request.getParameter("view");
                boolean extendable = Boolean.parseBoolean(request.getParameter("extendable"));
                Room.updateRoom(hotelId, roomNumber, price, capacity, view, extendable);
                response.sendRedirect("manageRooms.jsp?message=Room+updated+successfully!");

            } else if (action.equals("delete")) {
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
                Room.deleteRoom(hotelId, roomNumber);
                response.sendRedirect("manageRooms.jsp?message=Room+deleted+successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageRooms.jsp?error=Error:+" + e.getMessage());
        }
    }
}