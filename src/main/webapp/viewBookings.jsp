<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Room" %>
<%@ page import="com.demo.Customer" %>
<%@ page import="com.demo.Booking" %>
<%
    Integer userID = (Integer) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Customer customer = null;
    customer = Customer.getCustomerById(userID);

    List<Booking> bookings = null;

    try {
        bookings = Booking.getBookingByCustId(userID);
    } catch (Exception e) {
        e.printStackTrace();

    }
%>

<p>UserID: <%= userID %></p>

<!DOCTYPE html>
<html>
<head>
  <title>View Bookings</title>
  <style>
    body {
      min-height: 100vh;
      background: #c1d6f5;
      font-family: Arial, sans-serif;
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
    h1, h2 { color: #0e1130; text-align: center; }
    .back { display: block; text-align: center; margin-bottom: 1rem; color: #566ba3; }
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
    .btn:hover { background: #355099; }
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
      max-width: 900px;
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
    .back { display: block; text-align: center; margin-bottom: 1rem; color: #355099; }
  </style>
</head>
<body>

<div class="topbar">
    <a href="logout.jsp" class="logout">Logout</a>
</div>

<div class="header">
    <h1>Welcome, <%= customer.getFirstName() %>!</h1>
    <p>View your Booked Rooms</p>
</div>
<a class="back" href="customerDashboard.jsp"> Back to Dashboard</a>


<!-- BOOKED TABLE -->
<h2>Booked Rooms</h2>
 <table>
  <thead>
  <tr>
    <th>Hotel Chain</th>
    <th>Hotel Address</th>
    <th>Start Date</th>
    <th>End Date</th>
    <th>Room Number</th>
    <th>Delete</th>
  </tr>
  </thead>
  <tbody>
  <%
  if (bookings != null && !bookings.isEmpty()) {
      for (Booking b : bookings) {
  %>
  <tr>
        <td><%= b.getChainAddress() %></td>
        <td><%= b.getHotelAddress() %></td>
        <td><%= b.getStartDate() %></td>
        <td><%= b.getEndDate() %></td>
        <td><%= b.getRoomNumber() %></td>

        <td>
        <%
            java.util.Date today = new java.util.Date();
            java.util.Date endDate = b.getEndDate();

            boolean canDelete = endDate.after(today);
            %>

            <% if (canDelete) { %>
            <form method="post" action="BookingServlet">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="bookId" value="<%= b.getBookId() %>">

                <button type="submit" class="btn-delete"
                    onclick="return confirm('Delete booking <%= b.getBookId() %>?')">
                    Delete
                </button>
            </form>
            <% } else { %>
            <span style="color:gray;">Locked</span>
            <% } %>
        </td>
  </tr>
  <%
      }
  } else {
  %>
  <tr>
      <td colspan="7" style="text-align:center;">No bookings found</td>
  </tr>
  <%
  }
  %>
  </tbody>
</table>
</body>
</html>