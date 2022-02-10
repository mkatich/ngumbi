/*
 * UserPage class is used to create an object representing a user's page 
 * with data including links from the user_links table and other user info 
 * such as search options and other metadata from the users table.
 * This does not retrieve any data related to these objects - that must be 
 * done by other code (UserPageDAO) and then it can use this class to
 * create and use these objects.
 */
package UserPage;

import java.util.ArrayList;
import java.util.List;

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
    
    
    public int getUserId() {
        return this.user.getUserId();
    }
    public String getUsername() {
        return this.user.getUsername();
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
    
    //hasCat() allows checking a UserPage to know whether it has any links
    //with a category matching the given parameter - true if so, otherwise false
    public boolean hasCat(String cat) {
        boolean hasCat = false;
        for (int i = 0; i < userLinks.length && !hasCat; i++){
            if (userLinks[i].getCat().equals(cat)){
                hasCat = true;
            }
        }
        return hasCat;
    }
    
    //getMaxCatRank() will return the catRank of the user's links that are in 
    //their highest rank category (last category)
    public int getMaxCatRank() {
        //user links are always in order by catRank first, so we can just get 
        //the last one
        return userLinks[userLinks.length - 1].getCatRank();
    }
    
    //getLinksInCategory() will return an array of user's links in one category
    public UserLink[] getLinksInCategory(String cat) {
        List<UserLink> userLinksOneCatL = new ArrayList<>();
        for (int i = 0; i < userLinks.length; i++){
            if (userLinks[i].getCat().equals(cat)){
                userLinksOneCatL.add(userLinks[i]);
            }
        }
        UserLink[] userLinksOneCat = userLinksOneCatL.toArray(new UserLink[userLinksOneCatL.size()]);
        return userLinksOneCat;
    }
    
    public UserLink getLastLinkInCategory(String cat){
        UserLink[] userLinksOneCat = getLinksInCategory(cat);
        //user links are always in order by catRank first, so we can just get 
        //the last one
        return userLinksOneCat[userLinksOneCat.length - 1];
    }
    
    public int getMaxLinkRankInCategory(String cat){
        return getLastLinkInCategory(cat).getLinkRank();
    }
    
}
