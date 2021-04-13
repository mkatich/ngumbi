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
                <h2>
                    <a href="new1.jsp">Make your ngumbi homepage now!</a>
                </h2>
                <h3>
                    <a href="examples.jsp" style="font-weight: normal;">see examples</a>
                </h3>
            </div>

            <div class="columns">

                <div class="col_left">

                    <jsp:include page="left_menu.jsp" />

                </div>

                <div class="col_middle_right">
                    <table>
                        <tr>
                            <td valign=top>
                                <h1>What is it?</h1>
                                Ngumbi is a useful, convenient, easily customizable, fast, 
                                simple <b>homepage system</b> that doesn't get in your
                                way of finding what you want to see on the web, 
                                and you can access yours from any computer or smartphone!

                                <h1>What does it look like?</h1>
                                A homepage with this system is basically a page of your chosen links
                                organized how you like, with a search on top.  
                                Maybe you think that's boring, but you'll soon realize how much time you
                                save using it.  If you're an Internet user that regularly visits some
                                sites, you'll especially benefit.
                                <p>To see an Ngumbi page in action, check out the 
                                    <a href="examples.jsp" class="bold_orange_link">examples</a>.</p>
                                <p>If you're ready to start your own now, 
                                    <a href="new1.jsp" class="bold_orange_link">go here</a>.</p>
                            </td>

                            <!--<td align=right valign=top width=160 height=350 bgcolor="#FFFFFF">
                                    </td>-->
                        </tr>
                    </table>  
                </div>			

            </div>

        </div>

        <div class="bottom_footer">

            <p>
                Sponsored by:<br>
                <a href="http://www.datarecovery.com/"><img src="images/datarecoverycom_grayscale_157x34.png" alt="Datarecovery.com"></a>
            </p>

            <p>
                <a href="mailadmin.jsp">Contact the admin</a>
            </p>

        </div>

    </body>
</html>