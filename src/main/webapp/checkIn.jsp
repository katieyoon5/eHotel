<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Booking" %>
<!DOCTYPE html>
<html>
<head>
    <title>Check In</title>
    <style>
        body {
            min-height: 100vh;
            background: #c1d6f5;
            font-family: Arial;
            padding: 2rem;
            margin: 0;
        }
        h1 { color: #0e1130; text-align: center; }
        .back { display: block; text-align: center; margin-bottom: 1rem; color: #566ba3; }
        table {
            width: 100%;
            max-width: 900px;
            margin: 0 auto;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }
        th {
            background: #355099;
            color: #0e1130;
            padding: 12px;
            text-align: left;
        }
        td { padding: 12px; border-bottom: 1px solid #c1d6f5; color: #0e1130; }
        tr:hover { background: #c1d6f5; }
        .btn {
            background: #355099;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
        }
        .btn:hover { background: #1e3a7a; }
        .success { color: green; text-align: center; margin-bottom: 1rem; }
        .error { color: red; text-align: center; margin-bottom: 1rem; }
    </style>
</head>
<body>

<%
    String user = (String) session.getAttribute("user");
    if (user == null || !user.equals("employee")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    Integer userID = (Integer) session.getAttribute("userID");

    String message = request.getParameter("message");
    String error = request.getParameter("error");

    List<Booking> bookings = null;
    try {
        bookings = Booking.getAllBookings();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<h1>Check In a Customer</h1>
<a class="back" href="employeeDashboard.jsp"> Back to Dashboard</a>

<% if (message != null) { %><p class="success"><%= message %></p><% } %>
<% if (error != null) { %><p class="error"><%= error %></p><% } %>

<% if (bookings == null || bookings.isEmpty()) { %>
<p style="text-align:center; color:#355099;">No current bookings found.</p>
<% } else { %>
<table>
    <thead>
    <tr>
        <th>Booking ID</th>
        <th>Customer</th>
        <th>Hotel ID</th>
        <th>Room</th>
        <th>Start Date</th>
        <th>End Date</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <% for (Booking b : bookings) { %>
    <tr>
        <td><%= b.bookId %></td>
        <td><%= b.customerName %></td>
        <td><%= b.hotelId %></td>
        <td><%= b.roomNumber %></td>
        <td><%= b.startDate %></td>
        <td><%= b.endDate %></td>
        <td>
            <form method="post" action="CheckInServlet">
                <input type="hidden" name="bookId" value="<%= b.bookId %>">
                <input type="hidden" name="employeeSSN" value="<%= userID %>">
                <button type="submit" class="btn">Check In</button>
            </form>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>
<% } %>

</body>
</html>