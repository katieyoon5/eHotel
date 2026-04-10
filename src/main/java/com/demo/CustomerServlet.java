package com.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action.equals("insert")) {
                String firstName = request.getParameter("firstName");
                String middleName = request.getParameter("middleName");
                String lastName = request.getParameter("lastName");
                String address = request.getParameter("address");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                Customer.insertCustomer(firstName,
                        middleName.isEmpty() ? null : middleName,
                        lastName, address,
                        new Date(System.currentTimeMillis()),
                        username.isEmpty() ? null : username,
                        password.isEmpty() ? null : password);
                response.sendRedirect("manageCustomers.jsp?message=Customer+added+successfully!");

            } else if (action.equals("update")) {
                int custId = Integer.parseInt(request.getParameter("custId"));
                String firstName = request.getParameter("firstName");
                String middleName = request.getParameter("middleName");
                String lastName = request.getParameter("lastName");
                String address = request.getParameter("address");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                Customer editCust = Customer.getCustomerById(custId);
                Customer.updateCustomer(custId, firstName,
                        middleName.isEmpty() ? null : middleName,
                        lastName, address,
                        editCust.getRegistrationDate(),
                        username.isEmpty() ? null : username,
                        password.isEmpty() ? null : password);
                response.sendRedirect("manageCustomers.jsp?message=Customer+updated+successfully!");

            } else if (action.equals("delete")) {
                int custId = Integer.parseInt(request.getParameter("custId"));
                Customer.deleteCustomer(custId);
                response.sendRedirect("manageCustomers.jsp?message=Customer+deleted+successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageCustomers.jsp?error=Error:+" + e.getMessage());
        }
    }
}