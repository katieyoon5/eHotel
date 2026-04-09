<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-07
  Time: 7:47 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.demo.ConnectionDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Insert Payment</title>
    <style>
        body {
            min-height: 100vh;
            background: #c1d6f5;
            font-family: Arial;
            padding: 2rem;
            margin: 0;
        }
        h1 { color: #0e1130; text-align: center; }
        .back { display: block; text-align: center; margin-bottom: 1rem; color: #355099; }
        .card {
            background: white;
            border-radius: 12px;
            border: 1px solid #c1d6f5;
            padding: 1.5rem;
            max-width: 500px;
            margin: 0 auto;
        }
        label { color: #0e1130; font-weight: bold; display: block; margin-bottom: 4px; }
        select, input {
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
        .btn:hover { background: #355099; }
        .success { color: green; text-align: center; margin-bottom: 1rem; }
        .error { color: red; text-align: center; margin-bottom: 1rem; }
    </style>
</head>
<body>

<h1>Insert Payment</h1>
<a class="back" href="employeeDashboard.jsp"> Back to Dashboard</a>

<%
    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>

<% if (message != null) { %><p class="success"><%= message %></p><% } %>
<% if (error != null) { %><p class="error"><%= error %></p><% } %>

<div class="card">
    <form method="post" action="PaymentServlet">

        <label>Select Renting</label>
        <select name="rentId">
            <%
                ConnectionDB db = new ConnectionDB();
                Connection con = db.getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(
                        "SELECT r.Rent_ID, c.FirstName, c.LastName, r.Start_Date, r.End_Date " +
                                "FROM Renting r JOIN Customer c ON r.Cust_ID = c.Cust_ID " +
                                "ORDER BY r.Start_Date"
                );
                while (rs.next()) {
            %>
            <option value="<%= rs.getInt("Rent_ID") %>">
                #<%= rs.getInt("Rent_ID") %> — <%= rs.getString("FirstName") %> <%= rs.getString("LastName") %>
                (<%= rs.getString("Start_Date") %> to <%= rs.getString("End_Date") %>)
            </option>
            <%
                }
                rs.close();
                st.close();
                db.close();
            %>
        </select>

        <label>Payment Amount ($)</label>
        <input type="number" name="amount" min="0.01" step="0.01" required />

        <button type="submit" class="btn">Submit Payment</button>
    </form>
</div>

</body>
</html>
