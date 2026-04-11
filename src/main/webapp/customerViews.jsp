<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-07
  Time: 7:29 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.demo.ConnectionDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Room Statistics</title>
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
        table {
            width: 100%;
            max-width: 700px;
            margin: 0 auto 2rem auto;
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

    </style>
</head>
<body>

<h1>Room Statistics</h1>
<a class="back" href="customerDashboard.jsp"> Back to Dashboard</a>

<%
    ConnectionDB db = new ConnectionDB();
    Connection con = db.getConnection();
%>

<!-- View 1: Available Rooms Per Area -->
<h2>Available Rooms Per Area</h2>
<table>
    <thead>
    <tr>
        <th>Area (Hotel Address)</th>
        <th>Available Rooms</th>
    </tr>
    </thead>
    <tbody>
    <%
        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery("SELECT * FROM RoomsPerArea");
        while (rs1.next()) {
    %>
    <tr>
        <td><%= rs1.getString("address") %></td>
        <td><%= rs1.getInt("total_rooms") %></td>
    </tr>
    <%
        }
        rs1.close();
        st1.close();
    %>
    </tbody>
</table>

<!-- View 2: Hotel Capacity -->
<h2>Total Capacity Per Hotel</h2>
<table>
    <thead>
    <tr>
        <th>Hotel ID</th>
        <th>Total Capacity</th>
    </tr>
    </thead>
    <tbody>
    <%
        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery("SELECT * FROM HotelCapacity");
        while (rs2.next()) {
    %>
    <tr>
        <td><%= rs2.getInt("hotel_id") %></td>
        <td><%= rs2.getInt("total_capacity") %></td>
    </tr>
    <%
        }
        rs2.close();
        st2.close();
        db.close();
    %>
    </tbody>
</table>

</body>
</html>
