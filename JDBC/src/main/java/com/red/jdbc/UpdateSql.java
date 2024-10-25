package com.red.jdbc;

import org.apache.commons.dbutils.DbUtils;
import org.apache.commons.dbutils.QueryRunner;

import java.sql.*;

public class UpdateSql {
    public static void main(String[] args) {
        String url = "jdbc:mysql://127.0.0.1:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=utf8";
        String username = "user_11";
        String password = "123456";

        Connection conn = null;
        try{
            conn= DriverManager.getConnection(url,username,password);
            conn.setAutoCommit(false);
            QueryRunner runner = new QueryRunner();
            String sql = "UPDATE teacher SET course = ? WHERE id=?";
            int result = runner.update(conn,sql,"英语",1);
            System.out.println("Updated"+result+"row(s)");
            DbUtils.commitAndClose(conn);
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
}
