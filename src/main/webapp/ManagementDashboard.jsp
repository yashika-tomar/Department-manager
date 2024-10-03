<!DOCTYPE html>
<%@ page import="com.connection.DbConnection" %>
<%@ page import="java.sql.*, java.util.*" %>
<html>
<head>
<meta charset="UTF-8">
<title>Management Dashboard</title>
<%@ include file="cdn.jsp" %>
</head>
<body>
<div class="container">
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="ManagementDashboard">Management Dashboard</a>
    </div>
  </div>
</nav>
<div class="row">
<div class="col-md"></div>
<div class="col-md-8">
<fieldset>
<div class="container">

    <h2><br/><br/>Request Form</h2><br/>
    <form method="post" action="submitRequest.jsp">
    <div class="form-group">
        <label for="receiver">Receiver:</label><br>
        <label class="radio-inline"><input type="radio" name="department_to" value="Legal" checked>Legal Department</label>
        <label class="radio-inline"><input type="radio" name="department_to" value="Finance">Finance Department</label>
    </div>
    <div class="form-group">
        <label for="title">Request Title:</label>
        <input type="text" class="form-control" name="title"  required>
    </div>
    <div class="form-group">
        <label for="description">Request Description:</label>
        <textarea class="form-control" name="description" rows="5" required></textarea>
    </div>
    
    <button type="submit" class="btn btn-primary">Send</button>
</form>

</div>
</fieldset>
</div>
<div class="col-md-1"></div>
</div><br/><br/>
<div class="row">
<div class="col-md"></div>
		<div class="col-md-12">
		<h2>Track Requests</h2>
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
                            rs = stmt.executeQuery("SELECT * FROM Requests");
                            int count = 1;
                            while(rs.next()) {
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
                                    <td><%= approvalDate %></td>
                                    <td><%= approvedBy %></td>
                                    <td><%= remark %></td>
                                </tr>
                    <% 
                            }
                        } catch(SQLException e) {
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
		<div class="col-md">
		</div>
</div>
</div>
</body>
</html>

