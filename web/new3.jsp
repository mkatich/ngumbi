<%-- 
    Document   : new3
    Created on : Feb 18, 2011, 1:55:40 AM
    Author     : Michael
--%>

<%
/*********************************************************************
*	File: new2.jsp
*	Description: User came from new1.jsp, creating new account and
*       page.
*********************************************************************/
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<jsp:useBean id="helperMethods" scope="page" class="helperMethodsBean.helperMethods" />
<%

//get the passed arguments
String user = request.getParameter("user");
String pass = request.getParameter("pass");
String cpass = request.getParameter("cpass");
String loadDataName = request.getParameter("loadDataName");
String searchOption = request.getParameter("searchOption");

String searchUrlGoogle = request.getParameter("searchUrlGoogle");
String customSearchUrlGoogle = request.getParameter("customSearchUrlGoogle");
String searchLangGoogle = request.getParameter("searchLangGoogle");

String searchUrlYahoo = request.getParameter("searchUrlYahoo");
String customSearchUrlYahoo = request.getParameter("customSearchUrlYahoo");
String searchLangYahoo = request.getParameter("searchLangYahoo");


%>
<html>
<head>
<title>New ngumbi Page</title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<link rel="stylesheet" type="text/css" href="style.css">
<style type="text/css">
<!--

-->
</style>
<script type="text/javascript"><!--
//--></script>
<jsp:include page="inc_google_analytics.jsp" />
</head>

<%
//Here: validate their created login, intialize their new account in sql tables

//we got the inputs from the new users
//-username, -password, -confirmation password, -searchoption etc.
//we also have the field loadDataName IF the user had wanted to use another user's data to start

//basic validations of input login info
//first check that they entered non-blank user and password
//and less than or equal to 30 characters
//check that they entered two passwords the same
boolean goodLogin = true;

//check for nulls
if (user == null){ goodLogin = false; }
else if (pass == null){ goodLogin = false; }
else if (cpass == null){ goodLogin = false; }

//check that user and pass are a good length
else if (user.length() < 1){ goodLogin = false; }
else if (user.length() > 30){ goodLogin = false; }
else if (pass.length() < 1){ goodLogin = false; }
else if (pass.length() > 30){ goodLogin = false; }

//check that pass and cpass match
else if (!pass.equals(cpass)){ goodLogin = false; }

//reserved user names for possible future use
else if (user.equals("michael")){ goodLogin = false; }
else if (user.equals("mkatich")){ goodLogin = false; }
else if (user.equals("melissa")){ goodLogin = false; }
else if (user.equals("admin")){ goodLogin = false; }
else if (user.equals("sandbox")){ goodLogin = false; } //user "sandbox" already exists for demonstration
else if (user.matches("example.*")){ goodLogin = false; } //example users already exist, want to preserve all examples

//checks for special characters
else if (user.indexOf("'") > -1){ goodLogin = false; } //don't allow single quotes
else if (pass.indexOf("'") > -1){ goodLogin = false; } //don't allow single quotes
else if (user.indexOf("\"") > -1){ goodLogin = false; } //don't allow double quotes
else if (pass.indexOf("\"") > -1){ goodLogin = false; } //don't allow double quotes
else if (user.indexOf("\\") > -1){ goodLogin = false; } //don't allow backslash
else if (pass.indexOf("\\") > -1){ goodLogin = false; } //don't allow backslash


//else if (!pass.matches("\\w*")){ goodLogin = false; } //regular expression check, only allows alphanumeric

int searchOptionInt = Integer.parseInt(searchOption); //get the searchOption code as an int



if (!goodLogin){
    //take them back to index.jsp to start over
    %>
    <body>
        <div class="main">
            <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
            <p>
                User not created.  The login info given was invalid.  Either the username or password
                you entered was blank, too long, the passwords entered didn't match, or invalid characters
                were used such as space or quotes.
            </p>
            <p>
                <a href="new2.jsp?loadDataName=<%=loadDataName%>">Try again</a>
            </p>
            <p>or <a href="index.jsp">Cancel</a></p>
        </div>
    </body>
    <%
}
else {
    //the login they entered passed preliminary test

    //set the searchUrl, searchLang values
    //if customSearchUrl was entered, use that for searchUrl
    if (customSearchUrlGoogle != null && !customSearchUrlGoogle.equals(""))
        searchUrlGoogle = customSearchUrlGoogle;
    if (customSearchUrlYahoo != null && !customSearchUrlYahoo.equals(""))
        searchUrlYahoo = customSearchUrlYahoo;

    //now set the values we'll be putting into the users table for URL and Lang
    String searchUrl = "";
    String searchLang = "";
    if (searchOptionInt >= 1 && searchOptionInt < 10){
        //1-9 it's Google
        searchUrl = searchUrlGoogle;
        searchLang = searchLang;
    }
    else if (searchOptionInt >= 10 && searchOptionInt < 20){
        //10-19 it's Yahoo
        searchUrl = searchUrlYahoo;
        searchLang = searchLangYahoo;
    }

    //if have a search option with no language, then make it blank string
    if (searchLang == null)
        searchLang = "";



    //-- Connection and Operations on database --
    String dbname = "ngumbi";
    String dbuser = "ngumbi_db_user";
    String dbpass = "m8w1b174cpx9w0j3l";
    Driver driver = null;
    String dbURL = "jdbc:mysql://localhost:3306/"+dbname+"?user=";
    Connection conn = null;

    Statement stat1 = null;
    Statement stat6 = null;
    Statement stat7 = null;
    String userQuery = "SELECT username FROM users WHERE username = '"+user+"'";
    ResultSet rsMatchingUsers = null;
    String adminCheck = "SELECT allowNewUsers, maxUsers FROM admin";
    ResultSet rsAdminCheck = null;
    String numUsersCheck = "SELECT COUNT(*) AS numUsers FROM users";
    ResultSet rsNumUsers = null;

    //execute SQL operations
    try {
        driver = (Driver) Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection(dbURL, dbuser, dbpass);
        stat1 = conn.createStatement();
        rsMatchingUsers = stat1.executeQuery(userQuery);//gets matching user(s) already in table
        stat6 = conn.createStatement();
        rsAdminCheck = stat6.executeQuery(adminCheck);//gets max users allowed and if new users are allowed from admin table
        stat7 = conn.createStatement();
        rsNumUsers = stat7.executeQuery(numUsersCheck);//get # of existing users from users table
    }
    catch (Exception e) {
        out.print("Unable to make connection to production database");
        out.print(e);
    }

    //get results of queries
    int allowNewUsers = 0;
    int maxUsers = 0;
    int numUsers = 0;
    boolean userAlreadyExists = false;

    if (rsAdminCheck.next()){
        allowNewUsers = rsAdminCheck.getInt("allowNewUsers");
        maxUsers = rsAdminCheck.getInt("maxUsers");
    }
    rsAdminCheck.close();
    if (rsNumUsers.next())
        numUsers = rsNumUsers.getInt("numUsers");
    rsNumUsers.close();
    if (rsMatchingUsers.next())
        userAlreadyExists = true;
    rsMatchingUsers.close();


    //do checks
    if (allowNewUsers == 0){
        //no new users allowed
        %>
        <body>
            <div class="main">
                <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
                <p>User not created.  Sorry, but there is a new users freeze in effect.  Please try again later.</p>
                <p><a href="index.jsp">Back to main page</a></p>
            </div>
        </body>
        <%
    }
    else if (numUsers >= maxUsers){
        //we are at max users, no more new users allowed
        %>
        <body>
            <div class="main">
                <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
                <p>
                    User not created.  Sorry but there is a new users freeze in effect in order to ensure our
                    current users have the best service.
                </p>
                <p><a href="index.jsp">Back to main page</a></p>
            </div>
        </body>
        <%
    }
    else if (userAlreadyExists){
        //username already in use
        %>
        <body>
            <div class="main">
                <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
                <p>
                    User not created.  The username <span style="color: red;"><%=user%></span>
                    is already in use.
                </p>
                <p><a href="new2.jsp?loadDataName=<%=loadDataName%>">Try again</a></p>
            </div>
        </body>
        <%
    }



    else {
        //everything good, add them to users table and fill in data if applicable

        //put their data into users table
        Statement stat2 = null;
        Statement stat4 = null;
        Statement stat22 = null;
        Statement stat44 = null;
        Statement stat55 = null;
        String lockTables = "LOCK TABLES users WRITE";
        String userInsert = "INSERT INTO users (username, pass, searchOption, searchUrl, searchLang, createdDate) VALUES ('"+user+"', '"+pass+"', "+searchOption+", '"+searchUrl+"', '"+searchLang+"', NOW())";
        String getUserIdJustInserted = "SELECT MAX(user_id) AS lastUserId FROM users";
        String fillCheck = "SELECT user_id FROM users WHERE username = '"+loadDataName+"'";
        String unlockTables = "UNLOCK TABLES";
        ResultSet rsfillcheck = null;
        ResultSet rsLastId = null;

        int user_id_just_inserted = 0;

        //execute SQL operations
        try {
            //lock tables
            stat22 = conn.createStatement();
            stat22.execute(lockTables);

            //add them to users table
            stat2 = conn.createStatement();
            stat2.executeUpdate(userInsert);

            //get user_id of user just inserted
            stat44 = conn.createStatement();
            rsLastId = stat44.executeQuery(getUserIdJustInserted);
            if (rsLastId.next())
                user_id_just_inserted = rsLastId.getInt("lastUserId");
            rsLastId.close();

            //get matching user(s) for fill purpose already in table
            stat4 = conn.createStatement();
            rsfillcheck = stat4.executeQuery(fillCheck);

            //unlock tables
            stat55 = conn.createStatement();
            stat55.execute(unlockTables);

            //check if user chose to fill in data instead of just start from scratch
            //validate loaddataname with the DB to make sure that user actually exists
            if (rsfillcheck.next()){
                int loadDataFromUserId = rsfillcheck.getInt("user_id");

                Statement stat5 = null;
                String fillLinks = "INSERT INTO user_links (user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank) (SELECT "+user_id_just_inserted+" AS user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank FROM user_links WHERE user_id = "+loadDataFromUserId+")";
                try {
                    stat5 = conn.createStatement();
                    stat5.executeUpdate(fillLinks);//fill their table with chosen data
                }
                catch (Exception e) {
                    out.print("Unable to make connection to production database");
                    out.print(e);
                }
            }
            rsfillcheck.close();


            //after database operations above, update history table with the event
            //this is considered an edit also so it updates lastEdited field in users table
            //		**ADMIN UPDATE**
            helperMethods.adminUpdate(user, "new user");

        }
        catch (Exception e) {
                out.print("Unable to make connection to production database");
                out.print(e);
        }
        finally {
            rsLastId.close();
            rsfillcheck.close();
            conn.close();
        }



        //display a new user created message, then link them to their page
        %>
        <body>
            <div class="main">
                <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
                <p>
                    Your username has been created!

                    <script type="text/javascript"><!--

                        // If it's IE, use automatic link for setting home page
                        if (document.all){
                            document.write('<p>First - ');
                            document.write('<a href="#" onClick="this.style.behavior=\'url(#default#homepage)\';this.setHomePage(\'http://www.ngumbi.com/user/<%=user%>\');">');
                            document.write('Click here to set your home page</a>');
                            document.write('</p>');
                            document.write('<p>Then - ');
                        }

                        // If not and it's a document.getElementById capable browser, tell user to drag link onto Home button
                        else if (document.getElementById){
                            document.write('<p>First - ');
                            document.write('<a href="user/<%=user%>">Drag this link onto your Home button to make this your Home Page.</a>');
                            document.write('</p>');
                            document.write('<p>Then - ');
                        }

                        // If it's Netscape 4 or lower, give instructions to set Home Page
                        else if (document.layers){
                            document.write('<p>Once you go to your page with the link below, please set it as your home page by clicking "Use Current" in your browser settings.</p>');
                        }

                        // If it's any other browser, for which I don't know the specifications of home paging, display instructions
                        else {
                            document.write('<p>Once you go to your page with the link below, please set it as your home page by clicking "Use Current" in your browser settings.</p>');
                        }
                    //  End -->
                    //--></script>


                    <a href="user/<%=user%>">Go to your page</a>

                </p>
            </div>
        </body>
        <%

    } //end - //everything good
}//end - //the login they entered passed preliminary test



%>
</html>