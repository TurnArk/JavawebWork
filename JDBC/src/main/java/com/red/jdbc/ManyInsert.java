package com.red.jdbc;

import java.sql.*;

public class ManyInsert {
    public static void main(String[] args) {
        String DATABASE = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
        String USER = "user_11";
        String PASSWORD = "123456";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn= DriverManager.getConnection(DATABASE,USER,PASSWORD);
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("INSERT INTO teacher VALUES(?,?,?,?)");
            for(int i=9;i<=509;i++){
                ps.setInt(1,i);
                ps.setString(2,"天尊"+i+"号");
                String course=null;
                switch (i%4){
                    case 0:
                        course="虾头太刀";
                        break;
                    case 1:
                        course="至尊三灯耐摔王虫棍";
                        break;
                    case 2:
                        course="seya";
                        break;
                    case 3:
                        course="登龙";
                        break;
                }
                ps.setString(3,course);
                ps.setString(4,"2024-1-1");
                ps.addBatch();
                if(i%100==0){
                    ps.executeBatch();
                    ps.clearBatch();
                }
            }
            ps.executeBatch();
            conn.commit();
            System.out.println("天尊集合完毕准备速通极法");
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
