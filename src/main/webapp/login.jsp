<%@ page import="java.sql.*" %>
<%@ page import="com.demo.ConnectionDB" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Log in</title>

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
</head>

<body>
<h1>Log In</h1>
    <div class="card">
        <form method="post" >
            <select name="user" id="user" required>
                <option value="">Select Role</option>
                <option value="customer">Customer</option>
                <option value="employee">Employee</option>
            </select>
            <input type="text" name="username" placeholder="Enter your Username" required>
            <input type="password" name="pwd" placeholder="Enter you Password" required>
            <button type="submit" class="btn">Log In</button>
        </form>
<%
    String user = request.getParameter("user");
    String username = request.getParameter("username");
    String pwd = request.getParameter("pwd");

    if (user != null && !user.isEmpty() && username != null && pwd != null) {
        ConnectionDB db = new ConnectionDB();
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            con = db.getConnection();

            // check the correct table depending on user
            String sql = "";
            if ("customer".equals(user)) {
                sql = "SELECT * FROM customer WHERE Username = ? AND Password = ?";
            } else if ("employee".equals(user)) {
                sql = "SELECT * FROM employee WHERE Username = ? AND Password = ?";
            }

            stmt = con.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, pwd);

            rs = stmt.executeQuery();

            if (rs.next()) {
                if ("customer".equals(user)){
                response.sendRedirect("customerDashboard.jsp");
                }
                else if ("employee".equals(user)){
                                response.sendRedirect("employeeDashboard.jsp");
                                }
            } else {
            %>
                <p class="error">Invalid username or password for <%= user %>!</p>
            <%
            }
        } catch (Exception e) {
        %>
            <p class="error">Error: <%= e.getMessage() %></p>

            <%
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        }
    }
%>


    <div>
</body>
</html>