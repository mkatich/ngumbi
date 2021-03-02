<%
/*********************************************************************
*	File: user_page.jsp
*	Description: Retrieves links and search option from MySQL database
*	and displays links on webpage in organized way.
*
*	Author: Michael Katich
*********************************************************************/
%>

<%@ page language="java" import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="logon" scope="session" class="logonBean.logon" /> 
<jsp:useBean id="helperMethods" scope="page" class="helperMethodsBean.helperMethods" />

<%
//get the username which was passed as an argument ? thing
String user = request.getParameter("user");


%><html>
<head>
<title><%=user%> &#64; ngumbi.com</title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../style.css">
<%

//checking which color version of the page was chosen and assigning colors for style elements

//defaults, these are used when there is no parameter passed, it's white
String linkColor = "#0000cc";
String visitedColor = "#800080";
String hoverColor = "#800080";
String activeColor = "#ff0000";
String bgColor = "ffffff";
String textColor = "000000";

String fontSize = "-1";
String fontFamily = "arial,sans-serif,helvetica";


%>

<style type="text/css">
<!--

A:link{	color:<%=linkColor%>; 
		text-decoration:underline;
		font-family:<%=fontFamily%>;}
A:visited{	color:<%=visitedColor%>; 
			text-decoration:underline;
			font-family:<%=fontFamily%>;}
A:hover {	color:<%=hoverColor%>; 
			text-decoration:none;
			font-family:<%=fontFamily%>;}
A:active {	color:<%=activeColor%>; 
			text-decoration:none;
			font-family:<%=fontFamily%>;}
BODY { 	background-color: <%=bgColor%>; 
		color: <%=textColor%>;
		font-family:<%=fontFamily%>;}
-->
</style>

<jsp:include page="inc_google_analytics.jsp" />
</head>
<body>

<!-- Start Page Header (top table) -->
<table cellpadding=0 cellspacing=0 border=0 width=100%>
    <tr valign=top>
	<td align=left valign=top>

<%	
//Connection and Operations on database
String dbname = "ngumbi";
String dbuser = "ngumbi_db_user";
String dbpass = "ngumbi_db_pass";
Driver driver = null;
String dbURL = "jdbc:mysql://localhost:3306/"+dbname+"?user=";
Connection conn = null;

Statement stat2 = null;
Statement stat3 = null;
ResultSet rs = null;
ResultSet rsuserdata = null;
			
String linksQuery = ""
        + "SELECT ul.link_name AS link_name, ul.link_address AS link_address, ul.cat AS cat, ul.sub_cat_rank AS sub_cat_rank "
        + "FROM user_links ul LEFT JOIN users u ON (ul.user_id = u.user_id) "
        + "WHERE u.username = '"+user+"' "
        + "ORDER BY cat_rank, sub_cat_rank, link_rank";

String userDataQuery = "SELECT searchOption, searchUrl, searchLang FROM users WHERE username = '"+user+"'";

		
//execute SQL operations for username input check
try {
    driver = (Driver) Class.forName("com.mysql.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection(dbURL, dbuser, dbpass);
    stat3 = conn.createStatement();
    rsuserdata = stat3.executeQuery(userDataQuery);//gets matching user(s) already in table
} 
catch (Exception e) {
    out.print("Unable to make connection to production database");
    out.print(e);
    %>error here first try<%
}

//check if username exists
if (rsuserdata.next()){
	//it exists, continue with jumpstation code.
	
	//		**ADMIN UPDATE**	
	//update the last viewed value in users table
	//checks reporting turned on, then adds entry to history table for this view, while deleting oldest entry
	helperMethods.adminUpdate(user, "view");
	
	int linkCounter;
	int catCounter;
	String currCat = "";
	int currSubCatRank = 0;
	String lastCat = "";
	int searchFlag = 0;
        String searchUrl = "";
        String searchLang = "";
			
	//execute SQL queries
	try {
            stat2 = conn.createStatement();
            rs = stat2.executeQuery(linksQuery);
	}
	catch (Exception e) {
            %><center><font size=4 color=red>The username you have entered isn't a valid user</font><p>
            <a href="index.jsp"><font color=blue>Go back</font></a></center><p><br><br><br><br><br><br><br><br><br><%
            out.print("Unable to make connection to production database");
            out.print(e);
	}	

	
	%>
	<!-- Show current date and time -->
	<!--<%= new java.util.Date() %>	-->
			
	</td>
	<td valign=top style="text-align: center;">
	<%
	
	//Search check, flag is 
	//	0 - no search 
	// 	1 - ngumbi branded google search (default)
	//	2 - regular google search
	//	3 - ngumbi branded safe google search
	//	10 - yahoo search
	searchFlag = rsuserdata.getInt("searchOption");
        searchUrl = rsuserdata.getString("searchUrl");
        searchLang = rsuserdata.getString("searchLang");


	if (searchFlag == 0){
            //0 - no search 
	}
        //else if (searchFlag == 2){
            //2 - regular google search
            
        //}
        //else if (){
        //
        //}
	else if (searchFlag >= 1 && searchFlag <= 9){
            //1-9: we have some form of google search
            boolean useGoogleCse = false;
            String searchSuffix2 = "search";

            if (searchFlag == 1 || searchFlag == 3){
                //both search type 1 and 3 use adsense branded custom search engine
                searchSuffix2 = "cse";
                useGoogleCse = true;//google.com/cse, ngumbi branded
            }



            %>
            
            <!-- Search Google -->
            <form name="search_form" action="http://<%=searchUrl%>/<%=searchSuffix2%>" id="cse-search-box">
              <div>
                <a href="http://<%=searchUrl%>/" style="text-decoration: none;">
                    <img src="http://www.google.com/logos/Logo_40wht.gif" border="0" alt="Google" align="middle">
                </a>
                <%
                if (useGoogleCse){
                    //put in the adsense custom search partner code
                    %><input type="hidden" name="cx" value="partner-pub-8335750690638492:1547181858" /><%
                }

                if (searchFlag == 3){
                    //enable safe search strict here
                    %><input type="hidden" name="safe" value="active" /><%
                }
                %>
                <input type="hidden" name="ie" value="UTF-8" />
                <input type="hidden" name="hl" value="<%=searchLang%>">
                <input type="text" name="q" size="31" />
              </div>
            </form>
            <!-- end Search Google -->

            <!--set focus to the search form text box in javascript-->
            <script type="text/javascript"><!--
            document.search_form.q.focus();
            //--></script>

            <%
	}
	// end 1,2,3 google Search
	
	else if (searchFlag == 10){
            //10: yahoo search
            
            %>
            <!-- Yahoo! Search -->
            <form name="myform" method=get action="http://<%=searchUrl%>/search" style="padding: 5px; width:360px; text-align:center; margin-top: 15px; margin-bottom: 25px; margin-left: auto; margin-right: auto;">
                <a href="http://<%=searchUrl%>/"><img src="http://us.i1.yimg.com/us.yimg.com/i/us/search/ysan/ysanlogo.gif" alt="yahoo" align="absmiddle" border=0></a>
                <input type="text" name="p" size=25>&nbsp;
                <input type="hidden" name="fr" value="yscpb">&nbsp;
                <input type="submit" value="Search">
            </form>
            <!-- End Yahoo! Search -->

            <!--set focus to the search form text box in javascript-->
            <script type="text/javascript"><!--
            document.myform.p.focus();
            //--></script>

            <%
	}	
	%>
				
	</td>
	<td align=right valign=top>
	
	<% // The "Edit" link in top right, passes username so editor.jsp can require login.
	if (!logon.getSecure()){ //haven't edited before in this browser session
            %><a href="../editor.jsp?user=<%=user%>&state=1&fromstate=0">Edit</a><%
	}
	else { //they did edit before, skip login screen since it will authenticate already
            %><a href="../editor.jsp?user=<%=user%>&state=2&fromstate=0">Edit</a><%
	}
	
	
	%>
	</td>
	</tr>
	</table>
	<!-- End Start Page Header (top table) -->
	
	
	
	<!-- start main table -->
	<center>
	<table cellpadding="0" cellspacing="8" border="0"><%
	
	linkCounter = 0;
	catCounter = 0;
	
	//do the first link
	if(rs.next()){
		currCat = rs.getString("cat");	//have to get first table entry to assign tracking variables
		currSubCatRank = rs.getInt("sub_cat_rank"); // of current category and subcategory
		
		//check if first link is a category-less one
		if(currCat.equals("")){
			//first link doesn't have category
			%><!-- start table and print first link centered-->
			<tr><td valign=top colspan=2><center><font size= <%=fontSize%> >
			<a href="<%=rs.getString("link_address")%>"><%=rs.getString("link_name").replace('+',' ')%></a>&nbsp;&nbsp;<%
		}
	
		else {
			//first link does have category, print first category, then first link
			%><tr><td valign=top width="50%"><STRONG><%=currCat.replace('+',' ')%></STRONG><br>
			<font size= <%=fontSize%> ><a href="<%=rs.getString("link_address")%>"><%=rs.getString("link_name").replace('+',' ')%></a>&nbsp;&nbsp;<%
			catCounter++;
			lastCat = currCat;
		}
		
		linkCounter++;
	}
	
	// first link is completed, now loop through rest
	while (rs.next()) { 
		
		if ( !(currCat.equals(rs.getString("cat")))){ //we have a new category so indent accordingly
			currCat = rs.getString("cat");//set to new category
			currSubCatRank = rs.getInt("sub_cat_rank");//reset subcategory
			catCounter++;
			
			if (((catCounter%2) == 0) && !(lastCat.equals(""))){//we are still in the same row of big table, don't <tr> yet
				//also, have new category but last category wasn't null, so don't start new line under category-less pool
				%></font></td><td valign=top width="50%"><STRONG><%=currCat.replace('+',' ')%></STRONG><br><font size= <%=fontSize%> ><a href="<%=rs.getString("link_address")%>"><%=rs.getString("link_name").replace('+',' ')%></a>&nbsp;&nbsp;<%
			}
			else { // we jumped to next row of big table, do <tr>
				%></font></td></tr><tr><td valign=top><STRONG><%=currCat.replace('+',' ')%></STRONG><br><font size= <%=fontSize%> ><a href="<%=rs.getString("link_address")%>"><%=rs.getString("link_name").replace('+',' ')%></a>&nbsp;&nbsp;<%
				
				if (lastCat.equals("")){//we're on 1st new category since the category-less pool
					//do nothing, already accounted for
				}
			}
		}
		
		else{ //we are still in same category (or non-category)
			if ( currSubCatRank != rs.getInt("sub_cat_rank")){ //we are in a new subcategory, do <br>
				%><br><a href="<%=rs.getString("link_address")%>"><%=rs.getString("link_name").replace('+',' ')%></a>&nbsp;&nbsp;<%		
				currSubCatRank = rs.getInt("sub_cat_rank");//set subcategory	
			}
			else{//we are in same category and subcategory  
				%><a href="<%=rs.getString("link_address")%>"><%=rs.getString("link_name").replace('+',' ')%></a>&nbsp;&nbsp;<%
			}	
		}
		
		lastCat = currCat;
		linkCounter++;
	%>
	<% 	
	}//end while loop 	
	//by keeping this last bracket in separate java area, it keeps the html for the links from being all on the same line
	//when it was all on the same line, the table wasn't spacing properly in IE, it wouldn't shrink very far because
	//the links wouldn't spill over to the next line and the 2 columns weren't spacing 50%
		
	rs.close();
	%>
	
	</font>
	</td>
	</tr>
	</TABLE>
	</center>
	<!-- End main table -->
	

	
	<!-- list total links and categories -->
	<p style="text-align: center; font-size: .8em; padding-bottom: 20px;">
            Displaying <b><%=linkCounter%></b> links in <b><%=catCounter%></b> categories
            <br>
            <a href="../index.jsp">ngumbi</a>
        </p>
	
	
	<%

} //end if(rsuserdata.next())

	
else {
	%>
        <div class="main">
            <jsp:include page="inc_ngumbi_title_childlevel_unlinked.jsp" />
            <p>You've entered an invalid username (<%=user%>)</p>
            <p>Go to <a href="../index.jsp">ngumbi home</a></p>
        </div>
        <%
}	
rsuserdata.close();
conn.close();
%>
</BODY>
</html>

	