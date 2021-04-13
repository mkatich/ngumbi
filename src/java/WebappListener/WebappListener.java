/*
 * WebappListener is used to run things on web app startup and shutdown
 * as needed. contextInitialized() is only run once, on webapp startup.
 * contextDestroyed is run once, at webapp shutdown.
 */
package WebappListener;

import DbConnectionPool.DbConnectionPool;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Web application lifecycle listener.
 * @author Michael
 */
public class WebappListener implements ServletContextListener {

    static final Logger LOG = LoggerFactory.getLogger(WebappListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        //web app has been started
        //call anything for startup here
        
        //start up the Hikari connection pool for MySQL
        DbConnectionPool.initPool();
        
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        //web app has been ended
        //call anything for shutdown
        
        //shut down the Hikari connection pool for MySQL
        DbConnectionPool.shutdownPool();
        
    }
}
