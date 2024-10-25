package com.red.jdbc;

import java.sql.*;

public class DeleteSql {
    public static void main(String[] args) {
        String url = "jdbc:mysql://127.0.0.1:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=utf8";
        String username = "user_11";
        String password = "123456";

        Connection conn = null;
        PreparedStatement ps = null;
        try{
            conn= DriverManager.getConnection(url,username,password);
            String sql="DELETE FROM teacher WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1,8);
            ps.executeUpdate();
        }catch(SQLException e){
            e.printStackTrace();
        }finally {
            if(ps!=null){
                try {
                    ps.close();
                }catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if(conn!=null){
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
