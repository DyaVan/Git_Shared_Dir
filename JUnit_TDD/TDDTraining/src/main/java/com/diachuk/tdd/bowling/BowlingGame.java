package com.diachuk.tdd.bowling;

/**
 * Created by VA-N_ on 15.03.2017.
 */
public class BowlingGame {

    int[] attempts = new int[21];
    int currentattempt = 0;

    public int throwBall(int pins) {
        return attempts[currentattempt++] = pins;
    }

    public int getScore() {
        int score = 0;
        int firstInFrame = 0;
        for (int i = 0; i < 10; i++) {
            if (isStrike(firstInFrame)) {
                score += getStrikeScore(firstInFrame);
                firstInFrame++;
            } else {
                int frameScore = getFrameScore(firstInFrame);
                if (isSpare(frameScore)) {
                    score += getSpareScore(firstInFrame);
                } else {
                    score += frameScore;
                }
                firstInFrame += 2;
            }
        }
        return score;
    }

    private int getSpareScore(int firstInFrame) {
        return 10 + attempts[firstInFrame + 2];
    }

    private int getFrameScore(int firstInFrame) {
        return attempts[firstInFrame] + attempts[firstInFrame + 1];
    }

    private int getStrikeScore(int firstInFrame) {
        return 10 + attempts[firstInFrame + 1] + attempts[firstInFrame + 2];
    }

    private boolean isSpare(int frameScore) {
        return frameScore == 10;
    }

    private boolean isStrike(int firstInFrame) {
        return attempts[firstInFrame] == 10;
    }
}
