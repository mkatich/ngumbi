/*
 * MiscUtil.java
 * Description: Contains utility methods that aren't related to case data. Utility
 * methods that are related to case data are found in caseDataHelper.java.
 * 
 * Created: 06/06/2016
 * @author Michael
 */
package MiscUtil;

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
    
    
}
