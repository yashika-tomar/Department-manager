<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.connection.DbConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Handler</title>
</head>
<body>
<%
    // Only handle login attempts here, assuming session checks are done elsewhere
    String name = request.getParameter("name");
    String password = request.getParameter("password");
    String department = request.getParameter("department");

    if (name != null && password != null && department != null) {
        String dept = DbConnection.validateUser(name, password, department);
        if (dept != null && dept.equals(department)) {
            session.setAttribute("department", dept);
            response.sendRedirect(dept + "Dashboard.jsp");
        } else {
            out.println("<script type=\"text/javascript\">");
            out.println("alert('Invalid credentials or department mismatch.');");
            out.println("location='login.jsp';");
            out.println("</script>");
        }
    } else {
        // Redirect to login if critical parameters are missing
        response.sendRedirect("login.jsp");
    }
%>
</body>
</html>
