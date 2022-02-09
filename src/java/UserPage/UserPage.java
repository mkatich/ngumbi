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
    
    
    public String[] getCats() {
        String[] cats = new String[numCats];
        int indexLinks = 0;
        int indexCats = 0;
        while (indexLinks < userLinks.length && indexCats < cats.length){
            String currCat = userLinks[indexLinks].getCat();
            if (indexCats == 0){
                //if first one, just fill in
                cats[indexCats] = currCat;
                indexCats++;
            }
            else if (!currCat.equals(cats[indexCats-1])){
                //not first one, and different from previously saved cat.
                //save as new cat and increment index in cats
                cats[indexCats] = currCat;
                indexCats++;
            }
            indexLinks++;
        }
        return cats;
    }
    
    
    
}
