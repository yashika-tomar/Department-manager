package com.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DbConnection {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/deptmanager";
    private static final String USER = "root";
    private static final String PASS = "bhopal";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("Driver not found", e);
        }
        return DriverManager.getConnection(DB_URL, USER, PASS);
    }


    public static Object[] validateUser(String name, String password, String department) {
        Object[] results = new Object[2]; // Array to hold department and user ID
        String query = "SELECT department, user_id FROM users WHERE name = ? AND password = ? AND department = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, password);
            stmt.setString(3, department);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    results[0] = rs.getString("department"); // Department
                    results[1] = rs.getInt("user_id"); // User ID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null; // Return null on failure
        }
        return results; // Return the array containing department and user ID
    }

    public static boolean insertRequestData(String title, String description, int requestBy, String departmentTo) {
        String sql = "INSERT INTO Requests (title, description, request_by, request_date_time, department_to) VALUES (?, ?, ?, NOW(), ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, description);
            pstmt.setInt(3, requestBy);
            pstmt.setString(4, departmentTo);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

