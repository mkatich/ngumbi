<%-- 
    Document   : user_page
    Created on : 
    Author     : Michael

    Description: Retrieves links and search option from MySQL database
        and displays links on webpage in organized way.
    
--%>
<%@page import="UserPage.*"%>
<%@page import="DbConnectionPool.DbConnectionPool"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="logon" scope="session" class="logonBean.logon" /> 
<jsp:useBean id="helperMethods" scope="page" class="helperMethodsBean.helperMethods" />
<%
//get the username which was passed as an argument ? thing
String usernameInput = request.getParameter("user");

String errorMsg = "";

//defaults, these are used when there is no parameter passed, it's white
String linkColor = "#0000cc";
String visitedColor = "#800080";
String hoverColor = "#800080";
String activeColor = "#ff0000";
String bgColor = "ffffff";
String textColor = "000000";

//String fontSize = "-1";
String fontFamily = "arial,sans-serif,helvetica";

//retrieve all info needed for user page from database
UserPage userPage = UserPageDAO.getUserPage(usernameInput);


%>
<html>
<head>
<title><%=usernameInput%> &#64; ngumbi.com</title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../style.css">
<style type="text/css">
<!--

a:link {
    color:<%=linkColor%>;
    text-decoration:underline;
    font-family:<%=fontFamily%>;
}
a:visited {
    color:<%=visitedColor%>;
    text-decoration:underline;
    font-family:<%=fontFamily%>;
}
a:hover {
    color:<%=hoverColor%>;
    text-decoration:none;
    font-family:<%=fontFamily%>;
}
a:active {
    color:<%=activeColor%>;
    text-decoration:none;
    font-family:<%=fontFamily%>;
}
body {
    background-color: <%=bgColor%>;
    color: <%=textColor%>;
    font-family:<%=fontFamily%>;
}
a.user_link {
    font-size: .8em;
}

-->
</style>
<jsp:include page="inc_google_analytics.jsp" />
</head>
<body>
    <%
    
    
    //check if username exists
    if (userPage != null){
        
        User user = userPage.getUser();
        UserLink[] userLinks = userPage.getUserLinks();
        
        //pull user's search option details
        int searchOption = user.getSearchOption();
        String searchUrl = user.getSearchUrl();
        String searchLang = user.getSearchLang();
        
        
        //Show current date and time
        %>
        <!--<%= new java.util.Date() %>	-->
        
        <!-- Start Page Header (top table) -->
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr valign="top">
                <td valign="top" style="text-align: center;">
                    <%
                    
                    //Search check, flag is 
                    //	0 - no search 
                    // 	1 - ngumbi branded google search (default)
                    //	2 - regular google search
                    //	3 - ngumbi branded safe google search
                    //	10 - yahoo search
                    if (searchOption == 0){
                        //0 - no search 
                    }
                    //else if (searchFlag == 2){
                        //2 - regular google search

                    //}
                    //else if (){
                    //
                    //}
                    else if (searchOption >= 1 && searchOption <= 9){
                        //1-9: we have some form of google search
                        boolean useGoogleCse = false;
                        String searchSuffix2 = "search";
                        
                        if (searchOption == 1 || searchOption == 3){
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

                            if (searchOption == 3){
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
                    }// end 1,2,3 google Search

                    else if (searchOption == 10){
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
                <td align="right" valign="top">

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
        <table cellpadding="0" cellspacing="8" border="0" style="margin-left: auto; margin-right: auto;"><%
            
            
            int linkCounter = 0;
            int catCounter = 0;
            String currCat = "";
            int currSubCatRank = 0;
            String currLinkAddr = "";
            String currLinkName = "";
            String lastCat = "";
            int lastSubCatRank = 0;
            
            //do the first link
            if (userLinks.length > 0){
                
                UserLink link = userLinks[linkCounter];
                
                currCat = link.getCat().replace('+',' ');//have to get first table entry to assign tracking variables
                currSubCatRank = link.getSubCatRank();//of current category and subcategory
                currLinkAddr = link.getLinkAddress();
                currLinkName = link.getLinkName().replace('+',' ');
                
                //check if first link is a category-less one
                if (currCat.equals("")){
                    //first link doesn't have category - make this one span across the whole 
                    //top of the page, not broken into two columns
                    %>
                    <!-- start table and print first link -->
                    <tr>
                        <td valign="top" colspan="2">
                            <a href="<%=currLinkAddr%>" class="user_link"><%=currLinkName%></a>&nbsp;&nbsp;<%
                }
                
                else {
                    //first link does have category, print first category, then first link
                    %>
                    <tr>
                        <td valign="top" width="50%">
                            <STRONG><%=currCat%></STRONG>
                            <br><a href="<%=currLinkAddr%>" class="user_link"><%=currLinkName%></a>&nbsp;&nbsp;<%
                    catCounter++;
                    lastCat = currCat;
                }
                
                lastSubCatRank = currSubCatRank;
                linkCounter++;
            }

            // first link is completed, now loop through rest
            for (int i = 1; i < userLinks.length; i++){
                
                UserLink link = userLinks[linkCounter];
                
                currCat = link.getCat().replace('+',' ');//have to get first table entry to assign tracking variables
                currSubCatRank = link.getSubCatRank();//of current category and subcategory
                currLinkAddr = link.getLinkAddress();
                currLinkName = link.getLinkName().replace('+',' ');
                
                if (!(currCat.equals(lastCat))){
                    //we have a new category so indent accordingly
                    catCounter++;
                    
                    if (((catCounter % 2) == 0) && !(lastCat.equals(""))){
                        //we are still in the same row of big table, don't <tr> yet
                        //also, have new category but last category wasn't null, so don't start new line under category-less pool
                        %>
                        </td>
                        <td valign="top" width="50%">
                            <strong><%=currCat%></strong>
                            <br><a href="<%=currLinkAddr%>" class="user_link"><%=currLinkName%></a>&nbsp;&nbsp;<%
                    }
                    else {
                        // we jumped to next row of big table, do <tr>
                        %>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" width="50%">
                            <strong><%=currCat%></strong>
                            <br><a href="<%=currLinkAddr%>" class="user_link"><%=currLinkName%></a>&nbsp;&nbsp;<%

                        if (lastCat.equals("")){
                            //we're on 1st new category since the category-less pool
                            //do nothing, already accounted for
                        }
                    }
                }

                else {
                    //we are still in same category (or non-category)
                    if (currSubCatRank != lastSubCatRank){
                        //we are in a new subcategory, do <br>
                        %>
                            <br><a href="<%=currLinkAddr%>" class="user_link"><%=currLinkName%></a>&nbsp;&nbsp;<%		
                    }
                    else{
                        //we are in same category and subcategory  
                        %>
                            <a href="<%=currLinkAddr%>" class="user_link"><%=currLinkName%></a>&nbsp;&nbsp;<%
                    }	
                }

                lastCat = currCat;
                lastSubCatRank = currSubCatRank;
                linkCounter++;
                
            }

            %>
                        </td>
                    </tr>
        </table>
        <!-- End main table -->
        
        
        <!-- list total links and categories -->
        <p style="text-align: center; font-size: .8em; padding-bottom: 20px;">
            Displaying <b><%=linkCounter%></b> links
            <%
            //display count of categories only if had any
            if (catCounter > 0){
                %> in <b><%=catCounter%></b> categories<%
            }    
            %>
            <br>
            <a href="../index.jsp">ngumbi</a>
        </p>
        
        
        <%

    }//end if userExists
    else {
        errorMsg = "You've entered an invalid username ("+usernameInput+")";
    }
    
    if (!errorMsg.equals("")){
        %>
        <div class="main">
            <jsp:include page="inc_ngumbi_title_childlevel_unlinked.jsp" />
            <p><%=errorMsg%></p>
            <p>Go to <a href="../index.jsp">ngumbi home</a></p>
        </div>
        <%
    }
    
    %>
</body>
</html>
