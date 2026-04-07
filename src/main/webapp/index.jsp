<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.demo.Hotel" %>

<%
    List<Hotel> hotels = null;

    try {
        hotels = Hotel.getHotels();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Home Page </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>

<body>

<div class="container">
    <h2 class="mt-4">Hotel List</h2>

    <% if (hotels == null || hotels.size() == 0) { %>
    <h4>No hotels found</h4>
    <% } else { %>

    <table class="table table-bordered mt-3">
        <thead>
        <tr>
            <th>Hotel ID</th>
            <th>Address</th>
            <th>Rating</th>
            <th>Chain ID</th>
        </tr>
        </thead>
        <tbody>

        <% for (Hotel h : hotels) { %>
        <tr>
            <td><%= h.getHotelId() %></td>
            <td><%= h.getAddress() %></td>
            <td><%= h.getRating() %></td>
            <td><%= h.getChainId() %></td>
        </tr>
        <% } %>

        </tbody>
    </table>

    <% } %>
</div>
<script src="assets/bootstrap/js/bootstrap.min.js"></script>
<script src="/assets/js/jquery.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>

<script>

</script>

</body>
</html>