<%@ page import="java.sql.*" %>
<%@ page import="com.demo.ConnectionDB" %>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.Hotel" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>

    <style>
        body {
            min-height: 100vh;
            background: #c1d6f5;
            font-family: Arial;
            padding: 2rem;
            margin: 0;
        }
        h1 { text-align: center; }
        .card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            max-width: 500px;
            margin: 0 auto;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 1rem;
        }
        .btn {
            background: #355099;
            color: white;
            padding: 10px;
            border: none;
            width: 100%;
        }
    </style>

    <script>
        function changeForm() {
            let user = document.getElementById("user").value;

            document.getElementById("userInput").value = user;

            document.getElementById("customerForm").style.display = "none";
            document.getElementById("employeeForm").style.display = "none";

            if (user === "customer") {
                document.getElementById("customerForm").style.display = "block";
            } else if (user === "employee") {
                document.getElementById("employeeForm").style.display = "block";
            }
        }
    </script>
</head>

<body>

<h1>Sign Up</h1>

<div class="card">
<%
    List<Hotel> hotels = null;
    try {
        hotels = Hotel.getHotels();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<form method="post" onsubmit="document.getElementById('userInput').value = document.getElementById('user').value;">

    <select id="user" onchange="changeForm()">
        <option value="">Select Role</option>
        <option value="customer">Customer</option>
        <option value="employee">Employee</option>
    </select>

    <input type="hidden" name="user" id="userInput">

    <!-- CUSTOMER -->
    <div id="customerForm" style="display:none;">
        <input type="text" name="fname" placeholder="First Name" required>
        <input type="text" name="mname" placeholder="Middle Name" >
        <input type="text" name="lname" placeholder="Last Name" required>
        <input type="text" name="address" placeholder="Address" required>
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="pwd" placeholder="Password" required>
    </div>

    <!-- EMPLOYEE -->
    <div id="employeeForm" style="display:none;">
        <input type="text" name="emp_fname" placeholder="First Name" required>
        <input type="text" name="emp_mname" placeholder="Middle Name">
        <input type="text" name="emp_lname" placeholder="Last Name" required>
        <input type="text" name="emp_address" placeholder="Address" required>
        <input type="text" name="emp_role" placeholder="Enter your position" required>
        <select name="hotel_id">
            <option value="">Select Hotel</option>
            <%
                if (hotels != null) {
                    for (Hotel h : hotels) {
            %>
                <option value="<%= h.getHotelId() %>"><%= h.getAddress() %></option>
            <%
                    }
                } else {
            %>
                <option value="">No hotels available</option>
            <%
                }
            %>
        </select>
        <input type="text" name="emp_username" placeholder="Username" required>
        <input type="password" name="emp_pwd" placeholder="Password" required>
    </div>

    <button type="submit" class="btn">Sign Up</button>

</form>

<%
    // HANDLING SUBMISSION
    String user = request.getParameter("user");

    if (user != null && !user.isEmpty()) {

        ConnectionDB db = new ConnectionDB();
        Connection con = null;
        PreparedStatement stmt = null;

        try {
            con = db.getConnection();

            if ("customer".equals(user)) {

                String fname = request.getParameter("fname");
                String mname = request.getParameter("mname");
                String lname = request.getParameter("lname");
                String address = request.getParameter("address");
                String username = request.getParameter("username");
                String pwd = request.getParameter("pwd");

                String sql = "INSERT INTO customer(FirstName, MiddleName, LastName, Address, Username, Password) VALUES (?,?,?,?,?,?)";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, fname);
                if (mname == null || mname.trim().isEmpty()) { stmt.setNull(2, java.sql.Types.VARCHAR); }
                else { stmt.setString(2, mname); }
                stmt.setString(3, lname);
                stmt.setString(4, address);
                stmt.setString(5, username);
                stmt.setString(6, pwd);
                stmt.executeUpdate();

                %>
                <script>
                    alert("Customer registered successfully!");
                    window.location.href = "login.jsp";
                </script>
                <%
                return;

            } else if ("employee".equals(user)) {

                String fname = request.getParameter("emp_fname");
                String mname = request.getParameter("emp_mname");
                String lname = request.getParameter("emp_lname");
                String address = request.getParameter("emp_address");
                String roleEmp = request.getParameter("emp_role");
                String hotelId = request.getParameter("hotel_id");
                String username = request.getParameter("emp_username");
                String pwd = request.getParameter("emp_pwd");

                if (hotelId == null || hotelId.isEmpty()) {
                    out.println("<p style='color:red;'>Error: Please select a hotel.</p>");
                } else {
                    String sql = "INSERT INTO employee(firstName, middleName, lastName, address, role, hotel_ID, username, password) VALUES (?,?,?,?,?,?,?,?)";
                    stmt = con.prepareStatement(sql);
                    stmt.setString(1, fname);
                    if (mname == null || mname.trim().isEmpty()) { stmt.setNull(2, java.sql.Types.VARCHAR); }
                    else { stmt.setString(2, mname); }
                    stmt.setString(3, lname);
                    stmt.setString(4, address);
                    stmt.setString(5, roleEmp);
                    stmt.setInt(6, Integer.parseInt(hotelId));
                    stmt.setString(7, username);
                    stmt.setString(8, pwd);
                    stmt.executeUpdate();
                    %>
                    <script>
                        alert("Customer registered successfully!");
                        window.location.href = "login.jsp";
                    </script>
                    <%
                    return;
                }
            }

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        }
    }
%>

</div>

</body>
</html>
