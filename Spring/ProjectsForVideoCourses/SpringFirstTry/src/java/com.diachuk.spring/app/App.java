package com.diachuk.spring.app;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

/**
 * Created by VA-N_ on 15.03.2017.
 */
public class App {

    public App(Client client, IEventLogger eventLogger) {
        this.client = client;
        this.eventLogger = eventLogger;
    }

    private Client client;
    private IEventLogger eventLogger;


    //region GettersVsSetters
    public Client getClient() {
        return client;
    }

    public void setClient(Client client) {
        client = client;
    }

    public IEventLogger getConsoleEventLogger() {
        return eventLogger;
    }

    public void setConsoleEventLogger(IEventLogger consoleEventLogger) {
        eventLogger = consoleEventLogger;
    }
    //endregion

    public void logEvent(String msg) {
        String resMsg = msg.replaceAll(String.valueOf(client.getId()), client.getFullName());
        eventLogger.logEvent(resMsg);
    }

    public static void main(String[] args) {
        ApplicationContext ctx = new FileSystemXmlApplicationContext("AppConfig.xml");

        App app = (App)ctx.getBean("app");

        app.logEvent("lol 1 brel1");
    }
}
