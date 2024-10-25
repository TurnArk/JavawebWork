package com.red.jdbc;

import java.sql.*;

public class RollSql {
    public static void main(String[] args) {
        String DATABASE = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
        String USER = "user_11";
        String PASSWORD = "123456";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn= DriverManager.getConnection(DATABASE, USER, PASSWORD);
            String sql = "SELECT * FROM teacher";
            ps = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = ps.executeQuery();
            rs.absolute(-2);
            System.out.println(rs.getInt("id")+" "+rs.getString("name")
                    +" "+rs.getObject(3)+" "+rs.getObject(4));
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
