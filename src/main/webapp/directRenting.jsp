<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-10
  Time: 1:19 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Room" %>
<%@ page import="com.demo.Customer" %>
<!DOCTYPE html>
<html>
<head>
  <title>Direct Renting</title>
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
      max-width: 600px;
      margin: 0 auto 2rem auto;
    }
    label { color: #0e1130; font-weight: bold; display: block; margin-bottom: 4px; }
    input, select {
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
    .btn:hover { background: #0e1130; }
    .success { color: green; text-align: center; margin-bottom: 1rem; }
    .error { color: red; text-align: center; margin-bottom: 1rem; }
    .section-title {
      color: #355099;
      border-bottom: 1px solid #c1d6f5;
      padding-bottom: 6px;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body>

<%
  String message = request.getParameter("message");
  String error = request.getParameter("error");

  List<Room> availableRooms = null;
  List<Customer> customers = null;
  try {
    availableRooms = Room.getAvailableRooms();
    customers = Customer.getCustomers();
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

<h1>Direct Renting</h1>
<a class="back" href="employeeDashboard.jsp">Back to Dashboard</a>

<% if (message != null) { %><p class="success"><%= message %></p><% } %>
<% if (error != null) { %><p class="error"><%= error %></p><% } %>

<div class="card">
  <form method="post" action="DirectRentingServlet">

    <h2 class="section-title">Select Customer</h2>
    <p style="color:#355099; font-size:13px;">If walk-in customer is not registered, add them in Manage Customers first.</p>

    <label>Customer</label>
    <select name="custId">
      <% if (customers != null) { for (Customer c : customers) { %>
      <option value="<%= c.getcustomerid() %>">
        #<%= c.getcustomerid() %> — <%= c.getFirstName() %> <%= c.getLastName() %>
      </option>
      <% } } %>
    </select>

    <h2 class="section-title">Select Room</h2>

    <label>Available Room</label>
    <select name="hotelIdRoom">
      <% if (availableRooms != null) { for (Room r : availableRooms) { %>
      <option value="<%= r.getHotelId() %>_<%= r.getRoomNumber() %>">
        Hotel <%= r.getHotelId() %> — Room <%= r.getRoomNumber() %>
        (Capacity: <%= r.getCapacity() %>, $<%= r.getPrice() %>, <%= r.getView() %> view)
      </option>
      <% } } %>
    </select>

    <h2 class="section-title">Renting Dates</h2>

    <label>Start Date</label>
    <input type="date" name="startDate" required />

    <label>End Date</label>
    <input type="date" name="endDate" required />

    <input type="hidden" name="employeeSSN" value="1"> <!-- TEMP: hardcoded SSN -->

    <button type="submit" class="btn">Confirm Renting</button>
  </form>
</div>

</body>
</html>
