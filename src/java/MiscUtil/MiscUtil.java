/*
 * MiscUtil.java
 * Description: Contains utility methods that aren't related to case data. Utility
 * methods that are related to case data are found in caseDataHelper.java.
 * 
 * Created: 06/06/2016
 * @author Michael
 */
package MiscUtil;

import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.*;


public class MiscUtil {
    
    //Methods below get current datetime for logging purposes, in slightly different formats
    public static String getCurrDateTime() {
        return getCurrDateTime("yyyy-MM-dd HH:mm");
    }
    public static String getCurrDateTime(String dateFormatStr) {
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormatStr);
        java.util.Date currDateTime = new java.util.Date();//current datetime in java Date format
        return sdf.format(currDateTime);//current datetime in text
    }
    public static long getCurrDateTimeLong (){
        Calendar c_now = Calendar.getInstance();//create calendar object for this timezone
        long milliseconds = c_now.getTime().getTime();//get milliseconds since the epoch (midnight January 1, 1970 GMT) to now. once to get Date from Calendar, second to get milliseconds from Date
        return milliseconds;
    }
    public static long getDateTimeLongFromString (String date_string){
        //milliseconds will not be in the input. last 3 digits of output will
        //be milliseconds and will vary based on time of calculation.
        int year = Integer.parseInt(date_string.substring(0,4));
        int month = Integer.parseInt(date_string.substring(5,7)) - 1; //subtract 1 since months start at 0 in java
        int day = Integer.parseInt(date_string.substring(8,10));
        int hour = Integer.parseInt(date_string.substring(11,13));
        int minute = Integer.parseInt(date_string.substring(14,16));
        int second = Integer.parseInt(date_string.substring(17,19));
        Calendar c_date = Calendar.getInstance();//create calendar object for this timezone
        c_date.set(year, month, day, hour, minute, second);//set Calendar object with the date/time we want
        long milliseconds = c_date.getTime().getTime();//get milliseconds, once to get Date from Calendar, second to get milliseconds from Date
        return milliseconds;
    }
    //Takes a long representing milliseconds since the epoch (midnight January 1, 1970 GMT), an instant in time.
    //Converts to formatted String representing local time.
    public static String getLocalDateTimeFromEpochLong(long dateTimeL){
        return getLocalDateTimeFromEpochLong(dateTimeL, "yyyy-MM-dd HH:mm:ss");
    }
    public static String getLocalDateTimeFromEpochLong(long dateTimeL, String dateFormatStr){
        java.util.Date d = new java.util.Date(dateTimeL);//get the datetime as java.util.Date object
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormatStr);//create formatter that uses default local and timezone
        return sdf.format(d);
    }
    //Method getTimeDiffToNowApproxText1() gets text for rough approximation of difference between
    //two date/times based on largest time unit between them - example, will factor hours if more than 1 hour and say "2 hours" to be used as in "3 past cases, last created '2 hours' ago"
    /*public static String getTimeDiffToNowApproxText1(long inputTime){
        long currTime = getCurrDateTimeLong();
        long timeDiff = currTime - inputTime;
        long oneMin = 60000L;
        long oneHr = 3600000;
        long twentyFourHrs = 86400000L;//24hrs = 86,400,000 ms
        long fortyEightHrs = 172800000L;
        long oneWeek = 604800000L;
        long twoMonths = 5184000000L;
        long oneYear = 
        if ()
        
    }*/
    public static int getNumDaysFromLongMilliseconds(long timeInterval){
        long twentyFourHrs = 86400000;//24hrs = 86,400,000 ms
        int numDays = (int)(timeInterval/twentyFourHrs);
        return numDays;
    }

    public static String addLinkAddressPrefixAsNeeded(String linkAddress) {
        if (linkAddress.length() == 7){
            if (! (linkAddress.substring(0,7).equals("http://")) ){
                //no 'http://' or 'https://'
                if (!linkAddress.substring(0,4).equals("www.")){
                    //no 'www.' or 'http://'
                    linkAddress = "http://www.".concat(linkAddress);
                }
                else {
                    //has 'www.' but no 'http://'
                    linkAddress = "http://".concat(linkAddress);
                }
            }
            else {
                //we do have either http:// or https://, do nothing.
            }
        }
        //do same checks, except this time also check for https:// since it's more than 7 chars
        else if (linkAddress.length() > 7){
            if (! (linkAddress.substring(0,7).equals("http://") || linkAddress.substring(0,8).equals("https://")) ){
                //no 'http://' or 'https://'
                if (!linkAddress.substring(0,4).equals("www.")){
                    //no 'www.' or 'http://'
                    linkAddress = "http://www.".concat(linkAddress);
                }
                else {
                    //has 'www.' but no 'http://'
                    linkAddress = "http://".concat(linkAddress);
                }
            }
            else {
                //we do have either http:// or https://, do nothing.
            }
        }
        else {
            //it's too short, add the http://www. anyway no matter what
            //if it doesn't work, they get 404 and should fix it themself
            linkAddress = "http://www.".concat(linkAddress);
        }
        return linkAddress;
    }
    
    
    
    
    //do usual preparation for a value from a text input field (excluding prepping newlines which may be in textareas) for SQL insert
    public static String prepTextInputValForDb(String input){
        input = input.trim();
        input = replaceBackslash(input);
        input = replaceQuote(input);
        //input = limitNewlines(input);
        input = replace4ByteChars(input);
        return input;
    }
    //do usual preparation for a value from a text input field (including prepping newlines which may be in textareas)for SQL insert
    public static String prepTextareaInputValForDb(String input){
        input = input.trim();
        input = replaceBackslash(input);
        input = replaceQuote(input);
        input = limitNewlines(input);
        input = replace4ByteChars(input);
        return input;
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
    //check for backslash, replace \ with \\ for mysql, and \\\\ to escape java so it's properly inserted to DB
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
    //check for 4-byte characters (characters outside the Basic Multilingual Plane) which can't be saved in MySQL's regular utf8 (requires utf8mb4) and replace with ?
    public static String replace4ByteChars (String input){
        //String LAST_3_BYTE_UTF_CHAR = "\uFFFF";
        if (input == null)
            return input;
        else {
            return input.replaceAll("[^\\u0000-\\uFFFF]", "\uFFFD");//uses regular expression to check for 4-byte chars. Replacement char is "\uFFFD"
        }
    }
    //Method limitNewlines() will replace any instances of 3 or more newlines with just 2 newlines, and trim leading
    //and trailing newlines. This prevents extra space usage which makes notes and other things harder to read.
    public static String limitNewlines (String input){
        String output = input;
        
        //starty by replacing all \r\n with just \n for consistency (people on Windows will submit \r\n for their newlines)
        output = output.replaceAll("\r\n","\n");
        
        //check for 3 consecutive newlines and replace with 2, over and over until there aren't any more 3 consecutive newlines
        while (output.contains("\n\n\n"))
            output = output.replaceAll("\n\n\n","\n\n");//replace 3 newlines with just 2 newlines
        
        //trim any newlines at beginning and end
        output = output.trim();
        return output;
    }
    
    
    
    
    public static boolean isValidURI(String input) {
        
        Set<String> protocols, protocolsWithHost;
        protocolsWithHost = new HashSet<>( 
            Arrays.asList( new String[]{ "file", "ftp", "http", "https" } ) 
        );
        protocols = new HashSet<>( 
            Arrays.asList( new String[]{ "mailto", "news", "urn" } ) 
        );
        protocols.addAll(protocolsWithHost);
        
        int colon = input.indexOf(':');
        if (colon < 3)
            return false;

        String proto = input.substring(0, colon).toLowerCase();
        if (!protocols.contains(proto))
            return false;

        try {
            URI uri = new URI(input);
            if (protocolsWithHost.contains(proto)) {
                if (uri.getHost() == null)
                    return false;
                
                String path = uri.getPath();
                if (path != null) {
                    for (int i=path.length()-1; i >= 0; i--) {
                        if ("?<>:*|\"".indexOf( path.charAt(i) ) > -1)
                            return false;
                    }
                }
            }
            
            return true;
        } 
        catch ( URISyntaxException ex ) {}

        return false;
    }
    
    
    
}
