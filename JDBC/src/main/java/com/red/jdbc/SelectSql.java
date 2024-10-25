package com.red.jdbc;

import java.sql.*;

public class SelectSql {
    public static void main(String[] args) {
        String DATABASE = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
        String USER = "user_11";
        String PASSWORD = "123456";

        String selectSql="SELECT * FROM teacher";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            conn=DriverManager.getConnection(DATABASE,USER,PASSWORD);
            ps = conn.prepareStatement(selectSql);
            rs=ps.executeQuery();
            while(rs.next()){
                System.out.println(rs.getInt("id")+" "+rs.getString("name")
                        +" "+rs.getObject(3)+" "+rs.getObject(4));
            }
        }catch(SQLException e){
            e.printStackTrace();
        }finally {
            if(rs!=null){
                try {
                    rs.close();
                }catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if(ps!=null){try {
                ps.close();
            }catch (SQLException e) {
                e.printStackTrace();
            }
            }
            if(conn!=null){try {
                conn.close();
            }catch (SQLException e) {
                e.printStackTrace();
            }
            }
        }
    }
}
