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
            <h1>news</h1>
        </div>

        <div class="columns">

            <div class="col_left">

                <jsp:include page="left_menu.jsp" />

            </div>

            <div class="col_middle_right">
                <table>
                    <tr>
                        <td valign=top>

                            <!-- do not put p tag on first entry, add it for the others -->
                            <h1><a name="2008-05-19">2008-05-19 New Faster Host!</a></h1>
                            Ngumbi got even faster after moving to a new host today.
                            <br><a href="fast.jsp">Read more</a>
                            about how fast Ngumbi is :)

                            <h1><a name="2006-08-15">2006-08-15 Yahoo! search added</a></h1>
                            Yahoo search has been added to the choices for a search box
                            at the top of your Ngumbi home page making it the first non-Google
                            choice.  If you are creating yours for the first time, the choice is
                            easy to see when you start.  If you are an existing user, you can change
                            your search option within the Edit menu: More options.
                            <!-- <br><a href="asdfadsfadsf" class="small_green_link">Discuss in the forum</a> -->

                            <h1><a name="2006-07-14">2006-07-14 More languages supported</a></h1>
                            More languages and country domains have been added to the Google search
                            option so you can now use whichever Google search you like in whichever
                            language you like on your Ngumbi home page.  That way you can ensure you get
                            the search results most relevant to you in your language.  You
                            can use a Chinese Google interface to search with google.co.uk if you wish.
                            A Latvian guy from a forum at sciforums.com tested it for google.lv and Latvian
                            successfully.  I even added Pig Latin :)
                            <!-- <br><a href="asdfadsfadsf" class="small_green_link">Discuss in the forum</a> -->

                            <h1><a name="2006-05-11">2006-05-11 Ngumbi.com goes live</a></h1>
                            However, still only a few people besides me know of the site and use it.
                            It will stay that way
                            until I ensure I have a good host and add just a few more needed features.
                            I finally decided on the simple domain name of www.ngumbi.com after trying many
                            different ones.  There aren't many free domain names left.  See the <a href="faq.jsp">FAQ</a> to learn
                            what ngumbi is.
                            <!-- <br><a href="asdfadsfadsf" class="small_green_link">Discuss in the forum</a> -->


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