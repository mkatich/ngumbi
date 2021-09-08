/*
 * UserPage class is used to create an object representing a user's page 
 * with data including links from the user_links table and other user info 
 * such as search options and other metadata from the users table.
 * This does not retrieve any data related to these objects - that must be 
 * done by other code (UserPageDAO) and then it can use this class to
 * create and use these objects.
 */
package UserPage;

/**
 *
 * @author Michael
 */
public class UserPage {
    
    //Attributes
    private User user;
    private UserLink[] userLinks;
    
    
    //Constructor
    public UserPage(User user, UserLink[] userLinks) {
        this.user = user;
        this.userLinks = userLinks;
    }
    
    
    //Getters and Setters
    public User getUser() {
        return user;
    }
    public void setUser(User user) {
        this.user = user;
    }
    
    public UserLink[] getUserLinks() {
        return userLinks;
    }
    public void setUserLinks(UserLink[] userLinks) {
        this.userLinks = userLinks;
    }
    
    public boolean exists() {
        return this.user != null;
    }
    
}
