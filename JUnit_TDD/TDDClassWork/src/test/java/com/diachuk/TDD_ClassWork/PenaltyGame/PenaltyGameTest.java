package com.diachuk.TDD_ClassWork.PenaltyGame;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.when;

/**
 * Created by Ivan_Diachuk on 3/15/2017.
 */
public class PenaltyGameTest extends Assert {

    public static PenaltyGame game;

    @Before
    public void createWithTwoTeams() {
        game = new PenaltyGame("Arsenal", "Liverpool");
    }

    @Test
    public void canCreate() {
        assertNotNull(game);
    }

    @Test
    public void canGetStatus() {
        game.getStatus();
    }

    @Test
    public void canGetScore() {
        game.getScore();
    }

    //---------------

    @Test
    public void cleanWinStatus() {
        game.kick("Messi",true);
        game.kick("Messi",false);
        game.kick("Messi",true);
        game.kick("Messi",false);
        game.kick("Messi",true);
        game.kick("Messi",false);
        game.kick("Messi",true);
        game.kick("Messi",false);
        game.kick("Messi",true);
        game.kick("Messi",false);
        game.kick("Messi",true);
        game.kick("Messi",false);
        assertEquals(true, game.getStatus());
    }

    @Test
    public void twoShotsStatus() {
        game.kick("Messi",true);
        game.kick("Messi",true);
        assertEquals(false, game.getStatus());
    }

    @Test
    public void earlyFinishStatus() {
        game.kick("Messi",true);
        game.kick("Messi",false);
        game.kick("Messi",true);
        game.kick("Messi",false);
        game.kick("Messi",true);
        game.kick("Messi",false);

        assertEquals(true, game.getStatus());
    }

    @Test
    public void fourVSTwoStatus() {
        game.kick("Messi",true);
        game.kick("Messi",true);
        game.kick("Messi",true);
        game.kick("Messi",true);
        game.kick("Messi",true);
        game.kick("Messi",false);
        game.kick("Messi",true);
        game.kick("Messi",false);
        System.out.println(game.getScore());
        assertEquals(false, game.getStatus());
    }

    @Test
    public void cleanWinScore() {
        game.kick("Messi",true);
        game.kick("Messi",false);//1 0
        game.kick("Messi",true);
        game.kick("Messi",false);//2 0
        game.kick("Messi",true);
        game.kick("Messi",false);//3 0
        game.kick("Messi",true);
        game.kick("Messi",false);//4 0
        game.kick("Messi",true);
        game.kick("Messi",false);//5 0
        assertEquals("Arsenal(5:0)Liverpool", game.getScore());
    }

    @Test
    public void seventhsRollWinScore() {
        game.kick("Messi",true);
        game.kick("Messi",false);//1 0
        game.kick("Messi",false);
        game.kick("Messi",true);//1 1
        game.kick("Messi",true);
        game.kick("Messi",false);//2 1
        game.kick("Messi",true);
        game.kick("Messi",false);//3 1
        game.kick("Messi",true);
        game.kick("Messi",false);//4 1
        game.kick("Messi",true);
        game.kick("Messi",false);//5 1
        assertEquals("Arsenal(5:1)Liverpool", game.getScore());
    }


    @Test
    public void oneTeamRoll() {
        game.kick("Messi",false);
    }

    @Test
    public void playerKick() {
        PenaltyGame spyGame = spy(new PenaltyGame("Arsenal","Liverpool"));
        when(spyGame.getPlayerHistory("Messi")).thenReturn("[1,1,1,1,1]");

        assertEquals("[1,1,1,1,1],1", spyGame.kick("Messi", true));
    }

    @Test
    public void getScoreVSPrice() {
        PenaltyGame spyGame = spy(new PenaltyGame("Arsenal","Liverpool"));
        when(spyGame.getPlayerPrice("Messi")).thenReturn(1000);
        when(spyGame.getPlayerPrice("Petya")).thenReturn(500);
        when(spyGame.getPlayerPrice("Vasya")).thenReturn(200);


        spyGame.kick("Messi",false);
        spyGame.kick("Petya",false);
        spyGame.kick("Kolya",true);
        spyGame.kick("Vasya",false);

        System.out.println(game.getScoreVSLosersPrice());
        assertEquals("Arsenal(1:0)Liverpool (Arsenal losers price: 1000; Liverpool losers price: 700)",
                spyGame.getScoreVSLosersPrice());

    }

}
