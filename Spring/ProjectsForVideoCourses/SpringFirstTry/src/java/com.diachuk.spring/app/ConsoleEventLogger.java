package com.diachuk.spring.app;

/**
 * Created by VA-N_ on 15.03.2017.
 */
public class ConsoleEventLogger implements IEventLogger{

    public void logEvent(String msg) {
        System.out.println(msg);
    }
}
