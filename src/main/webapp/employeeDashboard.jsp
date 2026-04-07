<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-06
  Time: 7:30 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Dashboard</title>
</head>
<body>

<%--<%--%>
<%--    String role = (String) session.getAttribute("role");--%>
<%--    if (role == null || !role.equals("employee")) {--%>
<%--        response.sendRedirect("index.jsp");--%>
<%--        return;--%>
<%--    }--%>
<%--    String username = (String) session.getAttribute("username");--%>
<%--%>--%>

<%
    // TEMP: hardcoded session for testing, remove when login is done
    session.setAttribute("role", "employee");
    session.setAttribute("username", "alice");
    String username = (String) session.getAttribute("username");
%>

<h1>Welcome, <%= username %>!</h1>
<h2>Employee Dashboard</h2>

<ul>
    <li><a href="checkIn.jsp">Check In a Customer (Booking → Renting)</a></li>
    <li><a href="directRenting.jsp">Direct Renting (Walk-in Customer)</a></li>
    <li><a href="payment.jsp">Insert Payment</a></li>
    <li><a href="manageHotels.jsp">Manage Hotels</a></li>
    <li><a href="manageRooms.jsp">Manage Rooms</a></li>
    <li><a href="manageEmployees.jsp">Manage Employees</a></li>
    <li><a href="manageCustomers.jsp">Manage Customers</a></li>
    <li><a href="views.jsp">View Room Statistics</a></li>
</ul>

</body>
</html>