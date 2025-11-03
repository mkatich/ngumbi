<%-- 
    Document   : user_page_include_top
    Created on : Dec 13, 2021, 12:16:48 PM
    Author     : Michael

    Description: Contains top search bar area of the user's page. This may
    actually not have a search function if the user chose that. This will 
    include or exclude the Edit link based on parameters.
    
--%>
<%@page import="UserPage.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userLogin" class="UserLogin.UserLogin" scope="session" />
<%
    
    //Gather user details including search options from the userPage 
    //session attribute
    UserPage userPage = (UserPage) session.getAttribute("userPage");
    User user = userPage.getUser();
    String username = user.getUsername();
    int searchOption = user.getSearchOption();
    String searchUrl = user.getSearchUrl();
    String searchLang = user.getSearchLang();
    
    //Get whether user used http or https to access this page, and in turn, choose
    //which scheme (aka protocol) for the top search URL
    String schemeForSearchUrl = "http";
    if (request.getScheme().equals("https")) {
        schemeForSearchUrl = "https";
    }
    
    //Get mode for displaying links - default is 0 and shows regular link
    String topDisplayModeStr = request.getParameter("topDisplayMode");
    int topDisplayMode = 0;
    if (topDisplayModeStr != null && topDisplayModeStr.matches("\\d+")){
        topDisplayMode = Integer.parseInt(topDisplayModeStr);
    }
    
    
%>
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
                        <form name="search_form" action="<%=schemeForSearchUrl%>://<%=searchUrl%>/<%=searchSuffix2%>" id="cse-search-box">
                          <div>
                            <a href="<%=schemeForSearchUrl%>://<%=searchUrl%>/" style="text-decoration: none;">
                                <img src="<%=schemeForSearchUrl%>://www.google.com/logos/Logo_40wht.gif" border="0" alt="Google" align="middle">
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
                        <form name="myform" method=get action="<%=schemeForSearchUrl%>://<%=searchUrl%>/search" style="padding: 5px; width:360px; text-align:center; margin-top: 15px; margin-bottom: 25px; margin-left: auto; margin-right: auto;">
                            <a href="<%=schemeForSearchUrl%>://<%=searchUrl%>/"><img src="<%=schemeForSearchUrl%>://us.i1.yimg.com/us.yimg.com/i/us/search/ysan/ysanlogo.gif" alt="yahoo" align="absmiddle" border=0></a>
                            <input type="text" name="p" size="25">&nbsp;
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
                <%
                
                //display the Edit link only if topDisplayMode is 0 (default)
                if (topDisplayMode == 0){
                    %>
                    <td align="right" valign="top">
                        <%

                        //Show the "Edit" link in top right, passes username. If user
                        //is secure already, skip to state 2. Otherwise go to state 1
                        //for login.

                        if (userLogin.isSecure()){
                            //user did edit before and secure, skip login screen 
                            %><a href="../editor.jsp?user=<%=username%>&state=2&fromstate=0">Edit</a><%
                        }
                        else {
                            //haven't edited yet in this browser session, not secure
                            %><a href="../editor.jsp?user=<%=username%>&state=1&fromstate=0">Edit</a><%
                        }

                        %>
                    </td>
                    <%
                }
                else if (topDisplayMode == 1){
                    //do not display Edit link since we are likely already editing
                }
                
                %>
            </tr>
        </table>
        <!-- End Start Page Header (top table) -->