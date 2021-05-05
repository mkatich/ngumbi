<%-- 
    Document   : admin
    Created on : 
    Author     : Michael

    Description: Shows stats and allows admin option changes.
    
--%>

<jsp:useBean id="logon" scope="session" class="logonBean.logon" />
<%@ page language="java" import="java.sql.*" import="java.net.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.StringWriter"%>

<%
//set coding to UTF-8 before getting parameters
request.setCharacterEncoding("UTF-8");

//get the passed arguments, if not logged in yet, will only have user & state
String user = request.getParameter("user");
String pass = request.getParameter("pass");
String cpass = request.getParameter("cpass");
String state = request.getParameter("state");
String fromstate = request.getParameter("fromstate");

//used for editing purposes
/*String cat = request.getParameter("cat");
String catrank = request.getParameter("catrank");
String subcatrank = request.getParameter("subcatrank");
String linkrank = request.getParameter("linkrank");
String linkurl = request.getParameter("linkurl"); 
String linkname = request.getParameter("linkname"); //used to identify link that was clicked
String catnew = request.getParameter("catnew"); //new category name that was entered
String linkurlnew = request.getParameter("linkurlnew"); //new URL that was entered
String linknamenew = request.getParameter("linknamenew"); //new link name that was entered
String catradio = request.getParameter("catradio");
String rowradio = request.getParameter("rowradio");
String searchradio = request.getParameter("searchradio");
*/


%>
<html>
<head>
    <title>Ngumbi Admin</title>

    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="style-admin.css">
    <jsp:include page="inc_google_analytics.jsp" />
</head>
<body>
    <div class="main">
        <div class="title">
            <span class="logo">
                <a href="index.jsp"><span class="logo1">n</span><span class="logo2">gumbi</span><img src="images/logodot.gif" alt="dot" border=0><span class="logo3">com</span></a>
            </span>
            <a href="admin.jsp" style="text-decoration: none"><span class="row1">Administrator</span></a>
        </div>
        <%
        //Declarations for SQL operations, used both in state conditionals and jumpstation code
        String dbname = "ngumbi";
        String dbuser = "ngumbi_db_user";
        String dbpass = "m8w1b174cpx9w0j3l";
        Driver driver = null;
        String dbURL = "jdbc:mysql://localhost:3306/"+dbname+"?user=";
        Connection conn = null;

        try {
            driver = (Driver) Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection(dbURL, dbuser, dbpass);
        } 
        catch (Exception e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println("ERROR in admin.jsp, DB connection. \n"+stackTrace);
        }


        if (state == null){
            state = "1";
            fromstate = "0";
        }

        if (state.equals("1")){
            %>
            <center>
                <form name="jump" method="POST" action="admin.jsp"> 
                Username: <input name="user" size="15" maxlength="30">
                <p>
                    Password: <input type="password" name="pass" size="15" maxlength="30">
                    <input type="hidden" name="state" value="2" >
                    <input type="hidden" name="fromstate" value="1">
                <p>
                    <input type="submit" value="Submit">
                </form>
            </center>

            <!--set focus in javascript-->
            <script type="text/javascript"><!--
            document.jump.user.focus();
            //--></script>
            <%

            //this logs out the admin
            logon.logout();	
        }


        else {
            //For every state other than state1, check login info so it's always verified before any SQL is executed
            if (fromstate.equals("1")){
                //check password, set bean
                Statement stat4 = null;
                ResultSet rslogincheck = null;			
                String loginQuery = "SELECT pass FROM users WHERE username = '"+user+"'";
                //execute SQL operations
                try {
                    stat4 = conn.createStatement();
                    rslogincheck = stat4.executeQuery(loginQuery);//gets matching user(s) already in table

                    //check login info
                    if (rslogincheck.next()){
                        String tablePass = rslogincheck.getString("pass");					
                        if (tablePass.equals(pass)){
                            logon.setUserID(user);
                            logon.setSecure();
                        }
                    }
                    rslogincheck.close();

                }
                catch (Exception e) { 
                    StringWriter sw = new StringWriter();
                    e.printStackTrace(new PrintWriter(sw));
                    String stackTrace = sw.toString();
                    System.out.println("ERROR in admin.jsp, loginQuery: "+loginQuery+" \n"+stackTrace);
                }	
                //rslogincheck.close();
            }


            //check if user is logged in, all changes to databases are within this conditional
            if (logon.getUserID().equals("mike") && logon.getSecure()){
                %>
                <div class="row2">
                        <a href="admin.jsp?user=<%=user%>&state=2&fromstate=<%=state%>">Admin home</a> &nbsp;&nbsp;
                        <a href="admin.jsp?user=<%=user%>&state=1&fromstate=<%=state%>">Logout</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="admin.jsp?user=<%=user%>&state=3s&fromstate=<%=state%>">Statistics</a> &nbsp;&nbsp;
                        <a href="dd">Manage Users</a> &nbsp;&nbsp;
                        <a href="admin.jsp?user=<%=user%>&state=3v&fromstate=<%=state%>">Admin Variables</a> &nbsp;&nbsp;
                        <a href="lkad">Restore</a>
                </div>
                <%
                //state 2 is main screen once logged in as admin
                if (state.equals("2")){

                    //table showing a peek at the history table
                    Statement stat5 = null;
                    ResultSet rshistory1 = null;
                    String historyQuery1 = "SELECT h.user_id AS user_id, u.username AS username, h.event_type AS event_type, h.event_time AS event_time FROM history h LEFT JOIN users u ON (h.user_id = u.user_id) ORDER BY h.event_time DESC LIMIT 30";
                    try {
                        stat5 = conn.createStatement();
                        rshistory1 = stat5.executeQuery(historyQuery1);
                    }
                    catch (Exception e) { 
                        StringWriter sw = new StringWriter();
                        e.printStackTrace(new PrintWriter(sw));
                        String stackTrace = sw.toString();
                        System.out.println("ERROR in admin.jsp, historyQuery1: "+historyQuery1+" \n"+stackTrace);
                    }				
                    %>
                    <div class="bigtable">
                        <table>
                            <tr>
                                <th>user_id</th>
                                <th>user</th>
                                <th>event_type</th>
                                <th>event_time</th>
                            </tr>
                            <%
                            String bgcolor = "#ffffff";
                            while (rshistory1.next()){
                                // color coding based on eventType
                                if (rshistory1.getString("event_type").equals("new user")){
                                    bgcolor = "#ffffcc";	
                                }
                                else {
                                    bgcolor = "#ffffff";
                                }
                                %>
                                <tr>
                                    <td bgcolor=<%=bgcolor%>><%=rshistory1.getString("user_id")%></td>
                                    <td bgcolor=<%=bgcolor%>><%=rshistory1.getString("username")%></td>
                                    <td bgcolor=<%=bgcolor%>><%=rshistory1.getString("event_type")%></td>
                                    <td bgcolor=<%=bgcolor%>><%=rshistory1.getString("event_time")%></td>
                                </tr>
                                <%
                            }
                            %>
                        </table>
                    </div>	
                    <%


                } //end state.equals("2"), main screen once logged in

                //state 3s, top menu, statistics was chosen from top menu
                if (state.equals("3s")){

                    //table showing entire history table
                    Statement stat53 = null;
                    ResultSet rshistory2 = null;
                    String historyQuery2 = "SELECT h.user_id AS user_id, u.username AS username, h.event_type AS event_type, h.event_time AS event_time FROM history h LEFT JOIN users u ON (h.user_id = u.user_id) ORDER BY h.event_time DESC";
                    try {
                        stat53 = conn.createStatement();
                        rshistory2 = stat53.executeQuery(historyQuery2);
                    }
                    catch (Exception e) { 
                        StringWriter sw = new StringWriter();
                        e.printStackTrace(new PrintWriter(sw));
                        String stackTrace = sw.toString();
                        System.out.println("ERROR in admin.jsp, historyQuery2: "+historyQuery2+" \n"+stackTrace);
                    }				
                    %>
                    <div class="bigtable">
                            <table>
                                    <tr>
                                            <th>user_id</th>
                                            <th>user</th>
                                            <th>event_type</th>
                                            <th>event_time</th>
                                    </tr>
                                    <%
                                    String bgcolor = "#ffffff";
                                    while (rshistory2.next()){
                                            // color coding based on eventType
                                            if (rshistory2.getString("event_type").equals("new user")){
                                                    bgcolor = "#ffffcc";	
                                            }
                                            else {
                                                    bgcolor = "#ffffff";
                                            }				%>
                                            <tr>
                                                    <td bgcolor=<%=bgcolor%>><%=rshistory2.getString("user_id")%></td>
                                                    <td bgcolor=<%=bgcolor%>><%=rshistory2.getString("username")%></td>
                                                    <td bgcolor=<%=bgcolor%>><%=rshistory2.getString("event_type")%></td>
                                                    <td bgcolor=<%=bgcolor%>><%=rshistory2.getString("event_time")%></td>
                                            </tr><%
                                    }
                                    %>
                            </table>
                    </div>	
                    <%

                }

                //state 3v, top menu, admin variables was chosen from top menu
                if (state.equals("3v") || state.equals("3v_1")){

                    %>Table: 'admin' &nbsp;&nbsp;&nbsp;&nbsp;<%

                    //if fromstate equals 3v or 3v_1, do update on admin table
                    if (fromstate.equals("3v") || fromstate.equals("3v_1")){

                        //check what field was updated
                        //either one of the variables based on fields in the admin table is not null or they are all null

                        //first get table info, what fields exist (allows for future changes to admin table)
                        Statement stat51 = null;
                        ResultSet rsadminfields51 = null;
                        String adminFieldsQuery51 = "SHOW COLUMNS FROM admin";
                        try {
                            stat51 = conn.createStatement();
                            rsadminfields51 = stat51.executeQuery(adminFieldsQuery51);
                        }
                        catch (Exception e) { 
                            StringWriter sw = new StringWriter();
                            e.printStackTrace(new PrintWriter(sw));
                            String stackTrace = sw.toString();
                            System.out.println("ERROR in admin.jsp, adminFieldsQuery51: "+adminFieldsQuery51+" \n"+stackTrace);
                        }	

                        String adminChangeField = "";	//will be field that has change
                        String adminChangeValue = ""; //will be value of input
                        boolean nonNullFound = false;
                        //loop through all fields, check for non-null and non-blank inputs
                        while (rsadminfields51.next() && !nonNullFound){
                            adminChangeField = rsadminfields51.getString("Field");
                            adminChangeValue = request.getParameter("field_"+adminChangeField); //get input from form
                            if (adminChangeValue != null && !adminChangeValue.equals("")){
                                nonNullFound = true;
                            }
                        }

                        //if we found non-null input, change the table.  Otherwise do nothing.
                        if (nonNullFound == true){
                            Statement stat52 = null;
                            String adminTableUpdate = "UPDATE admin SET "+adminChangeField+" = '"+adminChangeValue+"'";
                            try {
                                stat52 = conn.createStatement();
                                stat52.executeUpdate(adminTableUpdate);
                            } 
                            catch (Exception e) {
                                StringWriter sw = new StringWriter();
                                e.printStackTrace(new PrintWriter(sw));
                                String stackTrace = sw.toString();
                                System.out.println("ERROR in admin.jsp, adminTableUpdate: "+adminTableUpdate+" \n"+stackTrace);
                            }					

                            //display update message
                            %><span style="background-color: #ffffcc">The field <b><%=adminChangeField%></b> has been updated to <b><%=adminChangeValue%></b></span><%
                        }				
                        rsadminfields51.close();				
                    }


                    //table showing all current variables
                    //first get table info to generically display it, so I can change
                    //admin table later (add a field) and not break this function
                    Statement stat6 = null;
                    ResultSet rsadminfields = null;
                    String adminFieldsQuery = "SHOW COLUMNS FROM admin";			
                    Statement stat7 = null;
                    ResultSet rsadminvars = null;
                    String adminVarsQuery = "SELECT * FROM admin";
                    try {
                        stat6 = conn.createStatement();
                        rsadminfields = stat6.executeQuery(adminFieldsQuery);
                        stat7 = conn.createStatement();
                        rsadminvars = stat7.executeQuery(adminVarsQuery);
                    }
                    catch (Exception e) { 
                        StringWriter sw = new StringWriter();
                        e.printStackTrace(new PrintWriter(sw));
                        String stackTrace = sw.toString();
                        System.out.println("ERROR in admin.jsp, \n adminFieldsQuery: "+adminFieldsQuery+"\n adminVarsQuery: "+adminVarsQuery+" \n"+stackTrace);
                    }	

                    %>
                    <div class="vartable">
                        <table border="1">
                                <tr>
                                    <%
                                    int count = 0; //stores number of fields in admin table to use later in more loops
                                    //loop for each field in admin table, do table headers
                                    while (rsadminfields.next()){
                                        %><th><%=rsadminfields.getString("Field")%></th><%
                                        count++;
                                    }
                                    %>
                                </tr>
                                <tr>
                                    <%
                                    rsadminfields.beforeFirst(); //move cursor back to beginning
                                    //loop again for values
                                    if (rsadminvars.next()){			
                                        while (rsadminfields.next()){
                                            %><td><%=rsadminvars.getString(rsadminfields.getString("Field"))%></td><%	
                                        }			
                                    }			
                                    %>
                                </tr>								
                        </table>
                    </div><!-- vartable -->

                    <div class="edittable">
                        <table border="1">
                            <tr>
                                <%
                                rsadminfields.beforeFirst(); //move cursor back to beginning
                                //loop for each field in admin table, do table headers
                                while (rsadminfields.next()){
                                        %><th><%=rsadminfields.getString("Field")%></th><%
                                }
                                %>		
                            </tr>
                            <tr>
                                <%
                                rsadminfields.beforeFirst(); //move cursor back to beginning
                                //loop for the edit fields and submit buttons
                                while (rsadminfields.next()){
                                    %>
                                    <td align=center>
                                        <form name="form_<%=rsadminfields.getString("Field")%>" method="post" action="admin.jsp">
                                        <input name="field_<%=rsadminfields.getString("Field")%>" size="5" value=""><br>
                                        <input name="user" value="<%=user%>" type=hidden>
                                        <input name="state" value="3v_1" type=hidden>
                                        <input name="fromstate" value="<%=state%>" type=hidden>
                                        <input type="submit" value="submit">						
                                        </form>
                                    </td>
                                    <%							
                                }						
                                %>
                            </tr>
                        </table>			
                    </div><!-- edittable -->

                    <div class="details">
                        <ol>
                                <li>
                                    <span class="bold">allowNewUsers</span> 
                                    - checked by new user process before allowing creation of new user.
                                    <ul>
                                        <li>0 for new users not allowed
                                        <li>1 for new users are allowed
                                    </ul>
                                </li>
                                <li>
                                    <span class="bold">maxUsers</span> 
                                    - checked by new user process before allowing creation of new user.
                                    <br>new user process checks the size of the 'users' table and compares to maxUsers
                                    value in the 'admin' table.  If the current number of users is
                                    <ul>
                                        <li>Greater than or equal to maxUsers - new users are not allowed
                                        <li>Less than maxUsers - new users are allowed
                                    </ul>
                                </li>
                                <li>
                                    <span class="bold">recordHistory</span> 
                                    - checked by editor.jsp before recording an edit action to 
                                    the 'history' table, and by user_page.jsp before recording a view to 'history' table.
                                    <ul>
                                        <li>0 for no recording to 'history' table
                                        <li>1 for reporting only edits
                                        <li>2 for reporting only views
                                        <li>3 for reporting both edits and views
                                    </ul>
                                </li>
                                <li>
                                    <span class="bold">maxHistorySize</span> 
                                    - checked by editor.jsp before recording an edit action to 
                                    the 'history' table, and by user_page.jsp before recording a view to 'history' table.
                                    In both cases, if the 'history' table is equal to or greater than the maxHistorySize
                                    value in the 'admin' table, the oldest entry in the 'history' table is deleted before
                                    the new entry is added.  These operations lock the 'history' table to ensure integrity.
                                    If maxHistorySize is changed to a smaller size, further operations are needed to delete
                                    the excess entries, otherwise it will just stay the same size.  If maxHistorySize is
                                    changed within admin.jsp, the deletion is done automatically with locks.
                                </li>
                                <li>
                                    <span class="bold">maxLinks</span> 
                                    - checked by editor.jsp before 'Add a link' operation.  If the current number
                                    of links in a user's table is greater than or equal to maxLinks in the 'admin' table,
                                    then new links cannot be added.  Changing maxLinks in admin.jsp or manually does not
                                    delete or change users' data.
                                </li>						
                        </ol>
                    </div><!-- details -->
                    <%

                    rsadminfields.close();
                    rsadminvars.close();

                } //end state 3v, edit admin variables chosen from top links

            } //end check if user is logged in

        } //end else for every state other than state1
        
        
        
        try {
            conn.close();
        } 
        catch (Exception e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println("ERROR in admin.jsp, closing DB connection. \n"+stackTrace);
        }



        %>
    </div><!-- end div class=main -->

<!-- code to list variable for development only, delete when finished. -->

<!--<p><p><p><p><p><br><br>
 user-<%=user%><br>
state-<%=state%><br>
fromstate-<%=fromstate%><br>
-->
<!--	end		-->

</body>
</html>