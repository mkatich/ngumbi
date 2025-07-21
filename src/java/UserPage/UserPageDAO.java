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
    
    
    
    
    
    public static UserLink getUserLink(String userLinkId) {
        UserLink userLink = null;
        
        //get user link data
        String qUserLink = ""
                + "SELECT "
                + "user_link_id, "
                + "user_id, "
                + "link_name, "
                + "link_address, "
                + "cat, "
                + "cat_rank, "
                + "sub_cat_rank, "
                + "link_rank "
                + "FROM user_links "
                + "WHERE user_link_id = ? ";
        PreparedStatement psUserLink = null;
        ResultSet rsUserLink = null;

        Connection conn = null;
        try {
            conn = DbConnectionPool.getConnection();//fetch a connection
            if (conn != null){
                //perform queries

                //get user data (metadata, not links)
                psUserLink = conn.prepareStatement(qUserLink);
                psUserLink.setString(1, userLinkId);
                rsUserLink = psUserLink.executeQuery();

                boolean haveUserLinkData = false;
                if (rsUserLink.next()){
                    haveUserLinkData = true;
                    
                    int userId = rsUserLink.getInt("user_id");
                    String linkName = rsUserLink.getString("link_name");
                    String linkAddress = rsUserLink.getString("link_address");
                    String cat = rsUserLink.getString("cat");
                    int catRank = rsUserLink.getInt("cat_rank");
                    int subCatRank = rsUserLink.getInt("sub_cat_rank");
                    int linkRank = rsUserLink.getInt("link_rank");
                    
                    int userLinkIdInt = Integer.parseInt(userLinkId);

                    userLink = new UserLink(userLinkIdInt, userId, linkName, linkAddress, cat, catRank, subCatRank, linkRank);
                    
                }
            }
        }
        catch (SQLException e) {
            DbConnectionPool.outputException(e, "UserPageDAO.getUserLink()", 
                    new String[]{"qUserLink", qUserLink});
            //errorMsg = "There was an error retrieving your page.";
        }
        finally {
            DbConnectionPool.closeResultSet(rsUserLink);
            DbConnectionPool.closeStatement(psUserLink);
            DbConnectionPool.closeConnection(conn);
        }
        
        return userLink;
        
    }
    
    
    
    //addLink() attempts to add a new link for a user. This takes params from
    //the editor and does all needed input checks, figures out category.
    //Returns empty string if successful. If not successful, returns message String
    public static String addLink(UserPage userPage, String linkName, String linkAddress, String catRadio, String catUserSpecified) {
        String errorMsg = "";
        
        //System.out.println("UserPageDAO.addLink() 1 - linkName: "+linkName+", linkAddress: "+linkAddress+", catRadio: "+catRadio+", catUserSpecified: "+catUserSpecified);
        
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
        
        //System.out.println("UserPageDAO.addLink() 2 - cat: "+cat);
        
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
        
        //System.out.println("UserPageDAO.addLink() 3 - inputCheckOk: "+inputCheckOk+", errorMsg: "+errorMsg);
        
        if (inputCheckOk){

            //next we'll compare number of user links with admin max links and 
            //we need to make database connection so start that
            boolean numLinksOk = true;
            String queryAdminMaxLinks = "SELECT maxLinks FROM admin";
            PreparedStatement psAdminMaxLinks = null;
            ResultSet rsAdminMaxLinks = null;
            int adminMaxLinks = -1;
            
            //Init SQL update stuff
            String updateAddLink = ""
                    + "INSERT INTO user_links "
                    + "(user_id, link_name, link_address, cat, cat_rank, sub_cat_rank, link_rank) "
                    + "VALUES "
                    + "(?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psAddLink = null;

            Connection conn = null;
            try {
                conn = DbConnectionPool.getConnection();//fetch a connection
                if (conn != null){
                    //Perform queries/updates

                    //Check on admin max links to compare with user's num links
                    psAdminMaxLinks = conn.prepareStatement(queryAdminMaxLinks);
                    rsAdminMaxLinks = psAdminMaxLinks.executeQuery();
                    if (rsAdminMaxLinks.next()){
                        adminMaxLinks = rsAdminMaxLinks.getInt("maxLinks");
                        if (userPage.getNumLinks() >= adminMaxLinks){
                            numLinksOk = false;
                            errorMsg = "Your page is at max links. Please remove one before adding.";
                        }
                    }
                    
                    //System.out.println("UserPageDAO.addLink() 4 - adminMaxLinks: "+adminMaxLinks+", userPage.getNumLinks(): "+userPage.getNumLinks()+", numLinksOk: "+numLinksOk);
                    
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
                            
                        }
                        else {
                            //it's an existing category (including blank category)
                            
                            //we will get info from the last link in this 
                            //user's matching category so that we can just use 
                            //that and add 1 to the linkRank for the new one
                            UserLink lastLinkInCat = userPage.getLastLinkInCategory(cat);
                            catRank = lastLinkInCat.getCatRank();
                            linkRank = lastLinkInCat.getLinkRank() + 1;
                            
                        }
                        
                        //System.out.println("UserPageDAO.addLink() 5 - catRank: "+catRank+", linkRank: "+linkRank);
                        
			psAddLink = conn.prepareStatement(updateAddLink);
			psAddLink.setInt(1, userPage.getUserId());
			psAddLink.setString(2, linkName);
			psAddLink.setString(3, linkAddress);
			psAddLink.setString(4, cat);
			psAddLink.setInt(5, catRank);
			psAddLink.setInt(6, subCatRank);
			psAddLink.setInt(7, linkRank);
                        //System.out.println("UserPageDAO.addLink() 6 - updateAddLink: "+psAddLink.toString());
			psAddLink.executeUpdate();
                        
                        // **ADMIN UPDATE**
                        helperMethods.adminUpdate(userPage.getUsername(), "edit Add");
                        
                    }
                    
                }
            }
            catch (SQLException e) {
                DbConnectionPool.outputException(e, "UserPageDAO.addLink()", 
                        new String[]{
                            "queryAdminMaxLinks", queryAdminMaxLinks, 
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
    
    
    //editLink() attempts to edit an existing link for a user, adjusting 
    //either or both of the link name and link URL. This takes params from
    //the editor and does all needed input checks.
    //Returns empty string if successful. If not successful, returns message String
    public static String editLink(UserPage userPage, String selected_user_link_id, String linkName, String linkAddress) {
        String errorMsg = "";
        
        System.out.println("UserPageDAO.editLink() 1 - linkName: "+linkName+", linkAddress: "+linkAddress);
        
        //do some escaping first
        linkName = MiscUtil.prepTextInputValForDb(linkName);
        linkAddress = MiscUtil.prepTextInputValForDb(linkAddress);
        
        //check linkAddress and add http:// or www. as needed
        linkAddress = MiscUtil.addLinkAddressPrefixAsNeeded(linkAddress);
        
        System.out.println("UserPageDAO.editLink() 2 - linkName: "+linkName+", linkAddress: "+linkAddress);
        
        //begin input checking
        //do some further validity checks of link name, address
        boolean inputCheckOk = true;
        if (linkName.equals("")){ 
            inputCheckOk = false; 
            errorMsg = "New link name is empty.";
        }
        if (linkName.contains("\"")){ 
            inputCheckOk = false;
            errorMsg = "Please remove the quote from new link name.";
        }
        if (linkAddress.equals("") || linkAddress.equals("null")){ 
            inputCheckOk = false; 
            errorMsg = "New link name is empty.";
        }
        if (linkAddress.contains("\"")){ 
            inputCheckOk = false;
            errorMsg = "Please remove the quote from new link URL.";
        }
        if (!MiscUtil.isValidURI(linkAddress)){ 
            inputCheckOk = false;
            errorMsg = "New link URL is invalid.";
        }
        
        System.out.println("UserPageDAO.editLink() 3 - inputCheckOk: "+inputCheckOk+", errorMsg: "+errorMsg);
        
        if (inputCheckOk){
            
            //Init SQL update stuff
            String updateEditLink = ""
                    + "UPDATE user_links "
                    + "SET "
                    + "link_name = ?, "
                    + "link_address = ? "
                    + "WHERE user_link_id = ? ";
            PreparedStatement psEditLink = null;
            
            Connection conn = null;
            try {
                conn = DbConnectionPool.getConnection();//fetch a connection
                if (conn != null){
                    //perform queries/updates
                    
                    //System.out.println("UserPageDAO.addLink() 4 - adminMaxLinks: "+adminMaxLinks+", userPage.getNumLinks(): "+userPage.getNumLinks()+", numLinksOk: "+numLinksOk);
                    
                    psEditLink = conn.prepareStatement(updateEditLink);
                    psEditLink.setString(1, linkName);
                    psEditLink.setString(2, linkAddress);
                    psEditLink.setString(3, selected_user_link_id);
                    //System.out.println("UserPageDAO.addLink() 6 - updateAddLink: "+psAddLink.toString());
                    psEditLink.executeUpdate();

                    // **ADMIN UPDATE**
                    helperMethods.adminUpdate(userPage.getUsername(), "edit Edit");

                }
            }
            catch (SQLException e) {
                DbConnectionPool.outputException(e, "UserPageDAO.editLink()", 
                        new String[]{"updateEditLink", updateEditLink}
                        );
                errorMsg = "Unknown error editing link";
            }
            finally {
                DbConnectionPool.closeStatement(psEditLink);
                DbConnectionPool.closeConnection(conn);
            }
        }
        
        return errorMsg;
    }
    
    
    //deleteLink() attempts to delete an existing link for a user. When needed, 
    //it also does housekeeping related to renumbering link ranks, category 
    //ranks, and sub-category rank.
    //Returns empty string if successful. If not successful, returns message String
    public static String deleteLink(UserPage userPage, String selected_user_link_id) {
        String errorMsg = "";
        
        System.out.println("UserPageDAO.deleteLink() 1 - selected_user_link_id: "+selected_user_link_id);
        
        boolean deletedLinkWasLastInCat = false;
        boolean deletedLinkWasLastInSubCat = false;
        
        //Get full info on the link chosen for deletion
        UserLink linkToDelete = getUserLink(selected_user_link_id);
        
        if (linkToDelete != null){
            
            //Gather category rank and sub-category rank of the link to delete. 
            //We'll use those to check whether deleted link was the last of its
            //kind in the category or sub-category.
            int linkToDeleteCatRank = linkToDelete.getCatRank();
            int linkToDeleteSubCatRank = linkToDelete.getSubCatRank();
            
            
            //Init SQL update stuff
            
            //Main delete link update
            String updateDeleteLink = ""
                    + "DELETE FROM user_links "
                    + "WHERE user_link_id = ? ";
            PreparedStatement psDeleteLink = null;
            
            //Prep to update cat_rank for a link
            String updateCatRank = ""
                    + "UPDATE user_links "
                    + "SET cat_rank = ? "
                    + "WHERE "
                    + "user_id = ? "
                    + "AND user_link_id = ? ";
            PreparedStatement psUpdateCatRank = null;
            
            //Prep to update sub_cat_rank for a link
            String updateSubCatRank = ""
                    + "UPDATE user_links "
                    + "SET sub_cat_rank = ? "
                    + "WHERE "
                    + "user_id = ? "
                    + "AND user_link_id = ? ";
            PreparedStatement psUpdateSubCatRank = null;
            
            //Prep to update link_rank for a link
            String updateLinkRank = ""
                    + "UPDATE user_links "
                    + "SET link_rank = ? "
                    + "WHERE "
                    + "user_id = ? "
                    + "AND user_link_id = ? ";
            PreparedStatement psUpdateLinkRank = null;
            
            
            Connection conn = null;
            try {
                conn = DbConnectionPool.getConnection();//fetch a connection
                if (conn != null){
                    //perform queries/updates
                    
                    System.out.println("UserPageDAO.deleteLink() 2 - selected_user_link_id: "+selected_user_link_id+", linkToDeleteCatRank: "+linkToDeleteCatRank+", linkToDeleteSubCatRank: "+linkToDeleteSubCatRank);
                    
                    //Delete the link from database
                    psDeleteLink = conn.prepareStatement(updateDeleteLink);
                    psDeleteLink.setString(1, selected_user_link_id);
                    System.out.println("UserPageDAO.deleteLink() 3 - updateDeleteLink: "+psDeleteLink.toString());
                    psDeleteLink.executeUpdate();
                    
                    //Check userPage object for all links with same category as deleted link
                    UserLink[] allLinksSameCategory = userPage.getLinksInCategoryByRank(linkToDeleteCatRank);
                    if (allLinksSameCategory.length > 0){
                        UserLink firstLink = allLinksSameCategory[0];
                        if (allLinksSameCategory.length == 1 && firstLink.getUserLinkId() == Integer.parseInt(selected_user_link_id)){
                            //There was only 1 link in that category, and it's the one we just deleted from the database.
                            deletedLinkWasLastInCat = true;
                        }
                    }
                    
                    //Check userPage object for all links with same sub-category as deleted link
                    UserLink[] allLinksSameSubCategory = userPage.getLinksInSubCategoryByRank(linkToDeleteCatRank, linkToDeleteSubCatRank);
                    if (allLinksSameSubCategory.length > 0){
                        UserLink firstLink = allLinksSameSubCategory[0];
                        if (allLinksSameSubCategory.length == 1 && firstLink.getUserLinkId() == Integer.parseInt(selected_user_link_id)){
                            //There was only 1 link in that sub-category, and it's the one we just deleted from the database.
                            deletedLinkWasLastInSubCat = true;
                        }
                    }
                    
                    
                    //Now we do different renumbering depending on whether the deleted link was
                    //the last in the sub-category, category, or not any last.
                    //If last in category, renumber all the category ranks over all links.
                    //If last in sub-category (not last in category), renumber sub-category ranks over all links in the category.
                    //If wasn't last in category or sub-category, renumber link ranks over all links in the sub-category.
                    if (deletedLinkWasLastInCat){
                        //Need to renumber category ranks of all user links
                        
                        //Prep renumbering the category ranks for all links.
                        int currLinkCatRankOld = 1;//Will be catRank before any change
                        int catRankNew = 1;//Will be catRank to update to
                        
                        //To start, get catRank of the first link to fill into currLinkCatRankOld
                        UserLink[] allLinks = userPage.getUserLinks();
                        if (allLinks.length > 0){
                            currLinkCatRankOld = allLinks[0].getCatRank();
                        }
                        
                        //Now we loop through all links to update them
                        for (int i = 0; i < allLinks.length; i++){
                            
                            if (allLinks[i].getUserLinkId() == Integer.parseInt(selected_user_link_id)){
                                //Current link in this array is same as one deleted. Need to 
                                //completely disregard this one for renumbering.
                            }
                            else {
                                //This link in array is not the same as the deleted one. Continue.
                            
                                //Check if loop hit a link that changed categories
                                if (currLinkCatRankOld != allLinks[i].getCatRank()){
                                    //Loop is on a user link with a different category than previous. 
                                    //Increment counter, update comparison variable.
                                    catRankNew++;
                                    currLinkCatRankOld = allLinks[i].getCatRank();
                                }

                                //Get id for link we're on
                                int currUserLinkId = allLinks[i].getUserLinkId();

                                //Update the link to renumber the category
                                psUpdateCatRank = conn.prepareStatement(updateCatRank);
                                psUpdateCatRank.setInt(1, catRankNew);
                                psUpdateCatRank.setInt(2, userPage.getUserId());
                                psUpdateCatRank.setInt(3, currUserLinkId);
                                System.out.println("UserPageDAO.deleteLink() - updateCatRank: "+psUpdateCatRank.toString());
                                psUpdateCatRank.executeUpdate();
                                
                            }
                            
                        }
                        
                    }
                    else if (deletedLinkWasLastInSubCat){
                        //Need to renumber sub-category ranks for all links in same category
                        //as deleted link. Deleted link was the only one in the sub-category, but not only one in the category.
                        
                        //Prep renumbering of the category ranks.
                        int currLinkSubCatRankOld = 1;//Will be subCatRank before any change
                        int subCatRankNew = 1;//Will be subCatRank to update to
                        
                        //Already have all links in the same category as deleted link - allLinksSameCategory.
                        //Loop through them.
                        for (int i = 0; i < allLinksSameCategory.length; i++){
                            
                            if (allLinksSameCategory[i].getUserLinkId() == Integer.parseInt(selected_user_link_id)){
                                //Current link in this array is same as one deleted. Need to 
                                //completely disregard this one for renumbering.
                            }
                            else {
                                //This link in array is not the same as the deleted one. Continue.
                                
                                if (currLinkSubCatRankOld != allLinksSameCategory[i].getSubCatRank()){
                                    //Loop is on a user link with a different subCatRank than previous. 
                                    //Increment counter, update comparison variable.
                                    subCatRankNew++;
                                    currLinkSubCatRankOld = allLinksSameCategory[i].getSubCatRank();
                                }
                                
                                //Get id for link we're on
                                int currUserLinkId = allLinksSameCategory[i].getUserLinkId();
                            
                                //Update the link to renumber the category
                                psUpdateSubCatRank = conn.prepareStatement(updateSubCatRank);
                                psUpdateSubCatRank.setInt(1, subCatRankNew);
                                psUpdateSubCatRank.setInt(2, userPage.getUserId());
                                psUpdateSubCatRank.setInt(3, currUserLinkId);
                                System.out.println("UserPageDAO.deleteLink() - updateSubCatRank: "+psUpdateSubCatRank.toString());
                                psUpdateSubCatRank.executeUpdate();
                                
                            }
                            
                        }
                        
                    }
                    else {
                        //Need to renumber link ranks for all links in same category 
                        //and sub-category as deleted link. 
                        
                        //Prep renumbering of the link ranks.
                        int linkRankNew = 1;//Will be linkRank to update to
                        
                        //Already have all links in the same sub-category as deleted link - allLinksSameSubCategory.
                        //Loop through them.
                        for (int i = 0; i < allLinksSameSubCategory.length; i++){
                            
                            if (allLinksSameSubCategory[i].getUserLinkId() == Integer.parseInt(selected_user_link_id)){
                                //Current link in this array is same as one deleted. Need to 
                                //completely disregard this one for renumbering.
                            }
                            else {
                                
                                //Get id for link we're on
                                int currUserLinkId = allLinksSameSubCategory[i].getUserLinkId();
                            
                                //Update the link to renumber the category
                                psUpdateLinkRank = conn.prepareStatement(updateLinkRank);
                                psUpdateLinkRank.setInt(1, linkRankNew);
                                psUpdateLinkRank.setInt(2, userPage.getUserId());
                                psUpdateLinkRank.setInt(3, currUserLinkId);
                                System.out.println("UserPageDAO.deleteLink() - updateLinkRank: "+psUpdateLinkRank.toString());
                                psUpdateLinkRank.executeUpdate();
                                
                                linkRankNew++;
                                
                            }
                            
                        }
                        
                    }
                    
                    // **ADMIN UPDATE**
                    helperMethods.adminUpdate(userPage.getUsername(), "edit Delete");
                    
                }
            }
            catch (SQLException e) {
                DbConnectionPool.outputException(e, "UserPageDAO.deleteLink()", 
                        new String[]{
                            "updateDeleteLink", updateDeleteLink, 
                            "updateCatRank", updateCatRank, 
                            "updateSubCatRank", updateSubCatRank, 
                            "updateLinkRank", updateLinkRank}
                        );
                errorMsg = "Unknown error editing link";
            }
            finally {
                DbConnectionPool.closeStatement(psDeleteLink);
                        
                DbConnectionPool.closeStatement(psUpdateCatRank);
                
                DbConnectionPool.closeStatement(psUpdateSubCatRank);
                
                DbConnectionPool.closeStatement(psUpdateLinkRank);
                
                DbConnectionPool.closeConnection(conn);
            }
            
        }
        
        return errorMsg;
    }
    
    
    //renameCategory() attempts to rename a category for a user. Category names 
    //are stored as a column in the links table. So to rename a category, this
    //acts on all links for the user which have this category value.
    //it also does housekeeping related to renumbering link ranks, category 
    //ranks, and sub-category rank.
    //Returns empty string if successful. If not successful, returns message String
    public static String renameCategory(UserPage userPage, String renamecat_old, String renamecat_new) {
        String errorMsg = "";
        
        return errorMsg;
    }
    
    
}
