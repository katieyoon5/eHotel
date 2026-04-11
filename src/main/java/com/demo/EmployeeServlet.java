package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/EmployeeServlet")
public class EmployeeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action.equals("insert")) {
                String firstName = request.getParameter("firstName");
                String middleName = request.getParameter("middleName");
                String lastName = request.getParameter("lastName");
                String address = request.getParameter("address");
                String role = request.getParameter("role");
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                Employee.insertEmployee(firstName, middleName, lastName, address, role, hotelId, username, password);
                response.sendRedirect("manageEmployees.jsp?message=Employee+added+successfully!");
            } else if (action.equals("update")) {
                int ssn = Integer.parseInt(request.getParameter("ssn"));
                String firstName = request.getParameter("firstName");
                String middleName = request.getParameter("middleName");
                String lastName = request.getParameter("lastName");
                String address = request.getParameter("address");
                String role = request.getParameter("role");
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                Employee.updateEmployee(ssn, firstName, middleName, lastName, address, role, hotelId);
                response.sendRedirect("manageEmployees.jsp?message=Employee+updated+successfull!");

            } else if (action.equals("delete")) {
                int ssn = Integer.parseInt(request.getParameter("ssn"));
                Employee.deleteEmployee(ssn);
                response.sendRedirect("manageEmployees.jsp?message=Employee+deleted+successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageEmployees.jsp?error=Error:+" + e.getMessage());
        }
    }
}