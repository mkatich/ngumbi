/*
 * UserLink class is used to create objects for a user's links based on entries 
 * in the user_links table. 
 * This does not retrieve any data related to these objects - that must be 
 * done by other code (UserPageDAO) and then it can use this class to
 * create and use these objects.
 */
package UserPage;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Michael
 */
public class UserLink {
    
    //Attributes
    private int userLinkId;
    private int userId;
    private String linkName;
    private String linkAddress;
    private String cat;
    private int catRank;
    private int subCatRank;
    private int linkRank;
    
    
    //Constructors
    public UserLink(int userLinkId, int userId, String linkName, String linkAddress, String cat, int catRank, int subCatRank, int linkRank) {
        this.userLinkId = userLinkId;
        this.userId = userId;
        this.linkName = linkName;
        this.linkAddress = linkAddress;
        this.cat = cat;
        this.catRank = catRank;
        this.subCatRank = subCatRank;
        this.linkRank = linkRank;
    }
    
    
    //Getters and Setters
    public int getUserLinkId() {
        return userLinkId;
    }
    public void setUserLinkId(int userLinkId) {
        this.userLinkId = userLinkId;
    }
    
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getLinkName() {
        return linkName;
    }
    public void setLinkName(String linkName) {
        this.linkName = linkName;
    }
    
    public String getLinkAddress() {
        return linkAddress;
    }
    public void setLinkAddress(String linkAddress) {
        this.linkAddress = linkAddress;
    }
    
    public String getCat() {
        return cat;
    }
    public void setCat(String cat) {
        this.cat = cat;
    }
    
    public int getCatRank() {
        return catRank;
    }
    public void setCatRank(int catRank) {
        this.catRank = catRank;
    }
    
    public int getSubCatRank() {
        return subCatRank;
    }
    public void setSubCatRank(int subCatRank) {
        this.subCatRank = subCatRank;
    }
    
    public int getLinkRank() {
        return linkRank;
    }
    public void setLinkRank(int linkRank) {
        this.linkRank = linkRank;
    }
    
    //returns html content for this link which can vary 
    //depending on given linkDisplayMode
    public String getLinkDispHtml() {
        return getLinkDispHtml(0);
    }
    public String getLinkDispHtml(int linkDisplayMode) {
        return getLinkDispHtml(linkDisplayMode, "", "");
    }
    public String getLinkDispHtml(int linkDisplayMode, String editorCurrState, String username){
        String linkHtml = "";
        String editorNextState;
        switch (linkDisplayMode) {
            case 0:
                //Default link mode, used by user page. Displays a normal clickable link.
                linkHtml = "<a href=\""+this.linkAddress+"\" class=\"user_link\">"+this.linkName.replace('+',' ')+"</a>";
                break;
                
            case 1:
                //This mode displays an unclickable link and is used for display when viewing Editor.
                String linkColorCss = "color: #0000cc;";
                linkHtml = "<span style=\""+linkColorCss+"\" class=\"user_link\"><u>"+this.linkName+"</u></span>";
                break;
                
            case 2:
                //This mode displays a clickable link meant for use within Editor for user to choose a link. This
                //identifies the link for the next part of the editing process. 
                //Here, the next state is derived as current state plus "_1" appended.
                //This one is for editing a link (3e)
                editorNextState = editorCurrState+"_1";
                linkHtml = ""
                        + "<a "
                        + "href=\"editor_NEW.jsp?user="+username+"&state="+editorNextState+"&fromstate="+editorCurrState+"&selected_user_link_id="+this.userLinkId+"&cat="+this.cat+"&sub_cat_rank="+this.subCatRank+"\" "
                        + "class=\"user_link\">"
                        + this.linkName
                        + "</a>";
                break;
                
            case 3:
                //This mode displays a clickable link meant for use within Editor for user to choose a link. This
                //identifies the link for the next part of the editing process. 
                //Here, the next state is just state 2.
                //This one is for deleting a link (3d)
                editorNextState = "2";
                linkHtml = ""
                        + "<a "
                        + "href=\"editor_NEW.jsp?user="+username+"&state="+editorNextState+"&fromstate="+editorCurrState+"&selected_user_link_id="+this.userLinkId+"\" "
                        + "class=\"user_link\">"
                        + this.linkName
                        + "</a>";
                break;
                
            case 4:
                //This mode displays just plain text, no link. It's not clickable, and there is no 
                //confusing for user. 
                //This is used when the category is clickable for renaming (3r)
                linkHtml = "<span class=\"user_link\">"+this.linkName+"</span>";
                break;
                
            default:
                break;
        }
        return linkHtml;
    }
    
    
    //returns html content for the category of this link which can vary 
    //depending on given catDisplayMode
    public String getCatDispHtml() {
        return getCatDispHtml(0);
    }
    public String getCatDispHtml(int catDisplayMode) {
        return getCatDispHtml(catDisplayMode, "", "");
    }
    public String getCatDispHtml(int catDisplayMode, String editorCurrState, String username){
        String catHtml = "";
        String editorNextState;
        switch (catDisplayMode) {
            case 0:
                //Default category display mode, used by user page. Displays a normal plaintext category.
                catHtml = this.cat;
                break;
                
            case 1:
                //This mode displays category as a clickable link meant for use within Editor for user to choose a category. 
                //This identifies the category for the next part of the editing process. 
                //Here, the next state is derived as current state plus "_1" appended.
                //This one is for renaming a category (3r)
                editorNextState = editorCurrState+"_1";
                String urlEncodedCategoryName = "";
                try {
                    urlEncodedCategoryName = URLEncoder.encode(this.cat, "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(UserLink.class.getName()).log(Level.SEVERE, null, ex);
                }
                catHtml = ""
                        + "<a "
                        + "href=\"editor_NEW.jsp?user="+username+"&state="+editorNextState+"&fromstate="+editorCurrState+"&renamecat_old="+urlEncodedCategoryName+"\" "
                        + ">"
                        + this.cat
                        + "</a>";
                break;
                
            default:
                break;
        }
        return catHtml;
    }
    
}
