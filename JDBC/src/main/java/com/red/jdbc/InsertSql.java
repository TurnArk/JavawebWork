package com.red.jdbc;

import org.apache.commons.dbutils.DbUtils;
import org.apache.commons.dbutils.QueryRunner;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class InsertSql {
    public static void main(String[] args) {
        String DATABASE = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
        String USER = "user_11";
        String PASSWORD = "123456";

        Connection conn = null;
        try {
            conn= DriverManager.getConnection(DATABASE, USER, PASSWORD);
            conn.setAutoCommit(false);
            QueryRunner qr = new QueryRunner();

            String sql="INSERT INTO teacher(id,name,course,birthday) VALUES(?,?,?,?)";
            int result=qr.update(conn,sql,8,"琪露诺","数学","1999-9-9");
            System.out.println("Insert:"+result);
            DbUtils.commitAndClose(conn);
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
