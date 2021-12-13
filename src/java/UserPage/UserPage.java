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
    private int numCats;
    
    //Constructor
    public UserPage(User user, UserLink[] userLinks, int numCats) {
        this.user = user;
        this.userLinks = userLinks;
        this.numCats = numCats;
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
    
    public int getNumCats() {
        return numCats;
    }
    public void setNumCats(int numCats) {
        this.numCats = numCats;
    }
    
    public int getNumLinks() {
        return this.userLinks.length;
    }
    
    public boolean exists() {
        return this.user != null;
    }
    
    
    
    
    /*
    public String getUserPageHtml() {
        String html = "";
        
        //gather user's search option details
        int searchOption = user.getSearchOption();
        String searchUrl = user.getSearchUrl();
        String searchLang = user.getSearchLang();
        
        
        
        return html;
    }
    */

    
    
    
}
