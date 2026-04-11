<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.demo.Customer" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard</title>
    <style>
        body {
            min-height: 100vh;
            background: #c1d6f5;
            font-family: Arial;
            padding: 2rem;
            margin: 0;
            box-sizing: border-box;
        }
        .topbar {
            display: flex;
            justify-content: flex-end;
            max-width: 1200px;
            margin: 0 auto 1rem;
        }
        .logout {
            background: white;
            border: 1px solid #355099;
            border-radius: 12px;
            padding: 0.6rem 1.2rem;
            text-decoration: none;
            color: #0e1130;
            font-weight: bold;
            font-size: 14px;
        }
        .logout:hover { background: #c1d6f5; }
        .header {
            text-align: center;
            margin-bottom: 2.5rem;
        }
        .header h1 { font-size: 32px; color: #0e1130; margin: 0 0 6px; }
        .header p { font-size: 18px; color: #355099; margin: 0; }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .card {
            background: white;
            border-radius: 12px;
            border: 1px solid #355099;
            padding: 2rem;
            text-decoration: none;
            display: block;
        }
        .card:hover { background: #c1d6f5; }
        .card-title { color: #0e1130; font-weight: bold; margin: 0 0 8px; font-size: 18px; }
        .card-sub { color: #355099; margin: 0; font-size: 14px; }
    </style>
</head>
<body>
<%
Integer userID = (Integer) session.getAttribute("userID");
if (userID == null) {
    response.sendRedirect("login.jsp");
    return;
}
Customer customer = null;
customer = Customer.getCustomerById(userID);
%>

<p>UserID: <%= userID %></p>

<div class="topbar">
    <a href="logout.jsp" class="logout">Logout</a>
</div>

<div class="header">
    <h1>Welcome, <%= customer.getFirstName() %>!</h1>
    <p>Customer Dashboard</p>
</div>

<div class="grid">
    <a href="searchRooms.jsp" class="card">
        <p class="card-title">Search available rooms</p>
        <p class="card-sub">Search available rooms</p>
    </a>

    <a href="viewBookings.jsp" class="card">
        <p class="card-title">View Bookings</p>
        <p class="card-sub">view or delete past bookings</p>
    </a>
    <a href="customerViews.jsp" class="card">
        <p class="card-title">Room Statistics</p>
        <p class="card-sub">View availability & capacity</p>
    </a>
</div>
</body>
</html>