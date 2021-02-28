<%-- 
    Document   : new2
    Created on : Feb 14, 2011, 12:52:59 AM
    Author     : Michael
--%>

<%
/*********************************************************************
*	File: new2.jsp
*	Description: User came from new1.jsp, creating new account and
*       page.
*********************************************************************/
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//get the passed arguments
String loadDataName = request.getParameter("loadDataName");

%>
<html>
<head>
<title>New ngumbi Page</title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<link rel="stylesheet" type="text/css" href="style.css">
<style type="text/css">
<!--

-->
</style>
<script type="text/javascript"><!--
function changeColor(){
    //var searchOption = document.getElementById('searchOption').value;
    var searchOption = 0

    for (var i=0; i < document.createlogin.searchOption.length; i++){
        if (document.createlogin.searchOption[i].checked)
            searchOption = document.createlogin.searchOption[i].value;
    }

    if (searchOption == 0){
            document.getElementById("rowNoSearch").style.backgroundColor ='ffffcc';
            document.getElementById("rowGoogle").style.backgroundColor='ffffff';
            document.getElementById("rowYahoo").style.backgroundColor='ffffff';
    }
    else if (searchOption >= 1 && searchOption <= 9){
            document.getElementById("rowNoSearch").style.backgroundColor='ffffff';
            document.getElementById("rowGoogle").style.backgroundColor='ffffcc';
            document.getElementById("rowYahoo").style.backgroundColor='ffffff';
    }
    else if (searchOption == 10){
            document.getElementById("rowNoSearch").style.backgroundColor='ffffff';
            document.getElementById("rowGoogle").style.backgroundColor='ffffff';
            document.getElementById("rowYahoo").style.backgroundColor='ffffcc';
    }
}
//--></script>
<jsp:include page="inc_google_analytics.jsp" />
</head>
<body onLoad="changeColor();">


    <div class="main">

        <jsp:include page="inc_ngumbi_title_unlinked.jsp" />


        <form name="createlogin" method="post" action="new3.jsp">

            <p>
                1. Please create your username and password below.
                Spaces are not allowed, use _ instead.
            </p>
            <p>
                username: <input type=text name="user" size=18 maxlength=30 value="">
                <span style="font-size: .8em;">(your page will be at ngumbi.com/users/&lt;username&gt;)</span>
                <br>
                password: <input type=password name="pass" size=18 maxlength=30 value="">
                <br>
                confirm password: <input type=password name="cpass" size=18 maxlength=30 value="">
            </p>
            <p>
                2. Choose your options for a search at the top of your page:
            </p>

            <table class="optionsnew">
                <tr id="rowGoogle">
                    <td>
                        <input type=radio name="searchOption" id="searchOptRadio1" value="1" checked onClick="changeColor()">
                        <label for="searchOptRadio1">Google search <span style="font-size: .7em">(n)</span></label><br>

                        <input type=radio name="searchOption" id="searchOptRadio2" value="2" onClick="changeColor()">
                        <label for="searchOptRadio2">Google search</label><br>

                        <input type=radio name="searchOption" id="searchOptRadio3" value="3" onClick="changeColor()">
                        <label for="searchOptRadio3">Google SafeSearch <span style="font-size: .7em">(n)</span></label><br>
                    </td>
                    <td valign=top>
                        Pick your Google
                        <select name="searchUrlGoogle">
                            <option value="www.google.com" selected>Default - www.google.com</option>
                            <option value="www.google.com.au">Australia - www.google.com.au</option><!-- Australia -->
                            <option value="www.google.be">België - www.google.be</option><!-- Belgium -->
                            <option value="www.google.com.br">Brasil - www.google.com.br</option><!-- Brazil -->
                            <option value="www.google.ca">Canada - www.google.ca</option><!-- Canada -->
                            <option value="www.google.cn">中国 - www.google.cn</option><!-- China -->
                            <option value="www.google.com.hk">香港 - www.google.com.hk</option><!-- China, Hong Kong (not censored) -->
                            <option value="www.google.com.tw">台灣 - www.google.com.tw</option><!-- Taiwan -->
                            <option value="www.google.dk">Danmark - www.google.dk</option><!-- Denmark -->
                            <option value="www.google.de">Deutschland - www.google.de</option><!-- Germany -->
                            <option value="www.google.fr">France - www.google.fr</option><!-- France -->
                            <option value="www.google.gr">Ελλάς - www.google.gr</option><!-- Greece -->
                            <option value="www.google.es">España - www.google.es</option><!-- Spain -->
                            <option value="www.google.ie">Ireland - www.google.ie</option><!-- Ireland -->
                            <option value="www.google.co.id">Indonesia - www.google.co.id</option><!-- Indonesia -->
                            <option value="www.google.co.in">India - www.google.co.in</option><!-- India -->
                            <option value="www.google.it">Italia - www.google.it</option><!-- Italy -->
                            <option value="www.google.co.kr">한국 - www.google.co.kr</option><!-- Korea (South) -->
                            <option value="www.google.lv">Latvija - www.google.lv</option><!-- Latvia -->
                            <option value="www.google.com.mx">México - www.google.com.mx</option><!-- Mexico -->
                            <option value="www.google.nl">Nederland - www.google.nl</option><!-- Netherlands -->
                            <option value="www.google.co.nz">New Zealand - www.google.co.nz</option><!-- New Zealand -->
                            <option value="www.google.com.pk">Pakistan - www.google.com.pk</option><!-- Pakistan -->
                            <option value="www.google.com.ph">Pilipinas - www.google.com.ph</option><!-- Philippines -->
                            <option value="www.google.ru">Россия - www.google.ru</option><!-- Russia -->
                            <option value="www.google.fi">Suomi - www.google.fi</option><!-- Finland -->
                            <option value="www.google.se">Sverige - www.google.se</option><!-- Sweden -->
                            <option value="www.google.com.tr">Türkiye - www.google.com.tr</option><!-- Turkey -->
                            <option value="www.google.co.uk">UK - www.google.co.uk</option><!-- UK -->
                            <option value="www.google.com">USA - www.google.com</option><!-- USA -->
                        </select>
                        <br>
                        or type custom URL
                        <input type=text name="customSearchUrlGoogle" size=15 maxlength=45 value="">

                        <div style="font-size: .8em; text-align: right;">(examples:&nbsp;&nbsp;google.ie&nbsp;&nbsp;google.co.kr)</div>
                    </td>
                    <td valign=top>
                        Language
                        <br>
                        <select name="searchLangGoogle">
                            <option value="ar">العربية</option><!-- Arabic -->
                            <option value="da">dansk</option><!-- Danish -->
                            <option value="de">Deutsch</option><!-- German -->
                            <option value="el">Ελληνικά</option><!-- Greek -->
                            <option value="en" selected >English</option><!-- English -->
                            <option value="es">español</option><!-- Spanish -->
                            <option value="tl">Filipino</option><!-- Filipino -->
                            <option value="fr">Français</option><!-- French -->
                            <option value="iw">עברית</option><!-- Hebrew -->
                            <option value="hi">हिंदी</option><!-- Hindi -->
                            <option value="lv">Latviešu</option><!-- Latvian -->
                            <option value="nl">Nederlands</option><!-- Dutch -->
                            <option value="ja">日本語</option><!-- Japanese -->
                            <option value="pt-BR">Português (Br)</option><!-- Portuguese (Brazil) -->
                            <option value="pt-PT">Português (Pt)</option><!-- Portuguese (Portugal) -->
                            <option value="ru">Россию</option><!-- Russian -->
                            <option value="fi">suomi</option><!-- Finnish -->
                            <option value="sv">Svenska</option><!-- Swedish -->
                            <option value="th">ภาษาไทย</option><!-- Thai -->
                            <option value="tr">Türk</option><!-- Turkish -->
                            <option value="ur">اردو</option><!-- Urdu (for Pakistan) -->
                            <option value="zh-CN">简体中文</option><!-- Chinese (simplified) -->
                            <option value="zh-TW">繁體中文</option><!-- Chinese (traditional) -->
                            <option value="xx-piglatin">Pig Latin</option><!-- Pig Latin -->
                        </select>
                    </td>
                </tr>

                <tr id="rowYahoo">
                    <td>
                        <input type=radio name="searchOption" id="searchOptRadio10" value="10" onClick="changeColor()"><label for="searchOptRadio10">Yahoo! search</label>
                    </td>
                    <td valign=top colspan="2">
                        Pick your Yahoo!
                        <select name="searchUrlYahoo">
                            <option value="search.yahoo.com" selected>Default - search.yahoo.com</option>
                            <option value="au.search.yahoo.com">Australia - au.search.yahoo.com</option><!-- Australia -->
                            <option value="br.search.yahoo.com">Brasil - br.search.yahoo.com</option><!-- Brazil -->
                            <option value="ca.search.yahoo.com">Canada - ca.search.yahoo.com</option><!-- Canada -->
                            <option value="dk.search.yahoo.com">Danmark - dk.search.yahoo.com</option><!-- Denmark -->
                            <option value="de.search.yahoo.com">Deutschland - de.search.yahoo.com</option><!-- Germany -->
                            <option value="gr.search.yahoo.com">Ελλάς - gr.search.yahoo.com</option><!-- Greece -->
                            <option value="es.search.yahoo.com">España - es.search.yahoo.com</option><!-- Spain -->
                            <option value="fr.search.yahoo.com">France - fr.search.yahoo.com</option><!-- France -->
                            <option value="one.cn.yahoo.com">中国 - one.cn.yahoo.com</option><!-- China -->
                            <option value="hk.search.yahoo.com">香港 - hk.search.yahoo.com</option><!-- China -->
                            <option value="tw.search.yahoo.com">中華民國 - tw.search.yahoo.com</option><!-- China (Taiwan) -->
                            <option value="in.search.yahoo.com">India - in.search.yahoo.com</option><!-- India -->
                            <option value="id.search.yahoo.com">Indonesia - id.search.yahoo.com</option><!-- Indonesia -->
                            <option value="it.search.yahoo.com">Italia - it.search.yahoo.com</option><!-- Italy -->
                            <option value="kr.search.yahoo.com">한국 - kr.search.yahoo.com</option><!-- Korea (South) -->
                            <option value="mx.search.yahoo.com">México - mx.search.yahoo.com</option><!-- Mexico -->
                            <option value="nl.search.yahoo.com">Nederland - nl.search.yahoo.com</option><!-- Netherlands -->
                            <option value="nz.search.yahoo.com">New Zealand - nz.search.yahoo.com</option><!-- New Zealand -->
                            <option value="ph.search.yahoo.com">Pilipinas - ph.search.yahoo.com</option><!-- Philippines -->
                            <option value="ru.search.yahoo.com">Россия - ru.search.yahoo.com</option><!-- Russia -->
                            <option value="ch.search.yahoo.com">Schweiz - ch.search.yahoo.com</option><!-- Switzerland (Confederation of Helvetia) -->
                            <option value="fi.search.yahoo.com">Suomi - fi.search.yahoo.com</option><!-- Finland -->
                            <option value="sv.search.yahoo.com">Sverige - sv.search.yahoo.com</option><!-- Sweden -->
                            <option value="th.search.yahoo.com">ประเทศไทย - th.search.yahoo.com</option><!-- Thailand -->
                            <option value="tr.search.yahoo.com">Türkiye - tr.search.yahoo.com</option><!-- Turkey -->
                            <option value="uk.search.yahoo.com">UK & Ireland - uk.search.yahoo.com</option><!-- United Kingdom -->
                            <option value="us.search.yahoo.com">USA - us.search.yahoo.com</option><!-- Canada -->
                            <option value="asia.search.yahoo.com">Asia - asia.search.yahoo.com</option><!-- Asia -->
                        </select>
                        <br>
                        or type custom URL
                        <input type=text name="customSearchUrlYahoo" size=15 maxlength=45 value="">

                        <div style="font-size: .8em; ">(example:&nbsp;&nbsp;uk.search.yahoo.com)</div>
                    </td>
                </tr>

                <tr id="rowNoSearch">
                    <td colspan="3">
                        <input type=radio name="searchOptionYahoo" id="searchOptRadio0" value="0" onClick="changeColor()"><label for="searchOptRadio0">No search</label>
                    </td>
                </tr>
            </table>


            <p style="text-align: center; padding-bottom: 15px;">
                <input type="submit" value="Submit">
            </p>

            <input type=hidden name="loadDataName" value="<%=loadDataName%>" >
            <input type=hidden name="searchLangYahoo" value="" >
        </form>

	<!--set focus in javascript-->
	<script type="text/javascript"><!--
            document.createlogin.user.focus();
	//--></script>

	<p style="font-size: .8em">
            * Search choices marked with (n) identify searches that are branded with
            a small Ngumbi logo on the results page.  It is still the usual Google search with just a few
            small differences, and when you choose one of these choices it helps sponsor this website. It's
            highly recommended :)
        </p>
	<p>
            <a href="index.jsp">Cancel</a>
        </p>


    </div>



</body>
</html>