<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.connection.DbConnection" %>
<html>
<head>
<meta charset="UTF-8">
<title>Legal Dashboard</title>
<%@ include file="cdn.jsp" %> <!-- Ensure that this file correctly includes necessary CSS/JS -->
</head>
<body>
<div class="row">
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="LegalDashboard">Legal Dashboard</a>
    </div>
  </div>
</nav>
    <div class="col-md-1"></div>
    <div class="col-md-10">
        <h2><br/><br/>Track Requests</h2>
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>SNo.</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Request By</th>
                    <th>Date and Time</th>
                    <th>Department To</th>
                    <th>Approval Date</th>
                    <th>Approved By</th>
                    <th>Remark</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    try {
                        conn = DbConnection.getConnection();
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT * FROM Requests WHERE department_to='Legal'");
                        int count = 1;
                        while (rs.next()) {
                            String title = rs.getString("title");
                            String description = rs.getString("description");
                            String requestBy = rs.getString("request_by");
                            String requestDateTime = rs.getString("request_date_time");
                            String departmentTo = rs.getString("department_to");
                            String approvalDate = rs.getString("approval_date");
                            String approvedBy = rs.getString("approved_by");
                            String remark = rs.getString("remark");
                %>
                            <tr>
                                <td><%= count++ %></td>
                                <td><%= title %></td>
                                <td><%= description %></td>
                                <td><%= requestBy %></td>
                                <td><%= requestDateTime %></td>
                                <td><%= departmentTo %></td>
                                <td><%= approvalDate != null ? approvalDate : "N/A" %></td>
                                <td><%= approvedBy != null ? approvedBy : "N/A" %></td>
                                <td><%= remark %></td>
                                <td>
                                    <% if ("Pending".equalsIgnoreCase(remark)) { %>
                                        <form method="post" action="UpdateRequestStatus.jsp">
                                            <input type="hidden" name="requestId" value="<%= rs.getInt("request_id") %>">
                                            <button type="submit" name="action" value="approve">Approve</button>
                                            <button type="submit" name="action" value="reject">Reject</button>
                                        </form>
                                    <% } else { %>
                                       	Completed
                                    <% } %>
                                </td>
                            </tr>
                <% 
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                %>
            </tbody>
        </table>
    </div>
    <div class="col-md-1"></div>
</div>
</body>
</html>
