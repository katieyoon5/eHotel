<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-10
  Time: 10:41 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.HotelChain" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Hotel Chains</title>
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

    HotelChain editChain = null;
    if (editId != null) {
        try {
            editChain = HotelChain.getChainById(Integer.parseInt(editId));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    List<HotelChain> chains = null;
    try {
        chains = HotelChain.getAllChains();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<h1>Manage Hotel Chains</h1>
<a class="back" href="employeeDashboard.jsp"> Back to Dashboard</a>

<% if (message != null) { %><p class="success"><%= message %></p><% } %>
<% if (error != null) { %><p class="error"><%= error %></p><% } %>

<!-- ADD / EDIT FORM -->
<div class="card">
    <% if (editChain != null) { %>
    <h2>Edit Chain #<%= editChain.getChainId() %></h2>
    <form method="post" action="HotelChainServlet">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="chainId" value="<%= editChain.getChainId() %>">

        <label>Office Address</label>
        <input type="text" name="officeAddress" value="<%= editChain.getOfficeAddress() %>" required />

        <label>Number of Hotels</label>
        <input type="number" name="numHotels" value="<%= editChain.getNumHotels() %>" required />

        <button type="submit" class="btn">Update Chain</button>
    </form>

    <h2>Phone Numbers</h2>
    <% for (String phone : editChain.getPhones()) { %>
    <span class="tag"><%= phone %></span>
    <form method="post" action="HotelChainServlet" style="display:inline;">
        <input type="hidden" name="action" value="deletePhone">
        <input type="hidden" name="chainId" value="<%= editChain.getChainId() %>">
        <input type="hidden" name="phone" value="<%= phone %>">
        <button type="submit" class="btn-delete" style="padding:2px 8px; font-size:11px;">x</button>
    </form>
    <% } %>
    <form method="post" action="HotelChainServlet" class="multival-form">
        <input type="hidden" name="action" value="addPhone">
        <input type="hidden" name="chainId" value="<%= editChain.getChainId() %>">
        <input type="text" name="phone" />
        <button type="submit" class="btn-small">Add</button>
    </form>

    <h2>Email Addresses</h2>
    <% for (String email : editChain.getEmails()) { %>
    <span class="tag"><%= email %></span>
    <form method="post" action="HotelChainServlet" style="display:inline;">
        <input type="hidden" name="action" value="deleteEmail">
        <input type="hidden" name="chainId" value="<%= editChain.getChainId() %>">
        <input type="hidden" name="email" value="<%= email %>">
        <button type="submit" class="btn-delete" style="padding:2px 8px; font-size:11px;">x</button>
    </form>
    <% } %>
    <form method="post" action="HotelChainServlet" class="multival-form">
        <input type="hidden" name="action" value="addEmail">
        <input type="hidden" name="chainId" value="<%= editChain.getChainId() %>">
        <input type="text" name="email" />
        <button type="submit" class="btn-small">Add</button>
    </form>

    <% } else { %>
    <h2>Add New Chain</h2>
    <form method="post" action="HotelChainServlet">
        <input type="hidden" name="action" value="insert">

        <label>Office Address</label>
        <input type="text" name="officeAddress" required />

        <label>Number of Hotels</label>
        <input type="number" name="numHotels" required />

        <button type="submit" class="btn">Add Chain</button>
    </form>
    <% } %>
</div>

<h2>All Hotel Chains</h2>
<table>
    <thead>
    <tr>
        <th>Chain ID</th>
        <th>Office Address</th>
        <th>Num Hotels</th>
        <th>Phones</th>
        <th>Emails</th>
        <th>Edit</th>
        <th>Delete</th>
    </tr>
    </thead>
    <tbody>
    <% if (chains != null) { for (HotelChain c : chains) { %>
    <tr>
        <td><%= c.getChainId() %></td>
        <td><%= c.getOfficeAddress() %></td>
        <td><%= c.getNumHotels() %></td>
        <td>
            <% for (String p : c.getPhones()) { %>
            <span class="tag"><%= p %></span>
            <% } %>
            <% if (c.getPhones().isEmpty()) { %><span style="color:#aaa;">none</span><% } %>
        </td>
        <td>
            <% for (String e : c.getEmails()) { %>
            <span class="tag"><%= e %></span>
            <% } %>
            <% if (c.getEmails().isEmpty()) { %><span style="color:#aaa;">none</span><% } %>
        </td>
        <td>
            <a href="manageHotelChains.jsp?editId=<%= c.getChainId() %>">
                <button class="btn-small">Edit</button>
            </a>
        </td>
        <td>
            <form method="post" action="HotelChainServlet">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="chainId" value="<%= c.getChainId() %>">
                <button type="submit" class="btn-delete"
                        onclick="return confirm('Delete chain <%= c.getChainId() %>?')">
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