package helperMethodsBean;
import DbConnectionPool.DbConnectionPool;
import java.sql.*;

public class helperMethods {

    //		**ADMIN UPDATE**
    // this method is called when the actual edits to a user's table are made or a view occurs
    // it records the edit data as a new entry in the history table if recording is turned on
    // and also updates the lastEdited or lastViewed field of the users table for this user
    public void adminUpdate(String username, String updateType) {

        //prep update for the users table to set the lastViewed or lastEdited
        //values. We'll check which to use below.
        String updateUsersTableViewed = "UPDATE users SET lastViewed = NOW() WHERE username = ? ";
        PreparedStatement psUpdateUsersTableViewed = null;
        String updateUsersTableEdited = "UPDATE users SET lastEdited = NOW() WHERE username = ? ";
        PreparedStatement psUpdateUsersTableEdited = null;

        //history table operations below
        //check if reporting is turned on in the admin table for history, and what kind
        //also check what max size of history table is set as
        String getHistoryConfig = "SELECT recordHistory, maxHistorySize FROM admin";
        PreparedStatement psGetHistoryConfig = null;
        ResultSet rsGetHistoryConfig = null;
        boolean reportEdits = false;
        boolean reportViews = false;
        int maxHistorySize = 0;

        //get user_id by the username
        String getUserId = "SELECT user_id FROM users where username = ? ";
        PreparedStatement psGetUserId = null;
        ResultSet rsGetUserId = null;
        String user_id = "0";
        
        //retrieve config for max size of history
        //String getHistorySizeMax = "SELECT maxHistorySize FROM admin";
        //PreparedStatement psHistorySizeMax = null;
        //ResultSet rsHistorySizeMax = null;
        
        //add entry to history table
        String updateHistory = "INSERT INTO history (user_id, username, event_type, event_time) VALUES (?, ?, ?, NOW())";
        PreparedStatement psUpdateHistory = null;
        
        //get current count of entries in history table
        //String getCurrHistorySize = "SELECT COUNT(*) AS c FROM history";
        //PreparedStatement psGetCurrHistorySize = null;
        //ResultSet rsGetCurrHistorySize = null;
        //int currHistorySize = 0;
        
        //delete oldest history entries to maintain max size
        //String deleteOldestHistoryEntries = "DELETE FROM history ORDER BY event_time ASC LIMIT ? ";//? will be number of rows to delete to reduce history to max size (should just be 1 every time)
        //PreparedStatement psDeleteOldestHistoryEntries = null;
        
        //delete oldest history entries to maintain max size
        //this version does not require another query to check the current size
        //and actually is a lot faster this way because that SELECT COUNT(*) is
        //quite slow for some reason
        String deleteOldestHistoryEntries2 = ""
                + "DELETE FROM history "
                + "WHERE event_time NOT IN ( "
                + "        SELECT event_time "
                + "        FROM ( "
                + "            SELECT event_time "
                + "            FROM history "
                + "            ORDER BY event_time DESC "
                + "            LIMIT ? "
                + "        ) temp1 "
                + "    ) ";
        PreparedStatement psDeleteOldestHistoryEntries2 = null;
        
        
        
        Connection conn = null;
        try {
            conn = DbConnectionPool.getConnection();//fetch a connection
            if (conn != null){
                //perform queries/updates
                
                //do update for either the lastViewed or lastEdited value
                //in users table for the given user
                if (updateType.equals("view")){
                    psUpdateUsersTableViewed = conn.prepareStatement(updateUsersTableViewed);
                    psUpdateUsersTableViewed.setString(1, username);
                    psUpdateUsersTableViewed.executeUpdate();
                }
                else {
                    psUpdateUsersTableEdited = conn.prepareStatement(updateUsersTableEdited);
                    psUpdateUsersTableEdited.setString(1, username);
                    psUpdateUsersTableEdited.executeUpdate();
                }

                //check if reporting is enabled, and whether reporting for 
                //edits and/or views is enabled
                psGetHistoryConfig = conn.prepareStatement(getHistoryConfig);
                rsGetHistoryConfig = psGetHistoryConfig.executeQuery();
                if (rsGetHistoryConfig.next()){
                    int recordHistoryVal = rsGetHistoryConfig.getInt("recordHistory");
                    maxHistorySize = rsGetHistoryConfig.getInt("maxHistorySize");
                    if (recordHistoryVal == 1 || recordHistoryVal == 3){
                        //reporting of edits is turned on. "new user" is considered an edit
                        reportEdits = true;
                    }
                    if (recordHistoryVal == 2 || recordHistoryVal == 3){
                        //reporting of views is turned on
                        reportViews = true;
                    }
                }

                //check if the updateType given is enabled for reporting, if not then do nothing.
                if ( (reportViews && updateType.equals("view")) 
                        || (reportEdits && !updateType.equals("view")) ){
                    //this action is enabled for reporting. prep for updating history table

                    //get user_id by the username
                    psGetUserId = conn.prepareStatement(getUserId);
                    psGetUserId.setString(1, username);
                    rsGetUserId = psGetUserId.executeQuery();
                    if (rsGetUserId.next()){
                        user_id = rsGetUserId.getString("user_id");
                    }

                    //get the history size max value from admin config info
                    //psHistorySizeMax = conn.prepareStatement(historySizeMax);
                    //rsHistorySizeMax = psHistorySizeMax.executeQuery();
                    //if (rsHistorySizeMax.next()){
                    //    maxHistorySize = rsHistorySizeMax.getInt("maxHistorySize");
                    //}

                    //add entry to history table for this event, view or edit
                    psUpdateHistory = conn.prepareStatement(updateHistory);
                    psUpdateHistory.setString(1, user_id);
                    psUpdateHistory.setString(2, username);
                    psUpdateHistory.setString(3, updateType);
                    psUpdateHistory.executeUpdate();
                    
                    //get current count of entries in history table
                    //psGetCurrHistorySize = conn.prepareStatement(getCurrHistorySize);
                    //rsGetCurrHistorySize = psGetCurrHistorySize.executeQuery();
                    //if (rsGetCurrHistorySize.next()){
                    //    currHistorySize = rsGetCurrHistorySize.getInt("c");
                    //}
                    
                    //calc number to delete from history
                    //int numHistoryEntriesToDelete = currHistorySize - maxHistorySize;
                    //if (numHistoryEntriesToDelete < 0)
                    //    numHistoryEntriesToDelete = 0;

                    //delete enough history entries to reduce the history to 
                    //the max size, deleting oldest entries first
                    //psDeleteOldestHistoryEntries = conn.prepareStatement(deleteOldestHistoryEntries);
                    //psDeleteOldestHistoryEntries.setInt(1, numHistoryEntriesToDelete);
                    //psDeleteOldestHistoryEntries.executeUpdate();

                    //delete enough history entries to reduce the history to 
                    //the max size, deleting oldest entries first
                    psDeleteOldestHistoryEntries2 = conn.prepareStatement(deleteOldestHistoryEntries2);
                    psDeleteOldestHistoryEntries2.setInt(1, maxHistorySize);
                    psDeleteOldestHistoryEntries2.executeUpdate();

                }

            }
        }
        catch (SQLException e) {
            DbConnectionPool.outputException(e, "helperMethods.adminUpdate()", 
                    new String[]{
                        "updateUsersTableViewed", updateUsersTableViewed, 
                        "updateUsersTableEdited", updateUsersTableEdited,
                        "getHistoryConfig", getHistoryConfig, 
                        "getUserId", getUserId, 
                        "updateHistory", updateHistory, 
                        "deleteOldestHistoryEntries2", deleteOldestHistoryEntries2 
                    }
            );
        }
        finally {
            DbConnectionPool.closeStatement(psUpdateUsersTableViewed);
            
            DbConnectionPool.closeStatement(psUpdateUsersTableEdited);
            
            DbConnectionPool.closeResultSet(rsGetHistoryConfig);
            DbConnectionPool.closeStatement(psGetHistoryConfig);
            
            DbConnectionPool.closeResultSet(rsGetUserId);
            DbConnectionPool.closeStatement(psGetUserId);
            
            DbConnectionPool.closeStatement(psUpdateHistory);
            
            //DbConnectionPool.closeResultSet(rsGetCurrHistorySize);
            //DbConnectionPool.closeStatement(psGetCurrHistorySize);
            
            //DbConnectionPool.closeStatement(psDeleteOldestHistoryEntries);
            
            DbConnectionPool.closeStatement(psDeleteOldestHistoryEntries2);
            
            DbConnectionPool.closeConnection(conn);
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
