<%-- 
    Document   : new3
    Created on : Feb 18, 2011, 1:55:40 AM
    Author     : Michael
--%>

<%@page import="DbConnectionPool.DbConnectionPool"%>
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
<link rel="stylesheet" type="text/css" href="style1.css">
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
            <p>
                or <a href="index.jsp">Cancel</a>
            </p>
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

    
        
    boolean okToInsertNewUser = false;

    //-- Connection and Operations on database --
    
    String lockTables = "LOCK TABLES users WRITE, admin READ";
    PreparedStatement psLockTables = null;
    String unlockTables = "UNLOCK TABLES";
    PreparedStatement psUnlockTables = null;
    
    //check if any matching users already exist
    String userQuery = "SELECT username FROM users WHERE username = ? ";
    ResultSet rsMatchingUsers = null;
    PreparedStatement psMatchingUsers = null;
    boolean userAlreadyExists = false;
    
    //check some relevant admin variables currently set
    String adminCheck = "SELECT allowNewUsers, maxUsers FROM admin";
    ResultSet rsAdminCheck = null;
    PreparedStatement psAdminCheck = null;
    int allowNewUsers = -1;
    int maxUsers = -1;
    
    //check number of existing users currently
    String numUsersCheck = "SELECT COUNT(*) AS numUsers FROM users";
    ResultSet rsNumUsers = null;
    PreparedStatement psNumUsers = null;
    int numUsers = -1;
    
    //insert statement to insert new user!
    String userInsert = ""
        + "INSERT INTO users "
        + "(username, pass, searchOption, searchUrl, searchLang, createdDate) "
        + "VALUES "
        + "(?, ?, ?, ?, ?, NOW())";
    //    + "('"+user+"', '"+pass+"', "+searchOption+", '"+searchUrl+"', '"+searchLang+"', NOW())";
    PreparedStatement psUserInsert = null;
    boolean userInserted = false;
    
    //get user_id of user just inserted
    String getUserIdJustInserted = "SELECT MAX(user_id) AS lastUserId FROM users";
    ResultSet rsUserIdJustInserted = null;
    PreparedStatement psUserIdJustInserted = null;
    int user_id_just_inserted = 0;
    
    //get the user_id of selected existing user if the new user chose to fill links from existing user into theirs
    String getFillUserId = "SELECT user_id FROM users WHERE username = ? ";
    //String getFillUserId = "SELECT user_id FROM users WHERE username = '"+loadDataName+"'";
    ResultSet rsFillUserId = null;
    PreparedStatement psFillUserId = null;
    
    //prepare insert for inserting another user's links into the new user in case that was chosen
    String fillLinks = ""
        + "INSERT INTO user_links "
        + "(user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank) "
        + "(    "
        + "    SELECT ? AS user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank "
        + "    FROM user_links WHERE user_id = ? "
        + ") ";
//+ "     FROM user_links WHERE user_id = "+loadDataFromUserId+")";
    PreparedStatement psFillLinks = null;
                    
    
    
    
    Connection conn = null;
    try {
        conn = DbConnectionPool.getConnection();//fetch a connection
        if (conn != null){
            //perform queries/updates
            
            //lock tables
            psLockTables = conn.prepareStatement(lockTables);
            psLockTables.executeUpdate();
            
            
            //check if any matching users already exist
            psMatchingUsers = conn.prepareStatement(userQuery);
            psMatchingUsers.setString(1, user);
            rsMatchingUsers = psMatchingUsers.executeQuery();
            if (rsMatchingUsers.next()){
                userAlreadyExists = true;
            }
            
            //check some relevant admin variables currently set
            psAdminCheck = conn.prepareStatement(adminCheck);
            rsAdminCheck = psAdminCheck.executeQuery();
            if (rsAdminCheck.next()){
                allowNewUsers = rsAdminCheck.getInt("allowNewUsers");
                maxUsers = rsAdminCheck.getInt("maxUsers");
            }
            
            //check number of existing users currently
            psNumUsers = conn.prepareStatement(numUsersCheck);
            rsNumUsers = psNumUsers.executeQuery();
            if (rsNumUsers.next()){
                numUsers = rsNumUsers.getInt("numUsers");
            }
            
            
            //now check if inputs and admin variables allow us to 
            //insert a new user
            if (!userAlreadyExists && allowNewUsers == 1 && numUsers < maxUsers){
                okToInsertNewUser = true;
                
                //do new user insert!
                psUserInsert = conn.prepareStatement(userInsert);
                psUserInsert.setString(1, user);
                psUserInsert.setString(2, pass);
                psUserInsert.setString(3, searchOption);
                psUserInsert.setString(4, searchUrl);
                psUserInsert.setString(5, searchLang);
                psUserInsert.executeUpdate();
                userInserted = true;
            
                //get user_id of user just inserted (auto-incremented)
                psUserIdJustInserted = conn.prepareStatement(getUserIdJustInserted);
                rsUserIdJustInserted = psUserIdJustInserted.executeQuery();
                if (rsUserIdJustInserted.next()){
                    user_id_just_inserted = rsUserIdJustInserted.getInt("lastUserId");
                }
                
                
                //unlock tables here since we're done with the stuff we need 
                //locking for, and so we don't have to lock the user_links table
                psUnlockTables = conn.prepareStatement(unlockTables);
                psUnlockTables.executeUpdate();
                
                //check if user chose to fill in data instead of just start from scratch
                //validate loaddataname with the DB to make sure that user actually exists
                psFillUserId = conn.prepareStatement(getFillUserId);
                psFillUserId.setString(1, loadDataName);
                rsFillUserId = psFillUserId.executeQuery();
                if (rsFillUserId.next()){
                    //yes, the loadDataName matches an already existing user, so 
                    //new user chose to fill with that
                    int loadDataFromUserId = rsFillUserId.getInt("user_id");
                    
                    //execute filling of chosen user's links into new user
                    psFillLinks = conn.prepareStatement(fillLinks);
                    psFillLinks.setInt(1, user_id_just_inserted);
                    psFillLinks.setInt(2, loadDataFromUserId);
                    psFillLinks.executeUpdate();
                }
                
            }
            
            
        }
    }
    catch (SQLException e) {
        DbConnectionPool.outputException(e, "new3.jsp", 
            new String[]{
                "lockTables", lockTables, 
                "userQuery", userQuery, 
                "adminCheck", adminCheck, 
                "numUsersCheck", numUsersCheck, 
                "userInsert", userInsert, 
                "getUserIdJustInserted", getUserIdJustInserted, 
                "getFillUserId", getFillUserId, 
                "fillLinks", fillLinks}
            );
    }
    finally {
        DbConnectionPool.closeStatement(psLockTables);
        
        DbConnectionPool.closeResultSet(rsMatchingUsers);
        DbConnectionPool.closeStatement(psMatchingUsers);
        DbConnectionPool.closeResultSet(rsAdminCheck);
        DbConnectionPool.closeStatement(psAdminCheck);
        DbConnectionPool.closeResultSet(rsNumUsers);
        DbConnectionPool.closeStatement(psNumUsers);
        
        DbConnectionPool.closeStatement(psUserInsert);
        
        DbConnectionPool.closeResultSet(rsUserIdJustInserted);
        DbConnectionPool.closeStatement(psUserIdJustInserted);

        DbConnectionPool.closeStatement(psFillUserId);
        
        //unlock tables in finally, even if already have unlock in the try{},
        //so they are unlocked even if has exception
        if (conn != null){
            psUnlockTables = conn.prepareStatement(unlockTables);
            psUnlockTables.executeUpdate();
        }
        
        DbConnectionPool.closeConnection(conn);
    }
    

    //do checks
    if (!userInserted){
        //we didn't insert the new user. check reasons why and display based on that.
        

        if (allowNewUsers == 0){
            //no new users allowed
            %>
            <body>
                <div class="main">
                    <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
                    <p>User not created. Sorry, but there is a new users freeze in effect.  Please try again later.</p>
                    <p><a href="index.jsp">Back to main page</a></p>
                </div>
            </body>
            <%
        }
        else if (numUsers >= maxUsers && numUsers != -1 && maxUsers != -1){
            //we are at max users, no more new users allowed
            %>
            <body>
                <div class="main">
                    <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
                    <p>
                        User not created. Sorry but there is a new users freeze in effect in order to ensure our
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
                        User not created. The username <span style="color: red;"><%=user%></span>
                        is already in use.
                    </p>
                    <p><a href="new2.jsp?loadDataName=<%=loadDataName%>">Try again</a></p>
                </div>
            </body>
            <%
        }        
        
    }
    else {
        //everything good, we added new user!
                
        //after database operations above, update history table with the event
        //this is considered an edit also so it updates lastEdited field in users table
        //		**ADMIN UPDATE**
        helperMethods.adminUpdate(user, "new user");
        
        //display a new user created message, then link them to their page
        %>
        <body>
            <div class="main">
                <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
                <p>
                    Your username <b><%=user%></b> has been created!

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