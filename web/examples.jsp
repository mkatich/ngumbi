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
        	<h1>examples</h1>
        </div>
        
        <div class="columns">
	        
	        <div class="col_left">

                        <jsp:include page="left_menu.jsp" />
	      			      		
			</div>
			
			<div class="col_middle_right">
			<table><tr><td valign=top>
				<!-- do not put p tag on first entry, add it for the others -->
				Here are just a few ways you can organize your page.  You can stay 
				simple with five links, or have over a hundred in a nice layout.
				<table>
					<tr>
						<th colspan=2><h1>Example 1</h1></th>
					</tr>
					<tr>
						<td><a href="user/example1"><img src="images/example1.gif" width=200 height=187 alt="example 1 thumbnail" border="0"></a></td>
						<td>Example 1 is just a simple row of links under the search, with no categories.</td>
					</tr>
					<tr>
						<th colspan=2><h1>Example 2</h1></th>
					</tr>
					<tr>
						<td><a href="user/example2"><img src="images/example2.gif" width=200 height=187 alt="example 2 thumbnail" border="0"></a></td>
						<td>Example 2 is like Example 1, but the links are all in a new row so it forms a single column.</td>
					</tr>
					<tr>
						<th colspan=2><h1>Example 3</h1></th>
					</tr>
					<tr>
						<td><a href="user/example3"><img src="images/example3.gif" width=200 height=187 alt="example 3 thumbnail" border="0"></a></td>
						<td>Example 3 has many links arranged into categories.  It shows a large and diverse homepage.</td>
					</tr>
					<tr>
						<th colspan=2><h1>Example 4</h1></th>
					</tr>
					<tr>
						<td><a href="user/example4"><img src="images/example4.gif" width=200 height=187 alt="example 4 thumbnail" border="0"></a></td>
						<td>Example 4 shows a homepage with many links and categories that were all added by making a new row, 
						which creates the two columns.</td>
					</tr>
				</table>	
				
				<h1>Sandbox</h1>
				If you just want to play around to see how it works, the
				user "sandbox" is made just for that.  The password is "pass".
				<a href="user/sandbox">Have at it</a>.
				<br>Warning: everyone can change it so it could get ugly :)</p>
				
				<p><a href="new1.jsp" class="bold_orange_link">Make yours now</a></p>
				
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