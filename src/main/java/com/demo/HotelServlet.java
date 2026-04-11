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
        String hotelIdParam = request.getParameter("hotelId");

        try {
            if (action.equals("insert")) {
                String address = request.getParameter("address");
                double rating = Double.parseDouble(request.getParameter("rating"));
                int chainId = Integer.parseInt(request.getParameter("chainId"));
                Hotel.insertHotel(address, rating, chainId);
                response.sendRedirect("manageHotels.jsp?message=Hotel+added+successfully!");

            } else if (action.equals("update")) {
                int hotelId = Integer.parseInt(hotelIdParam);
                String address = request.getParameter("address");
                double rating = Double.parseDouble(request.getParameter("rating"));
                int chainId = Integer.parseInt(request.getParameter("chainId"));
                Hotel.updateHotel(hotelId, address, rating, chainId);
                response.sendRedirect("manageHotels.jsp?editId=" + hotelId + "&message=Hotel+updated+successfully!");

            } else if (action.equals("delete")) {
                int hotelId = Integer.parseInt(hotelIdParam);
                Hotel.deleteHotel(hotelId);
                response.sendRedirect("manageHotels.jsp?message=Hotel+deleted+successfully!");

            } else if (action.equals("addPhone")) {
                int hotelId = Integer.parseInt(hotelIdParam);
                String phone = request.getParameter("phone");
                Hotel.addPhone(hotelId, phone);
                response.sendRedirect("manageHotels.jsp?editId=" + hotelId + "&message=Phone+added!");

            } else if (action.equals("deletePhone")) {
                int hotelId = Integer.parseInt(hotelIdParam);
                String phone = request.getParameter("phone");
                Hotel.deletePhone(hotelId, phone);
                response.sendRedirect("manageHotels.jsp?editId=" + hotelId + "&message=Phone+deleted!");

            } else if (action.equals("addEmail")) {
                int hotelId = Integer.parseInt(hotelIdParam);
                String email = request.getParameter("email");
                Hotel.addEmail(hotelId, email);
                response.sendRedirect("manageHotels.jsp?editId=" + hotelId + "&message=Email+added!");

            } else if (action.equals("deleteEmail")) {
                int hotelId = Integer.parseInt(hotelIdParam);
                String email = request.getParameter("email");
                Hotel.deleteEmail(hotelId, email);
                response.sendRedirect("manageHotels.jsp?editId=" + hotelId + "&message=Email+deleted!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageHotels.jsp?error=Error:+" + e.getMessage());
        }
    }
}