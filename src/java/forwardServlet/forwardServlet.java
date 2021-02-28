//this should be in the location $app-dir/WEB-INF/classes/userForwardServlet/forwardServlet.class


package forwardServlet;

import javax.servlet.*;
import javax.servlet.http.*;

public class forwardServlet extends HttpServlet {

    @Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) {
            try {

                String forward_to = "";
                String user = "";


                //getRequestURI() returns "/user/xxxxxxxxxx" as the request, or perhaps "/ngumbi/user/xxxxxxx" if testing in NetBeans
                //response.setContentType("text/html");
                //System.out.println(request.getRequestURI());

                request.setCharacterEncoding("UTF-8");
                String uri_path = request.getRequestURI();

                //get everything after /user/ first
                int begin_index1 = uri_path.indexOf("/user/") + 6;
                int end_index1 = uri_path.length();
                String uri_path_after_user = uri_path.substring(begin_index1, end_index1);

                //now should be left with only the user's name
                //if I add in edit here somehow as another special address thing, need to check more.
                user = uri_path_after_user.substring(0,uri_path_after_user.length());

                user = replaceBackslash(user);
                user = replaceQuote(user);

                user = user.replaceFirst("/devroot",""); //erases '/devroot' in case it's me in the devroot
                //out.print(user+" - - ");

                //translate the request listed above to "/user_page.jsp?user=someperson"
                forward_to = "/user_page.jsp?user="+user;
                RequestDispatcher dispatcher;

                dispatcher = request.getRequestDispatcher(forward_to);
                dispatcher.forward(request, response);

            }
            catch (Exception e) {
                    //e.printStackTrace();
            }
        }

    @Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) {

		try{



			//this is for when someone came from the html form on index.jsp
			//String user = request.getQueryString();

			String user = request.getParameter("user");


			//PrintWriter out = response.getWriter();
			//out.print(user);



			//user = user.replaceFirst("user=", ""); //erases all 'user=' the ? is already gone in querystring

			//out.print(user);


			/*RequestDispatcher dispatcher;

			//translate the request listed above to "/user_page.jsp?user=someperson"
			dispatcher = request.getRequestDispatcher("/user_page.jsp?user="+user);
			dispatcher.forward(request, response);*/

			response.sendRedirect(user);

		}
		catch (Exception e) {
			//e.printStackTrace();
		}
	}


	//check for single quote, replace ' with \' for mysql, and \\' to escape java so it's properly inserted to DB
	public static String replaceQuote (String input){
		//base case
		if (input == null)
			return input;
		else if (input.indexOf('\'') == -1)
			return input;

		//recursive case
		else {
			// (input.indexOf('\'') != -1){ //recursive case
			return input.substring(0, input.indexOf('\''))+"\\'"+replaceQuote(input.substring(input.indexOf('\'')+1, input.length()));
		}
	}
	//check for single quote, replace ' with \' for mysql, and \\' to escape java so it's properly inserted to DB
	public static String replaceBackslash (String input){
		//base case
		if (input == null)
			return input;
		else if (input.indexOf('\\') == -1)
			return input;

		//recursive case
		else {
			// (input.indexOf('\'') != -1){ //recursive case
			return input.substring(0, input.indexOf('\\'))+"\\\\"+replaceBackslash(input.substring(input.indexOf('\\')+1, input.length()));
		}
	}

}