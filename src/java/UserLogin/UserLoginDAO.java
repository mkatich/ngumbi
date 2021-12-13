/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserLogin;

import DbConnectionPool.DbConnectionPool;
import java.sql.*;

/**
 *
 * @author Michael
 */
public class UserLoginDAO {
    
    
    public static UserLogin login(UserLogin userLogin) {
        
        if (userLogin.getUsername() == null){
            //username or password was not set, can't attempt login
            System.out.println("Error in UserLoginDAO.login() - username was not set, can't attempt login");
        }
        else if (userLogin.getPass() == null){
            //username or password was not set, can't attempt login
            System.out.println("Error in UserLoginDAO.login() - password was not set, can't attempt login");
        }
        else {
            
            String qLogin = ""
                    + "SELECT "
                    + "u.pass AS pass "
                    + "FROM users u "
                    + "WHERE u.username = ? ";
            PreparedStatement psLogin = null;
            ResultSet rsLogin = null;
            
            Connection conn = null;
            try {
                conn = DbConnectionPool.getConnection();//fetch a connection
                if (conn != null){
                    //perform queries/updates
                    psLogin = conn.prepareStatement(qLogin);
                    psLogin.setString(1, userLogin.getUsername());
                    rsLogin = psLogin.executeQuery();

                    //get saved user data
                    if (rsLogin.next()){
                        String tablePass = rsLogin.getString("pass");
                        
                        //check login! Here userEnteredPass is the non-hashed password the user entered
                        //and tablePass is the stored hashed password value of the user's password.
                        String userEnteredPass = userLogin.getPass();
                        
                        if (userEnteredPass.equals(tablePass)){
                            //good login
                            userLogin.setSecure();//officially logged in after this
                        }
                        else {
                            //bad login due to user/password
                            System.out.println("Error in UserLoginDAO.login() - bad login");
                        }
                    }
                    else {
                        //no results in query, user doesn't exist
                        System.out.println("Error in UserLoginDAO.login() - user doesn't exist");
                    }

                }
            }
            catch (SQLException e) {
                DbConnectionPool.outputException(e, "UserLoginDAO.login()", "qLogin", qLogin);
            }
            finally {
                DbConnectionPool.closeResultSet(rsLogin);
                DbConnectionPool.closeStatement(psLogin);
                DbConnectionPool.closeConnection(conn);
            }
            
        }
        
        
        return userLogin;
     }
     
}
