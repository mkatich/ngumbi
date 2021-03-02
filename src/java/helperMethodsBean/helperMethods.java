package helperMethodsBean;
import java.sql.*;

public class helperMethods 
{

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
		
	//		**ADMIN UPDATE**
	// this method is called when the actual edits to a user's table are made or a view occurs
	// it records the edit data as a new entry in the history table if recording is turned on
	// and also updates the lastEdited or lastViewed field of the users table for this user
	public void adminUpdate(String username, String updateType) throws SQLException, Exception {

		
		//check for the type of update, view or edit, and update users table accordingly
		//these are always done, even if reporting to history table is turned off
		String updateUsersTable = "";
		if (updateType.equals("view")){
			//it was a view, update the lastViewed time in the users table
			updateUsersTable = "UPDATE users SET lastViewed = NOW() WHERE username = '"+username+"'";
		}	
		else {
			//it was an edit or new user, update the lastEdited time in the users table
			updateUsersTable = "UPDATE users SET lastEdited = NOW() WHERE username = '"+username+"'";
		}
		
		
		
		//Connection and Operations on database
		String dbname = "ngumbi";
		String dbuser = "ngumbi_db_user";
		String dbpass = "ngumbi_db_pass";
		Driver driver = null;
		String dbURL = "jdbc:mysql://localhost:3306/"+dbname+"?user=";
		Connection conn = null;
		
		//perform update to users table
		Statement stat19 = null;
		Statement stat18 = null;
		ResultSet rs88 = null;
		String getUserId = "SELECT user_id FROM users where username = '"+username+"'";
		int user_id = 0;
		try {
			driver = (Driver) Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(dbURL, dbuser, dbpass);
			
			stat19 = conn.createStatement();
			stat19.executeUpdate(updateUsersTable);
			
			stat18 = conn.createStatement();
			rs88 = stat18.executeQuery(getUserId);
		}
		catch (Exception e) {
			System.out.print("Unable to make connection to production database");
			System.out.print(e);
		}
		
		//get user_id of this user
		if (rs88.next())
                    user_id = rs88.getInt("user_id");
                rs88.close();
		
		
		//history table operations
		//first check if reporting is turned on in the admin table for history, and what kind
		String reportingCheck = "SELECT recordHistory FROM admin";
		ResultSet rsreporting = null;
		Statement stat20 = null;
		try {
			stat20 = conn.createStatement();
			rsreporting = stat20.executeQuery(reportingCheck);	
		}
		catch (Exception e) {
			//get a compile problem if I leave those uncommented below, I even tried putting the method call
			//in a try/catch block but that didn't help
			System.out.print("Unable to make connection to production database");
			System.out.print(e);
		}
		
		boolean reportEdits = false;
		boolean reportViews = false;
		
		if (rsreporting.next()){
			if (rsreporting.getInt("recordHistory") == 1 || rsreporting.getInt("recordHistory") == 3){
				//reporting of edits is turned on, "new user" is considered an edit
				reportEdits = true;
			}
			if (rsreporting.getInt("recordHistory") == 2 || rsreporting.getInt("recordHistory") == 3){
				//reporting of views is turned on
				reportViews = true;
			}
		}
		
		//check if the updateType given is enabled for reporting, if not then do nothing.
		if ( (reportEdits && !updateType.equals("view")) || (reportViews && updateType.equals("view"))  ){
			//preparation for updating history table
			//first lock the history table and check if it's full, also readlock admin table
			Statement stat6 = null;
			Statement stat7 = null;
			Statement stat11 = null;
			String lockHistory = "LOCK TABLES history WRITE, admin READ";
			String historySizeCheck = "SELECT COUNT(*) AS historyCount FROM history";
			String historySizeMax = "SELECT maxHistorySize FROM admin";
			ResultSet rshistorycheck = null;
			ResultSet rshistorymax = null;
			try {
				stat11 = conn.createStatement();
				stat11.execute(lockHistory);
				stat6 = conn.createStatement();
				rshistorycheck = stat6.executeQuery(historySizeCheck);
				stat7 = conn.createStatement();
				rshistorymax = stat7.executeQuery(historySizeMax);
			}
			catch (Exception e) {
				System.out.print("Unable to make connection to production database");
				System.out.print(e);
			}
			
			if (rshistorycheck.next() && rshistorymax.next()){
				//rshistorycheck.next();
				//rshistorymax.next();
				if (rshistorycheck.getInt("historyCount") >= rshistorymax.getInt("maxHistorySize")){
					//history is at max size specified by admin, delete oldest first
					Statement stat8 = null;
					String getOldest = "SELECT MIN(event_time) AS oldestEventTime FROM history";
					ResultSet rsoldest = null;
					try {
						stat8 = conn.createStatement();
						rsoldest = stat8.executeQuery(getOldest);
					}
					catch (Exception e) {
						System.out.print("Unable to make connection to production database");
						System.out.print(e);
					}			
					rsoldest.next();			
					
					//get the timestamp (date)			
					Timestamp date1 = rsoldest.getTimestamp("oldestEventTime");
					
					//here is the date identifying the oldest one
					//it could delete more than one if they have the same exact date, who cares
					String deleteOldest = "DELETE FROM history WHERE event_time = '"+date1+"'";	
					Statement stat9 = null;		
					try {
						stat9 = conn.createStatement();
						stat9.executeUpdate(deleteOldest);
					}
					catch (Exception e) {
						System.out.print("Unable to make connection to production database");
						System.out.print(e);
					}
					rsoldest.close();
				}
			}
			
			//now add new history entry and unlock the history table
			Statement stat10 = null;
			Statement stat12 = null;
			String updateHistory = "INSERT INTO history (user_id, username, event_type, event_time) VALUES ("+user_id+", '"+username+"', '"+updateType+"', NOW())";
			String unlockHistory = "UNLOCK TABLES";
			try {
				stat10 = conn.createStatement();
				stat10.executeUpdate(updateHistory);
				stat12 = conn.createStatement();
				stat12.execute(unlockHistory);
			}
			catch (Exception e) {
				System.out.print("Unable to make connection to production database");
				System.out.print(e);
			}						
			rshistorycheck.close();
			rshistorymax.close();						
			
		}

		rsreporting.close();		
	}


	
}
