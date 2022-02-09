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
<jsp:useBean id="userLogin" class="UserLogin.UserLogin" scope="session" />
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

-->
</style>
<jsp:include page="inc_google_analytics.jsp" />
</head>
<body>
    <%
    

    //retrieve all info needed for user page from database
    UserPage userPage = UserPageDAO.getUserPage(usernameInput);
    
    //check if username exists
    if (userPage != null){
        
        User user = userPage.getUser();
        //String userPageHtml = userPage.getUserPageHtml();
        
        
        UserLink[] userLinks = userPage.getUserLinks();
        
        
        //set userPage as a session attribute so the include files can use it
        session.setAttribute("userPage", userPage);
        
        
        //pull user's search option details
        int searchOption = user.getSearchOption();
        String searchUrl = user.getSearchUrl();
        String searchLang = user.getSearchLang();
        
        
        //Show current date and time
        %>
        <!--<%= new java.util.Date() %>	-->
        
        <jsp:include page="user_page_include_top.jsp" />
        
        <jsp:include page="user_page_include_links.jsp" />
        
        <jsp:include page="user_page_include_bottom.jsp" />
        
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
