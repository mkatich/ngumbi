<%-- 
    Document   : admin
    Created on : 
    Author     : Michael

    Description: Shows stats and allows admin option changes.
    
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="DbConnectionPool.DbConnectionPool"%>
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
                String loginQuery = "SELECT pass FROM users WHERE username = ?";
                PreparedStatement psCheckPass = null;
                ResultSet rsCheckPass = null;

                Connection conn = null;
                try {
                    conn = DbConnectionPool.getConnection();//fetch a connection
                    if (conn != null){
                        //perform queries/updates
                        psCheckPass = conn.prepareStatement(loginQuery);
                        psCheckPass.setString(1, user);
                        rsCheckPass = psCheckPass.executeQuery();

                        //get saved data
                        if (rsCheckPass.next()){
                            String tablePass = rsCheckPass.getString("pass");					
                            if (tablePass.equals(pass)){
                                logon.setUserID(user);
                                logon.setSecure();
                            }
                        }
                    }
                }
                catch (SQLException e) {
                    DbConnectionPool.outputException(e, "admin.jsp", "loginQuery", loginQuery);
                }
                finally {
                    DbConnectionPool.closeResultSet(rsCheckPass);
                    DbConnectionPool.closeStatement(psCheckPass);
                    DbConnectionPool.closeConnection(conn);
                }
                
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
                //show most recent history entries (not all of them)
                if (state.equals("2")){
                    
                    String historyQuery = ""
                            + "SELECT h.user_id AS user_id, u.username AS username, h.event_type AS event_type, h.event_time AS event_time "
                            + "FROM history h LEFT JOIN users u ON (h.user_id = u.user_id) "
                            + "ORDER BY h.event_time DESC "
                            + "LIMIT 30";
                    PreparedStatement psHistory = null;
                    ResultSet rsHistory = null;
                    String[][] historyResults = null;
                    
                    Connection conn = null;
                    try {
                        conn = DbConnectionPool.getConnection();//fetch a connection
                        if (conn != null){
                            //perform queries/updates
                            psHistory = conn.prepareStatement(historyQuery, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            rsHistory = psHistory.executeQuery();

                            //get saved data
                            int countHistoryResults = 0;
                            while (rsHistory.next()){
                                countHistoryResults++;
                            }
                            rsHistory.beforeFirst();
                            
                            historyResults = new String[countHistoryResults][4];
                            countHistoryResults = 0;
                            while (rsHistory.next()){
                                historyResults[countHistoryResults][0] = rsHistory.getString("user_id");
                                historyResults[countHistoryResults][1] = rsHistory.getString("username");
                                historyResults[countHistoryResults][2] = rsHistory.getString("event_type");
                                historyResults[countHistoryResults][3] = rsHistory.getString("event_time");
                                countHistoryResults++;
                            }
                            
                        }
                    }
                    catch (SQLException e) {
                        DbConnectionPool.outputException(e, "admin.jsp", "historyQuery", historyQuery);
                    }
                    finally {
                        DbConnectionPool.closeResultSet(rsHistory);
                        DbConnectionPool.closeStatement(psHistory);
                        DbConnectionPool.closeConnection(conn);
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
                            for (int i = 0; i < historyResults.length; i++){
                                //get all values this row
                                String currUserId = historyResults[i][0];
                                String currUsername = historyResults[i][1];
                                String currEventType = historyResults[i][2];
                                String currEventTime = historyResults[i][3];
                                
                                // color coding based on eventType
                                if (currEventType.equals("new user")){
                                    bgcolor = "#ffffcc";	
                                }
                                else {
                                    bgcolor = "#ffffff";
                                }
                                %>
                                <tr>
                                    <td bgcolor=<%=bgcolor%>><%=currUserId%></td>
                                    <td bgcolor=<%=bgcolor%>><%=currUsername%></td>
                                    <td bgcolor=<%=bgcolor%>><%=currEventType%></td>
                                    <td bgcolor=<%=bgcolor%>><%=currEventTime%></td>
                                </tr>
                                <%
                            }
                            %>
                        </table>
                    </div>
                    <%
                    
                } //end state.equals("2"), main screen once logged in

                //state 3s, top menu, statistics was chosen from top menu
                //show all history entries
                if (state.equals("3s")){
                    String historyQuery = ""
                            + "SELECT h.user_id AS user_id, u.username AS username, h.event_type AS event_type, h.event_time AS event_time "
                            + "FROM history h LEFT JOIN users u ON (h.user_id = u.user_id) "
                            + "ORDER BY h.event_time DESC ";
                    PreparedStatement psHistory = null;
                    ResultSet rsHistory = null;
                    String[][] historyResults = null;
                    
                    Connection conn = null;
                    try {
                        conn = DbConnectionPool.getConnection();//fetch a connection
                        if (conn != null){
                            //perform queries/updates
                            psHistory = conn.prepareStatement(historyQuery, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            rsHistory = psHistory.executeQuery();

                            //get saved data
                            int countHistoryResults = 0;
                            while (rsHistory.next()){
                                countHistoryResults++;
                            }
                            rsHistory.beforeFirst();
                            
                            historyResults = new String[countHistoryResults][4];
                            countHistoryResults = 0;
                            while (rsHistory.next()){
                                historyResults[countHistoryResults][0] = rsHistory.getString("user_id");
                                historyResults[countHistoryResults][1] = rsHistory.getString("username");
                                historyResults[countHistoryResults][2] = rsHistory.getString("event_type");
                                historyResults[countHistoryResults][3] = rsHistory.getString("event_time");
                                countHistoryResults++;
                            }
                            
                        }
                    }
                    catch (SQLException e) {
                        DbConnectionPool.outputException(e, "admin.jsp", "historyQuery", historyQuery);
                    }
                    finally {
                        DbConnectionPool.closeResultSet(rsHistory);
                        DbConnectionPool.closeStatement(psHistory);
                        DbConnectionPool.closeConnection(conn);
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
                            for (int i = 0; i < historyResults.length; i++){
                                //get all values this row
                                String currUserId = historyResults[i][0];
                                String currUsername = historyResults[i][1];
                                String currEventType = historyResults[i][2];
                                String currEventTime = historyResults[i][3];
                                
                                // color coding based on eventType
                                if (currEventType.equals("new user")){
                                    bgcolor = "#ffffcc";	
                                }
                                else {
                                    bgcolor = "#ffffff";
                                }
                                %>
                                <tr>
                                    <td bgcolor=<%=bgcolor%>><%=currUserId%></td>
                                    <td bgcolor=<%=bgcolor%>><%=currUsername%></td>
                                    <td bgcolor=<%=bgcolor%>><%=currEventType%></td>
                                    <td bgcolor=<%=bgcolor%>><%=currEventTime%></td>
                                </tr>
                                <%
                            }
                            %>
                        </table>
                    </div>
                    <%
                    
                } //end state.equals("3s"), statistics

                //state 3v, top menu, admin variables was chosen from top menu
                if (state.equals("3v") || state.equals("3v_1")){

                    %>Table: 'admin' &nbsp;&nbsp;&nbsp;&nbsp;<%
                        
                        
                    //if fromstate equals 3v or 3v_1, do update on admin table
                    if (fromstate.equals("3v") || fromstate.equals("3v_1")){

                        //check what field was updated
                        //either one of the variables based on fields in the admin table is not null or they are all null
                        
                        //first get table info, what fields exist (allows for future changes to admin table)
                        String adminFieldsQuery = "SHOW COLUMNS FROM admin";
                        PreparedStatement psAdminFields = null;
                        ResultSet rsAdminFields = null;
                        String adminChangeField = "";//will be field that has change
                        String adminChangeValue = ""; //get input from form
                        boolean nonNullFound = false;
                        
                        //update statement as needed
                        String adminTableUpdate = "";
                        PreparedStatement psAdminTableUpdate = null;

                        Connection conn = null;
                        try {
                            conn = DbConnectionPool.getConnection();//fetch a connection
                            if (conn != null){
                                //perform queries/updates
                                psAdminFields = conn.prepareStatement(adminFieldsQuery);
                                rsAdminFields = psAdminFields.executeQuery();

                                //get saved data
                                while (rsAdminFields.next() && !nonNullFound){
                                    adminChangeField = rsAdminFields.getString("Field");
                                    adminChangeValue = request.getParameter("field_"+adminChangeField);
                                    if (adminChangeValue != null && !adminChangeValue.equals("")){
                                        nonNullFound = true;
                                    }
                                }
                                
                                //if we found non-null input, change the table.  Otherwise do nothing.
                                if (nonNullFound == true){
                                    adminTableUpdate = "UPDATE admin SET "+adminChangeField+" = ? ";//can't set column names as parameters this way
                                    psAdminTableUpdate = conn.prepareStatement(adminTableUpdate);
                                    psAdminTableUpdate.setString(1, adminChangeValue);
                                    psAdminTableUpdate.executeUpdate();
                                    
                                    //display update message
                                    %><span style="background-color: #ffffcc">The field <b><%=adminChangeField%></b> has been updated to <b><%=adminChangeValue%></b></span><%
                                }	
                                
                            }
                        }
                        catch (SQLException e) {
                            DbConnectionPool.outputException(e, "admin.jsp", "adminFieldsQuery", adminFieldsQuery);
                        }
                        finally {
                            DbConnectionPool.closeResultSet(rsAdminFields);
                            DbConnectionPool.closeStatement(psAdminFields);
                            
                            DbConnectionPool.closeStatement(psAdminTableUpdate);
                            
                            DbConnectionPool.closeConnection(conn);
                        }
                        
                        				
                    }


                    //get table showing all current variables (one may have been updated as well)
                    //these operations will work without knowing the field names 
                    //or the number of admin fields ahead of time so that I can change
                    //admin table later (add a field) and not break this function
                    
                    String adminFieldsQuery = "SHOW COLUMNS FROM admin";
                    PreparedStatement psAdminFields = null;
                    ResultSet rsAdminFields = null;
                    String[] adminFieldsArray = null;

                    String adminValuesQuery = "SELECT * FROM admin";
                    PreparedStatement psAdminValues = null;
                    ResultSet rsAdminValues = null;
                    String[] adminValuesArray = null;
                    
                    Connection conn = null;
                    try {
                        conn = DbConnectionPool.getConnection();//fetch a connection
                        if (conn != null){
                            //query for admin fields
                            psAdminFields = conn.prepareStatement(adminFieldsQuery);
                            rsAdminFields = psAdminFields.executeQuery();

                            //get admin fields data
                            List<String> adminFieldsList = new ArrayList<>();
                            while (rsAdminFields.next()){
                                adminFieldsList.add(rsAdminFields.getString("Field"));
                            }
                            adminFieldsArray = adminFieldsList.toArray(new String[adminFieldsList.size()]);
                            
                            //query for admin values
                            psAdminValues = conn.prepareStatement(adminValuesQuery);
                            rsAdminValues = psAdminValues.executeQuery();
                            
                            //get admin values data
                            //will fill these in based on 
                            List<String> adminValuesList = new ArrayList<>();
                            if (rsAdminValues.next()){
                                for (int i = 0; i < adminFieldsArray.length; i++){
                                    adminValuesList.add(rsAdminValues.getString(adminFieldsArray[i]));
                                }
                            }
                            adminValuesArray = adminValuesList.toArray(new String[adminValuesList.size()]);
                            
                        }
                    }
                    catch (SQLException e) {
                        DbConnectionPool.outputException(e, "admin.jsp", "adminFieldsQuery", adminFieldsQuery);
                    }
                    finally {
                        DbConnectionPool.closeResultSet(rsAdminFields);
                        DbConnectionPool.closeStatement(psAdminFields);

                        DbConnectionPool.closeResultSet(rsAdminValues);
                        DbConnectionPool.closeStatement(psAdminValues);

                        DbConnectionPool.closeConnection(conn);
                    }
                    
                    
                    %>
                    <div class="vartable">
                        <table border="1">
                                <tr>
                                    <%
                                        
                                        for (int i = 0; i < adminFieldsArray.length; i++){
                                            %><th><%=adminFieldsArray[i]%></th><%
                                        }
                                        
                                    %>
                                </tr>
                                <tr>
                                    <%
                                        
                                        for (int i = 0; i < adminValuesArray.length; i++){
                                            %><td><%=adminValuesArray[i]%></td><%
                                        }
                                        
                                    %>
                                </tr>
                                <tr>
                                    <%
                                        //this row has inputs and allows for
                                        //updating the values
                                        for (int i = 0; i < adminFieldsArray.length; i++){
                                            %>
                                            <td>
                                                <form name="form_<%=adminFieldsArray[i]%>" method="post" action="admin.jsp">
                                                <input name="field_<%=adminFieldsArray[i]%>" size="5" value=""><br>
                                                <input name="user" value="<%=user%>" type="hidden">
                                                <input name="state" value="3v_1" type="hidden">
                                                <input name="fromstate" value="<%=state%>" type="hidden">
                                                <input type="submit" value="update">						
                                                </form>
                                                </td>
                                            <%
                                        }
                                        
                                    %>
                                </tr>
                        </table>
                    </div><!-- vartable -->

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
                    
                } //end state 3v, edit admin variables chosen from top links

            } //end check if user is logged in

        } //end else for every state other than state1
        
        
        
        %>
    </div><!-- end div class=main -->

</body>
</html>