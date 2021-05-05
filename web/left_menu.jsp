<%-- 
    Document   : left_menu
    Created on : Feb 9, 2011, 9:49:56 AM
    Author     : Michael Katich <mike.katich@datarecovery.com>
--%>
<ul class="left_menu">
    <li><a href="index.jsp">home</a>
    <li><a href="faq.jsp">faq</a>
    <li><a href="examples.jsp">examples</a>
    <li><a href="why.jsp">why use it?</a>
</ul>

<div id="loadbox_outer">
    <div id="loadbox_middle">
        <div id="loadbox_inner">
            
            <form name="jump" method="post" action="user/" enctype="application/x-www-form-urlencoded">
                <input name="user" size="12" maxlength="30" style="margin-bottom: 4px;">
                <input type="submit" value="get my page">
            </form>
            
            <!--set focus in javascript-->
            <script type="text/javascript"><!--
            document.jump.user.focus();
            //--></script>
        </div>
    </div>
</div>