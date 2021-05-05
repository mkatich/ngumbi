<%-- 
    Document   : fast
    Created on : Mar 3, 2011, 4:23:53 PM
    Author     : Michael Katich <mike.katich@datarecovery.com>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>ngumbi.com</title>
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
    <link rel="stylesheet" type="text/css" href="style.css">
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    <jsp:include page="inc_google_analytics.jsp" />
</head>
<body>

    <div class="main">

        <jsp:include page="inc_ngumbi_title.jsp" />

        <div class="under_title">
            <h1>ngumbi is fast!</h1>
        </div>

        <div class="columns">

            <div class="col_left">

                <jsp:include page="left_menu.jsp" />

            </div>

            <div class="col_middle_right">
                <table>
                    <tr>
                        <td valign="top">

                            <p>
                                Not only is ngumbi a very light web site to load, it's on a
                                very quick web server as well.
                            </p>
                            <p>
                                I ran a speed test and got the following result:
                            </p>
                            <img src="images/speed_test.PNG" width="719" height="165" alt="speed test">

                            <p>
                                At least your Google search will only be just a few times slower than your Ngumbi page.
                            </p>
                        </td>

                        <!--<td align=right valign=top width=160 height=350 bgcolor="#FFFFFF">
                        </td>-->
                    </tr>
                </table>
            </div>

        </div>

    </div>

    <div class="bottom_footer">
        <a href="mailadmin.jsp">Contact the admin</a>
    </div>

</body>
</html>
