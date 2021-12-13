<%-- 
    Document   : user_page_include_links
    Created on : Dec 13, 2021, 2:24:57 PM
    Author     : Michael

    Description: Contains main body of user page with links. 
    Using parameters, can specify which way links are displayed - as normal 
    links, as non-linked text that looks the same as a link, or as a special
    link for the editor.
    
--%>
<%@page import="UserPage.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userLogin" class="UserLogin.UserLogin" scope="session" />
<%
    
    //gather user details including user links from the userPage 
    //session attribute
    UserPage userPage = (UserPage) session.getAttribute("userPage");
    User user = userPage.getUser();
    UserLink[] userLinks = userPage.getUserLinks();
    
    //get mode for displaying links - default is 0 and shows regular link
    String linkDisplayModeStr = request.getParameter("linkDisplayMode");
    int linkDisplayMode = 0;
    if (linkDisplayModeStr != null && linkDisplayModeStr.matches("\\d+")){
        linkDisplayMode = Integer.parseInt(linkDisplayModeStr);
    }
    
    
%>
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
            
            String currLinkHtml = "";
            
            //do the first link
            if (userLinks.length > 0){
                
                UserLink link = userLinks[linkCounter];
                
                currCat = link.getCat().replace('+',' ');//have to get first table entry to assign tracking variables
                currSubCatRank = link.getSubCatRank();//of current category and subcategory
                //currLinkAddr = link.getLinkAddress();
                //currLinkName = link.getLinkName().replace('+',' ');
                currLinkHtml = link.getDispHtml(linkDisplayMode);
                
                //check if first link is a category-less one
                if (currCat.equals("")){
                    //first link doesn't have category - make this one span across the whole 
                    //top of the page, not broken into two columns
                    %>
                    <!-- start table and print first link -->
                    <tr>
                        <td valign="top" colspan="2">
                            <%=currLinkHtml%>&nbsp;&nbsp;<%
                }
                
                else {
                    //first link does have category, print first category, then first link
                    %>
                    <tr>
                        <td valign="top" width="50%">
                            <strong><%=currCat%></strong>
                            <br><%=currLinkHtml%>&nbsp;&nbsp;<%
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
                //currLinkAddr = link.getLinkAddress();
                //currLinkName = link.getLinkName().replace('+',' ');
                currLinkHtml = link.getDispHtml(linkDisplayMode);
                
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
                            <br><%=currLinkHtml%>&nbsp;&nbsp;<%
                    }
                    else {
                        // we jumped to next row of big table, do <tr>
                        %>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" width="50%">
                            <strong><%=currCat%></strong>
                            <br><%=currLinkHtml%>&nbsp;&nbsp;<%

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
                            <br><%=currLinkHtml%>&nbsp;&nbsp;<%		
                    }
                    else{
                        //we are in same category and subcategory  
                        %>
                            <%=currLinkHtml%>&nbsp;&nbsp;<%
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
        