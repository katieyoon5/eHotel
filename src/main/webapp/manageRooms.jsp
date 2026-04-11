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
      max-width: 1200px;
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
    .tag-issue {
      display: inline-block;
      background: #c1d6f5;
      color: #355099;
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

<!-- ADD / EDIT FORM -->
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

  <!-- AMENITIES -->
  <h2>Amenities</h2>
  <%
    List<String> amenities = Room.getAmenitiesForRoom(editRoom.getHotelId(), editRoom.getRoomNumber());
    for (String amenity : amenities) {
  %>
  <span class="tag"><%= amenity %></span>
  <form method="post" action="RoomServlet" style="display:inline;">
    <input type="hidden" name="action" value="deleteAmenity">
    <input type="hidden" name="hotelId" value="<%= editRoom.getHotelId() %>">
    <input type="hidden" name="roomNumber" value="<%= editRoom.getRoomNumber() %>">
    <input type="hidden" name="amenity" value="<%= amenity %>">
    <button type="submit" class="btn-delete" style="padding:2px 8px; font-size:11px;">x</button>
  </form>
  <% } %>
  <% if (amenities.isEmpty()) { %><p style="color:#aaa; font-size:13px;">No amenities yet</p><% } %>
  <form method="post" action="RoomServlet" class="multival-form">
    <input type="hidden" name="action" value="addAmenity">
    <input type="hidden" name="hotelId" value="<%= editRoom.getHotelId() %>">
    <input type="hidden" name="roomNumber" value="<%= editRoom.getRoomNumber() %>">
    <input type="text" name="amenity" />
    <button type="submit" class="btn-small">Add</button>
  </form>

  <!-- ISSUES -->
  <h2>Issues</h2>
  <%
    List<String> issues = Room.getIssuesForRoom(editRoom.getHotelId(), editRoom.getRoomNumber());
    for (String issue : issues) {
  %>
  <span class="tag-issue"><%= issue %></span>
  <form method="post" action="RoomServlet" style="display:inline;">
    <input type="hidden" name="action" value="deleteIssue">
    <input type="hidden" name="hotelId" value="<%= editRoom.getHotelId() %>">
    <input type="hidden" name="roomNumber" value="<%= editRoom.getRoomNumber() %>">
    <input type="hidden" name="issue" value="<%= issue %>">
    <button type="submit" class="btn-delete" style="padding:2px 8px; font-size:11px;">x</button>
  </form>
  <% } %>
  <% if (issues.isEmpty()) { %><p style="color:#aaa; font-size:13px;">No issues reported</p><% } %>
  <form method="post" action="RoomServlet" class="multival-form">
    <input type="hidden" name="action" value="addIssue">
    <input type="hidden" name="hotelId" value="<%= editRoom.getHotelId() %>">
    <input type="hidden" name="roomNumber" value="<%= editRoom.getRoomNumber() %>">
    <input type="text" name="issue" />
    <button type="submit" class="btn-small">Add</button>
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

<!-- ROOMS TABLE -->
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
    <th>Amenities</th>
    <th>Issues</th>
    <th>Edit</th>
    <th>Delete</th>
  </tr>
  </thead>
  <tbody>
  <% if (rooms != null) { for (Room r : rooms) {
    List<String> rAmenities = Room.getAmenitiesForRoom(r.getHotelId(), r.getRoomNumber());
    List<String> rIssues = Room.getIssuesForRoom(r.getHotelId(), r.getRoomNumber());
  %>
  <tr>
    <td><%= r.getHotelId() %></td>
    <td><%= r.getRoomNumber() %></td>
    <td><%= r.getChainId() %></td>
    <td>$<%= r.getPrice() %></td>
    <td><%= r.getCapacity() %></td>
    <td><%= r.getView() %></td>
    <td><%= r.getExtendable() ? "Yes" : "No" %></td>
    <td>
      <% if (rAmenities.isEmpty()) { %><span style="color:#aaa;">none</span>
      <% } else { for (String a : rAmenities) { %><span class="tag"><%= a %></span><% } } %>
    </td>
    <td>
      <% if (rIssues.isEmpty()) { %><span style="color:#aaa;">none</span>
      <% } else { for (String i : rIssues) { %><span class="tag-issue"><%= i %></span><% } } %>
    </td>
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