<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

	// UTF-8
    response.setCharacterEncoding("UTF-8");

    String year = request.getParameter("year");

	String url_mysql = "jdbc:mysql://localhost/sealevel?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String sql = "SELECT * FROM chartdata ";

    JSONObject jsonList = new JSONObject();
    JSONArray itemList = new JSONArray();
    
    String where = "WHERE Year = '"+year+"'";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ResultSet rs = stmt_mysql.executeQuery(sql+where); 

        while (rs.next()){
            JSONObject tempJson = new JSONObject();

            itemList.add(rs.getString(1));
            // itemList.add(rs.getString(2));   // sealevel은 제외
            itemList.add(rs.getString(3));
            itemList.add(rs.getString(4));
            itemList.add(rs.getString(5));
            itemList.add(rs.getString(6));
            itemList.add(rs.getString(7));
            itemList.add(rs.getString(8));
        }

        // jsonList.put("results",itemList);
        conn_mysql.close();
        out.print(itemList);

    } catch (Exception e) {
        e.printStackTrace();
        out.print(e);
    }
%>
