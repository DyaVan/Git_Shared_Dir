package com.diachuk.tdd.bowling;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

/**
 * Created by VA-N_ on 14.03.2017.
 */
public class BowlingGameTest  {

    public static BowlingGame testedBowlingGame;

    @Before
    public void setBowlingGame() {
        testedBowlingGame = new BowlingGame();
    }

    @Test
    public void canCreateGame(){
        assertNotNull(testedBowlingGame);
    }

    @Test
    public void canThrow(){
        testedBowlingGame.throwBall(0);
    }

    @Test
    public void canGetScore(){
        assertTrue(testedBowlingGame.getScore()>=0);
    }

    @Test
    public void allOnes() {
        throwMany(20,4);
        assertEquals(80,testedBowlingGame.getScore());
    }

    @Test
    public void testForSpares(){
        throwMany(10,5);
        throwMany(1,1);
        assertEquals(72,testedBowlingGame.getScore());
    }

    @Test
    public void testForStrikes(){
        throwMany(1,10);
        throwMany(18,1);
        assertEquals(30,testedBowlingGame.getScore());
    }

//    @Ignore
    @Test
    public void perfectGame(){
        throwMany(12,10);
        assertEquals(300, testedBowlingGame.getScore());
    }

    private void throwMany(int countOfRolls, int score) {
        for(int i = 0; i<countOfRolls;i++) {
            testedBowlingGame.throwBall(score);
        }
    }

}
