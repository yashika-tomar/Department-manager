<%@ page import="java.sql.*" %>
<%@ page import="com.connection.DbConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Submission Status</title>
</head>
<body>
<%
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String departmentTo = request.getParameter("department_to");
    Integer userId = (Integer) session.getAttribute("userId"); // Direct use of implicit 'session' object

    if (userId == null) {
        out.println("<h1>Error: User ID is missing.</h1>");
        return; // Stop further processing if userID is not found
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DbConnection.getConnection();
        String sql = "SELECT name FROM Users WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        String userName = null;
        if (rs.next()) {
            userName = rs.getString("name");
        }

        rs.close();
        pstmt.close();

        if (userName != null) {
            // Prepare SQL to insert data into the database using the exact column order.
            sql = "INSERT INTO Requests (title, description, request_by, request_date_time, department_to) VALUES (?, ?, ?, NOW(), ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, description);
            pstmt.setString(3, userName); // User's name as 'request_by'
            pstmt.setString(4, departmentTo); // Department to which the request is made

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("ManagementDashboard.jsp"); // Redirect to the dashboard
            } else {
                out.println("<h1>Failed to submit the request.</h1>");
            }
        } else {
            out.println("<h1>User name not found. Request cannot be processed.</h1>");
        }
    } catch (SQLException e) {
        out.println("<h1>Error in database operation: " + e.getMessage() + "</h1>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
</body>
</html>