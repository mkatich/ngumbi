/*
 * UserLink class is used to create objects for a user's links based on entries 
 * in the user_links table. 
 * This does not retrieve any data related to these objects - that must be 
 * done by other code (UserPageDAO) and then it can use this class to
 * create and use these objects.
 */
package UserPage;

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
    public String getDispHtml() {
        return getDispHtml(0);
    }
    public String getDispHtml(int linkDisplayMode){
        String linkHtml = "";
        
        switch (linkDisplayMode) {
            case 0:
                linkHtml = "<a href=\""+this.linkAddress+"\" class=\"user_link\">"+this.linkName.replace('+',' ')+"</a>";
                break;
            case 1:
                String linkColor = "#0000cc";
                linkHtml = "<font color=\""+linkColor+"\"><u>"+this.linkName+"</u></font>";
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                break;
            default:
                break;
        }
        
        return linkHtml;
    }
    
}
