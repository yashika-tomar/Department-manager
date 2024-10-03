<%@ page import="java.sql.*" %>
<%@ page import="com.connection.DbConnection" %>
<%
    String action = request.getParameter("action");
    int requestId = Integer.parseInt(request.getParameter("requestId"));
    String approvedBy = (String) session.getAttribute("userName"); // Assumes user name is stored in session
    String department = (String) session.getAttribute("department"); // Assuming department is also stored in session
    String remark = action.equals("approve") ? "Approved" : "Rejected";

    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        conn = DbConnection.getConnection();
        String sql = "UPDATE Requests SET remark = ?, approved_by = ?, approval_date = NOW() WHERE request_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, remark);
        pstmt.setString(2, approvedBy);
        pstmt.setInt(3, requestId);

        int updateCount = pstmt.executeUpdate();

        // Check the department and redirect accordingly
        if (department.equalsIgnoreCase("Legal")) {
            response.sendRedirect("LegalDashboard.jsp"); // Redirect to the Legal dashboard
        } else if (department.equalsIgnoreCase("Finance")) {
            response.sendRedirect("FinanceDashboard.jsp"); // Redirect to the Finance dashboard
        } else {
            response.sendRedirect("errorPage.jsp"); // Redirect to an error page if the department doesn't match
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("errorPage.jsp"); // Redirect to an error page in case of SQL exception
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
