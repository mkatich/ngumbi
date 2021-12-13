<%-- 
    Document   : user_page_include_bottom
    Created on : Dec 13, 2021, 3:05:09 PM
    Author     : Michael
--%>
<%@page import="UserPage.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userLogin" class="UserLogin.UserLogin" scope="session" />
<%
    
    //gather user details including search options from the userPage 
    //session attribute
    UserPage userPage = (UserPage) session.getAttribute("userPage");
    
%>
        <!-- list total links and categories -->
        <p style="text-align: center; font-size: .8em; padding-bottom: 20px;">
            Displaying <b><%=userPage.getNumLinks()%></b> links
            <%
            //display count of categories only if had any
            if (userPage.getNumCats() > 0){
                %> in <b><%=userPage.getNumCats()%></b> categories<%
            }
            %>
            <br>
            <a href="../index.jsp">ngumbi</a>
        </p>