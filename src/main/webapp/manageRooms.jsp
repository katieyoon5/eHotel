<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-10
  Time: 12:47 a.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Room" %>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Rooms</title>
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
  String editHotelId = request.getParameter("editHotelId");
  String editRoomNumber = request.getParameter("editRoomNumber");

  Room editRoom = null;
  if (editHotelId != null && editRoomNumber != null) {
    try {
      editRoom = Room.getRoomById(Integer.parseInt(editHotelId), Integer.parseInt(editRoomNumber));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  List<Room> rooms = null;
  try {
    rooms = Room.getAllRooms();
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

<h1>Manage Rooms</h1>
<a class="back" href="employeeDashboard.jsp"> Back to Dashboard</a>

<% if (message != null) { %><p class="success"><%= message %></p><% } %>
<% if (error != null) { %><p class="error"><%= error %></p><% } %>

<div class="card">
  <% if (editRoom != null) { %>
  <h2>Edit Room <%= editRoom.getRoomNumber() %> (Hotel <%= editRoom.getHotelId() %>)</h2>
  <form method="post" action="RoomServlet">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="hotelId" value="<%= editRoom.getHotelId() %>">
    <input type="hidden" name="roomNumber" value="<%= editRoom.getRoomNumber() %>">

    <label>Price ($)</label>
    <input type="number" name="price" value="<%= editRoom.getPrice() %>" required />

    <label>Capacity</label>
    <input type="number" name="capacity" value="<%= editRoom.getCapacity() %>" required />

    <label>View</label>
    <select name="view">
      <option value="sea" <%= "sea".equals(editRoom.getView()) ? "selected" : "" %>>Sea</option>
      <option value="mountain" <%= "mountain".equals(editRoom.getView()) ? "selected" : "" %>>Mountain</option>
    </select>

    <label>Extendable</label>
    <select name="extendable">
      <option value="true" <%= editRoom.getExtendable() ? "selected" : "" %>>Yes</option>
      <option value="false" <%= !editRoom.getExtendable() ? "selected" : "" %>>No</option>
    </select>

    <button type="submit" class="btn">Update Room</button>
  </form>
  <% } else { %>
  <h2>Add New Room</h2>
  <form method="post" action="RoomServlet">
    <input type="hidden" name="action" value="insert">

    <label>Hotel ID</label>
    <input type="number" name="hotelId" required />

    <label>Chain ID</label>
    <input type="number" name="chainId" required />

    <label>Room Number</label>
    <input type="number" name="roomNumber" required />

    <label>Price ($)</label>
    <input type="number" name="price" required />

    <label>Capacity</label>
    <input type="number" name="capacity" required />

    <label>View</label>
    <select name="view">
      <option value="sea">Sea</option>
      <option value="mountain">Mountain</option>
    </select>

    <label>Extendable</label>
    <select name="extendable">
      <option value="true">Yes</option>
      <option value="false">No</option>
    </select>

    <button type="submit" class="btn">Add Room</button>
  </form>
  <% } %>
</div>

<h2>All Rooms</h2>
<table>
  <thead>
  <tr>
    <th>Hotel ID</th>
    <th>Room #</th>
    <th>Chain ID</th>
    <th>Price</th>
    <th>Capacity</th>
    <th>View</th>
    <th>Extendable</th>
    <th>Edit</th>
    <th>Delete</th>
  </tr>
  </thead>
  <tbody>
  <% if (rooms != null) { for (Room r : rooms) { %>
  <tr>
    <td><%= r.getHotelId() %></td>
    <td><%= r.getRoomNumber() %></td>
    <td><%= r.getChainId() %></td>
    <td>$<%= r.getPrice() %></td>
    <td><%= r.getCapacity() %></td>
    <td><%= r.getView() %></td>
    <td><%= r.getExtendable() ? "Yes" : "No" %></td>
    <td>
      <a href="manageRooms.jsp?editHotelId=<%= r.getHotelId() %>&editRoomNumber=<%= r.getRoomNumber() %>">
        <button class="btn-edit">Edit</button>
      </a>
    </td>
    <td>
      <form method="post" action="RoomServlet">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="hotelId" value="<%= r.getHotelId() %>">
        <input type="hidden" name="roomNumber" value="<%= r.getRoomNumber() %>">
        <button type="submit" class="btn-delete"
                onclick="return confirm('Delete room <%= r.getRoomNumber() %>?')">
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