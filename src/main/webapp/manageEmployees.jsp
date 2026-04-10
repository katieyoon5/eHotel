<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-09
  Time: 5:06 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Employee" %>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Employees</title>
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
      color: #355099;
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
      max-width: 1000px;
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
  String editSSN = request.getParameter("editSSN");

  Employee editEmployee = null;
  if (editSSN != null) {
    try {
      editEmployee = Employee.getEmployeeBySSN(Integer.parseInt(editSSN));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  List<Employee> employees = null;
  try {
    employees = Employee.getEmployees();
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

<h1>Manage Employees</h1>
<a class="back" href="employeeDashboard.jsp"> Back to Dashboard</a>

<% if (message != null) { %><p class="success"><%= message %></p><% } %>
<% if (error != null) { %><p class="error"><%= error %></p><% } %>

<div class="card">
  <% if (editEmployee != null) { %>
  <h2>Edit Employee #<%= editEmployee.getSSN() %></h2>
  <form method="post" action="EmployeeServlet">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="ssn" value="<%= editEmployee.getSSN() %>">

    <label>First Name</label>
    <input type="text" name="firstName" value="<%= editEmployee.getFirstName() %>" required />

    <label>Middle Name</label>
    <input type="text" name="middleName" value="<%= editEmployee.getMiddleName() != null ? editEmployee.getMiddleName() : "" %>" />

    <label>Last Name</label>
    <input type="text" name="lastName" value="<%= editEmployee.getLastName() %>" required />

    <label>Address</label>
    <input type="text" name="address" value="<%= editEmployee.getAddress() %>" required />

    <label>Role</label>
    <input type="text" name="role" value="<%= editEmployee.getRole() %>" required />

    <label>Hotel ID</label>
    <input type="number" name="hotelId" value="<%= editEmployee.getHotelId() %>" required />

    <button type="submit" class="btn">Update Employee</button>
  </form>
  <% } else { %>
  <h2>Add New Employee</h2>
  <form method="post" action="EmployeeServlet">
    <input type="hidden" name="action" value="insert">

    <label>First Name</label>
    <input type="text" name="firstName" required />

    <label>Middle Name</label>
    <input type="text" name="middleName" />

    <label>Last Name</label>
    <input type="text" name="lastName" required />

    <label>Address</label>
    <input type="text" name="address" required />

    <label>Role</label>
    <input type="text" name="role" required />

    <label>Hotel ID</label>
    <input type="number" name="hotelId" required />

    <button type="submit" class="btn">Add Employee</button>
  </form>
  <% } %>
</div>

<h2>All Employees</h2>
<table>
  <thead>
  <tr>
    <th>SSN</th>
    <th>First Name</th>
    <th>Last Name</th>
    <th>Role</th>
    <th>Hotel ID</th>
    <th>Address</th>
    <th>Edit</th>
    <th>Delete</th>
  </tr>
  </thead>
  <tbody>
  <% if (employees != null) { for (Employee e : employees) { %>
  <tr>
    <td><%= e.getSSN() %></td>
    <td><%= e.getFirstName() %></td>
    <td><%= e.getLastName() %></td>
    <td><%= e.getRole() %></td>
    <td><%= e.getHotelId() %></td>
    <td><%= e.getAddress() %></td>
    <td>
      <a href="manageEmployees.jsp?editSSN=<%= e.getSSN() %>">
        <button class="btn-edit">Edit</button>
      </a>
    </td>
    <td>
      <form method="post" action="EmployeeServlet">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="ssn" value="<%= e.getSSN() %>">
        <button type="submit" class="btn-delete"
                onclick="return confirm('Delete employee <%= e.getSSN() %>?')">
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