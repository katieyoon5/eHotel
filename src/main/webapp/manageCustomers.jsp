<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-10
  Time: 11:29 a.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Customer" %>
<%@ page import="java.sql.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customers</title>
    <style>
        body {
            min-height: 100vh;
            background: #c1d6f5;
            font-family: Arial;
            padding: 2rem;
            margin: 0;
        }
        h1, h2 { color: #0e1130; text-align: center; }
        .back { display: block; text-align: center; margin-bottom: 1rem; color: #355099; }
        .card {
            background: white;
            border-radius: 12px;
            border: 1px solid #c1d6f5;
            padding: 1.5rem;
            max-width: 500px;
            margin: 0 auto 2rem auto;
        }
        label { color: #0e1130; font-weight: bold; display: block; margin-bottom: 4px; }
        input {
            width: 100%;
            padding: 10px;
            margin-bottom: 1rem;
            border-radius: 8px;
            border: 1px solid #c1d6f5;
            box-sizing: border-box;
            color: #0e1130;
        }
        .btn {
            background: #355099;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        .btn:hover { background: #566ba3; }
        .btn-delete {
            background: #355099;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            cursor: pointer;
        }
        .btn-edit {
            background: #355099;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            cursor: pointer;
        }
        table {
            width: 100%;
            max-width: 1100px;
            margin: 0 auto 2rem auto;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }
        th {
            background: #c1d6f5;
            color: #0e1130;
            padding: 12px;
            text-align: left;
        }
        td { padding: 12px; border-bottom: 1px solid #c1d6f5; color: #0e1130; }
        tr:hover { background: #c1d6f5; }
        .success { color: green; text-align: center; margin-bottom: 1rem; }
        .error { color: red; text-align: center; margin-bottom: 1rem; }
    </style>
</head>
<body>

<%
    String message = request.getParameter("message");
    String error = request.getParameter("error");
    String editId = request.getParameter("editId");

    Customer editCustomer = null;
    if (editId != null) {
        try {
            editCustomer = Customer.getCustomerById(Integer.parseInt(editId));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    List<Customer> customers = null;
    try {
        customers = Customer.getCustomers();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<h1>Manage Customers</h1>
<a class="back" href="employeeDashboard.jsp"> Back to Dashboard</a>

<% if (message != null) { %><p class="success"><%= message %></p><% } %>
<% if (error != null) { %><p class="error"><%= error %></p><% } %>

<div class="card">
    <% if (editCustomer != null) { %>
    <h2>Edit Customer #<%= editCustomer.getcustomerid() %></h2>
    <form method="post" action="CustomerServlet">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="custId" value="<%= editCustomer.getcustomerid() %>">

        <label>First Name</label>
        <input type="text" name="firstName" value="<%= editCustomer.getFirstName() %>" required />

        <label>Middle Name</label>
        <input type="text" name="middleName" value="<%= editCustomer.getMiddleName() != null ? editCustomer.getMiddleName() : "" %>" />

        <label>Last Name</label>
        <input type="text" name="lastName" value="<%= editCustomer.getLastName() %>" required />

        <label>Address</label>
        <input type="text" name="address" value="<%= editCustomer.getAddress() %>" required />

        <label>Username</label>
        <input type="text" name="username" value="<%= editCustomer.getUsername() != null ? editCustomer.getUsername() : "" %>" />

        <label>Password</label>
        <input type="password" name="password" value="<%= editCustomer.getPassword() != null ? editCustomer.getPassword() : "" %>" />

        <button type="submit" class="btn">Update Customer</button>
    </form>
    <% } else { %>
    <h2>Add New Customer</h2>
    <form method="post" action="CustomerServlet">
        <input type="hidden" name="action" value="insert">

        <label>First Name</label>
        <input type="text" name="firstName" required />

        <label>Middle Name</label>
        <input type="text" name="middleName" />

        <label>Last Name</label>
        <input type="text" name="lastName" required />

        <label>Address</label>
        <input type="text" name="address" required />

        <label>Username</label>
        <input type="text" name="username" placeholder="optional" />

        <label>Password</label>
        <input type="password" name="password" placeholder="optional" />

        <button type="submit" class="btn">Add Customer</button>
    </form>
    <% } %>
</div>

<h2>All Customers</h2>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Address</th>
        <th>Registration Date</th>
        <th>Username</th>
        <th>Edit</th>
        <th>Delete</th>
    </tr>
    </thead>
    <tbody>
    <% if (customers != null) { for (Customer c : customers) { %>
    <tr>
        <td><%= c.getcustomerid() %></td>
        <td><%= c.getFirstName() %></td>
        <td><%= c.getLastName() %></td>
        <td><%= c.getAddress() %></td>
        <td><%= c.getRegistrationDate() %></td>
        <td><%= c.getUsername() != null ? c.getUsername() : "-" %></td>
        <td>
            <a href="manageCustomers.jsp?editId=<%= c.getcustomerid() %>">
                <button class="btn-edit">Edit</button>
            </a>
        </td>
        <td>
            <form method="post" action="CustomerServlet">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="custId" value="<%= c.getcustomerid() %>">
                <button type="submit" class="btn-delete"
                        onclick="return confirm('Delete customer <%= c.getcustomerid() %>?')">
                    Delete
                </button>
            </form>
        </td>
    </tr>
    <% } } %>
    </tbody>
</table>

</body>
</html>