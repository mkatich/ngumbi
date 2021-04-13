<%-- 
    Document   : newjsp
    Created on : Feb 23, 2011, 11:57:33 AM
    Author     : Michael Katich <mike.katich@datarecovery.com>
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="Java" import="java.sql.*" %>
<%@ page language="Java" import="java.util.regex.Pattern" %>

<%



String state = request.getParameter("state");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>ngumbi batch module</title>
<script type="text/javascript" src="textAreaMaxLen.js"></script>
</head>
<%


if (state == null){
    //first time here

    %>
    <h1>Batch Module for Converting Plusses back to Spaces</h1>
    <h3>First time here!</h3>
    <p>This will read current link values from user_links table, edit, and update to new value.</p>
    <form method="post" name="runbatch" action="batch_module_plusses.jsp">
        <input type="hidden" name="state" value="1">
        <input type=submit name="start_button" value="Start Batch Process">
    </form>

    <%

}
else if (state.equals("1")){


    int total_rows_inserted = 0;

    String dbname = "ngumbi";
    String dbuser = "ngumbi_db_user";
    String pass = "m8w1b174cpx9w0j3l";
    Driver driver = null;
    String dbURL = "jdbc:mysql://localhost:3306/"+dbname+"?user=";
    Connection conn = null;


    String getLinkData = "SELECT user_link_id, link_name, cat FROM user_links WHERE link_name LIKE '%+%' OR cat LIKE '%+%' ORDER BY user_link_id DESC";

    ResultSet rs = null;
    Statement stat1 = null;


    try {
        driver = (Driver) Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection(dbURL, dbuser, pass);

        stat1 = conn.createStatement();
        rs = stat1.executeQuery(getLinkData);;
    }
    catch (Exception e){
        //
    }

    int user_link_id = 0;
    String link_name = "";
    String cat = "";
    while (rs.next()){
        user_link_id = rs.getInt("user_link_id");
        link_name = rs.getString("link_name");
        cat = rs.getString("cat");

        //convert
        //You need to escape the + for the regular expression, using \.
        //However, Java uses a String parameter to construct regular expressions, which uses \ for its own escape sequences. So you have to escape the \ itself:
        link_name = link_name.replaceAll(Pattern.quote("+"), " ");
        cat = cat.replaceAll(Pattern.quote("+"), " ");

        //build update
        String update = "UPDATE user_links SET link_name = '"+link_name+"', cat = '"+cat+"'  WHERE user_link_id = "+user_link_id;


        //execute insert
        Connection conn2 = null;
        Statement stat2 = null;
        try {
            driver = (Driver) Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn2 = DriverManager.getConnection(dbURL, dbuser, pass);

            stat2 = conn.createStatement();
            total_rows_inserted += stat2.executeUpdate(update);;
        }
        catch (Exception e){
            //
        }
        stat2.close();
        conn2.close();

        //pause so database back end isn't overloaded
        Thread.currentThread().sleep(250);//in milliseconds

    }
    rs.close();
    stat1.close();
    conn.close();

    %>
    <h1>Batch Module for Converting Plusses back to Spaces</h1>
    <h3>Completed</h3>
    <%=total_rows_inserted%> rows updated in user links table.
    <%

}


%>
</html>

