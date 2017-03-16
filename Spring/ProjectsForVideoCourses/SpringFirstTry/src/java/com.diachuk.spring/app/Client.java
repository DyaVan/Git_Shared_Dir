package com.diachuk.spring.app;

/**
 * Created by VA-N_ on 15.03.2017.
 */
public class Client {

    private int id;

    private String fullName;

    public Client() {
    }

    public Client(int id, String fullName) {
        this.id = id;
        this.fullName = fullName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
}