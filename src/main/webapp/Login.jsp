<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ page import="com.connection.DbConnection" %>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <%@ include file="cdn.jsp" %>
</head>
<body>
<%
    String name = request.getParameter("name");
    String password = request.getParameter("password");
    String department = request.getParameter("department");

    if ("POST".equalsIgnoreCase(request.getMethod()) && name != null && password != null && department != null) {
        try {
            Object[] validationResults = DbConnection.validateUser(name, password, department);
            if (validationResults != null && validationResults[0] != null && validationResults[1] != null) {
                String dept = (String) validationResults[0];
                Integer userId = (Integer) validationResults[1];

                session.setAttribute("department", dept);
                session.setAttribute("userId", userId);
                response.sendRedirect(dept + "Dashboard.jsp");
            } else {
                out.println("<p>Invalid credentials or department mismatch. Please try again.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
%>


<div class="row">
<div class="col-md-4"></div>
<div class="col-md-4">
<fieldset>
<legend style="font-size: 28px;">Login Details</legend>
<form method="post" action="Login.jsp">
    <input type="text" name="name" class="form-control" placeholder="Enter Name"/><br/>
    <input type="password" name="password" class="form-control" placeholder="Enter Password"/><br/>
    <select name="department" class="form-control">
        <option disabled selected>Select Department</option>
        <option value="Management">Management Department</option>
        <option value="Legal">Legal Department</option>
        <option value="Finance">Finance Department</option>
    </select><br/>
    <input type="submit" class="btn btn-primary" value="Login"/>
</form>
</fieldset>
</div>
<div class="col-md-4"></div>
</div>
</body>
</html>
