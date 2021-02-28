<%-- 
    Document   : new1
    Created on : Feb 13, 2011, 5:04:28 PM
    Author     : Michael
--%>

<%
/*********************************************************************
*	File: new1.jsp
*	Description: User came from the create new link on main page.
*       This is the editor used for creating a new account and page.
*********************************************************************/
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
<title>New ngumbi Page</title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<link rel="stylesheet" type="text/css" href="style.css">
<style type="text/css">
<!--
table.start_with_example td {
    padding: 5px 15px;
}
-->
</style>
<script type="text/javascript"><!--

//--></script>
<jsp:include page="inc_google_analytics.jsp" />
</head>
<body>


    <div class="main">

        <jsp:include page="inc_ngumbi_title_unlinked.jsp" />

        <p>
            To begin you have two options.  You can start from scratch or start with
            <br>one of the example homepages and edit the links from there.
        </p>

        <form name="new1" method="post" action="new2.jsp">

            <div style="padding-bottom: 30px;">
                <input type=submit name="loadDataName" value="Start from scratch">
            </div>

            <table class="start_with_example" >
                <tr>
                    <td style="vertical-align: top;">
                        <b>Preview example</b>
                        <br><span style="font-size: .8em; font-weight: normal;">(in new window)</span>
                    </td>
                    <td style="vertical-align: top;">
                        <b>Start with this</b>
                    </td>
                </tr>

                <!-- example1 row -->
                <tr>
                    <td valign=top>
                        <a target="blah" href="user/example1">example1</a>
                    </td>
                    <td align=center valign=bottom>
                        <input type=submit name="loadDataName" value="example1">
                    </td>
                </tr>

                <!-- example2 row -->
                <tr>
                    <td valign=top>
                        <a target="blah" href="user/example2">example2</a>
                    </td>
                    <td align=center valign=bottom>
                        <input type=submit name="loadDataName" value="example2">
                    </td>
                </tr>

                <!-- example3 row -->
                <tr>
                    <td valign=top>
                        <a target="blah" href="user/example3">example3</a>
                    </td>
                    <td align=center valign=bottom>
                        <input type=submit name="loadDataName" value="example3">
                    </td>
                </tr>

                <!-- example4 row -->
                <tr>
                    <td valign=top>
                        <a target="blah" href="user/example4">example4</a>
                    </td>
                    <td align=center valign=bottom>
                        <input type=submit name="loadDataName" value="example4">
                    </td>
                </tr>
            </table>

        </form>


	<p>
            <a href="index.jsp">Cancel</a>
        </p>

    </div>



</body>
</html>