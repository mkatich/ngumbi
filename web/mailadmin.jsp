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
    
        <div class="title">
        	<span class="logo">
        		<a href="index.jsp"><span class="logo1">n</span><span class="logo2">gumbi</span><img src="images/logodot.gif" alt="dot on the i" border=0 width=23 height=27><span class="logo3">com</span></a>
        	</span>
        </div>
        
        <div class="under_title">
        	<h1>contact the admin</h1>
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
							You can send me a message at: <img src="images/admin_email.gif" alt="admin email address" border=0 width=172 height=15 style="vertical-align: middle;">
							
						</td>
						<td align=right valign=top width=160 height=350 bgcolor="#FFFFFF">
						</td>
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