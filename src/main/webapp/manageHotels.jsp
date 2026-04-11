<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-08
  Time: 3:08 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Hotel" %>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Hotels</title>
  <style>
    body {
      min-height: 100vh;
      background: #c1d6f5;
      font-family: Arial, sans-serif;
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
      margin-bottom: 0.5rem;
    }
    .btn:hover { background: #1e3a7a; }
    .btn-small {
      background: #355099;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 8px;
      cursor: pointer;
      font-size: 13px;
    }
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
    td { padding: 12px; border-bottom: 1px solid #c1d6f5; color: #0e1130; vertical-align: top; }
    tr:hover { background: #eef4ff; }
    .success { color: green; text-align: center; margin-bottom: 1rem; }
    .error { color: red; text-align: center; margin-bottom: 1rem; }
    .tag {
      display: inline-block;
      background: #c1d6f5;
      color: #0e1130;
      border-radius: 8px;
      padding: 3px 8px;
      font-size: 12px;
      margin: 2px;
    }
    .multival-form {
      display: flex;
      gap: 6px;
      margin-top: 6px;
    }
    .multival-form input {
      margin-bottom: 0;
      flex: 1;
    }
  </style>
</head>
<body>

<%
  String user = (String) session.getAttribute("user");
  if (user == null || !user.equals("employee")) {
    response.sendRedirect("index.jsp");
    return;
  }

  String message = request.getParameter("message");
  String error = request.getParameter("error");
  String editId = request.getParameter("editId");

  Hotel editHotel = null;
  if (editId != null) {
    try {
      editHotel = Hotel.getHotelById(Integer.parseInt(editId));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  List<Hotel> hotels = null;
  try {
    hotels = Hotel.getHotels();
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

<h1>Manage Hotels</h1>
<a class="back" href="employeeDashboard.jsp"> Back to Dashboard</a>

<% if (message != null) { %><p class="success"><%= message %></p><% } %>
<% if (error != null) { %><p class="error"><%= error %></p><% } %>

<div class="card">
  <% if (editHotel != null) { %>
  <h2>Edit Hotel #<%= editHotel.getHotelId() %></h2>
  <form method="post" action="HotelServlet">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="hotelId" value="<%= editHotel.getHotelId() %>">

    <label>Address</label>
    <input type="text" name="address" value="<%= editHotel.getAddress() %>" required />

    <label>Rating (1-5)</label>
    <input type="number" name="rating" min="1" max="5" step="0.5" value="<%= editHotel.getRating() %>" required />

    <label>Chain ID</label>
    <input type="number" name="chainId" value="<%= editHotel.getChainId() %>" required />

    <button type="submit" class="btn">Update Hotel</button>
  </form>

  <!-- PHONES -->
  <h2>Phone Numbers</h2>
  <% for (String phone : editHotel.getPhones()) { %>
  <span class="tag"><%= phone %></span>
  <form method="post" action="HotelServlet" style="display:inline;">
    <input type="hidden" name="action" value="deletePhone">
    <input type="hidden" name="hotelId" value="<%= editHotel.getHotelId() %>">
    <input type="hidden" name="phone" value="<%= phone %>">
    <button type="submit" class="btn-delete" style="padding:2px 8px; font-size:11px;">x</button>
  </form>
  <% } %>
  <% if (editHotel.getPhones().isEmpty()) { %><p style="color:#aaa; font-size:13px;">No phones yet</p><% } %>
  <form method="post" action="HotelServlet" class="multival-form">
    <input type="hidden" name="action" value="addPhone">
    <input type="hidden" name="hotelId" value="<%= editHotel.getHotelId() %>">
    <input type="text" name="phone" />
    <button type="submit" class="btn-small">Add</button>
  </form>

  <!-- EMAILS -->
  <h2>Email Addresses</h2>
  <% for (String email : editHotel.getEmails()) { %>
  <span class="tag"><%= email %></span>
  <form method="post" action="HotelServlet" style="display:inline;">
    <input type="hidden" name="action" value="deleteEmail">
    <input type="hidden" name="hotelId" value="<%= editHotel.getHotelId() %>">
    <input type="hidden" name="email" value="<%= email %>">
    <button type="submit" class="btn-delete" style="padding:2px 8px; font-size:11px;">x</button>
  </form>
  <% } %>
  <% if (editHotel.getEmails().isEmpty()) { %><p style="color:#aaa; font-size:13px;">No emails yet</p><% } %>
  <form method="post" action="HotelServlet" class="multival-form">
    <input type="hidden" name="action" value="addEmail">
    <input type="hidden" name="hotelId" value="<%= editHotel.getHotelId() %>">
    <input type="text" name="email" />
    <button type="submit" class="btn-small">Add</button>
  </form>

  <% } else { %>
  <h2>Add New Hotel</h2>
  <form method="post" action="HotelServlet">
    <input type="hidden" name="action" value="insert">

    <label>Address</label>
    <input type="text" name="address" required />

    <label>Rating (1-5)</label>
    <input type="number" name="rating" min="1" max="5" step="0.5"  required />

    <label>Chain ID</label>
    <input type="number" name="chainId" required />

    <button type="submit" class="btn">Add Hotel</button>
  </form>
  <% } %>
</div>

<!-- HOTELS TABLE -->
<h2>All Hotels</h2>
<table>
  <thead>
  <tr>
    <th>Hotel ID</th>
    <th>Address</th>
    <th>Rating</th>
    <th>Chain ID</th>
    <th>Manager SSN</th>
    <th>Phones</th>
    <th>Emails</th>
    <th>Edit</th>
    <th>Delete</th>
  </tr>
  </thead>
  <tbody>
  <% if (hotels != null) { for (Hotel h : hotels) { %>
  <tr>
    <td><%= h.getHotelId() %></td>
    <td><%= h.getAddress() %></td>
    <td><%= h.getRating() %></td>
    <td><%= h.getChainId() %></td>
    <td><%= h.getManagerSsn() %></td>
    <td>
      <% for (String p : h.getPhones()) { %>
      <span class="tag"><%= p %></span>
      <% } %>
      <% if (h.getPhones().isEmpty()) { %><span style="color:#aaa;">none</span><% } %>
    </td>
    <td>
      <% for (String e : h.getEmails()) { %>
      <span class="tag"><%= e %></span>
      <% } %>
      <% if (h.getEmails().isEmpty()) { %><span style="color:#aaa;">none</span><% } %>
    </td>
    <td>
      <a href="manageHotels.jsp?editId=<%= h.getHotelId() %>">
        <button class="btn-edit">Edit</button>
      </a>
    </td>
    <td>
      <form method="post" action="HotelServlet">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="hotelId" value="<%= h.getHotelId() %>">
        <button type="submit" class="btn-delete"
                onclick="return confirm('Delete hotel <%= h.getHotelId() %>?')">
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