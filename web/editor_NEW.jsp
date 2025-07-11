<%
/*********************************************************************
*	File: editor_NEW.jsp
*	Description: This is the editor used by existing users to edit
*	their jumpstation.
*
*	Author: Michael Katich
*********************************************************************/



/*
Explanation of states of the user interface.  

*state 1 - they clicked edit on their jumpstation, take them to editor_NEW.jsp with username passed, which will 
	be their jumpstation with a yellow column on the right.  State 1 will just have their username and a 
	textbox for them to enter their password.
*state 2 - after they enter correct (CHECK) password, the column on right will show all editing options.  
	Add a link, Edit a link, Move a link, Delete a link, Move a category, Rename a category, Cancel, Start 
	Over etc. State 2 also does all the SQL execution after editor has come from another state editing a 
	certain thing (using fromstate variable).
*state 3a - they chose Add a link option.  Has form for user to enter linkname, link url, category.
	Existing categories are shown among the choices, also the default "no category" 
	and user can input new category. They do not enter linkrank, if they want to 
	add a link in between other links they will have to use the Move a link.
	*state 3a_1 - user given error message for trying to add link or name already in use, 
		or other error and can try again
*state 3e - they chose Edit a link.  This state has plain text in the yellow column saying to click the
	link they want to edit on the left.  The normal jumpstation	links are now links that will tell the 
	editor (state 3e_1) which one they chose in the next state
	*state 3e_1 - they clicked on the link they want to edit. Now in the yellow column it shows editable
		textfields of the linkname and url.  They can edit those and click save, which will pass the 
		linkname and url to state 2 where it updates that link and then shows normal state 2 with changes.
	*state 3e_2 - similar to state 3a_1, user shown error message, otherwise same as 3e, try again
*state 3d - they chose Delete a link.  When this is chosen, yellow edit column will have text saying to click the 
	link they want to delete.  Each link will pass its ID so state 2 can delete it.
*state 3r - they chose Rename a category.  This state has text in the edit bar saying to click the category name
	they wish to edit.  The category names are now links that will pass their ID to state 3_r1.
	*state 3r_1 - they clicked the category they want to edit, 3r_1 shows textbox for editing it, and save button
	*state 3r_2 - error message was triggered like in 3a_1, otherwise same as 3r_1, try again
*state 3dj - they chose Delete this jumpstation.  This will delete their user data from users table and 
	delete their table, then drop them at the index page, currently index.jsp
*state 3g - they chose Change Search option.  This displays message saying current selection and give choice to
	change the option to no search, regular google (adsense), regular google, or google safe search (adsense).
*state 3p - they chose Change password.  Displays text boxes for user to enter new password.
	*state 3p_1 - similar to 3a_1, displays error message for user input, otherwise same as 3p.
*state 3o - they chose more options.  Gives menu for non-basic options such as changing password.
*/
%>
<%@ page language="java" import="java.sql.*" import="java.net.*"%>
<%@page import="UserLogin.UserLoginDAO"%>
<%@page import="UserPage.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="userLogin" class="UserLogin.UserLogin" scope="session" />
<jsp:useBean id="logon" scope="session" class="logonBean.logon" />
<jsp:useBean id="helperMethods" scope="page" class="helperMethodsBean.helperMethods" />
<%@page import="MiscUtil.MiscUtil"%>
<%
    
//set coding to UTF-8 before getting parameters
request.setCharacterEncoding("UTF-8");

//get the passed params, if not logged in yet, will only have user & state
String username = request.getParameter("user");
String pass = request.getParameter("pass");
String cpass = request.getParameter("cpass");
String state = request.getParameter("state");
String fromstate = request.getParameter("fromstate");

//get additional params used for editing purposes
String addlink_linkname = request.getParameter("addlink_linkname");
String addlink_linkaddress = request.getParameter("addlink_linkaddress");
String addlink_cat_radio = request.getParameter("addlink_cat_radio");
String addlink_cat_userspecified = request.getParameter("addlink_cat_userspecified");
String selected_user_link_id = request.getParameter("selected_user_link_id");
String editlink_linkname = request.getParameter("editlink_linkname");
String editlink_linkaddress = request.getParameter("editlink_linkaddress");


//get additional params used for editing purposes
//CONTINUED ORIGINAL, DELETE THESE EVENTUALLY, WHAT'S LEFT AND NOT ABOVE
String cat = request.getParameter("cat");
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
String searchUrl = request.getParameter("searchUrl");
String customSearchUrl = request.getParameter("customSearchUrl");
String searchLang = request.getParameter("searchLang");

//some style elements
String linkColor = "#0000cc";
String visitedColor = "#800080";
String hoverColor = "#800080";
String activeColor = "#ff0000";
String bgColor = "ffffff";
String textColor = "000000";
String fontFamily = "arial,sans-serif,helvetica";


//retrieve all info needed for user page from database
UserPage userPage = UserPageDAO.getUserPage(username);
//set userPage as a session attribute so the include files can use it
session.setAttribute("userPage", userPage);


//set error message var that should hold info if an operation failed
String errMsg = "";


if (state.equals("1")){
    //state 1 - 
    //User clicked edit on their user page. Show login dialog.
    
    
    
}
else if (state.equals("2")){
    //state 2 - 
    //Main edit screen showing edit options. 
    //If coming from state 1, user has attempted login to get here.
    //If coming from a state 3-something, user has attempted to make an update, 
    //and we need to execute it.
    
    //if user came from state 1, try login
    if (fromstate.equals("1")){
        
        //set up UserLogin object with username and password given
        userLogin.setUsername(username.toLowerCase());
        userLogin.setPass(pass);
        
        //attempt login (if successful this will set secure = true)
        userLogin = UserLoginDAO.login(userLogin);

        //check if we had a good login
        if (userLogin.isSecure()){
            //good login
            //HttpSession session = request.getSession(true);
            //session.setAttribute("userLogin", userLogin);//UserLoginBean object can be accessed as user
            System.out.println("good login");
        }
        else {
            //bad login
            System.out.println("bad login");
        }
    }
    
    //here we should be logged in, whether already logged in or just did
    if (userLogin.isSecure() && username.equals(userLogin.getUsername())){
        //
        
        
        if (fromstate.equals("3a") || fromstate.equals("3a_1")){
            //From State 3a, 3a_1
            //Add a Link
            
            //Call UserPageDAO.addLink() to add it (does input check, checks for duplicate)
            //addlink_linkname - user chosen display name for new link
            //addlink_linkaddress - URL for new link
            //addlink_cat_radio - user chosen existing category to add new link to 
            //addlink_cat_userspecified - user entered new category to add new link to (adds category)
            String addLinkResultMsg = UserPageDAO.addLink(userPage, addlink_linkname, addlink_linkaddress, addlink_cat_radio, addlink_cat_userspecified);
            
            if (!addLinkResultMsg.equals("")){
                //Have an error message and didn't add the link
                state = "3a_1";
                errMsg = addLinkResultMsg;
            }
            else {
                //No error. Update the UserPage for display.
                userPage = UserPageDAO.getUserPage(username);
                //Set userPage as a session attribute so the include files can use it
                session.setAttribute("userPage", userPage);
            }
            
        }
        else if (fromstate.equals("3e_1") || fromstate.equals("3e_2")){
            //From State 3e_1, 3e_2
            //Edit a Link
            
            //Call UserPageDAO.editLink() to edit it (does input check, checks for duplicate)
            //selected_user_link_id - the link the user selected for this action
            //editlink_linkname - user chosen new display name for link
            //editlink_linkaddress - new URL for link
            String editLinkResultMsg = UserPageDAO.editLink(userPage, selected_user_link_id, editlink_linkname, editlink_linkaddress);
            
            if (!editLinkResultMsg.equals("")){
                //Have an error message and didn't add the link
                state = "3e_2";
                errMsg = editLinkResultMsg;
            }
            else {
                //No error. Update the UserPage for display.
                userPage = UserPageDAO.getUserPage(username);
                //Set userPage as a session attribute so the include files can use it
                session.setAttribute("userPage", userPage);
            }
            
            
            //LEFT OFF HERE... 
            //JUST IMPLEMENTED UserPageDAO.editLink(), and need to test that works!!
            
            //BUT HAVE A PROBLEM THAT WHEN I CLICK ON 
            //EDIT A LINK, IT SHOWS THE LOGIN SCREEN. IT DOES THIS BECAUSE THE SECURE CHECK
            //IS DONE IN state = 2, fromstate = 1
            //AND THERE ISN'T ACTUALLY ANY SECURE CHECK IN STATE 3e
            
            //SO FIGURE THAT OUT.
            
            //ON TOP OF THAT, I HAVE TO MAKE SURE THE LINKS DISPLAY WITH THE DIFFERENT METHOD
            //FOR THIS STATE BECAUSE I WANT THEM TO BE CLICKABLE FOR THE EDIT LINK PURPOSE
            //AND THE LINKS ALL GO TO EDITOR_NEW.JSP WITH A SPECIFIC STATE AND THE LINK ID IN THE QUERY STRING.
            
            
        }
        else if (fromstate.equals("3d")){
            //From State 3d, Delete a Link
            
            
        }
        else if (fromstate.equals("3r_1") || fromstate.equals("3r_2")){
            //From State 3r_1, 3r_2, Rename a Category
            //edit table to modify category name they chose
        }
        else if (fromstate.equals("3g") || fromstate.equals("3g_0") || fromstate.equals("3g_10")){
            //From State 3g, Change Search option
            
        }
        else if (fromstate.equals("3p") || fromstate.equals("3p_1")){
            //From State 3p or 3p_1, Change password option
            
        }
        else if (fromstate.equals("3dj")){
            //delete all user data
            //From State 3dj, Delete Jumpstation
        }
        
        
        
        
    }
    else {
        //not secure in state 2, must have entered incorrect password
        //require entering password again
        state = "1"; 
    }
    
    
    
    
    
    
    
    
}
else if (state.equals("3a")){
    //state 3a - 
    //they chose Add a link option.  Has form for user to enter linkname, link url, category,
    //and row option.  Existing categories are shown among the choices, also the default "no category"
    //and user can input new category.  The row option determines which row the link will go into in that category,
    //the default is add the new link to very end category. The other row options are to add link to a new row
    //and add to a specific row (which requires another step). They do not enter linkrank, if they want to
    //add a link in between other links they will have to use the Move a link.
    
}
else if (state.equals("3e")){
    //state 3e - 
    //they chose Edit a link.  This state has plain text in
    //the yellow column saying to click the link they want to edit on the left.  The normal jumpstation
    //links are now links that will tell the editor which one they chose in the next state.
    
}
else if (state.equals("3e_1")){
    //state 3e_1 - 
    //they chose Edit a link, and they clicked on the link they want to edit.  Now in the yellow
    //column, show textfields of data about the link.  It will have the link name and link url.  They can
    //edit those and click save, which will pass the state and the linkname and url to state 2 where it will
    //execute SQL to update that link and then show normal state 2 with the changes.

}
else if (state.equals("3m")){
    //state 3m - 
    //they chose Move a link, this will have text in yellow saying to choose link they want to move.
    //They'll click a link in jumpstation area and the link will pass the state and link info
    
}
else if (state.equals("3m_1")){
    //state 3m_1 - they chose link they wanted to move, will display jumpstation again but with markers before and
    //after every link, the markers are links between others so they can pick where exactly to put the original
    //link.  Also, this jumpstation must not include the link in question.  They click a marker and go back to state 2
    //passing the state, the link to move, and location to move it to.  State 2 will show regular jumpstation again
    //with the link moved.

}
else if (state.equals("3d")){
    //state 3d - they chose Delete a link.  After this is chosen, yellow will have text saying to click the
    //link they want to delete.  Each link will pass the state 3d so state 2 knows to delete this link.

}
else if (state.equals("3mc")){
    //state 3mc - 
    //they chose Move a category

}
else if (state.equals("3r")){
    //state 3r - 
    //they chose Rename a category


}
else if (state.equals("3dj")){
    //state 3dj
    //They chose to delete their userpage & account. This will delete their 
    //user data from users table and delete their table, then drop them at index.jsp.
    
}


//set fromstate as current state for next action (goes into forms as hidden input)
fromstate = state;





//LEFT OFF HERE
//start off here putting in only the yellow sidebar basically 
//do big table structure, but just fill in the second cell with yellow
//side. Then make sure the navigation works and log in is registering correctly.
//Remove all usage of logon.java eventually



%>
<html>
<head>
<title>Editing <%=username%> &#64; ngumbi.com</title>
<link rel="stylesheet" type="text/css" href="style1.css">
<style type="text/css">
<!--

A:link{
    color:<%=linkColor%>;
    text-decoration:underline;
    font-family:<%=fontFamily%>;
}
A:visited{
    color:<%=visitedColor%>;
    text-decoration:underline;
    font-family:<%=fontFamily%>;
}
A:hover {
    color:<%=hoverColor%>;
    text-decoration:none;
    font-family:<%=fontFamily%>;
}
A:active {
    color:<%=activeColor%>;
    text-decoration:none;
    font-family:<%=fontFamily%>;
}
body {
    background-color: <%=bgColor%>;
    color: <%=textColor%>;
    font-family:<%=fontFamily%>;
    height: 95%; /*this used so yellow background edit column doesn't fill height*/
}
-->
</style>
<jsp:include page="inc_google_analytics.jsp" />
</head>
<body>
    
    
    
    <%
    
    
    //set the display mode for the top so it doesn't include the Edit link while in the editor
    String topDisplayMode = "1";//omits the Edit link
    
    //set the display mode for the user links area so it shows links that look like links but are plain text and not clickable
    String linkDisplayMode = "1";//look like links but are plain text
    
    
    
    //state 1, display login form with password input
    if (state.equals("1")){
        
        
        %>
        <table cellpadding="0" cellspacing="0" border="0" width="100%" style="height: 100%;">
            <tr>
                <td valign="top">
                    <jsp:include page="user_page_include_top.jsp" >
                        <jsp:param name="topDisplayMode" value="<%=topDisplayMode%>" />
                    </jsp:include>
                    <jsp:include page="user_page_include_links.jsp" >
                        <jsp:param name="linkDisplayMode" value="<%=linkDisplayMode%>" />
                    </jsp:include>
                    <jsp:include page="user_page_include_bottom.jsp" />
                </td>
                <td style="width: 220px; background-color: #ffc; padding: 20px 20px; vertical-align: middle;">
                    <form name="edit_login" method="post" action="editor_NEW.jsp">
                        <p style="text-align: left; padding: 0px 7px;">
                            Username: <b><%=username%></b>
                        </p>
                        <p style="text-align: left; padding: 0px 7px;">
                            Password: <input type="password" name="pass" size="13" maxlength="30">
                        </p>
                        <input type="hidden" name="user" value="<%=username%>" >
                        <input type="hidden" name="state" value="2" >
                        <input type="hidden" name="fromstate" value="<%=fromstate%>" >
                        <div style="text-align: center; margin-top: 20px;">
                            <input type="submit" value="Submit">
                        </div>
                    </form>
                    <p style="text-align: center; padding: 30px 7px;">
                        <a href="user/<%=username%>">Cancel</a>
                    </p>
                    <!--set focus in javascript-->
                    <script type="text/javascript"><!--
                        document.edit_login.pass.focus();
                    //--></script>
                </td>
            </tr>
        </table>
        <%

    }
    else if (userLogin.isSecure() && username.equals(userLogin.getUsername())){
        //user is logged in. ok to display interior menu options

        //state 2, display main edit options
        if (state.equals("2")){
            
            %>
            <table cellpadding="0" cellspacing="0" border="0" width="100%" style="height: 100%;">
                <tr>
                    <td valign="top">
                        <jsp:include page="user_page_include_top.jsp" >
                            <jsp:param name="topDisplayMode" value="<%=topDisplayMode%>" />
                        </jsp:include>
                        <jsp:include page="user_page_include_links.jsp" >
                            <jsp:param name="linkDisplayMode" value="<%=linkDisplayMode%>" />
                        </jsp:include>
                        <jsp:include page="user_page_include_bottom.jsp" />
                    </td>
                    <td style="width: 220px; background-color: #ffc; padding: 20px 20px; vertical-align: middle;">
                        <div style="text-align: center;">
                            <a href="editor_NEW.jsp?user=<%=username%>&state=3a&fromstate=<%=fromstate%>" >Add a link</a><br>
                            <a href="editor_NEW.jsp?user=<%=username%>&state=3e&fromstate=<%=fromstate%>" >Edit a link</a><br>
                            <!--<a href="editor_NEW.jsp?user=<%=username%>&state=3m&fromstate=<%=fromstate%>" >Move a link</a><br>-->
                            <a href="editor_NEW.jsp?user=<%=username%>&state=3d&fromstate=<%=fromstate%>" >Delete a link</a><br>
                            <a href="editor_NEW.jsp?user=<%=username%>&state=3r&fromstate=<%=fromstate%>" >Rename a category</a>
                            <br>
                            <br>
                            <a href="editor_NEW.jsp?user=<%=username%>&state=3o&fromstate=<%=fromstate%>" >More options</a>
                            <br><br><br>
                            <a href="user/<%=username%>">Exit</a>
                        </div>
                    </td>
                </tr>
            </table>
            <%
        }

        //state 3o, display 'more options', non-basic options
        else if (state.equals("3o")){
            
            %>
            <table cellpadding="0" cellspacing="0" border="0" width="100%" style="height: 100%;">
                <tr>
                    <td valign="top">
                        <jsp:include page="user_page_include_top.jsp" >
                            <jsp:param name="topDisplayMode" value="<%=topDisplayMode%>" />
                        </jsp:include>
                        <jsp:include page="user_page_include_links.jsp" >
                            <jsp:param name="linkDisplayMode" value="<%=linkDisplayMode%>" />
                        </jsp:include>
                        <jsp:include page="user_page_include_bottom.jsp" />
                    </td>
                    <td style="width: 220px; background-color: #ffc; padding: 20px 20px; vertical-align: middle;">
                        <div style="text-align: center;">
                            <a href="editor_NEW.jsp?user=<%=username%>&state=3g&fromstate=<%=fromstate%>" >Change search option</a>
                            <br><br><br>
                            <a href="editor_NEW.jsp?user=<%=username%>&state=3p&fromstate=<%=fromstate%>" >Change password</a>
                            <br><br>
                            <a href="editor_NEW.jsp?user=<%=username%>&state=3dj&fromstate=<%=fromstate%>" >Delete my account</a>
                            <br><br><br>
                            <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Back to main options</a>
                            <br><br>
                            <a href="user/<%=username%>">Exit</a>
                        </div>
                    </td>
                </tr>
            </table>
            <%
        }
        
        //state 3a, display add a link dialog and form
        else if (state.equals("3a") || state.equals("3a_1")){
            
            String default_addlink_linkname = "";
            String default_addlink_linkaddress = "";
            String addErrMsgHtml = "";
            if (state.equals("3a_1")){
                default_addlink_linkname = addlink_linkname;
                default_addlink_linkaddress = addlink_linkaddress;
                if (!errMsg.equals("")){
                    addErrMsgHtml = "<span style=\"color: red;\">"+errMsg+"</span>";
                }
            }
            
            %>
            <table cellpadding="0" cellspacing="0" border="0" width="100%" style="height: 100%;">
                <tr>
                    <td valign="top">
                        <jsp:include page="user_page_include_top.jsp" >
                            <jsp:param name="topDisplayMode" value="<%=topDisplayMode%>" />
                        </jsp:include>
                        <jsp:include page="user_page_include_links.jsp" >
                            <jsp:param name="linkDisplayMode" value="<%=linkDisplayMode%>" />
                        </jsp:include>
                        <jsp:include page="user_page_include_bottom.jsp" />
                    </td>
                    <td style="width: 220px; background-color: #ffc; padding: 20px 20px; vertical-align: middle;">
                        
                        <%=addErrMsgHtml%>
                        
                        <form name="add" method="post" action="editor_NEW.jsp" enctype="application/x-www-form-urlencoded">
                            New link name: <input name="addlink_linkname" size="27" maxlength="30" value="<%=default_addlink_linkname%>">
                            <br>
                            New link URL: <input name="addlink_linkaddress" size="27" maxlength="85" value="<%=default_addlink_linkaddress%>">
                            <hr size="1" width="66%" align="center">
                            Choose category:
                            <br>
                            <input type="radio" name="addlink_cat_radio" value="" checked>No category<br>
                            <input type="radio" name="addlink_cat_radio" value="_user_specified_new_cat"><input name="addlink_cat_userspecified" size="22" maxlength="20" value="new category"><br>
                            <%

                            //list out categories as radio buttons
                            String[] userCategories = userPage.getCats();
                            for (int i = 0; i < userCategories.length; i++){
                                if (!userCategories.equals("")){
                                    %><input type="radio" name="addlink_cat_radio" value="<%=userCategories[i]%>"><%=userCategories[i]%><br><%
                                }
                            }

                            %>
                            <input type="hidden" name="user" value="<%=username%>" >
                            <input type="hidden" name="state" value="2" >
                            <input type="hidden" name="fromstate" value="<%=fromstate%>" >
                            <div style="text-align: center; margin-top: 20px;">
                                <input type="submit" value="Submit">
                            </div>
                        </form>
                        
                        <!--set focus in javascript-->
                        <script type="text/javascript"><!--
                            document.add.linknamenew.focus();
                        //--></script>
                        
                        <p style="text-align: center; padding: 30px 7px;">
                            <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                        </p>
                        
                    </td>
                </tr>
            </table>
            <%
        }
        
        
        
        
    }




    %>
    
    
    
    
</body>
</html>











<html>
<head>
<title>Editing <%=username%> &#64; ngumbi.com</title>
<link rel="stylesheet" type="text/css" href="style1.css">
<style type="text/css">
<!--

A:link{
    color:<%=linkColor%>;
    text-decoration:underline;
    font-family:<%=fontFamily%>;
}
A:visited{
    color:<%=visitedColor%>;
    text-decoration:underline;
    font-family:<%=fontFamily%>;
}
A:hover {
    color:<%=hoverColor%>;
    text-decoration:none;
    font-family:<%=fontFamily%>;
}
A:active {
    color:<%=activeColor%>;
    text-decoration:none;
    font-family:<%=fontFamily%>;
}
body {
    background-color: <%=bgColor%>;
    color: <%=textColor%>;
    font-family:<%=fontFamily%>;
    height: 95%; /*this used so yellow background edit column doesn't fill height*/
}
-->
</style>
<jsp:include page="inc_google_analytics.jsp" />
</head>
<body>


<%

String dbname = "ngumbi";
String dbuser = "ngumbi_db_user";
String dbpass = "m8w1b174cpx9w0j3l";
Driver driver = null;
String dbURL = "jdbc:mysql://localhost:3306/"+dbname+"?user=";
Connection conn = null;
%>
<%


//Do initial check for valid username as in user_page.jsp and set communication to UTF-8
Statement stat3 = null;
ResultSet rsuser = null;
String userQuery = "SELECT user_id, username FROM users WHERE username = '"+username+"'";

int user_id = 0;

//execute SQL operations for username check
try {
    driver = (Driver) Class.forName("com.mysql.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection(dbURL, dbuser, dbpass);
    //stat00 = conn.createStatement();
    //stat00.execute(utf8setNames);
    //stat111 = conn.createStatement();
    //stat111.execute(utf8setCharSet);
    stat3 = conn.createStatement();
    rsuser = stat3.executeQuery(userQuery);//gets matching user(s) already in table
} 
catch (Exception e) {
    out.print("Unable to make connection to production database");
    out.print(e);
}
		
//check if username exists
if (!rsuser.next()){ //username doesn't exist
    %>
    <div class="main">
        <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
        <p>You've entered an invalid username</p>
        <p>Go to the <a href="index.jsp">main page</a></p>
    </div>
    <%
}
else {	
    //username good, execute rest of code

    user_id = rsuser.getInt("user_id");



    /*
    states & rules:

    state 1- they clicked edit on their jumpstation, take them to editor_NEW.jsp with username passed, which will
    be their jumpstation with a yellow column on the right.  State 1 will just have their username and a
    textbox for them to enter their password.
    */
    if (state.equals("1")){
            //enter your password state, no operations yet


    }



	//For every state other than state1, check login info so it's always verified before any SQL is executed
	else {
				
            if (fromstate.equals("1")){

                //check password, set bean
                Statement stat4 = null;
                ResultSet rslogincheck = null;

                String loginQuery = "SELECT pass FROM users WHERE username = '"+username+"'";
                //execute SQL operations
                try {
                    stat4 = conn.createStatement();
                    rslogincheck = stat4.executeQuery(loginQuery);//gets matching user(s) already in table
                }
                catch (Exception e) {
                    //slight possibility that someone gets here if they hack url and use invalid username
                    out.print("Unable to make connection to production database");
                    out.print(e);
                }

                //check login info
                rslogincheck.next();
                String tablePass = rslogincheck.getString("pass");
                if (tablePass.equals(pass)){
                    logon.setUserID(username);
                    logon.setSecure();
                }
                rslogincheck.close();
            }
		
		
            //check if user is logged in, all changes to databases are within this if statement
            if (logon.getUserID().equals(username) && logon.getSecure()){

                    /*
                    state 2- after they enter correct (CHECK) password, the column on right will show all editing options.  Add a link, Edit a link,
                    Move a link, Delete a link, Move a category, Rename a category, Cancel, Start Over etc.  There will be cancel
                    link at the bottom which will just take them back to their jumpstation.
                                    -State 2 also does all the SQL execution after editor has come from another state editing a certain thing (using fromstate variable).
                                            -If came from 3a, need to check that linkname doesn't exist already, url doesn't exist already.  Then add the link
                    */
                    if (state.equals("2")){
                            
                        //From State 3a, 3a_1, Add a Link
                        if (fromstate.equals("3a") || fromstate.equals("3a_1")){

                            //here replace any single quote, space, double quote, etc for saving in MySQL
                            catradio = MiscUtil.replaceBackslash(catradio);
                            catnew = MiscUtil.replaceBackslash(catnew);
                            linknamenew = MiscUtil.replaceBackslash(linknamenew);
                            linkurlnew = MiscUtil.replaceBackslash(linkurlnew);
                            catradio = MiscUtil.replaceQuote(catradio);
                            catnew = MiscUtil.replaceQuote(catnew);
                            linknamenew = MiscUtil.replaceQuote(linknamenew);
                            linkurlnew = MiscUtil.replaceQuote(linkurlnew);

                            //first check if we need to add http:// or www. or both
                            //length of 7 is first check, if it's longer than 7, need to check for https:// also which is 8 chars
                            if (linkurlnew.length() == 7){
                                if (! (linkurlnew.substring(0,7).equals("http://")) ){ //no 'http://' or 'https://'
                                    if (!linkurlnew.substring(0,4).equals("www.")){ //no 'www.' or 'http://'
                                        linkurlnew = "http://www.".concat(linkurlnew);
                                    }
                                    else { //has 'www.' but no 'http://'
                                        linkurlnew = "http://".concat(linkurlnew);
                                    }
                                }
                                else {
                                    //we do have either http:// or https://, do nothing.
                                }
                            }
                            //do same checks, except this time also check for https:// since it's more than 7 chars
                            else if (linkurlnew.length() > 7){
                                if (! (linkurlnew.substring(0,7).equals("http://") || linkurlnew.substring(0,8).equals("https://")) ){ //no 'http://' or 'https://'
                                    if (!linkurlnew.substring(0,4).equals("www.")){ //no 'www.' or 'http://'
                                        linkurlnew = "http://www.".concat(linkurlnew);
                                    }
                                    else { //has 'www.' but no 'http://'
                                        linkurlnew = "http://".concat(linkurlnew);
                                    }
                                }
                                else {
                                    //we do have either http:// or https://, do nothing.
                                }
                            }
                            else {
                                //it's too short, add the http://www. anyway no matter what
                                //if it doesn't work, they get 404 and should fix it themself
                                linkurlnew = "http://www.".concat(linkurlnew);
                            }


                            //if the radio button selected wasn't the editable one, then make catnew the value of the radio chosen
                            if (!catradio.equals("null")){
                                catnew = catradio;
                            }
                            else {
                                //they entered their own category, check if it's not in use already
                                String duplicateCatCheck = "SELECT link_name FROM user_links WHERE user_id = "+user_id+" AND cat = '"+catnew+"'";
                                Statement stat11 = null;
                                ResultSet rsdupcat = null;
                                try {
                                    stat11 = conn.createStatement();
                                    rsdupcat = stat11.executeQuery(duplicateCatCheck);//if changed linkurl or linkname already exists in table, returns a linkname
                                }
                                catch (Exception e) {
                                    out.print("Unable to make connection to production database");
                                    out.print(e);
                                }
                                if (rsdupcat.next()){ //found a matching category that already exists
                                    catradio = catnew; //so later logic knows this isn't really a new category
                                }
                                rsdupcat.close();
                            }


                            //here do same checks on validity and uniqueness of catnew, linknamenew, linkurlnew entered
                            // as in edit link and rename category options.  Already checked above for unique category, it
                            // will just put it in that category if a new one is specified but it already exists.
                            boolean inputCheckOk = true;
                            if (linknamenew.equals("") || linknamenew.equals("null")){ inputCheckOk = false; }//check for blank input
                            if (linknamenew.indexOf("\"") > -1){ inputCheckOk = false; }//check for double quote

                            if (linkurlnew.equals("") || linkurlnew.equals("null")){ inputCheckOk = false; }//check for blank input
                            if (linkurlnew.indexOf("\"") > -1){ inputCheckOk = false; }//check for double quote

                            if (catnew.equals("null")){ inputCheckOk = false; }//can't add category of "null" since it is used as a
                            if (catnew.indexOf("\"") > -1){ inputCheckOk = false; }//check for double quote
                                                                            //special case to identify user choosing to add new category
                            //if (linknamenew.indexOf('\"') != -1){ inputCheckOk = false; } //check for double quote
                            //if (linkurlnew.indexOf('\"') != -1){ inputCheckOk = false; } //check for double quote
                            //if (catnew.indexOf('\"') != -1){ inputCheckOk = false; } //check for double quote
                            if (!catnew.equals("")){ //before checking first character, need to make sure one exists
                                if (catnew.substring(0,1).equals("~")){ inputCheckOk = false; } // ~ character is reserved for Admin stuff
                            }

                            //make a check for the max links allowed for a user, if they have < or = that, then give them message
                            //that they hit the max links and the #

                            //NO LONGER DOING DUPLICATE CHECK
                            //String duplicateCheck = "SELECT link_name FROM user_links WHERE user_id = "+user_id+" AND (link_address = '"+linkurlnew+"' OR link_name = '"+linknamenew+"')";
                            String maxLinksCheck = "SELECT maxLinks FROM admin";
                            String numLinksCheck = "SELECT COUNT(*) AS userLinkCount FROM user_links WHERE user_id = "+user_id;
                            //Statement stat12 = null;
                            Statement stat20 = null;
                            Statement stat21 = null;
                            //ResultSet rsduplicates1 = null;
                            ResultSet rsmaxlinks = null;
                            ResultSet rsnumlinks = null;
                            try {
                                //stat12 = conn.createStatement();
                                //rsduplicates1 = stat12.executeQuery(duplicateCheck);//if changed linkurl or linkname already exists in table, returns a linkname
                                stat20 = conn.createStatement();
                                rsmaxlinks = stat20.executeQuery(maxLinksCheck);//check for max links allowed by admin
                                stat21 = conn.createStatement();
                                rsnumlinks = stat21.executeQuery(numLinksCheck);//check for # links user has now
                            }
                            catch (Exception e) {
                                out.print("Unable to make connection to production database");
                                out.print(e);
                            }
                            rsnumlinks.next();
                            rsmaxlinks.next();
                            if (rsnumlinks.getInt("userLinkCount") >= rsmaxlinks.getInt("maxLinks")){ inputCheckOk = false; }
                            //they are at the maximum number of links for a user

                            //NO LONGER DOING DUPLICATE CHECK
                            //if (rsduplicates1.next()){ inputCheckOk = false; } //there was a duplicate of an input already in table

                            if (inputCheckOk) {
                                //continue adding link operations
                                
                                
                                //ROWRADIO NOW IGNORED. ALL LINKS ADDED TO END OF THE CHOSEN CATEGORY
                                //**********
                                //here check what rowradio was selected,
                                //if 1 (add to end of row) need to check catrank, subcatrank, linkrank of last link in the category
                                //		then add link with same catrank, subcatrank, and one greater linkrank.
                                //if 2 (add to new row) do the same as 1 but one greater subcatrank and make it linkrank of 1
                                //if 3 (add to specific row), need to ask for more info, which row? Will send to state 3a_1
                                //		which will check how many distinct subcatranks are in this category and display those as a
                                //		choice in the yellow edit column
                                
                                int catrankInt = 1;
                                int subcatrankInt = 1;
                                int linkrankInt = 1;

                                if (catradio.equals("null")){ //they entered new category name

                                    //get highest catrank (last category value) so can add new category after it
                                    Statement stat13 = null;
                                    ResultSet rslastcat = null;
                                    String lastCat = "SELECT MAX(cat_rank) AS cat_rank FROM user_links where user_id = "+user_id;
                                    try {
                                            stat13 = conn.createStatement();
                                            rslastcat = stat13.executeQuery(lastCat);
                                    }
                                    catch (Exception e) {
                                            out.print("Unable to make connection to production database");
                                            out.print(e);
                                    }
                                    if (rslastcat.next()){ //if no links yet, this will be false
                                            catrankInt = rslastcat.getInt("cat_rank") + 1;
                                    }

                                    //add the link
                                    Statement stat14 = null;

                                    String addLink = "INSERT INTO user_links (user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank) VALUES ("+user_id+", '"+linknamenew+"','"+linkurlnew+"','"+catnew+"',"+catrankInt+","+subcatrankInt+","+linkrankInt+")";
                                    //String addLink = "INSERT INTO "+user+" VALUES ('"+linknamenew+"','"+linkurlnew+"','"+catnew+"',"+catrankInt+","+subcatrankInt+","+linkrankInt+")";
                                    try {
                                            stat14 = conn.createStatement();
                                            stat14.executeUpdate(addLink);
                                    }
                                    catch (Exception e) {
                                            out.print("Unable to make connection to production database");
                                            out.print(e);
                                    }

                                    rslastcat.close();

                                }
                                else {
                                    //they chose existing category name, or no category

                                    //lastLink query gets the catrank, subcatrank, and linkrank from the last link in the category
                                    //  eg. that with the greatest linkrank in the set of the greatest subcatrank
                                    //initial FROM statement returns a table of info from the links in last subcategory of the category specified
                                    //nested tables in the main WHERE statement identify the highest linkrank in the highest subcategory of the category specified
                                    //
                                    //formatted:	SELECT One.catrank, One.subcatrank, One.linkrank
                                    //				FROM 	(SELECT Two.catrank, Two.subcatrank, Two.linkrank
                                    //						 FROM etable Two
                                    //						 WHERE Two.subcatrank = (SELECT MAX(subcatrank)
                                    //												 FROM etable
                                    //												 WHERE cat = 'Reference')
                                    //								&& cat = 'Reference')
                                    //				AS One
                                    //				WHERE One.linkrank = (SELECT MAX(linkrank)
                                    //									  FROM etable
                                    //									  WHERE subcatrank = (SELECT MAX(subcatrank)
                                    //														  FROM etable
                                    //														  WHERE cat = 'Reference')
                                    //											&& cat = 'Reference')




                                    //String lastLink = "SELECT One.catrank, One.subcatrank, One.linkrank FROM (SELECT Two.catrank, Two.subcatrank, Two.linkrank FROM "+user+" Two WHERE Two.subcatrank = (SELECT MAX(subcatrank) FROM "+user+" WHERE cat = '"+catnew+"') && Two.cat = '"+catnew+"') AS One WHERE One.linkrank = (SELECT MAX(linkrank) FROM "+user+" WHERE subcatrank = (SELECT MAX(subcatrank) FROM "+user+" WHERE cat = '"+catnew+"') && cat = '"+catnew+"')";

                                    //with this new lastLink query, the first result is the data from the last link in the category given (even if blank)
                                    String lastLink = "SELECT cat, cat_rank, sub_cat_rank, link_rank FROM user_links WHERE user_id = "+user_id+" AND cat = '"+catnew+"' ORDER BY sub_cat_rank DESC, link_rank DESC";
                                    Statement stat15 = null;
                                    ResultSet rslastlink = null;
                                    try {
                                        stat15 = conn.createStatement();
                                        rslastlink = stat15.executeQuery(lastLink);
                                    }
                                    catch (Exception e) {
                                        out.print("Unable to make connection to production database");
                                        out.print(e);
                                    }
                                    if (rslastlink.next()){
                                        catrankInt = rslastlink.getInt("cat_rank");
                                        subcatrankInt = rslastlink.getInt("sub_cat_rank");
                                        linkrankInt = rslastlink.getInt("link_rank");
                                        //prepare data for new link
                                        linkrankInt++;
                                    }
                                    else {
                                        //there are no links in this category yet.  Since they didn't enter new category
                                        //name in this part of the conditional, they must have chosen "no category"
                                        //always make the "no category" category have catrank of 0
                                        catrankInt = 0;
                                    }


                                    //Add the link to the table, insert new row
                                    Statement stat16 = null;
                                    String addLink = "INSERT INTO user_links (user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank) VALUES ("+user_id+", '"+linknamenew+"','"+linkurlnew+"','"+catnew+"',"+catrankInt+","+subcatrankInt+","+linkrankInt+")";
                                    try {
                                        stat16 = conn.createStatement();
                                        stat16.executeUpdate(addLink);
                                    }
                                    catch (Exception e) {
                                        out.print("Unable to make connection to production database");
                                        out.print(e);
                                    }

                                    rslastlink.close();
                                }
                                
                                
                                //		**ADMIN UPDATE**
                                helperMethods.adminUpdate(username, "edit Add");

                            } //end if(inputCheckOk)

                            else if (!inputCheckOk){ //input was bad somehow, duplicate or bad characters, or maxLinks
                                    state = "3a_1";
                            }

                            //rsduplicates1.close();
                            rsmaxlinks.close();
                            rsnumlinks.close();

                        }


                        //From State 3e_1, 3e_2, Edit a Link
                        if (fromstate.equals("3e_1") || fromstate.equals("3e_2")){
                            //edit table to modify the link as specified
                            
                            //here replace any single quote, space, double quote, etc for saving in MySQL
                            linknamenew = MiscUtil.replaceBackslash(linknamenew);
                            linkurlnew = MiscUtil.replaceBackslash(linkurlnew);
                            linknamenew = MiscUtil.replaceQuote(linknamenew);
                            linkurlnew = MiscUtil.replaceQuote(linkurlnew);

                            //first check if we need to add http:// or www. or both
                            if (linkurlnew.length() >= 7){ //prevent index out of bounds if it's too short
                                if (! (linkurlnew.substring(0,7).equals("http://") || linkurlnew.substring(0,8).equals("https://")) ){ //no 'http://' or 'https://'
                                    if (!linkurlnew.substring(0,4).equals("www.")){ //no 'www.' or 'http://'
                                        linkurlnew = "http://www.".concat(linkurlnew);
                                    }
                                    else { //has 'www' but still no 'http://'
                                        linkurlnew = "http://".concat(linkurlnew);
                                    }
                                }
                            }
                            else {
                                //it's too short, add the http://www. anyway no matter what
                                //if it doesn't work, they get 404 and should fix it themself
                                linkurlnew = "http://www.".concat(linkurlnew);
                            }


                            //do checks on what user input for invalid stuff
                            //int change = 0; //0=neither field changed, 1=just linkname changed, 2=just linkurl changed, 3=both linkname and linkurl changed
                            boolean inputCheckOk = true;
                            if (linknamenew.equals("") || linknamenew.equals("null")){ inputCheckOk = false; }//check for blank input
                            if (linkurlnew.equals("") || linkurlnew.equals("null")){ inputCheckOk = false; }//check for blank input
                            //if (linknamenew.indexOf('+') != -1){ inputCheckOk = false; } //will be -1 if there is no + character
                            //if (linknamenew.indexOf('\'') != -1){ inputCheckOk = false; } //check for single quote
                            //commented above two because urlencoding and checks higher up in code worked better
                            //if (linknamenew.indexOf('\"') != -1){ inputCheckOk = false; } //check for double quote
                            //if (linkurlnew.indexOf('\"') != -1){ inputCheckOk = false; } //check for double quote

                            //do SQL operations
                            if (inputCheckOk){
                                //inputs are ok, not bad characters or dups and there was a change
                                Statement stat96 = null;
                                String updateLink = "UPDATE user_links SET link_name = '"+linknamenew+"', link_address = '"+linkurlnew+"' WHERE user_link_id = "+selected_user_link_id;
                                //String updateLink = "UPDATE "+user+" SET linkname = '"+linknamenew+"', link = '"+linkurlnew+"' WHERE link = '"+linkurl+"'";
                                try {
                                    stat96 = conn.createStatement();
                                    stat96.executeUpdate(updateLink);
                                }
                                catch (Exception e) {
                                    out.print("Unable to make connection to production database");
                                    out.print(e);
                                }
                            }
                            else {	
                                //either they used a bad character or linkname or linkurl they entered is already in use in another link
                                //go to state 3e_2, only difference with 3e_1 is message that attempted change was unsuccessful
                                state = "3e_2";
                            }

                            //		**ADMIN UPDATE**
                            helperMethods.adminUpdate(username, "edit Edit");

                        }

                        //From State 3d, Delete a Link
                        else if (fromstate.equals("3d")){

                            //here replace any single quote, space, double quote, etc for saving in MySQL
                            cat = MiscUtil.replaceBackslash(cat);
                            cat = MiscUtil.replaceQuote(cat);


                            //delete the link they chose
                            Statement stat97 = null;
                            String deleteLink = "DELETE FROM user_links WHERE user_link_id = "+selected_user_link_id;
                            try {
                                stat97 = conn.createStatement();
                                stat97.executeUpdate(deleteLink);
                            }
                            catch (Exception e) {
                                out.print("Unable to make connection to production database");
                                out.print(e);
                            }

                            //need to renumber the linkranks, subcatranks, catranks
                            //do queries here to see if that link was the last in its subcategory or category or last overall
                            Statement stat551 = null;
                            Statement stat552 = null;
                            String deletedCat = "SELECT link_name, sub_cat_rank FROM user_links WHERE user_id = "+user_id+" AND cat = '"+cat+"' ORDER BY sub_cat_rank, link_rank";
                            //String deletedCat = "SELECT linkname, subcatrank FROM "+user+" WHERE cat = '"+cat+"' ORDER BY subcatrank, linkrank";
                            String deletedSubCat = "SELECT link_name FROM user_links WHERE user_id = "+user_id+" AND cat = '"+cat+"' AND sub_cat_rank = "+subcatrank+" ORDER BY link_rank";
                            //String deletedSubCat = "SELECT linkname FROM "+user+" WHERE cat = '"+cat+"' && subcatrank = '"+subcatrank+"' ORDER BY linkrank";

                            ResultSet rsdelsubcat = null;
                            ResultSet rsdellink = null;
                            try {
                                stat551 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                rsdelsubcat = stat551.executeQuery(deletedCat);
                                stat552 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                rsdellink = stat552.executeQuery(deletedSubCat);
                            }
                            catch (Exception e) {
                                out.print("Unable to make connection to production database");
                                out.print(e);
                            }

                            if (!rsdelsubcat.next()){
                                //deleted link was the last in the category, renumber the category ranks
                                //non-category links always have category rank of zero so don't worry about them
                                //query includes all links ordered like jumpstation code minus non-category links
                                String linksQuery2 = "SELECT link_name, cat_rank FROM user_links WHERE user_id = "+user_id+" AND cat != '' ORDER BY cat_rank, sub_cat_rank, link_rank";
                                Statement stat553 = null;
                                ResultSet rsdelcat = null;
                                try {
                                    stat553 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                    rsdelcat = stat553.executeQuery(linksQuery2);
                                }
                                catch (Exception e) {
                                    out.print("Unable to make connection to production database");
                                    out.print(e);
                                }

                                //have all non-categoryless links in order, now renumber the catranks for all
                                int dCatRank = 1;
                                int dCurrCatRank = 1;
                                if (rsdelcat.next()){dCurrCatRank = rsdelcat.getInt("cat_rank");}
                                Statement stat554 = null;
                                String numberCatRanks = "";
                                rsdelcat.previous();
                                while (rsdelcat.next()){
                                    if (dCurrCatRank != rsdelcat.getInt("cat_rank")){
                                        //new category, increment counter, update comparison variable
                                        dCatRank++;
                                        dCurrCatRank = rsdelcat.getInt("cat_rank");
                                    }


                                    //2016-05-24 added replaceBackslash and replaceQuote here because I was getting an error after deleting a link. It did
                                    //delete the link, but error was I think due to another link where I had a single quote in the name, and I think here is 
                                    //where the error came from.
                                    String currLinkName = rsdelcat.getString("link_name");
                                    //here replace any single quote, space, double quote, etc for saving in MySQL
                                    currLinkName = MiscUtil.replaceBackslash(currLinkName);
                                    currLinkName = MiscUtil.replaceQuote(currLinkName);


                                    numberCatRanks = "UPDATE user_links SET cat_rank = "+dCatRank+" WHERE user_id = "+user_id+" AND link_name = '"+currLinkName+"'";
                                    try {
                                        stat554 = conn.createStatement();
                                        stat554.executeUpdate(numberCatRanks);
                                    }
                                    catch (Exception e) {
                                        out.print("Unable to make connection to production database");
                                        out.print(e);
                                    }
                                }
                            }
                            else if (!rsdellink.next()){
                                //deleted link was the last in the subcategory, but not category, renumber subcategories
                                //have all the links in this category in rsdelsubcat ordered by subcatrank, then linkrank
                                int dSubCatRank = 1;
                                int dCurrSubCatRank = rsdelsubcat.getInt("sub_cat_rank");
                                Statement stat557 = null;
                                String numberSubCatRanks = "";
                                rsdelsubcat.previous();
                                while (rsdelsubcat.next()){
                                    if (dCurrSubCatRank != rsdelsubcat.getInt("sub_cat_rank")){
                                        //new subcategory, increment the counter, update comparison variable
                                        dSubCatRank++;
                                        dCurrSubCatRank = rsdelsubcat.getInt("sub_cat_rank");
                                    }
                                    numberSubCatRanks = "UPDATE user_links SET sub_cat_rank = "+dSubCatRank+" WHERE user_id = "+user_id+" AND link_name = '"+rsdelsubcat.getString("link_name")+"'";
                                    try {
                                        stat557 = conn.createStatement();
                                        stat557.executeUpdate(numberSubCatRanks);
                                    }
                                    catch (Exception e) {
                                        out.print("Unable to make connection to production database");
                                        out.print(e);
                                    }
                                }
                            }
                            else {
                                //deleted link wasn't the last in subcategory or category, renumber the linkranks in this subcategory
                                //have all the links in this subcategory in rsdellink ordered by linkrank in rsdellink
                                int dLinkRank = 1;
                                Statement stat558 = null;
                                String numberLinkRanks = "";
                                rsdellink.previous();
                                while (rsdellink.next()){
                                    numberLinkRanks = "UPDATE user_links SET link_rank = "+dLinkRank+" WHERE user_id = "+user_id+" AND link_name = '"+rsdellink.getString("link_name")+"'";
                                    try {
                                        stat558 = conn.createStatement();
                                        stat558.executeUpdate(numberLinkRanks);
                                    }
                                    catch (Exception e) {
                                        out.print("Unable to make connection to production database");
                                        out.print(e);
                                    }
                                    dLinkRank++;
                                }
                            }

                            //		**ADMIN UPDATE**
                            helperMethods.adminUpdate(username, "edit Delete");

                        }//end From State 3d

                        //From State 3r_1, 3r_2, Rename a Category
                        else if (fromstate.equals("3r_1") || fromstate.equals("3r_2")){ //edit table to modify category name they chose
                            //here replace any single quote, space, double quote, etc for saving in MySQL
                            cat = MiscUtil.replaceBackslash(cat);
                            catnew = MiscUtil.replaceBackslash(catnew);
                            cat = MiscUtil.replaceQuote(cat);
                            catnew = MiscUtil.replaceQuote(catnew);

                            //first do checks on what user input for invalid stuff
                            boolean inputCheckOk = true;
                            if (catnew.equals("") || catnew.equals("null")){ inputCheckOk = false; } //check for blank input
                            else if (catnew.substring(0,1).equals("~")){ inputCheckOk = false; } // ~ character is reserved for Admin stuff

                            if (catnew.indexOf('\"') != -1){ inputCheckOk = false; } //check for double quote



                            if (!catnew.equals(cat)){
                                //there was a change, so need to check for duplicate
                                String duplicateCheck = "SELECT cat FROM user_links WHERE user_id = "+user_id+" AND cat = '"+catnew+"'";
                                Statement stat98 = null;
                                ResultSet rsduplicates3 = null;
                                //duplicate check looks for duplicate category name
                                try {
                                    stat98 = conn.createStatement();
                                    rsduplicates3 = stat98.executeQuery(duplicateCheck);//if changed linkurl or linkname already exists in table, returns a linkname
                                }
                                catch (Exception e) {
                                    out.print("Unable to make connection to production database");
                                    out.print(e);
                                }
                                if (rsduplicates3.next()){ inputCheckOk = false; } //there was a duplicate of an input already in table

                                //do SQL operations, change all links with this category name to new category name
                                if (inputCheckOk){ //inputs are ok, not bad characters or dups and there was a change

                                    Statement stat99 = null;
                                    String updateCat = "UPDATE user_links SET cat = '"+catnew+"' WHERE user_id = "+user_id+" AND cat = '"+cat+"'";
                                    try {
                                        stat99 = conn.createStatement();
                                        stat99.executeUpdate(updateCat);
                                    }
                                    catch (Exception e) {
                                        out.print("Unable to make connection to production database - updateCat: "+updateCat+". ");
                                        out.print(e);
                                    }

                                    //		**ADMIN UPDATE**
                                    helperMethods.adminUpdate(username, "edit Rename");

                                }
                                else {
                                    //inputCheckOk is not ok.
                                    //either they used a bad character or new category name they entered is already in use in another link
                                    //go to state 3r_2, only difference with 3r_1 is message that attempted change was unsuccessful
                                    state = "3r_2";
                                }
                                rsduplicates3.close();
                            }

                        }



                        //From State 3g, Change Search option
                        else if (fromstate.equals("3g") || fromstate.equals("3g_0") || fromstate.equals("3g_10")){

                            int tempSearchInt = Integer.parseInt(searchradio); //get the search code as an int
                            if (fromstate.equals("3g")	&& tempSearchInt > 0 && tempSearchInt < 10 ){
                                //have a google search so need to go to the next page of options, no operations yet
                                state = "3g_0";
                            }
                            else if (fromstate.equals("3g")	&& tempSearchInt > 9 && tempSearchInt < 20 ){
                                //have a yahoo search so need to go to the next page of options, no operations yet
                                state = "3g_10";
                            }
                            else {
                                //update the search and searchLang variables based on input
                                //if not using a google choice, then the searchLang, searchUrl, customSearchUrl vars
                                //are just passed as they were before, no point in changing
                                Statement stat996 = null;
                                String updateSearch = "UPDATE users SET searchOption = '"+searchradio+"', searchLang = '"+searchLang+"' WHERE user_id = "+user_id;
                                try {
                                    stat996 = conn.createStatement();
                                    stat996.executeUpdate(updateSearch);
                                }
                                catch (Exception e) {
                                    out.print("Unable to make connection to production database");
                                    out.print(e);
                                }

                                //check input of search url
                                Statement stat996a = null;
                                String newSearchUrl = searchUrl;
                                if (!customSearchUrl.equals(""))
                                    newSearchUrl = customSearchUrl;

                                String updateSearchUrl = "UPDATE users SET searchUrl = '"+newSearchUrl+"', searchLang = '"+searchLang+"' WHERE user_id = "+user_id;
                                try {
                                    stat996a = conn.createStatement();
                                    stat996a.executeUpdate(updateSearchUrl);
                                }
                                catch (Exception e) {
                                    out.print("Unable to make connection to production database");
                                    out.print(e);
                                }

                                //		**ADMIN UPDATE**
                                helperMethods.adminUpdate(username, "edit Search");
                            }
                        }

                        //From State 3p or 3p_1, Change password option
                        else if (fromstate.equals("3p") || fromstate.equals("3p_1")){
                            //first check that both passwords are the same and valid
                            boolean goodPass = true;
                            if (pass.length() < 1){ goodPass = false; }
                            if (pass.length() > 30){ goodPass = false; }
                            if (!pass.equals(cpass)){ goodPass = false; }
                            if (pass.equals("null")){ goodPass = false; }
                            if (pass.indexOf(' ') != -1){ goodPass = false; } //check for space
                            if (pass.indexOf('\"') != -1){ goodPass = false; } //check for double quote
                            if (pass.indexOf('\'') != -1){ goodPass = false; } //check for single quote
                            //probably need to add more in here eventually
                            if (goodPass){
                                Statement stat997 = null;
                                String updatePass = "UPDATE users SET pass = '"+pass+"' WHERE user_id = "+user_id;
                                try {
                                    stat997 = conn.createStatement();
                                    stat997.executeUpdate(updatePass);
                                }
                                catch (Exception e) {
                                    out.print("Unable to make connection to production database");
                                    out.print(e);
                                }
                                //		**ADMIN UPDATE**
                                helperMethods.adminUpdate(username, "edit Password");
                            }
                            else {
                                //send to state 3p_1, try again
                                state = "3p_1";
                            }

                        }

                        //From State 3dj, Delete Jumpstation
                        else if (fromstate.equals("3dj")){ //delete all user data
                            Statement stat998 = null;
                            Statement stat999 = null;
                            String deleteUser = "DELETE FROM users WHERE user_id = "+user_id;
                            String deleteTable = "DELETE FROM user_links WHERE user_id = "+user_id;
                            try {
                                stat998 = conn.createStatement();
                                stat999 = conn.createStatement();
                                stat998.executeUpdate(deleteUser);
                                stat999.execute(deleteTable);
                            }
                            catch (Exception e) {
                                out.print("Unable to make connection to production database");
                                out.print(e);
                            }
                        }
                    }





                    /*
                    state 3a - they chose Add a link option.  Has form for user to enter linkname, link url, category.  
                    Existing categories are shown among the choices, also the default "no category"
                    and user can input new category. They do not enter linkrank, if they want to
                    add a link in between other links they will have to use the Move a link. */
                    else if (state.equals("3a")){



                    }

                    /*

                    state 3e - they chose Edit a link.  This state has plain text in
                    the yellow column saying to click the link they want to edit on the left.  The normal jumpstation
                    links are now links that will tell the editor which one they chose in the next state. */
                    else if (state.equals("3e")){


                    }



                    /*

                    state 3e_1 - they chose Edit a link, and they clicked on the link they want to edit.  Now in the yellow
                    column, show textfields of data about the link.  It will have the link name and link url.  They can
                    edit those and click save, which will pass the state and the linkname and url to state 2 where it will
                    execute SQL to update that link and then show normal state 2 with the changes.*/
                    else if (state.equals("3e_1")){



                    }



                    /*
                    state 3m - they chose Move a link, this will have text in yellow saying to choose link they want to move.
                    They'll click a link in jumpstation area and the link will pass the state and link info*/
                    else if (state.equals("3m")){


                    }

                    /*
                    state 3m_1 - they chose link they wanted to move, will display jumpstation again but with markers before and
                    after every link, the markers are links between others so they can pick where exactly to put the original
                    link.  Also, this jumpstation must not include the link in question.  They click a marker and go back to state 2
                    passing the state, the link to move, and location to move it to.  State 2 will show regular jumpstation again
                    with the link moved.*/
                    else if (state.equals("3m_1")){


                    }

                    /*
                    state 3d - they chose Delete a link.  After this is chosen, yellow will have text saying to click the
                    link they want to delete.  Each link will pass the state 3d so state 2 knows to delete this link.*/
                    else if (state.equals("3d")){


                    }



                    /*
                    state 3mc - they chose Move a category */
                    else if (state.equals("3mc")){


                    }

                    /*
                    state 3r - they chose Rename a category */
                    else if (state.equals("3r")){


                    }


                    //State 3dj - 	they chose Delete this jumpstation.  This will delete their user data from users table
                    //				and delete their table, then drop them at index.jsp.
                    else if (state.equals("3dj")){


                    }




            }
            else{ //incorrect password
                    state = "1"; //make them re-enter password
            }
		
	} //end of state1 check conditional
	
	//before jumpstation code, check if user's data has just been deleted in the conditional above
	if (fromstate.equals("3dj")){ //was deleted, so don't attempt jumpstation code
            //record to history table they deleted account
            helperMethods.adminUpdate(username, "edit DeleteAcct");
            %>
            <div class="main">
                <jsp:include page="inc_ngumbi_title_unlinked.jsp" />
                <p>Your user data has just been deleted.</p>
                <p>Go to the <a href="index.jsp">main page</a></p>
            </div>
            <%
	}
	else {

            fromstate = state; //assign fromstate for next time

            /*/////////////////////////////////////////////////////////////////
            Outer table code, 2 cells, jumpstation and yellow edit column   */
            %>
            <table cellpadding="0" cellspacing="0" border="0" width="100%" style="height: 100%;">
                <tr>
                    <td valign="top">
            <%


            /*////////////////////////////////////////////////////////////////
            Jumpstation Code
            Regular jumpstation code will go below everything since changes to table are made in state 2 and should also be
            displayed in state 2.  There will be conditionals within the jumpstation code altering the links based on the
            state.  EX: If they are at the state 3m_1, to choose where to move a link, the actual links won't be links, just
            plain text and there will be markers between them and before and after them that will be hot links.  They will
            pass information.
            */
            %>

            <!-- Start Page Header (top table) ----------------------------------------->
            <table cellpadding="0" cellspacing="0" border="0" width="100%" >
            <tr valign="top">
            <td align="left" valign="top">

            <%	
            //Connection and Operations on database

            Statement stat1 = null;
            Statement stat2 = null;
            ResultSet rs = null;
            ResultSet rsuserdata = null;

            String linksQuery = "SELECT user_link_id, link_name, link_address, cat, sub_cat_rank, link_rank "
                    + "FROM user_links WHERE user_id = "+user_id+" "
                    + "ORDER BY cat_rank, sub_cat_rank, link_rank";

            String userDataQuery = "SELECT searchOption, searchUrl, searchLang FROM users WHERE user_id = "+user_id;

            int currLinkId = 0;
            int linkCounter;
            int catCounter;
            String currCat = "";
            int currSubCatRank = 0;
            String lastCat = "";
            int searchFlag = 0;
            String searchSuffix2 = "";
            String placeholder = "|||";
            int moveFlag = 0;
            String moveColor="red";

            //execute SQL queries
            try {					
                    stat2 = conn.createStatement();
                    rs = stat2.executeQuery(linksQuery);	
                    stat1 = conn.createStatement();
                    rsuserdata = stat1.executeQuery(userDataQuery);//gets matching user(s) already in table		
            }
            catch (Exception e) {//if query doesn't work, user probably doesn't exist
                    %><center><font size=4 color=red>The username you have entered isn't a valid user</font><p>
                    <a href="index.jsp"><font color=blue>Go back</font></a></center><p><br><br><br><br><br><br><br><br><br><%
                    out.print("Unable to make connection to production database");
                    out.print(e);
            }
            %>



            <!-- Show current date and time -->
            <!--<%= new java.util.Date() %>	-->



            </td><%

            if (rsuserdata.next()){
                //Search check, flag is
                //	0 for no search
                // 	1 for ngumbi branded google search (default)
                //	2 for regular google search
                //	3 for ngumbi branded safe google search
                //	10 for yahoo search
                searchFlag = rsuserdata.getInt("searchOption");
                searchUrl = rsuserdata.getString("searchUrl");

                if (searchFlag == 0){
                    //no search
                }
                else if (searchFlag == 1 || searchFlag == 2 || searchFlag == 3){
                    //we have some form of google search
                    if (searchFlag == 1)
                        searchSuffix2 = "custom";//google.com, ngumbi branded
                    else if (searchFlag == 2)
                        searchSuffix2 = "search";//google.com, regular
                    else if (searchFlag == 3)
                        searchSuffix2 = "custom";//google.com, safesearch - same as first, but do a check later for the specific safesearch bit

                    //we have some form of google search
                    %>
                    <td style="text-align: center;">

                        <!-- Search Google -->
                        <form name="search_form" action="http://<%=searchUrl%>/<%=searchSuffix2%>" id="cse-search-box">
                          <div>
                            <a href="http://<%=searchUrl%>/" style="text-decoration: none;">
                                <img src="http://www.google.com/logos/Logo_40wht.gif" border="0" alt="Google" align="middle">
                            </a>
                            <input type="hidden" name="cx" value="partner-pub-8335750690638492:0017612265" />
                            <input type="hidden" name="ie" value="UTF-8" />
                            <%
                            if (searchFlag == 3){//google safe search
                                %><input type="hidden" name="safe" value="active"/><%
                            }
                            %>
                            <input type="hidden" name="safe" value="active"/>
                            <input type="hidden" name="hl" value="<%=searchLang%>">
                            <input type="text" name="q" size="31" />
                          </div>
                        </form>
                        <!-- end Search Google -->

                    </td>
                    <%

                } //end 1,2,3 google search

                else if (searchFlag == 10){
                        //yahoo search
                        %>
                        <td>
                        <center>
                        <!-- Yahoo! Search -->
                        <form method="get" action="http://<%=searchUrl%>/search" style="padding: 5px; width:360px; text-align:center; margin-top: 15px; margin-bottom: 25px;">
                        <a href="http://<%=searchUrl%>/">
                        <img src="http://us.i1.yimg.com/us.yimg.com/i/us/search/ysan/ysanlogo.gif" alt="yahoo" align="absmiddle" border="0"></a>&nbsp;<input type="text" name="p" size=25>&nbsp;<input type="hidden" name="fr" value="yscpb">&nbsp;<input type="submit" value="Search">
                        </form>
                        </center>
                        <!-- End Yahoo! Search -->
                        </td>
                        <%
                } //end yahoo search

            } //end 		if (rsuserdata.next()){

            %>
            <td align="right" valign="top">
            </td>
            </tr>
            </table>
            <!-- End Start Page Header (top table) ----------------------------------------->



            <!--- start main (dynamic) table-->
            <center>
            <table cellpadding="0" cellspacing="8" border="0"><%

            linkCounter = 0;
            catCounter = 0;



            //do the first link
            if(rs.next()){
                    currLinkId = rs.getInt("user_link_id");
                    currCat = rs.getString("cat");//have to get first table entry to assign tracking variables
                    currSubCatRank = rs.getInt("sub_cat_rank");//of current category and subcategory

                    //

                    if( currCat.equals("")){//check if first link is a category-less one
                        %><!-- start table and print first link centered--><%
                        %><tr><td valign="top" colspan="2"><center><font size="-1"><%

                        if (state.equals("3e") || state.equals("3d") || state.equals("3m")){
                            //instead of normal links, need to pass the info of which link was clicked.
                            fromstate = state;
                            String state2 = "";
                            if (state.equals("3e") || state.equals("3m")){ state2 = state+"_1"; } // go to next step within this option (edit or move link)
                            else if (state.equals("3d")){ state2 = "2"; } // go back to state 2, link will be deleted

                            //here doing some edits for chinese testing, the first link
                            //the "encoded" one comes out as %E5%95%8A or some such, for a chinese character, but the one in the link below does not
                            // why not!??? they are both URLEncoded.
                            //URLEncoder.encode(rsInventoryInStock.getString("return_media_desc"), "UTF-8")
                            %><a href="editor_NEW.jsp?user=<%=username%>&state=<%=state2%>&fromstate=<%=fromstate%>&selected_user_link_id=<%=currLinkId%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>&sub_cat_rank=<%=currSubCatRank%>"><%=rs.getString("link_name")%></a>&nbsp;&nbsp;<%
                        }
                        else if (state.equals("3m_1")){ //move link, show links as plain text to protect from accidental clicks
                            if (!rs.getString("link_name").equals(linkname)){ //insert placeholder, it's not adjacent to the link picked to move
                                    if (moveFlag == 1){
                                        moveFlag = 0;
                                        if (rs.getInt("link_rank") == 1){ %><a href="asdf"><%=placeholder%></a>&nbsp;<% } //last link was one picked to move, don't put placeholder
                                    }
                                    else { %><a href="asdf"><%=placeholder%></a>&nbsp;<% }
                            }
                            else { //link is one that was picked to move, set variable to not write placeholder after it either
                                    moveFlag = 1;
                                    %><font color=<%=moveColor%>><%
                            }
                            %><%=rs.getString("link_name")%>&nbsp;<%	
                            //finish font tag for the picked link
                            if (moveFlag == 1){ %></font><%	}
                        }
                        else if (state.equals("3r") || state.equals("3mc")){
                            //show links as plain text to protect from accidental clicks
                            %><%=rs.getString("link_name")%> <%
                        }
                        else {
                            //show links as blue underlined text, but not links, to protect from accidental clicks
                            %><font color=<%=linkColor%>><u><%=rs.getString("link_name")%></u></font>&nbsp;&nbsp;<%
                        }				
                    }

                    else{ //print first category, then first link
                            %><tr><td valign="top" width="50%"><strong><%

                            if (state.equals("3r")){ //print category name as a link for user to pick when modifying category
                                    fromstate = state;
                                    String state3 = "";
                                    state3 = state+"_1";
                                    %><a href="editor_NEW.jsp?user=<%=username%>&state=<%=state3%>&fromstate=<%=fromstate%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>"><%=currCat%></a><%
                            }
                            else { //print category name normally
                                    %><%=currCat%><%
                            }						

                            %></strong><br><font size="-1"><%

                            if (state.equals("3e") || state.equals("3d") || state.equals("3m")){ //instead of normal links, need to pass the info of which link was clicked.
                                    fromstate = state;
                                    String state2 = "";
                                    if (state.equals("3e") || state.equals("3m")){ state2 = state+"_1"; } // go to next step within this option (edit or move link)
                                    else if (state.equals("3d")){ state2 = "2"; } // go back to state 2, link will be deleted		
                                    %><a href="editor_NEW.jsp?user=<%=username%>&state=<%=state2%>&fromstate=<%=fromstate%>&selected_user_link_id=<%=currLinkId%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>&sub_cat_rank=<%=currSubCatRank%>"><%=rs.getString("link_name")%></a>&nbsp;&nbsp;<%
                            }
                            else if (state.equals("3m_1")){ //move link, show links as plain text to protect from accidental clicks
                                    if (!rs.getString("link_name").equals(linkname)){ //insert placeholder, it's not adjacent to the link picked to move
                                            if (moveFlag == 1){
                                                    moveFlag = 0;
                                                    if (rs.getInt("link_rank") == 1){ %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<% } //last link was one picked to move, don't put placeholder
                                            }
                                            else { %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<% }
                                    }
                                    else { //link is one that was picked to move, set variable to not write placeholder after it either
                                            moveFlag = 1;
                                            %><font color=<%=moveColor%>><%
                                    }
                                    %><%=rs.getString("link_name")%>&nbsp;&nbsp;<%	
                                    //finish font tag for the picked link
                                    if (moveFlag == 1){ %></font><%	}
                            }
                            else if (state.equals("3r") || state.equals("3mc")){ //show links as plain text to protect from accidental clicks
                                    %><%=rs.getString("link_name")%>&nbsp;&nbsp;<%
                            }
                            else { 	//show links as blue underlined text, but not links, to protect from accidental clicks
                                    %><font color=<%=linkColor%>><u><%=rs.getString("link_name")%></u></font>&nbsp;&nbsp;<%
                            }				

                            catCounter++;
                            lastCat = currCat;
                    }

                    linkCounter++;
            }

            // first link is completed, now loop through rest
            while (rs.next()) {
                currLinkId = rs.getInt("user_link_id");

                    if ( !(currCat.equals(rs.getString("cat")))){ //we have a new category so indent accordingly
                            currCat = rs.getString("cat");//set to new category
                            currSubCatRank = rs.getInt("sub_cat_rank");//reset subcategory
                            catCounter++;

                            //code for putting last placeholder on end of row if moving a link (this one for end of category, is another for end of subcat)
                            if (state.equals("3m_1") && moveFlag != 1){
                                    %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<%
                            }					

                            if (((catCounter%2) == 0) && !(lastCat.equals(""))){//we are still in the same row of big table, don't <tr> yet
                                    //also, have new category but last category wasn't null, so don't start new line under category-less pool
                                    %></font></td><td valign="top" width="50%"><strong><%
                                    if (state.equals("3r")){ //print category name as a link for user to pick when modifying category
                                            fromstate = state;
                                            String state3 = "";
                                            state3 = state+"_1";
                                            %><a href="editor_NEW.jsp?user=<%=username%>&state=<%=state3%>&fromstate=<%=fromstate%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>"><%=currCat%></a><%
                                    }
                                    else { //print category normally
                                            %><%=currCat%><%
                                    }

                                    %></strong><br><font size="-1"><%

                                    if (state.equals("3e") || state.equals("3d") || state.equals("3m")){ //instead of normal links, need to pass the info of which link was clicked.
                                            fromstate = state;
                                            String state2 = "";
                                            if (state.equals("3e") || state.equals("3m")){ state2 = state+"_1"; } // go to next step within this option (edit or move link)
                                            else if (state.equals("3d")){ state2 = "2"; } // go back to state 2, link will be deleted		
                                            %>
                                            <a href="editor_NEW.jsp?user=<%=username%>&state=<%=state2%>&fromstate=<%=fromstate%>&selected_user_link_id=<%=currLinkId%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>&sub_cat_rank=<%=currSubCatRank%>"><%=rs.getString("link_name")%></a>&nbsp;&nbsp;<%
                                    }
                                    else if (state.equals("3m_1")){ //move link, show links as plain text to protect from accidental clicks
                                            if (!rs.getString("link_name").equals(linkname)){ //insert placeholder, it's not adjacent to the link picked to move
                                                    if (moveFlag == 1){
                                                            moveFlag = 0;
                                                            if (rs.getInt("link_rank") == 1){ %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<% } //last link was one picked to move, but now on new row, put placeholder
                                                    }
                                                    else { %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<% }
                                            }
                                            else { //link is one that was picked to move, set variable to not write placeholder after it either, and set special color
                                                    moveFlag = 1;
                                                    %><font color=<%=moveColor%>><%
                                            }
                                            %><%=rs.getString("link_name")%><%
                                            //finish font tag for the picked link
                                            if (moveFlag == 1){ %></font><%	}

                                    }
                                    else if (state.equals("3r") || state.equals("3mc")){ //show links as plain text to protect from accidental clicks
                                            %><%=rs.getString("link_name")%>&nbsp;&nbsp;<%
                                    }
                                    else { 	//show links as blue underlined text, but not links, to protect from accidental clicks
                                            %><font color=<%=linkColor%>><u><%=rs.getString("link_name")%></u></font>&nbsp;&nbsp;<%
                                    }				
                            }
                            else { // we jumped to next row of big table, do <tr>
                                    %></font></td></tr><tr><td valign="top"><strong><%
                                    if (state.equals("3r")){ //print category name as a link for user to pick when modifying category
                                            fromstate = state;
                                            String state3 = "";
                                            state3 = state+"_1";
                                            %><a href="editor_NEW.jsp?user=<%=username%>&state=<%=state3%>&fromstate=<%=fromstate%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>"><%=currCat%></a><%
                                    }
                                    else { //print category normally
                                            %><%=currCat%><%
                                    }
                                    %></strong><br><font size="-1"><%

                                    if (state.equals("3e") || state.equals("3d") || state.equals("3m")){ //instead of normal links, need to pass the info of which link was clicked.
                                            fromstate = state;
                                            String state2 = "";
                                            if (state.equals("3e") || state.equals("3m")){
                                                state2 = state+"_1";// go to next step within this option (edit or move link)
                                            }
                                            else if (state.equals("3d")){ 
                                                state2 = "2"; // go back to state 2, link will be deleted		
                                            }
                                            %><a href="editor_NEW.jsp?user=<%=username%>&state=<%=state2%>&fromstate=<%=fromstate%>&selected_user_link_id=<%=currLinkId%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>&sub_cat_rank=<%=currSubCatRank%>"><%=rs.getString("link_name")%></a>&nbsp;&nbsp;<%
                                    }
                                    else if (state.equals("3m_1")){ //move link, show links as plain text to protect from accidental clicks
                                            if (!rs.getString("link_name").equals(linkname)){ //insert placeholder, it's not adjacent to the link picked to move
                                                    if (moveFlag == 1){
                                                            moveFlag = 0;
                                                            if (rs.getInt("link_rank") == 1){ %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<% } //last link was one picked to move, don't put placeholder
                                                    }
                                                    else { %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<% }
                                            }
                                            else { //link is one that was picked to move, set variable to not write placeholder after it either
                                                    moveFlag = 1;
                                                    %><font color=<%=moveColor%>><%
                                            }
                                            %><%=rs.getString("link_name")%><%	
                                            //finish font tag for the picked link
                                            if (moveFlag == 1){ %></font><%	}
                                    }
                                    else if (state.equals("3r") || state.equals("3mc")){ //show links as plain text to protect from accidental clicks
                                            %><%=rs.getString("link_name")%>&nbsp;&nbsp;<%
                                    }
                                    else { 	//show links as blue underlined text, but not links, to protect from accidental clicks
                                            %><font color=<%=linkColor%>><u><%=rs.getString("link_name")%></u></font>&nbsp;&nbsp;<%
                                    }				

                                    if (lastCat.equals("")){//we're on 1st new category since the category-less pool
                                            //do nothing, already accounted for
                                    }
                            }
                    }

                    else{ //we are still in same category (or non-category)
                            if ( currSubCatRank != rs.getInt("sub_cat_rank")){ //we are in a new subcategory, do <br>

                                    //code for putting last placeholder on end of row if moving a link
                                    if (state.equals("3m_1") && moveFlag != 1){
                                            %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<%
                                    }

                                    %><br><%

                                    if (state.equals("3e") || state.equals("3d") || state.equals("3m")){ //instead of normal links, need to pass the info of which link was clicked.
                                            fromstate = state;
                                            String state2 = "";
                                            if (state.equals("3e") || state.equals("3m")){ state2 = state+"_1"; } // go to next step within this option (edit or move link)
                                            else if (state.equals("3d")){ state2 = "2"; } // go back to state 2, link will be deleted	
                                            %><a href="editor_NEW.jsp?user=<%=username%>&state=<%=state2%>&fromstate=<%=fromstate%>&selected_user_link_id=<%=currLinkId%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>&sub_cat_rank=<%=currSubCatRank%>"><%=rs.getString("link_name")%></a>&nbsp;&nbsp;<%
                                    }
                                    else if (state.equals("3m_1")){ //move link, show links as plain text to protect from accidental clicks
                                        if (!rs.getString("link_name").equals(linkname)){ //insert placeholder, it's not adjacent to the link picked to move
                                            if (moveFlag == 1){
                                                moveFlag = 0;
                                                if (rs.getInt("link_rank") == 1){ %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<% } //last link was one picked to move, don't put placeholder
                                            }
                                            else {
                                                %><a href="asdf"><%=placeholder%></a>&nbsp;<%
                                            }
                                        }
                                        else { //link is one that was picked to move, set variable to not write placeholder after it either
                                            moveFlag = 1;
                                            %><font color=<%=moveColor%>><%
                                        }
                                        %><%=rs.getString("link_name")%><%	
                                        //finish font tag for the picked link
                                        if (moveFlag == 1){ 
                                            %></font><%
                                        }
                                    }
                                    else if (state.equals("3r") || state.equals("3mc")){ //show links as plain text to protect from accidental clicks
                                            %><%=rs.getString("link_name")%>&nbsp;&nbsp;<%
                                    }
                                    else { 	//show links as blue underlined text, but not links, to protect from accidental clicks
                                            %><font color=<%=linkColor%>><u><%=rs.getString("link_name")%></u></font>&nbsp;&nbsp;<%
                                    }				
                                    currSubCatRank = rs.getInt("sub_cat_rank");//set subcategory	
                            }
                            else{//we are in same category and subcategory  
                                    if (state.equals("3e") || state.equals("3d") || state.equals("3m")){ //instead of normal links, need to pass the info of which link was clicked.
                                            fromstate = state;
                                            String state2 = "";
                                            if (state.equals("3e") || state.equals("3m")){ 
                                                state2 = state+"_1";//go to next step within this option (edit or move link)
                                            }
                                            else if (state.equals("3d")){ 
                                                state2 = "2";//go back to state 2, link will be deleted	
                                            }		
                                            %><a href="editor_NEW.jsp?user=<%=username%>&state=<%=state2%>&fromstate=<%=fromstate%>&selected_user_link_id=<%=currLinkId%>&cat=<%=URLEncoder.encode(currCat,"UTF-8")%>&sub_cat_rank=<%=currSubCatRank%>"><%=rs.getString("link_name")%></a>&nbsp;&nbsp;<%
                                    }
                                    else if (state.equals("3m_1")){ //move link, show links as plain text to protect from accidental clicks
                                            if (!rs.getString("link_name").equals(linkname)){ //insert placeholder, it's not adjacent to the link picked to move
                                                    if (moveFlag == 1){
                                                            moveFlag = 0;
                                                            if (rs.getInt("link_rank") == 1){
                                                                %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<%
                                                            } //last link was one picked to move, don't put placeholder
                                                    }
                                                    else { %><a href="asdf"><%=placeholder%></a>&nbsp;&nbsp;<% }
                                            }
                                            else { //link is one that was picked to move, set variable to not write placeholder after it either
                                                    moveFlag = 1;
                                                    %><font color=<%=moveColor%>><%
                                            }
                                            %><%=rs.getString("link_name")%><%	
                                            //finish font tag for the picked link
                                            if (moveFlag == 1){ %></font><%	}
                                    }
                                    else if (state.equals("3r") || state.equals("3mc")){ //show links as plain text to protect from accidental clicks
                                            %><%=rs.getString("link_name")%>&nbsp;&nbsp;<%
                                    }
                                    else { 	//show links as blue underlined text, but not links, to protect from accidental clicks
                                            %><font color=<%=linkColor%>><u><%=rs.getString("link_name")%></u></font>&nbsp;&nbsp;<%
                                    }				
                            }	
                    }

                    lastCat = currCat;
                    linkCounter++;
            %>
            <% 	
            } 	
            //by keeping this last } in separate java area, it keeps the html for the links from being all on the same line
            //when it was all on the same line, the table wasn't spacing properly in IE, it wouldn't shrink very far because
            //the links wouldn't spill over to the next line and the 2 columns weren't spacing 50%

            rs.close();
            %>

            </table>
            <!--- End main table-->

            </center>

            <!-- list total links and categories -->
            <p style="text-align: center; font-size: .8em;">
                Displaying&nbsp;<b><%=linkCounter%></b>&nbsp;links in&nbsp;<b><%=catCounter%></b>&nbsp;categories
                <br>
                <a href="index.jsp">ngumbi</a>
            </p>

            <!-- check mysql to display last update of DB time -->

            <%
            /////////////////////////////////////////////////////////////////
            //back to big table with two cells
            %>
            </td>

            <%
            /////////////////////////////////////////////////////////////////
            // code for yellow editor column begins here
            %>
            <td style="width: 220px; background-color: #ffc; padding: 20px 20px; vertical-align: middle;">
                <%


            //state 1, display password dialog
            if (state.equals("1")){
                %>
                <form name="edit_login" method="post" action="editor_NEW.jsp">
                    <p style="text-align: left; padding: 0px 7px;">
                        Username: <b><%=username%></b>
                    </p>
                    <p style="text-align: left; padding: 0px 7px;">
                        Password: <input type="password" name="pass" size="13" maxlength="30">
                    </p>
                    <input type="hidden" name="user" value="<%=username%>" >
                    <input type="hidden" name="state" value="2" >
                    <input type="hidden" name="fromstate" value="<%=fromstate%>" >
                    <div style="text-align: center; margin-top: 20px;">
                        <input type="submit" value="Submit">
                    </div>
                </form>

                <p style="text-align: center; padding: 30px 7px;">
                    <a href="user/<%=username%>">Cancel</a>
                </p>

                <!--set focus in javascript-->
                <script type="text/javascript"><!--
                    //document.edit_login.pass.focus();
                //--></script>
                <%
            }

            //state 2, display main edit options
            else if (state.equals("2")){
                %>
                <div style="text-align: center;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=3a&fromstate=<%=fromstate%>" >Add a link</a><br>
                    <a href="editor_NEW.jsp?user=<%=username%>&state=3e&fromstate=<%=fromstate%>" >Edit a link</a><br>
                    <!--<a href="editor_NEW.jsp?user=<%=username%>&state=3m&fromstate=<%=fromstate%>" >Move a link</a><br>-->
                    <a href="editor_NEW.jsp?user=<%=username%>&state=3d&fromstate=<%=fromstate%>" >Delete a link</a><br>
                    <!--Move a group<br>-->
                    <a href="editor_NEW.jsp?user=<%=username%>&state=3r&fromstate=<%=fromstate%>" >Rename a category</a>
                    <br>
                    <br>
                    <a href="editor_NEW.jsp?user=<%=username%>&state=3o&fromstate=<%=fromstate%>" >More options</a>
                    <br><br><br>
                    <a href="user/<%=username%>">Exit</a>
                </div>
                <%
            }

            //state 3o, display 'more options', non-basic options
            else if (state.equals("3o")){
                %>
                <div style="text-align: center;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=3g&fromstate=<%=fromstate%>" >Change search option</a>
                    <br><br><br>
                    <a href="editor_NEW.jsp?user=<%=username%>&state=3p&fromstate=<%=fromstate%>" >Change password</a>
                    <br><br>
                    <a href="editor_NEW.jsp?user=<%=username%>&state=3dj&fromstate=<%=fromstate%>" >Delete my account</a>
                    <br><br><br>
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Back to main options</a>
                    <br><br>
                    <a href="user/<%=username%>">Exit</a>
                </div>
                <%
            }

            //state 3a, display add a link dialog and form
            else if (state.equals("3a") || state.equals("3a_1")){
                
                if (state.equals("3a_1")){
                    //adding link was unsuccessful
                    %>
                    <span style="color: red;">
                        Unsuccessful. Either you attempted to use invalid characters or
                        you've hit the max # of links.
                    </span>
                    <%
                }

                %>
                <form name="add" method="post" action="editor_NEW.jsp" enctype="application/x-www-form-urlencoded">
                New link name: <input name=linknamenew SIZE=27 MAXLENGTH=30>
                <br>
                New link URL: <input name=linkurlnew SIZE=27 MAXLENGTH=85>
                <%	//here have radio buttons for each category (and non-category) and a text box for entering a new category name
                %>
                <HR size=1 width="66%" align=center>
                Choose category:
                <br>
                <input type="radio" name="catradio" value="" CHECKED>No category<br>
                <input type="radio" name="catradio" value="null"><input name="catnew" SIZE=22 maxlength=20 value="new category"><br>

                <%//code to find all existing categories and make radio button for each
                Statement stat100 = null;
                ResultSet rsallcats = null;
                String catQuery = "SELECT DISTINCT cat FROM user_links WHERE user_id = "+user_id+" AND cat != ''";
                try {
                    stat100 = conn.createStatement();
                    rsallcats = stat100.executeQuery(catQuery);//gets matching user(s) already in table
                }
                catch (Exception e) {
                    //slight possibility that someone gets here if they hack url and use invalid username
                    out.print("Unable to make connection to production database");
                    out.print(e);
                }

                while (rsallcats.next()){
                    %><input type="radio" name="catradio" value="<%=rsallcats.getString("cat")%>"><%=rsallcats.getString("cat")%><br><%
                }
                rsallcats.close();


                //here have radio buttons for the row option, default will be add to end but
                //there will also be, add new row and add to specific row
                %>

                <input type="hidden" name="user" value="<%=username%>" >
                <input type="hidden" name="state" value="2" >
                <input type="hidden" name="fromstate" value="<%=fromstate%>" >

                <div style="text-align: center; margin-top: 20px;">
                    <input type="submit" value="Submit">
                </div>
                </FORM>

                <!--set focus in javascript-->
                <script type="text/javascript"><!--
                document.add.linknamenew.focus();
                //--></script>


                <p style="text-align: center; padding: 30px 7px;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </p>
                <%
            }


            //state 3e, display message to click the link to edit
            else if (state.equals("3e")){
                %>
                Click the link on the left that you want to edit

                <p style="text-align: center; padding: 20px 0px;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </p>
                <%
            }

            //state 3e_1, display text boxes for editing linkname and URL
            else if (state.equals("3e_1") || state.equals("3e_2")){
                
                //Get info for link chosen so we can prefill values into input fields
                UserLink selectedUserLink = UserPageDAO.getUserLink(selected_user_link_id);
                String prefill_editlink_linkname = selectedUserLink.getLinkName();
                String prefill_editlink_linkaddress = selectedUserLink.getLinkAddress();
                
                //code to find and display the first links mentioned above
                /*Statement stat102 = null;
                ResultSet rsEditLink = null;
                String getLinkDetails = "SELECT link_name, link_address FROM user_links WHERE user_link_id = "+selected_user_link_id;
                try {
                    stat102 = conn.createStatement();
                    rsEditLink = stat102.executeQuery(getLinkDetails);
                }
                catch (Exception e) {
                    out.print("Unable to make connection to production database");
                    out.print(e);
                }


                if (rsEditLink.next()){
                    linkname = rsEditLink.getString("link_name");
                    linkurl = rsEditLink.getString("link_address");
                }
                rsEditLink.close();
                */
                
                if (state.equals("3e_2")){ //has unsuccessful attempt for editing link
                    %>
                    <span style="color: red;">
                        The change was unsuccessful because either the link name or URL you entered
                        is already in use for another link or you attempted to use invalid characters
                    </span>
                    <%
                }

                %>
                <form name="editl" method="GET" action="editor_NEW.jsp" enctype="application/x-www-form-urlencoded">
                    Link name: <input name="editlink_linkname" size="27" maxlength="30" value="<%=prefill_editlink_linkname%>">
                    <br>
                    Link URL: <input name="editlink_linkaddress" size="27" maxlength="85" value="<%=prefill_editlink_linkaddress%>">
                    <input type="hidden" name="selected_user_link_id" value="<%=selected_user_link_id%>" >
                    <input type="hidden" name="user" value="<%=username%>" >
                    <input type="hidden" name="state" value="2" >
                    <input type="hidden" name="fromstate" value="<%=fromstate%>" >

                    <div style="text-align: center; margin-top: 20px;">
                        <input type="submit" value="Submit">
                    </div>
                </FORM>

                <p style="text-align: center; padding: 20px 0px;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </p>

                <!--set focus in javascript-->
                <script type="text/javascript"><!--
                    document.editl.linknamenew.focus();
                //--></script>
                <%
            }

            //state 3m, display message asking user to click link they wish to move
            else if (state.equals("3m")){
                %>
                Click the link on the left that you want to move

                <p style="text-align: center; padding: 20px 0px;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </p>
                <%
            }

            //state 3d, display message asking user to click link they wish to delete
            else if (state.equals("3d")){
                %>
                Click the link on the left that you want to delete

                <p style="text-align: center; padding: 20px 0px;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </p>
                <%
            }

            //state 3r, display message asking user to click category they wish to rename
            else if (state.equals("3r")){
                %>
                Click the category name that you want to rename

                <p style="text-align: center; padding: 20px 0px;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </p>
                <%
            }

            //state 3r_1, a category was chosen, display textbox with cat name and submit button for editing
            else if (state.equals("3r_1") || state.equals("3r_2")){

                //similar to 3e_1, need to do check if category entered is already in use.
                if (state.equals("3r_2")){ //has unsuccessful attempt for editing category name
                    %>
                    <span style="color: red;">
                        The change was unsuccessful because either the category name you entered
                        is already in use or you attempted to use invalid characters
                    </span>
                    <%
                }

                %>
                <form name="editc" method="post" action="editor_NEW.jsp" enctype="application/x-www-form-urlencoded">
                    Category name: <input name="catnew" size="20" maxlength=20 value="<%=cat%>" >
                    <input type="hidden" name="cat" value="<%=cat%>" >
                    <input type="hidden" name="user" value="<%=username%>" >
                    <input type="hidden" name="state" value="2" >
                    <input type="hidden" name="fromstate" value="<%=fromstate%>" >
                    <div style="text-align: center; margin-top: 20px;">
                        <input type="submit" value="Submit">
                    </div>
                </FORM>
                
                <p style="text-align: center; padding: 20px 0px;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </p>

                <!--set focus in javascript-->
                <script type="text/javascript"><!--
                document.editc.catnew.focus();
                //--></script>
                <%
            }

            //state 3g, display search options
            else if (state.equals("3g")){
                //we already have the user's search option in "searchFlag" variable
                //from regular jumpstation code.  Commented out code below is in case
                //we don't have that, maybe won't run the jumpstation code someday...
                String currSelectionMsg = "";
                String checked0 = "";
                String checked1 = "";
                String checked2 = "";
                String checked3 = "";
                String checked10 = "";

                if (searchFlag == 0){
                    currSelectionMsg = "Your current selection is for <span style=\"color: blue;\">no search</span>";
                    checked0 = "checked";
                }
                else if (searchFlag == 1){
                    currSelectionMsg = "Your current selection is for a <span style=\"color: blue\">Google search (Ngumbi branded)</span> "+
                                "at <span style=\"color: blue\">"+searchUrl+"</span>";
                    checked1 = "checked";
                }
                else if (searchFlag == 2){
                    currSelectionMsg = "Your current selection is for a <span style=\"color: blue\">regular Google search</span> "+
                                "at <span style=\"color: blue\">"+searchUrl+"</span>";
                    checked2 = "checked";
                }
                else if (searchFlag == 3){
                    currSelectionMsg = "Your current selection is for a <span style=\"color: blue\">Google SafeSearch (Ngumbi branded)</span> "+
                                "at <span style=\"color: blue\">"+searchUrl+"</span>";
                    checked3 = "checked";
                }
                else if (searchFlag == 10){
                    currSelectionMsg = "Your current selection is for a <span style=\"color: blue\">Google SafeSearch (Ngumbi branded)</span> "+
                                "at <span style=\"color: blue\">"+searchUrl+"</span>";
                    checked10 = "checked";
                }
                %>

                <%=currSelectionMsg%>

                <form name="editg" method="post" action="editor_NEW.jsp">
                    <p>
                        Choose new search options:
                    </p>

                    <div>
                        <label id="searchradio0">
                            <input type="radio" name="searchradio" value="0" id="searchradio0" <%=checked0%> >No search
                        </label>
                        <br>
                        <label id="searchradio1">
                            <input type="radio" name="searchradio" value="1" <%=checked1%> >Google search<span style="font-size: .7em">(n)</span>
                        </label>
                        <br>
                        <label id="searchradio0">
                        <input type="radio" name="searchradio" value="2" <%=checked2%> >Google search
                        </label>
                        <br>
                        <label id="searchradio0">
                        <input type="radio" name="searchradio" value="3" <%=checked3%> >Google SafeSearch<span style="font-size: .7em">(n)</span>
                        </label>
                        <br>
                        <label id="searchradio0">
                        <input type="radio" name="searchradio" value="10" <%=checked10%> >Yahoo! search
                        </label>

                        <input type="hidden" name="user" value="<%=username%>" >
                        <input type="hidden" name="state" value="2" >
                        <input type="hidden" name="fromstate" value="<%=fromstate%>" >
                        <input type="hidden" name="searchUrl" value="<%=searchUrl%>" >
                        <input type="hidden" name="customSearchUrl" value="" >
                        <input type="hidden" name="searchLang" value="<%=searchLang%>" >
                    </div>

                    <div style="padding: 15px 0px; text-align: center;">
                        <input type="submit" value="Submit">
                    </div>
                </FORM>

                <p style="text-align: center; padding: 20px 0px;">
                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </p>
                <%
            }

            //state 3g, display search options
            else if (state.equals("3g_0")){			

                //second page of search options, only for google search choices
                %>
                <form name="editg0" method="post" action="editor_NEW.jsp">

                    <div style="padding: 15px 0px;">
                        Google URL: <br>
                        <select name="searchUrl" style="width: 200px;">
                            <%
                            if (rsuserdata.getString("searchUrl").indexOf("google") > -1){
                                //previously had yahoo choice, put first and preselect it
                                %>
                                <option value="<%=rsuserdata.getString("searchUrl")%>" SELECTED ><%=rsuserdata.getString("searchUrl")%></option>
                                <optgroup label="-----------------"></optgroup>
                                <%
                            }
                            %>
                            <option value="www.google.com" >Default - www.google.com</option>
                            <option value="www.google.com.au">Australia - www.google.com.au</option><!-- Australia -->
                            <option value="www.google.be">België - www.google.be</option><!-- Belgium -->
                            <option value="www.google.com.br">Brasil - www.google.com.br</option><!-- Brazil -->
                            <option value="www.google.ca">Canada - www.google.ca</option><!-- Canada -->
                            <option value="www.google.cn">中国 - www.google.cn</option><!-- China -->
                            <option value="www.google.com.hk">香港 - www.google.com.hk</option><!-- China, Hong Kong (not censored) -->
                            <option value="www.google.com.tw">台灣 - www.google.com.tw</option><!-- Taiwan -->
                            <option value="www.google.dk">Danmark - www.google.dk</option><!-- Denmark -->
                            <option value="www.google.de">Deutschland - www.google.de</option><!-- Germany -->
                            <option value="www.google.fr">France - www.google.fr</option><!-- France -->
                            <option value="www.google.gr">Ελλάς - www.google.gr</option><!-- Greece -->
                            <option value="www.google.es">España - www.google.es</option><!-- Spain -->
                            <option value="www.google.ie">Ireland - www.google.ie</option><!-- Ireland -->
                            <option value="www.google.co.id">Indonesia - www.google.co.id</option><!-- Indonesia -->
                            <option value="www.google.co.in">India - www.google.co.in</option><!-- India -->
                            <option value="www.google.it">Italia - www.google.it</option><!-- Italy -->
                            <option value="www.google.co.kr">한국 - www.google.co.kr</option><!-- Korea (South) -->
                            <option value="www.google.lv">Latvija - www.google.lv</option><!-- Latvia -->
                            <option value="www.google.com.mx">México - www.google.com.mx</option><!-- Mexico -->
                            <option value="www.google.nl">Nederland - www.google.nl</option><!-- Netherlands -->
                            <option value="www.google.co.nz">New Zealand - www.google.co.nz</option><!-- New Zealand -->
                            <option value="www.google.com.pk">Pakistan - www.google.com.pk</option><!-- Pakistan -->
                            <option value="www.google.com.ph">Pilipinas - www.google.com.ph</option><!-- Philippines -->
                            <option value="www.google.ru">Россия - www.google.ru</option><!-- Russia -->
                            <option value="www.google.fi">Suomi - www.google.fi</option><!-- Finland -->
                            <option value="www.google.se">Sverige - www.google.se</option><!-- Sweden -->
                            <option value="www.google.com.tr">Türkiye - www.google.com.tr</option><!-- Turkey -->
                            <option value="www.google.co.uk">UK - www.google.co.uk</option><!-- UK -->
                            <option value="www.google.com">USA - www.google.com</option><!-- USA -->
                        </select>
                        <br><br>
                        or
                        <input type="text" name="customSearchUrl" size="20" maxlength="45" value="">
                    </div>

                    <div style="padding: 15px 0px;">
                        Language
                        <select name="searchLang">
                            <%
                            String english_selected = "selected";
                            if (rsuserdata.getString("searchUrl").indexOf("google") > -1){
                                //previously had yahoo choice, put first and preselect it
                                %>
                                <option value="<%=rsuserdata.getString("searchLang")%>" SELECTED ><%=rsuserdata.getString("searchLang")%></option>
                                <optgroup label="-----------------"></optgroup>
                                <%
                                english_selected = "";//preselect english if there was no language, such as if user had yahoo or no search previously
                            }
                            %>
                            <option value="ar">العربية</option><!-- Arabic -->
                            <option value="da">dansk</option><!-- Danish -->
                            <option value="de">Deutsch</option><!-- German -->
                            <option value="el">Ελληνικά</option><!-- Greek -->
                            <option value="en" <%=english_selected%> >English</option><!-- English -->
                            <option value="es">español</option><!-- Spanish -->
                            <option value="tl">Filipino</option><!-- Filipino -->
                            <option value="fr">Français</option><!-- French -->
                            <option value="iw">עברית</option><!-- Hebrew -->
                            <option value="hi">हिंदी</option><!-- Hindi -->
                            <option value="lv">Latviešu</option><!-- Latvian -->
                            <option value="nl">Nederlands</option><!-- Dutch -->
                            <option value="ja">日本語</option><!-- Japanese -->
                            <option value="pt-BR">Português (Br)</option><!-- Portuguese (Brazil) -->
                            <option value="pt-PT">Português (Pt)</option><!-- Portuguese (Portugal) -->
                            <option value="ru">Россию</option><!-- Russian -->
                            <option value="fi">suomi</option><!-- Finnish -->
                            <option value="sv">Svenska</option><!-- Swedish -->
                            <option value="th">ภาษาไทย</option><!-- Thai -->
                            <option value="tr">Türk</option><!-- Turkish -->
                            <option value="ur">اردو</option><!-- Urdu (for Pakistan) -->
                            <option value="zh-CN">简体中文</option><!-- Chinese (simplified) -->
                            <option value="zh-TW">繁體中文</option><!-- Chinese (traditional) -->
                            <option value="xx-piglatin">Pig Latin</option><!-- Pig Latin -->
                        </select>
                    </div>

                    <input type="hidden" name="user" value="<%=username%>" >
                    <input type="hidden" name="state" value="2" >
                    <input type="hidden" name="fromstate" value="<%=fromstate%>" >
                    <input type="hidden" name="searchradio" value="<%=searchradio%>" >

                    <div style="padding: 15px 0px; text-align: center;">
                        <input type="submit" value="Submit">
                    </div>

                </form>

                <div style="text-align: center; ">
                   <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a>
                </div>
                <%
            }

            else if (state.equals("3g_10") ){

                    //second page of search options, only for yahoo search choices
                    %>
                    <center><p>

                    <form name="editg0" method="post" action="editor_NEW.jsp">
                    Yahoo! URL: <br>
                    <select name="searchUrl" style="width: 180px;">
                        <%
                        if (rsuserdata.getString("searchUrl").indexOf("yahoo") > -1){
                            //previously had yahoo choice, put first and preselect it
                            %>
                            <option value="<%=rsuserdata.getString("searchUrl")%>" SELECTED ><%=rsuserdata.getString("searchUrl")%></option>
                            <optgroup label="-----------------"></optgroup>
                            <%
                        }
                        %>
                        <option value="search.yahoo.com" >Default - search.yahoo.com</option>
                        <option value="au.search.yahoo.com">Australia - au.search.yahoo.com</option><!-- Australia -->
                        <option value="br.search.yahoo.com">Brasil - br.search.yahoo.com</option><!-- Brazil -->
                        <option value="ca.search.yahoo.com">Canada - ca.search.yahoo.com</option><!-- Canada -->
                        <option value="dk.search.yahoo.com">Danmark - dk.search.yahoo.com</option><!-- Denmark -->
                        <option value="de.search.yahoo.com">Deutschland - de.search.yahoo.com</option><!-- Germany -->
                        <option value="gr.search.yahoo.com">Ελλάς - gr.search.yahoo.com</option><!-- Greece -->
                        <option value="es.search.yahoo.com">España - es.search.yahoo.com</option><!-- Spain -->
                        <option value="fr.search.yahoo.com">France - fr.search.yahoo.com</option><!-- France -->
                        <option value="one.cn.yahoo.com">中国 - one.cn.yahoo.com</option><!-- China -->
                        <option value="hk.search.yahoo.com">香港 - hk.search.yahoo.com</option><!-- China -->
                        <option value="tw.search.yahoo.com">中華民國 - tw.search.yahoo.com</option><!-- China (Taiwan) -->
                        <option value="in.search.yahoo.com">India - in.search.yahoo.com</option><!-- India -->
                        <option value="id.search.yahoo.com">Indonesia - id.search.yahoo.com</option><!-- Indonesia -->
                        <option value="it.search.yahoo.com">Italia - it.search.yahoo.com</option><!-- Italy -->
                        <option value="kr.search.yahoo.com">한국 - kr.search.yahoo.com</option><!-- Korea (South) -->
                        <option value="mx.search.yahoo.com">México - mx.search.yahoo.com</option><!-- Mexico -->
                        <option value="nl.search.yahoo.com">Nederland - nl.search.yahoo.com</option><!-- Netherlands -->
                        <option value="nz.search.yahoo.com">New Zealand - nz.search.yahoo.com</option><!-- New Zealand -->
                        <option value="ph.search.yahoo.com">Pilipinas - ph.search.yahoo.com</option><!-- Philippines -->
                        <option value="ru.search.yahoo.com">Россия - ru.search.yahoo.com</option><!-- Russia -->
                        <option value="ch.search.yahoo.com">Schweiz - ch.search.yahoo.com</option><!-- Switzerland (Confederation of Helvetia) -->
                        <option value="fi.search.yahoo.com">Suomi - fi.search.yahoo.com</option><!-- Finland -->
                        <option value="sv.search.yahoo.com">Sverige - sv.search.yahoo.com</option><!-- Sweden -->
                        <option value="th.search.yahoo.com">ประเทศไทย - th.search.yahoo.com</option><!-- Thailand -->
                        <option value="tr.search.yahoo.com">Türkiye - tr.search.yahoo.com</option><!-- Turkey -->
                        <option value="uk.search.yahoo.com">UK & Ireland - uk.search.yahoo.com</option><!-- United Kingdom -->
                        <option value="us.search.yahoo.com">USA - us.search.yahoo.com</option><!-- Canada -->
                        <option value="asia.search.yahoo.com">Asia - asia.search.yahoo.com</option><!-- Asia -->
                    </select><br>
                    or
                    <input type="text" name="customSearchUrl" size="15" maxlength="45" value="">
                    <input type="hidden" name="searchLang" value="">



                    </center>

                    <center><input type="hidden" name="user" value="<%=username%>" >
                    <input type="hidden" name="state" value="2" >
                    <input type="hidden" name="fromstate" value="<%=fromstate%>" >
                    <input type="hidden" name="searchradio" value="<%=searchradio%>" >

                    <p><input type="submit" value="Submit">
                    </form>
                    <br><br><br>

                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a><%
            }

            //state 3p, display boxes to change password
            else if (state.equals("3p") || state.equals("3p_1")){

                    //similar to 3e_1, need to do check if new password entered is invalid
                    if (state.equals("3p_1")){ //has unsuccessful attempt for editing category name
                            %><font color=red>The password change was unsuccessful because 
                            either the two fields didn't match or you attempted to use invalid characters.  
                            Spaces are invalid.  Try sticking to letters and numbers.  Try again.</font><%
                    }

                    %><p>Please enter your new password twice.  It may contain <i>some</i> punctuation characters.
                    <form name="editp" method="post" action="editor_NEW.jsp" enctype="application/x-www-form-urlencoded"> 
                    <input type="password" name="pass" size="20" maxlength="30" value="">
                    <input type="password" name="cpass" size="20" maxlength="30" value="">
                    <input type="hidden" name="user" value="<%=username%>" >
                    <input type="hidden" name="state" value="2" >
                    <input type="hidden" name="fromstate" value="<%=fromstate%>" >
                    <p><input type="submit" value="Submit">
                    </form>

                    <!--set focus in javascript-->
                    <script type="text/javascript"><!--
                        document.editp.pass.focus();
                    //--></script>
                    <br><br><br>			

                    <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a><%

            }


            //state 3dj, display confirmation to delete jumpstation
            else if (state.equals("3dj")){
                %>You're sure you want to delete your account?
                <p><a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=<%=fromstate%>" >Yes</a>
                <br><br><br>

                <a href="editor_NEW.jsp?user=<%=username%>&state=2&fromstate=0">Cancel</a><%

            }






            //



            %>
            </td>
            </tr>
            </table>
            <%
			
	rsuserdata.close();
    } //end conditional for state 3dj (user data was deleted)
} //end conditional for valid username check

rsuser.close();
conn.close();
























%>


<!-- code to list variable for development only, delete when finished. -->

<!--<p><p><p><p><p><br><br>
 user-<%=username%><br>
state-<%=state%><br>
fromstate-<%=fromstate%><br>
cat-<%=cat%><br>
subcatrank-<%=subcatrank%><br> 
linkrank-<%=linkrank%><br>
linkurl-<%=linkurl%><br>
linkname-<%=linkname%><br>
linkurlnew-<%=linkurlnew%><br>
linknamenew-<%=linknamenew%><br>
catnew-<%=catnew%><br>
rowradio-<%=rowradio%><br>
searchradio-<%=searchradio%><br>
-->
<!--	end		--><%





%>
</body>
</html>