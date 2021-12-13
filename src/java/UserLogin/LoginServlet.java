/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserLogin;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Michael
 */
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        
        String username = request.getParameter("login_username");
        String password = request.getParameter("login_password");
        String login_destination = request.getParameter("login_destination");
        if (login_destination == null || login_destination.equals("null"))
            login_destination = "";
        
        //System.out.println("DEBUG - at LoginServlet, attempting login, userID: "+userId+", password: "+password+", login_destination: ["+login_destination+"]");
        
        
        if (username == null || password == null){
            //parameter(s) sent is null. Can happen. But just send to index
            response.sendRedirect("index.jsp");
        }
        else {
            
            //set the user in a new UserLoginBean
            UserLogin user = new UserLogin();
            user.setUsername(username.toLowerCase());
            user.setPass(password);
            
            //attempt login
            user = UserLoginDAO.login(user);
            
            //check if we had a good login
            if (user.isSecure()){
                //good login
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);//UserLoginBean object can be accessed as user
                response.sendRedirect(login_destination);//logged-in page 
            }
            else {
                //bad login
                String login_focus_field = "login_password";
                String msg = "Login failed, please retry.";
                
                //log this failed login attempt
                //
                
                //build error output to web server log
                //System.out.println(MiscUtil.getCurrDateTime()+" INFO Failed login attempt. User: "+userId);

                //send user back to login screen (send: user used, any login_destination passed, new message to display, and login_focus_field to be set as password field)
                //use this method below rather than response.sendRedirect() to avoid params showing in URL
                
                
                //will send user to this URL with parameters (like password) appearing in URL
                //String url = "login_direct_or_retry2.jsp?user="+userID+"&login_destination="+login_destination+"&msg="+msg+"&login_focus_field="+login_focus_field;
                //response.sendRedirect(url);
                
                //will send user to this URL without it changing the URL (requires URL start with /)
                String url = "/login_direct_or_retry.jsp?login_user_id="+username+"&login_destination="+login_destination+"&msg="+msg+"&login_focus_field="+login_focus_field;
                //System.out.println("DEBUG - at LoginServlet, had bad login, login_destination: ["+login_destination+"]");
                RequestDispatcher dispatcher = request.getServletContext().getRequestDispatcher(url);
                dispatcher.forward(request, response);
                //return;
            }
            
            
        }
        
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description here";
    }// </editor-fold>

}
