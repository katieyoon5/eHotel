package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/HotelChainServlet")
public class HotelChainServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String chainIdParam = request.getParameter("chainId");

        try {
            if (action.equals("insert")) {
                String officeAddress = request.getParameter("officeAddress");
                int numHotels = Integer.parseInt(request.getParameter("numHotels"));
                HotelChain.insertChain(officeAddress, numHotels);
                response.sendRedirect("manageHotelChains.jsp?message=Chain+added+successfully!");

            } else if (action.equals("update")) {
                int chainId = Integer.parseInt(chainIdParam);
                String officeAddress = request.getParameter("officeAddress");
                int numHotels = Integer.parseInt(request.getParameter("numHotels"));
                HotelChain.updateChain(chainId, officeAddress, numHotels);
                response.sendRedirect("manageHotelChains.jsp?editId=" + chainId + "&message=Chain+updated+successfully!");

            } else if (action.equals("delete")) {
                int chainId = Integer.parseInt(chainIdParam);
                HotelChain.deleteChain(chainId);
                response.sendRedirect("manageHotelChains.jsp?message=Chain+deleted+successfully!");

            } else if (action.equals("addPhone")) {
                int chainId = Integer.parseInt(chainIdParam);
                String phone = request.getParameter("phone");
                HotelChain.addPhone(chainId, phone);
                response.sendRedirect("manageHotelChains.jsp?editId=" + chainId + "&message=Phone+added!");

            } else if (action.equals("deletePhone")) {
                int chainId = Integer.parseInt(chainIdParam);
                String phone = request.getParameter("phone");
                HotelChain.deletePhone(chainId, phone);
                response.sendRedirect("manageHotelChains.jsp?editId=" + chainId + "&message=Phone+deleted!");

            } else if (action.equals("addEmail")) {
                int chainId = Integer.parseInt(chainIdParam);
                String email = request.getParameter("email");
                HotelChain.addEmail(chainId, email);
                response.sendRedirect("manageHotelChains.jsp?editId=" + chainId + "&message=Email+added!");

            } else if (action.equals("deleteEmail")) {
                int chainId = Integer.parseInt(chainIdParam);
                String email = request.getParameter("email");
                HotelChain.deleteEmail(chainId, email);
                response.sendRedirect("manageHotelChains.jsp?editId=" + chainId + "&message=Email+deleted!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageHotelChains.jsp?error=Error:+" + e.getMessage());
        }
    }
}