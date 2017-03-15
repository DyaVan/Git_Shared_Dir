package com.diachuk.TDD_ClassWork.PenaltyGame;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ivan_Diachuk on 3/15/2017.
 */
public class PenaltyGame {

    private String[] teamNames = new String[2];
    int team1Score = 0;
    int team2Score = 0;
    private List<String> team1losers = new ArrayList<String>();
    private List<String> team2losers = new ArrayList<String>();

    private int rollsCount = 0;


    public PenaltyGame(String team1, String team2) {
        teamNames[0] = team1;
        teamNames[1] = team2;
    }

    public String kick(String player, boolean shot) {
        int shotScore = shot ? 1 : 0;
        if (rollsCount % 2 == 0) {
            team1Score += shotScore;
            if (!shot) {
                team1losers.add(player);
            }
        } else {
            team2Score += shotScore;
            if(!shot){
                team2losers.add(player);
            }
        }
        rollsCount++;
        return getPlayerHistory(player) + "," + shotScore;
    }

    public boolean getStatus() {
        return rollsCount >= 10 ?
                (getScoreGap() >= 1 && rollsCount % 2 == 0) : (rollsCount % 2 == 0 ? getScoreGap() > 2 : getScoreGap() > 3);
    }

    private int getScoreGap() {
        return Math.abs(team1Score - team2Score);
    }

    public String getScore() {
        return teamNames[0] + "(" + team1Score + ":" + team2Score + ")" + teamNames[1];
    }


    public String getPlayerHistory(String messi) {
        return null;
    }


    public String getLosersPrice() {
        return " (" + teamNames[0] + " losers price: " + getPlayersPrice(team1losers) + "; " +
                teamNames[1] + " losers price: " + getPlayersPrice(team2losers) + ")";
    }

    public int getPlayersPrice(List<String> players) {
        int res = 0;
        for (String player : players) {
            res += getPlayerPrice(player);
        }
        return res;
    }


    public int getPlayerPrice(String player) {
        return 0;
    }

    public String getScoreVSLosersPrice() {
        return getScore() + getLosersPrice();
    }
}
