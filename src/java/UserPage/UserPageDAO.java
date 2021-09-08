/*
 * UserPageDAO class serves as the data access object for the user's page. 
 * To do this, it pulls various data from the users and user_links tables. 
 */
package UserPage;

import DbConnectionPool.DbConnectionPool;
import helperMethodsBean.helperMethods;
import java.sql.*;

/**
 *
 * @author Michael
 */
public class UserPageDAO {
    
    
    //getUserPage() retrieves both user info from users table and user's links
    //from user_links table and returns UserPage object with both of those
    //components. If user doesn't exist, returns null.
    public static UserPage getUserPage(String username) {
        
        UserPage userPage = null;
        
        if (username != null && username.length() > 0){
            
            //get user data (not user links)
            String qUserData = ""
                    + "SELECT "
                    + "user_id, "
                    + "username, "
                    + "pass, "
                    + "searchOption, "
                    + "searchUrl, "
                    + "searchLang, "
                    + "createdDate, "
                    + "lastViewed, "
                    + "lastEdited "
                    + "FROM users "
                    + "WHERE username = ? ";
            PreparedStatement psUserData = null;
            ResultSet rsUserData = null;
            
            //get user links
            String qUserLinks = ""
                    + "SELECT "
                    + "ul.user_link_id AS user_link_id, "
                    + "ul.user_id AS user_id, "
                    + "ul.link_name AS link_name, "
                    + "ul.link_address AS link_address, "
                    + "ul.cat AS cat, "
                    + "ul.cat_rank AS cat_rank, "
                    + "ul.sub_cat_rank AS sub_cat_rank, "
                    + "ul.link_rank AS link_rank "
                    + "FROM user_links ul LEFT JOIN users u ON (ul.user_id = u.user_id) "
                    + "WHERE u.username = ? "
                    + "ORDER BY cat_rank, sub_cat_rank, link_rank";
            PreparedStatement psUserLinks = null;
            ResultSet rsUserLinks = null;
            
            Connection conn = null;
            try {
                conn = DbConnectionPool.getConnection();//fetch a connection
                if (conn != null){
                    //perform queries
                    
                    //get user data (metadata, not links)
                    psUserData = conn.prepareStatement(qUserData);
                    psUserData.setString(1, username);
                    rsUserData = psUserData.executeQuery();
                    
                    //create User component of UserPage
                    User user = null;
                    
                    int userId1 = -1;
                    String pass = "";
                    int searchOption = -1;
                    String searchUrl = "";
                    String searchLang = "";
                    Timestamp createdDate = null;
                    Timestamp lastViewed = null;
                    Timestamp lastEdited = null;
                    if (rsUserData.next()){
                        userId1 = rsUserData.getInt("user_id");
                        pass = rsUserData.getString("pass");
                        searchOption = rsUserData.getInt("searchOption");
                        searchUrl = rsUserData.getString("searchUrl");
                        searchLang = rsUserData.getString("searchLang");
                        createdDate = rsUserData.getTimestamp("createdDate");
                        lastViewed = rsUserData.getTimestamp("lastViewed");
                        lastEdited = rsUserData.getTimestamp("lastEdited");
                        
                        user = new User(userId1, username, pass, searchOption, searchUrl, searchLang, createdDate, lastViewed, lastEdited);
                        
                        //		**ADMIN UPDATE**	
                        //update the last viewed value in users table
                        //checks reporting turned on, then adds entry to history table for this view, while deleting oldest entry
                        helperMethods.adminUpdate(username, "view");
                    }

                    //get user links
                    psUserLinks = conn.prepareStatement(qUserLinks);
                    psUserLinks.setString(1, username);
                    rsUserLinks = psUserLinks.executeQuery();

                    int countUserLinks = 0;
                    while (rsUserLinks.next()){
                        countUserLinks++;
                    }
                    rsUserLinks.beforeFirst();
                    
                    //create UserLink array component of UserPage
                    UserLink[] userLinks = new UserLink[countUserLinks];
                    
                    countUserLinks = 0;
                    while (rsUserLinks.next()){
                        int userLinkId = rsUserLinks.getInt("user_link_id");
                        int userId2 = rsUserLinks.getInt("user_id");
                        String linkName = rsUserLinks.getString("link_name");
                        String linkAddress = rsUserLinks.getString("link_address");
                        String cat = rsUserLinks.getString("cat");
                        int catRank = rsUserLinks.getInt("cat_rank");
                        int subCatRank = rsUserLinks.getInt("sub_cat_rank");
                        int linkRank = rsUserLinks.getInt("link_rank");
                        
                        UserLink currUserLink = new UserLink(userLinkId, userId2, linkName, linkAddress, cat, catRank, subCatRank, linkRank);
                        
                        userLinks[countUserLinks] = currUserLink;
                        
                        countUserLinks++;
                    }
                    
                    //put the user data and user links array together into UserPage object
                    userPage = new UserPage(user, userLinks);

                }
            }
            catch (SQLException e) {
                DbConnectionPool.outputException(e, "UserPageDAO.getUserPage()", 
                        new String[]{"qUserData", qUserData, "qUserLinks", qUserLinks});
                //errorMsg = "There was an error retrieving your page.";
            }
            finally {
                DbConnectionPool.closeResultSet(rsUserData);
                DbConnectionPool.closeStatement(psUserData);
                DbConnectionPool.closeResultSet(rsUserLinks);
                DbConnectionPool.closeStatement(psUserLinks);
                DbConnectionPool.closeConnection(conn);
            }
            
            
        }
        
        return userPage;
        
    }
    
}
