package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/HotelServlet")
public class HotelServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action.equals("insert")) {
                String address = request.getParameter("address");
                double rating = Double.parseDouble(request.getParameter("rating"));
                int chainId = Integer.parseInt(request.getParameter("chainId"));
                Hotel.insertHotel(address, rating, chainId);
                response.sendRedirect("manageHotels.jsp?message=Hotel+added+successfully!");
            } else if (action.equals("update")) {
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                String address = request.getParameter("address");
                double rating = Double.parseDouble(request.getParameter("rating"));
                int chainId = Integer.parseInt(request.getParameter("chainId"));
                Hotel.updateHotel(hotelId, address, rating, chainId);
                response.sendRedirect("manageHotels.jsp?message=Hotel+updated+successfully!");
            } else if (action.equals("delete")) {
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                Hotel.deleteHotel(hotelId);
                response.sendRedirect("manageHotels.jsp?message=Hotel+deleted+successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageHotels.jsp?error=Cannot+delete+hotel:+employees+are+still+assigned+to+it.+Reassign+or+delete+those+employees+first.");
        }
    }
}