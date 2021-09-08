/*
 * User class is used to create objects for a user using their entry in
 * the users table. 
 * This does not retrieve any data related to these objects - that must be 
 * done by other code (UserPageDAO) and then it can use this class to
 * create and use these objects.
 */
package UserPage;

import java.sql.Timestamp;

/**
 *
 * @author Michael
 */
public class User {
    
    //Attributes
    private int userId;
    private String username;
    private String pass;
    private int searchOption;
    private String searchUrl;
    private String searchLang;
    private Timestamp createdDate;
    private Timestamp lastViewed;
    private Timestamp lastEdited;
    
    
    //Constructor
    public User(int userId, String username, String pass, int searchOption, String searchUrl, String searchLang, Timestamp createdDate, Timestamp lastViewed, Timestamp lastEdited) {
        this.userId = userId;
        this.username = username;
        this.pass = pass;
        this.searchOption = searchOption;
        this.searchUrl = searchUrl;
        this.searchLang = searchLang;
        this.createdDate = createdDate;
        this.lastViewed = lastViewed;
        this.lastEdited = lastEdited;
    }
    
    
    //Getters and Setters
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPass() {
        return pass;
    }
    
    public int getSearchOption() {
        return searchOption;
    }
    public void setSearchOption(int searchOption) {
        this.searchOption = searchOption;
    }

    public String getSearchUrl() {
        return searchUrl;
    }
    public void setSearchUrl(String searchUrl) {
        this.searchUrl = searchUrl;
    }

    public String getSearchLang() {
        return searchLang;
    }
    public void setSearchLang(String searchLang) {
        this.searchLang = searchLang;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getLastViewed() {
        return lastViewed;
    }
    public void setLastViewed(Timestamp lastViewed) {
        this.lastViewed = lastViewed;
    }

    public Timestamp getLastEdited() {
        return lastEdited;
    }
    public void setLastEdited(Timestamp lastEdited) {
        this.lastEdited = lastEdited;
    }
    
}
