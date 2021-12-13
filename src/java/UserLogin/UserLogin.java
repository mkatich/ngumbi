/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserLogin;

import MiscUtil.MiscUtil;
import java.sql.Timestamp;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

/**
 *
 * @author Michael
 */
public class UserLogin implements HttpSessionBindingListener {
    
    
    @Override
    public void valueBound(HttpSessionBindingEvent hsBindingEvent){
        //Handle session-initialization. This is called when session is created (before login).
        this.userSession = hsBindingEvent.getSession();//set member variable for session
        //this.userMaxInactiveInterval = userSession.getMaxInactiveInterval();//sets the inactive interval so we know what it's set to on the server.
        //hsBindingEvent.getName() - will give "UserLoginBean"
        //output to Tomcat's stdout log
        //System.out.println(getTime()+" "+hsBindingEvent.getValue()+" bound to new session, ID="+userSession.getId()+", MaxInactiveInterval:"+userSession.getMaxInactiveInterval()+"seconds");
    }
    @Override 
    public void valueUnbound(HttpSessionBindingEvent hsBindingEvent){
        //This is called when UserLoginBean has been unbound from the session.
        //Session may have been invalidated (user logged out), or timed out, or invalidate() was called in code.
        //This may be as a result of a servlet programmer explicitly unbinding an attribute from a session, due to a session being invalidated, or due to a session timing out. 
        
        //Handle session-cleanup. 
        
        //This is called when session closes (but not with logout).
        //I believe it also may be called when user attempt accessing a session that has already been closed
        //since I see some outputs that were just session ended without any name after I kicked everyone for an update.
        //So I don't want to just output something every time.
        //String sessionName = "";
        //if (hsBindingEvent.getValue() != null)
        //    sessionName = hsBindingEvent.getValue().toString();
        
        //get some session time parameters and values
        long nowTime = MiscUtil.getCurrDateTimeLong();
        long sessionLastAccessedTime = 0;
        long userMaxInactiveInterval = 0;
        try {
            sessionLastAccessedTime = this.getSessionLastAccessedTime();//milliseconds since midnight January 1, 1970 GMT
            userMaxInactiveInterval = this.getSessionMaxInactiveInterval()*1000;//multiply by 1000 to get milliseconds
        }
        catch(IllegalStateException e){
            //if this throws an exception, then it's because the session is already invalidated and we can't get that info.
        }
        
        if (this.username.equals("")){
            //I think this one is hit if the user accessed a URL, but is not logged in.
            //perhaps a new session is started after logging in and this one is closed
            //    this.logLogoutToServerLog("session ended, blank userId");
        }
        else if (sessionLastAccessedTime != 0 && nowTime - sessionLastAccessedTime >= userMaxInactiveInterval){
            //session must have timed out from inactivity, which logged out a user
            //
            this.logLogoutToServerLog("max inactivity period");
        }
        else {
            //session ended for another reason, must've been kicked. 
            //could be kicked if servlet container restarted or webapp undeployed for update
            //but could also be kicked if user hit max inactivity (may not have session data to check this)
            //
            this.logLogoutToServerLog("kicked");
        }
    }
    

    private void logLogoutToServerLog(String logoutMsg) {
        String serverLogMsg;
        String sessionName = this.userSession.getId();
        
        if (this.userSession == null){
            //User session is null, invalidated already, don't try to get info
            //Build message for the server log
            serverLogMsg = 
                    MiscUtil.getCurrDateTime()+" "
                    + "Session ended. User '"+this.username+"' ["+sessionName+"]  "
                    + logoutMsg+". "
                    + "No session start/last access/duration info since already invalidated.";
        }
        else {
            //User session is not null, get info if possible
            
            try {
                
                //Get some session time parameters and values
                long sessionLastAccessedTime = this.getSessionLastAccessedTime();//milliseconds since midnight January 1, 1970 GMT
                long timeNow = MiscUtil.getCurrDateTimeLong();
                long sessionInactiveInMinutes = (timeNow - sessionLastAccessedTime)/1000/60;

                //Derive some as readable String
                String lastAccessedDateTimeStr = MiscUtil.getLocalDateTimeFromEpochLong(sessionLastAccessedTime).substring(0,16);
                
                //Build message for the server log
                serverLogMsg = 
                        MiscUtil.getCurrDateTime()+" "
                        + "Session ended. User '"+this.userId+"' "
                        + logoutMsg+". "
                        + "Last access "+lastAccessedDateTimeStr+" ("+sessionInactiveInMinutes+"m ago)";
            }
            catch(IllegalStateException e){
                //If this throws an exception, then it's because the session is already 
                //invalidated and we can't get that info. Build message for the server log... with less info.
                //I'm not sure why this is frequently the case. Sometimes we can retrieve this info 
                //in both kick and voluntary logout situations.
                serverLogMsg = 
                        MiscUtil.getCurrDateTime()+" "
                        + "Session ended. User '"+this.userId+"' "
                        + logoutMsg+". "
                        + "Session invalidated from inactivity. Last access n/a.";
            }
        }
        
        System.out.println(serverLogMsg);//output to Tomcat server's stdout log
    }
    private void logLoginToServerLog() {
        //build message for the server log
        String serverLogMsg = 
                MiscUtil.getCurrDateTime()+" "
                + "Session started. User '"+this.userId+"' logged in.";
        System.out.println(serverLogMsg);//output to Tomcat's stdout log
    }
    
    
    
    
    // Attributes

    //HTTP Session attributes
    HttpSession userSession; //used for doing things when session created and after destroyed

    //Main user login attributes
    private int userId;
    private String username;
    private String pass;
    private boolean secure;

    private int searchOption;
    private String searchUrl;
    private String searchLang;
    private Timestamp createdDate;
    private Timestamp lastViewed;
    private Timestamp lastEdited;


    public void logout(){
        //user logging themselves out
        this.secure = false;
    }

    public void setSecure(){
        this.secure = true;
        this.logLoginToServerLog();//output to Tomcat's stdout log
    }
    public boolean isSecure(){
        return secure;
    }
    
    public void setUserId(int userId){
        this.userId = userId;
    }
    public int getUserId(){
        return userId;
    }

    public void setUsername(String username){
        this.username = username;
    }
    public String getUsername(){
        return username;
    }

    public void setPass(String pass){
        this.pass = pass;
    }
    public String getPass(){
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
    
    
    
    
    //Getters for some session parameters (not kept as member vars here; prefer to use those already kept in HttpSession)
    //https://tomcat.apache.org/tomcat-9.0-doc/servletapi/index.html
    //maxInactiveInterval is currently set in web.xml, but it can also be set here like this.userSession.setMaxInactiveInterval(XXXXX);
    public long getSessionCreatedTime() {
        //first check the session is valid, otherwise may get java.lang.IllegalStateException ... Session already invalidated 
        long val = -1L;
        if (this.userSession != null)
            val = this.userSession.getCreationTime();//milliseconds since midnight January 1, 1970 GMT
        return val;
    }
    public long getSessionLastAccessedTime() throws IllegalStateException {
        //first check the session is valid, otherwise may get java.lang.IllegalStateException ... Session already invalidated 
        long val = -1L;
        if (this.userSession != null)
            val = this.userSession.getLastAccessedTime();//milliseconds since midnight January 1, 1970 GMT
        return val;
    }
    public int getSessionMaxInactiveInterval() {
        //first check the session is valid, otherwise may get java.lang.IllegalStateException ... Session already invalidated 
        int val = -1;
        if (this.userSession != null)
            val = this.userSession.getMaxInactiveInterval();//seconds
        return val;
    }
    public long getSessionDuration() {
        //first check the session is valid, otherwise may get java.lang.IllegalStateException: getCreationTime: Session already invalidated 
        long val = -1L;
        if (this.userSession != null)
            val = (System.currentTimeMillis() - this.userSession.getCreationTime());
        return val;
    }
    
}
