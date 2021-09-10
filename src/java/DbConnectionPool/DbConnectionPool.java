/*
 * DbConnectionPool.java - DbConnectionPool class uses a connection pooling library 
 * for JDBC to enable easy coding of database connections without leaking connections (everything is closed), 
 * pooling of connection resources for much better performance.
 * 
 */
package DbConnectionPool;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Properties;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Michael
 */
public class DbConnectionPool {
    
    private static HikariConfig config;
    private static HikariDataSource connectionPool;
    
    private static final String WEBAPP_NAME = "Ngumbi";
    private static final String PROPERTIES_FILE_NAME = "ngumbi.properties";
    private static String DB_NAME;
    private static String DB_BASEURL;
    private static String DB_USERNAME;
    private static String DB_PASSWORD;
    
    
    //call initialization methods to start up the connection pool! This is called
    //when webapp starts so that connections from the pool will be ready for use.
    public static void initPool() {
        
        System.out.println("My current path is::: " + new File(".").getAbsolutePath());
        
        //gather database config
        Properties dbProps = readDbPropertiesFile();
        DB_NAME = dbProps.getProperty("db.name");
        DB_BASEURL = dbProps.getProperty("db.baseurl");
        DB_USERNAME = dbProps.getProperty("db.user");
        DB_PASSWORD = dbProps.getProperty("db.password");
        System.out.println("Properties read.");
        
        //register driver
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            //get id of this driver, just used for outputting
            ClassLoader cl = Thread.currentThread().getContextClassLoader();
            Enumeration<Driver> drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                if (driver.getClass().getClassLoader() == cl) {
                    System.out.println("\n"+"Registered MySQL JDBC driver id: "+driver);
                }
            }
            
        }
        catch (ClassNotFoundException ex) {
            StringWriter sw = new StringWriter();
            ex.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println(stackTrace);
        }
        
        //set pool configuration options to be able to get connection to 
        //database, and set the instance variable for the DbConnectionPool object
        config = new HikariConfig();
        config.setJdbcUrl(DB_BASEURL+DB_NAME);
        config.setUsername(DB_USERNAME);
        config.setPassword(DB_PASSWORD);
        config.addDataSourceProperty("cachePrepStmts" , "true");//Neither of the above parameters have any effect if the cache is in fact disabled, as it is by default. You must set this parameter to true.
        config.addDataSourceProperty("prepStmtCacheSize" , "250");//This sets the number of prepared statements that the MySQL driver will cache per connection. The default is a conservative 25. We recommend setting this to between 250-500.
        config.addDataSourceProperty("prepStmtCacheSqlLimit" , "2048");//This is the maximum length of a prepared SQL statement that the driver will cache. The MySQL default is 256. In our experience, especially with ORM frameworks like Hibernate, this default is well below the threshold of generated statement lengths. Our recommended setting is 2048.
        config.addDataSourceProperty("useServerPrepStmts" , "true");//Newer versions of MySQL support server-side prepared statements, this can provide a substantial performance boost. Set this property to true.
        config.setLeakDetectionThreshold(TimeUnit.SECONDS.toMillis(20));//enable leak detection and output to log. Will output message if connection not returned within X seconds
        connectionPool = new HikariDataSource(config);
        
        System.out.println(WEBAPP_NAME+" database connection pool has been started.");
        
        //runDbTest();
    }
        
    //call stop method when webapp is ending, undeployed, or whatever, to allow
    //the connection pool to shut down
    public static void shutdownPool() {
        //shut down data source
        if (connectionPool != null) {
            connectionPool.close();
            //connectionPool.shutdown();//deprecated method
            System.out.println(WEBAPP_NAME+" database connection pool has been shut down.");
        }
        
        //unregister the driver (making sure it was this web app that loaded it
        // - prevents Tomcat saying: The web application [WEBAPP_NAME] registered the JDBC driver [com.mysql.jdbc.Driver] but failed to unregister it when the web application was stopped. To prevent a memory leak, the JDBC Driver has been forcibly unregistered.
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            String driverDispName = driver.toString()+" v "+driver.getMajorVersion()+"."+driver.getMinorVersion();
            if (driver.getClass().getClassLoader() == cl) {
                /*try {
                    //we found driver that was loaded by this web app
                    System.out.print("Shutting down MySQL JDBC driver id: "+driver+". ");
                    if (driver.getClass().getName().toLowerCase().contains("mysql")) {
                        com.mysql.jdbc.AbandonedConnectionCleanupThread.shutdown();
                    }
                }
                catch (InterruptedException ex) {
                    System.out.println("ERROR Shutting down MySql JDBC driver "+driver+" : "+ex);
                }*/
                try {
                    System.out.println("Deregistering.");
                    DriverManager.deregisterDriver(driver);
                }
                catch (SQLException ex) {
                    System.out.println("ERROR Deregistering JDBC driver "+driverDispName+" : "+ex);
                }
            }
            else {
                System.out.println("Will not deregister JDBC driver {"+driverDispName+"} as it does not belong to the "+WEBAPP_NAME+"'s ClassLoader");
            }
        }
        
    }
    
    //get a connection from the connection pool!
    public static Connection getConnection() {
        Connection connection = null;

        try {
            connection = connectionPool.getConnection();
        } catch (SQLException e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println(stackTrace);
        }

        return connection;
    }
    
    
    //close as ResultSet
    public static void closeResultSet(ResultSet rs) {
        try {
        if (rs != null)
            rs.close();
        } catch (SQLException e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println(stackTrace);
        }

    }
    
    //close a Statement
    public static void closeStatement(Statement stmt) {
        try {
        if (stmt != null)
            stmt.close();
        } catch (SQLException e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println(stackTrace);
        }

    }
    
    //release a Connection back to the pool! (not really closing connection)
    public static void closeConnection(Connection conn) {
        try {
        if (conn != null)
            conn.close(); //release the connection - the name is tricky but connection is not closed it is released
            //and it will stay in pool
        } catch (SQLException e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println(stackTrace);
        }

    }
    
    /*
    public static void release(Connection connection) {
        try {
            if (connection != null) {
                connection.close();
            }
        } catch (Exception ex) {
            StringWriter sw = new StringWriter();
            ex.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println(stackTrace);
        }
    }
    */
    
    public static Properties readDbPropertiesFile() {
        //readPropertiesFile
        FileInputStream fis = null;
        Properties prop = null;
        try {
            fis = new FileInputStream(PROPERTIES_FILE_NAME);
            prop = new Properties();
            prop.load(fis);
            System.out.println("Properties file ["+PROPERTIES_FILE_NAME+"] loaded successfully.");
        }
        catch(FileNotFoundException e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println(stackTrace);
        }
        catch(IOException e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();
            System.out.println(stackTrace);
        }
        finally {
            try {
                if (fis != null)
                    fis.close();
            } catch (IOException e) {
                Logger.getLogger(DbConnectionPool.class.getName()).log(Level.SEVERE, null, e);
            }
        }
        return prop;
    }
    
    /*
    private static void runDbTest() throws SQLException {
        Connection connection = getConnection(); // fetch a connection
        if (connection != null){
            System.out.println("Connection successful!");
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT username FROM users ORDER BY user_id ASC"); // do something with the connection.
            while(rs.next()){
                System.out.println(rs.getString("username")); // should print out "1"'
            }
            connection.close();
        }
    }
    */
    
    //Standardized error outputting methods. These are here since they'll often be used together with
    //the connection methods above.
    public static void outputException(Exception e, String callerName, String queryUpdateName, String queryUpdate) {
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        String stackTrace = sw.toString();
        
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        java.util.Date currDateTime = new java.util.Date();//current datetime in java Date format
        String current_datetime_str = sdf1.format(currDateTime);//current datetime in text
        
        System.out.println(current_datetime_str+" ERROR in "+callerName+" - "+queryUpdateName+": "+queryUpdate+" \nStacktrace: "+stackTrace);
    }
    public static void outputSqlException(SQLException e, String callerName, String queryUpdateName, String queryUpdate) {
        outputException(e, callerName, queryUpdateName, queryUpdate);
    }
    //Below is the same idea but it accepts a String[] array with even cells being the query/update name and odd cells being
    //the actual query/update itself. It must be length multiple of 2 obviously.
    public static void outputException(Exception e, String callerName, String[] queryUpdates) {
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        String stackTrace = sw.toString();
        
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        java.util.Date currDateTime = new java.util.Date();//current datetime in java Date format
        String current_datetime_str = sdf1.format(currDateTime);//current datetime in text
        
        System.out.println(current_datetime_str+" ERROR in "+callerName+", one of the following -");
        for (int i = 0; i < queryUpdates.length && i%2 == 0; i+=2)
            System.out.println(queryUpdates[i]+": "+queryUpdates[i+1]);
        System.out.println("\nStacktrace: "+stackTrace);
    }
    public static void outputSqlException(SQLException e, String callerName, String[] queryUpdates) {
        outputException(e, callerName, queryUpdates);
    }
    
}
