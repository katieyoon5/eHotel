<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Customer" %>
<%@ page import="com.demo.Room" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard</title>
    <style>
        body {
            min-height: 100vh;
            background: #c1d6f5;
            font-family: Arial;
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

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .card {
            background: white;
            border-radius: 12px;
            border: 1px solid #355099;
            padding: 2rem;
            text-decoration: none;
            display: block;
        }

        .card:hover { background: #c1d6f5; }

        .card-title {
            color: #0e1130;
            font-weight: bold;
            margin: 0 0 8px;
            font-size: 18px;
        }

        .card-sub {
            color: #355099;
            margin: 0;
            font-size: 14px;
        }

        .back {
            display: block;
            text-align: center;
            margin-bottom: 1rem;
            color: #355099;
        }

        form {
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>

<%
Integer userID = (Integer) session.getAttribute("userID");

if (userID == null) {
    response.sendRedirect("login.jsp");
    return;
}

Customer customer = Customer.getCustomerById(userID);

// SORT
String sortBy = request.getParameter("sortBy");
if (sortBy == null) sortBy = "price";

// SEARCH (all optional)
String hotelSearch = request.getParameter("hotelSearch");
String chainSearch = request.getParameter("chainSearch");
String minPrice = request.getParameter("minPrice");
String maxPrice = request.getParameter("maxPrice");
String capacity = request.getParameter("capacity");

List<Room> rooms = null;

try {
    if ((hotelSearch != null && !hotelSearch.isEmpty()) ||
        (chainSearch != null && !chainSearch.isEmpty()) ||
        (minPrice != null && !minPrice.isEmpty()) ||
        (maxPrice != null && !maxPrice.isEmpty()) ||
        (capacity != null && !capacity.isEmpty())) {

        rooms = Room.searchRooms(hotelSearch, chainSearch, minPrice, maxPrice, capacity);

    } else {
        // otherwise just sort
        rooms = Room.getRooms(sortBy);
    }

} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>


<div class="topbar">
    <a href="logout.jsp" class="logout">Logout</a>
</div>

<div class="header">
    <h1>Welcome, <%= customer.getFirstName() %>!</h1>
    <p>View Available Rooms</p>
</div>

<a class="back" href="customerDashboard.jsp">Back to Dashboard</a>

<h2 style="text-align:center;">Available Rooms</h2>


<!-- SEARCH FORM -->
<form method="get">
    <input type="text" name="hotelSearch" placeholder="Hotel Address">
    <input type="text" name="chainSearch" placeholder="Chain Address">
    <input type="number" name="minPrice" placeholder="Min Price">
    <input type="number" name="maxPrice" placeholder="Max Price">
    <input type="number" name="capacity" placeholder="Min Capacity">
    <button type="submit">Search</button>
</form>



<!-- SORT FORM -->
<form method="get">
    <select name="sortBy">
        <option value="price" <%= "price".equals(sortBy) ? "selected" : "" %>>Price (Low → High)</option>
        <option value="capacity" <%= "capacity".equals(sortBy) ? "selected" : "" %>>Capacity</option>
        <option value="chain" <%= "chain".equals(sortBy) ? "selected" : "" %>>Hotel Chain</option>
        <option value="rating" <%= "rating".equals(sortBy) ? "selected" : "" %>>Hotel Rating</option>
        <option value="area" <%= "area".equals(sortBy) ? "selected" : "" %>>Area</option>
    </select>
    <button type="submit">Sort</button>
</form>

<div class="grid">

<%
if (rooms != null && !rooms.isEmpty()) {
    for (Room r : rooms) {
%>

    <a class="card"
       href="bookRoom.jsp?hotelId=<%= r.getHotelId() %>&roomNumber=<%= r.getRoomNumber() %>">

        <p class="card-title">Room <%= r.getRoomNumber() %></p>
        <p class="card-sub">Price: $<%= r.getPrice() %></p>
        <p class="card-sub">Capacity: <%= r.getCapacity() %></p>
        <p class="card-sub">View: <%= r.getView() %></p>
        <p class="card-sub">Extendable: <%= r.getExtendable() %></p>
        <p class="card-sub">Rating: <%= r.getRating() %> ⭐</p>
        <p class="card-sub">Hotel: <%= r.getHotelAddress() %></p>
        <p class="card-sub">Chain: <%= r.getChainAddress() %></p>

    </a>

<%
    }
} else {
%>

    <p style="text-align:center;">No rooms available right now.</p>

<%
}
%>

</div>

</body>
</html>