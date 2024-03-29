/*
 * UserPageDAO class serves as the data access object for the user's page. 
 * To do this, it pulls various data from the users and user_links tables. 
 */
package UserPage;

import DbConnectionPool.DbConnectionPool;
import MiscUtil.MiscUtil;
import helperMethodsBean.helperMethods;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
            
            //get user links - only perform this if we can find user
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
                    + "ORDER BY cat_rank ASC, sub_cat_rank ASC, link_rank ASC";
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
                    
                    boolean haveUserData = false;
                    if (rsUserData.next()){
                        haveUserData = true;
                        
                        int userId1 = rsUserData.getInt("user_id");
                        String pass = rsUserData.getString("pass");
                        int searchOption = rsUserData.getInt("searchOption");
                        String searchUrl = rsUserData.getString("searchUrl");
                        String searchLang = rsUserData.getString("searchLang");
                        Timestamp createdDate = rsUserData.getTimestamp("createdDate");
                        Timestamp lastViewed = rsUserData.getTimestamp("lastViewed");
                        Timestamp lastEdited = rsUserData.getTimestamp("lastEdited");
                        
                        user = new User(userId1, username, pass, searchOption, searchUrl, searchLang, createdDate, lastViewed, lastEdited);
                        
                        //		**ADMIN UPDATE**	
                        //update the last viewed value in users table
                        //checks reporting turned on, then adds entry to history table for this view, while deleting oldest entry
                        helperMethods.adminUpdate(username, "view");
                        
                        //get user links
                        psUserLinks = conn.prepareStatement(qUserLinks);
                        psUserLinks.setString(1, username);
                        rsUserLinks = psUserLinks.executeQuery();

                        //create UserLink list to hold results initially when iterating array component of UserPage
                        List<UserLink> userLinksList = new ArrayList<>();

                        //int countUserLinks = 0;
                        int countCats = 0;//used for counting categories
                        String lastCat = "";//used for counting categories
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

                            userLinksList.add(currUserLink);
                            //userLinks[countUserLinks] = currUserLink;

                            //countUserLinks++;
                            if (!(cat.equals(lastCat))){
                                countCats++;
                            }
                            lastCat = cat;
                        }

                        //create UserLink array component of UserPage - convert the list gathered above
                        UserLink[] userLinks = userLinksList.toArray(new UserLink[userLinksList.size()]);

                        //put the user data and user links array together into UserPage object
                        userPage = new UserPage(user, userLinks, countCats);
                        
                    }
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
    
    
    
    //addLink() attempts to add a new link for a user. This takes params from
    //the editor and does all needed input checks, figures out category.
    //Returns empty string if successful. If not successful, returns message String
    public static String addLink(UserPage userPage, String linkName, String linkAddress, String catRadio, String catUserSpecified) {
        String errorMsg = "";
        
        System.out.println("UserPageDAO.addLink() 1 - linkName: "+linkName+", linkAddress: "+linkAddress+", catRadio: "+catRadio+", catUserSpecified: "+catUserSpecified);
        
        
        //do some escaping first
        linkName = MiscUtil.prepTextInputValForDb(linkName);
        linkAddress = MiscUtil.prepTextInputValForDb(linkAddress);
        catRadio = MiscUtil.prepTextInputValForDb(catRadio);
        catUserSpecified = MiscUtil.prepTextInputValForDb(catUserSpecified);
        
        //check linkAddress and add http:// or www. as needed
        linkAddress = MiscUtil.addLinkAddressPrefixAsNeeded(linkAddress);
        
        //get category. Either user chose existing category radio button, or 
        //radio for specifying new category 
        String cat = catRadio;
        if (catRadio.equals("_user_specified_new_cat")){
            //user entered their own category, use that
            cat = catUserSpecified;
            
            //now check if this user specified category actually matches an existing
            //one. If it does, we'll just use that so we don't create a duplicate
            //category with a different id
            if (userPage.hasCat(cat)){
                //yes, it already has this category. Change catRadio to match
                //this so it's like the user just picked that category radio button
                //instead and code below this doesn't attempt to make new category
                catRadio = cat;
            }
        }
        
        
        System.out.println("UserPageDAO.addLink() 2 - cat: "+cat);
        
        //begin input checking
        //do some further validity checks of link name, address, category
        boolean inputCheckOk = true;
        if (linkName.equals("")){ 
            inputCheckOk = false; 
            errorMsg = "New link name is empty";
        }
        if (linkName.contains("\"")){ 
            inputCheckOk = false;
            errorMsg = "Please remove the quote from new link name";
        }
        if (linkAddress.equals("") || linkAddress.equals("null")){ 
            inputCheckOk = false; 
            errorMsg = "New link name is empty";
        }
        if (linkAddress.contains("\"")){ 
            inputCheckOk = false;
            errorMsg = "Please remove the quote from new link URL";
        }
        if (!MiscUtil.isValidURI(linkAddress)){ 
            inputCheckOk = false;
            errorMsg = "New link URL is invalid";
        }
        if (cat.equals("_user_specified_new_cat")){
            inputCheckOk = false;
            errorMsg = "New category is invalid";
        }
        if (cat.contains("\"")){ 
            inputCheckOk = false;
            errorMsg = "Please remove the quote from the new category";
        }
        if (!cat.equals("") && cat.substring(0,1).equals("~")){
            // ~ character is reserved for Admin stuff
            inputCheckOk = false;
            errorMsg = "New category is invalid";
        } 
        
        System.out.println("UserPageDAO.addLink() 3 - inputCheckOk: "+inputCheckOk+", errorMsg: "+errorMsg);
        
        
        if (inputCheckOk){


            //next we'll compare number of user links with admin max links and 
            //we need to make database connection so start that
            boolean numLinksOk = true;
            String queryAdminMaxLinks = "SELECT maxLinks FROM admin";
            PreparedStatement psAdminMaxLinks = null;
            ResultSet rsAdminMaxLinks = null;
            int adminMaxLinks = -1;
            
            //init update stuff for if we do add the link
            String updateAddLink = "";
            PreparedStatement psAddLink = null;

            Connection conn = null;
            try {
                conn = DbConnectionPool.getConnection();//fetch a connection
                if (conn != null){
                    //perform queries/updates

                    //check on admin max links to compare with user's num links
                    psAdminMaxLinks = conn.prepareStatement(queryAdminMaxLinks);
                    rsAdminMaxLinks = psAdminMaxLinks.executeQuery();
                    if (rsAdminMaxLinks.next()){
                        adminMaxLinks = rsAdminMaxLinks.getInt("maxLinks");
                        if (userPage.getNumLinks() >= adminMaxLinks){
                            numLinksOk = false;
                            errorMsg = "Your page is at max links. Please remove one before adding.";
                        }
                    }
                    
                    
        System.out.println("UserPageDAO.addLink() 4 - adminMaxLinks: "+adminMaxLinks+", userPage.getNumLinks(): "+userPage.getNumLinks()+", numLinksOk: "+numLinksOk);
                    
                    if (numLinksOk){
                        
                        //continue with link adding!
                        
                        //we need to find a couple rank values before adding.
                        //these are used for positioning.
                        int catRank = 1;
                        int subCatRank = 1;//this one is no longer used in new editor, always will be 1
                        int linkRank = 1;
                        
                        //figure out catRank. If this is a newly entered category, 
                        //we need to find what the current max is. If this is 
                        //already existing category, use the catRank from that.
                        if (catRadio.equals("_user_specified_new_cat")){
                            //it's a newly entered category. link rank will be 1
                            
                            //get highest catRank (last category value) and we'll
                            //add one after that
                            int lastCatRank = userPage.getMaxCatRank();
                            catRank = lastCatRank + 1;
                            
                            /*String queryLastCatRank = "SELECT MAX(cat_rank) AS max_cat_rank FROM user_links where user_id = ? ";
                            PreparedStatement psLastCatRank = null;
                            ResultSet rsLastCatRank = null;
                            int lastCatRank = -1;
                            
                            psLastCatRank = conn.prepareStatement(queryLastCatRank);
                            psLastCatRank.setInt(1, userPage.getUserId());
                            rsLastCatRank = psLastCatRank.executeQuery();
                            if (rsLastCatRank.next()){
                                lastCatRank = rsLastCatRank.getInt("max_cat_rank");
                                catRank = lastCatRank + 1;
                            }*/
                            
                        }
                        else {
                            //it's an existing category (including blank category)
                            
                            //we will get info from the last link in this 
                            //user's matching category so that we can just use 
                            //that and add 1 to the linkRank for the new one
                            UserLink lastLinkInCat = userPage.getLastLinkInCategory(cat);
                            catRank = lastLinkInCat.getCatRank();
                            linkRank = lastLinkInCat.getLinkRank() + 1;
                            
                            /*
                            String queryLastLinkGivenCat = ""
                                    + "SELECT "
                                    + "cat, cat_rank, sub_cat_rank, link_rank "
                                    + "FROM user_links "
                                    + "WHERE "
                                    + "user_id = ? "
                                    + "AND cat = ? "
                                    + "ORDER BY link_rank DESC"
                                    + "";
                            */
                        }
                        
                        
        System.out.println("UserPageDAO.addLink() 5 - catRank: "+catRank+", linkRank: "+linkRank);
                        
                        //now we have the details of the link to add. add it.
                        updateAddLink = ""
                                + "INSERT INTO user_links "
                                + "(user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank) "
                                + "VALUES "
                                + "(?, ?, ?, ?, ?, ?, ?)";
                        
                        //String addLink = "INSERT INTO user_links (user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank) 
                        //VALUES ("+user_id+", '"+linknamenew+"','"+linkurlnew+"','"+catnew+"',"+catrankInt+","+subcatrankInt+","+linkrankInt+")";
                        
			psAddLink = conn.prepareStatement(updateAddLink);
			psAddLink.setInt(1, userPage.getUserId());
			psAddLink.setString(2, linkName);
			psAddLink.setString(3, linkAddress);
			psAddLink.setString(4, cat);
			psAddLink.setInt(5, catRank);
			psAddLink.setInt(6, subCatRank);
			psAddLink.setInt(7, linkRank);
        System.out.println("UserPageDAO.addLink() 6 - updateAddLink: "+psAddLink.toString());
			psAddLink.executeUpdate();
                        
                        //		**ADMIN UPDATE**
                        helperMethods.adminUpdate(userPage.getUsername(), "edit Add");
                        
                    }
                    
                }
            }
            catch (SQLException e) {
                DbConnectionPool.outputException(e, "UserPageDAO.addLink()", 
                        new String[]{"queryAdminMaxLinks", queryAdminMaxLinks, 
                            "updateAddLink", updateAddLink}
                        );
                errorMsg = "Unknown error adding link";
            }
            finally {
                DbConnectionPool.closeResultSet(rsAdminMaxLinks);
                DbConnectionPool.closeStatement(psAdminMaxLinks);
                DbConnectionPool.closeStatement(psAddLink);
                DbConnectionPool.closeConnection(conn);
            }
            
        }
        
        return errorMsg;
    }
    
    
    
    
    
}
