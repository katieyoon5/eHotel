<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.demo.Room" %>
<%@ page import="com.demo.Customer" %>
<%@ page import="com.demo.Booking" %>
<%@ page import="java.util.List" %>
<%
int hotelId = Integer.parseInt(request.getParameter("hotelId"));
int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));

Integer userID = (Integer) session.getAttribute("userID");

if (userID == null) {
    response.sendRedirect("login.jsp");
    return;
}

Customer customer = Customer.getCustomerById(userID);

Room room = Room.getRoomByHotelAndNumber(hotelId, roomNumber);
int capacity = room.getCapacity();

List<String> blockedDates = Room.getBlockedDates(hotelId, roomNumber);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book Room</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <style>
        body {
            font-family: Arial;
            background: #c1d6f5;
            padding: 2rem;
        }
        .form-box {
            background: white;
            padding: 2rem;
            max-width: 400px;
            margin: auto;
            border-radius: 12px;
            border: 1px solid #355099;
        }
        input, select, button {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
        }
        button {
            background: #355099;
            color: white;
            border: none;
        }
    </style>
</head>

<body>

<div class="form-box">

<h2>Book Room <%= roomNumber %></h2>

<form action="BookRoomServlet" method="post">

    <input type="hidden" name="hotelId" value="<%= hotelId %>">
    <input type="hidden" name="roomNumber" value="<%= roomNumber %>">

    <label>Check-in Date</label>
    <input type="text" id="checkin" name="checkin" required>

    <label>Check-out Date</label>
    <input type="text" id="checkout" name="checkout" required>

    <label>Number of Guests</label>
    <select name="guests" required>
        <%
            for (int i = 1; i <= capacity; i++) {
        %>
        <option value="<%= i %>"><%= i %></option>
        <%
            }
        %>
    </select>

    <button type="submit">Book Now</button>
</form>

</div>

<script>
let blocked = [
<%
for (String d : blockedDates) {
%>
"<%= d %>",
<%
}
%>
];

// convert to function format for flatpickr
function disableDates(date) {
    let d = date.toISOString().split("T")[0];

    if (blocked.includes(d)) return true;

    // block past dates
    let today = new Date();
    today.setHours(0,0,0,0);
    if (date < today) return true;

    return false;
}

flatpickr("#checkin", {
    dateFormat: "Y-m-d",
    disable: [disableDates]
});

flatpickr("#checkout", {
    dateFormat: "Y-m-d",
    disable: [disableDates]
});
</script>

</body>
</html>