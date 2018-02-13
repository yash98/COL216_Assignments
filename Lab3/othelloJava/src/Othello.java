import java.util.Scanner;

public class Othello {
    public int movesDone;
    public char[] board;
    public int wScore;
    public int bScore;
    public int[] moveArr;

    public Othello() {
        this.board = new char[]{'0', '0', '0', '0', '0', '0', '0', '0',
                                '0', '0', '0', '0', '0', '0', '0', '0',
                                '0', '0', '0', '0', '0', '0', '0', '0',
                                '0', '0', '0', 'W', 'B', '0', '0', '0',
                                '0', '0', '0', 'B', 'W', '0', '0', '0',
                                '0', '0', '0', '0', '0', '0', '0', '0',
                                '0', '0', '0', '0', '0', '0', '0', '0',
                                '0', '0', '0', '0', '0', '0', '0', '0'};
        this.movesDone = 4;
        this.wScore = 2;
        this.bScore = 2;
        this.moveArr = new int[]{1,0, 1,1, 0,1, -1,1, -1,0, -1,-1, 0,-1, 1,-1};
    }

    public int to1D(int x, int y) {
        return 8*y + x;
    }

    public boolean obtainPlaces(char chance) {
        int oneD;
        int mx;
        int my;
        int tx;
        int ty;
        boolean anyPlace = false;
        for (int x=0; x<8; x++) {
            for (int y=0; y<8; y++) {
                oneD = to1D(x, y);
                if (this.board[oneD] == 'W' || this.board[oneD] == 'B') {
                    for (int m=0; m<8; m++) {
                        mx = moveArr[2*m];
                        my = moveArr[2*m+1];
                        tx = x+mx;
                        ty = y+my;
                        oneD = to1D(tx, ty);
                        if (this.board[oneD] == '0') {
                            anyPlace |= checkPlace(tx, ty, chance);
                        }
                    }
                }
            }
        }
        return anyPlace;
    }

    public boolean checkPlace(int x, int y, char chance) {
        int tx, ty, mx, my, oneD;
        boolean possible = false;
        for (int m=0; m<8; m++) {
            mx = moveArr[2*m];
            my = moveArr[2*m+1];
            tx = x+mx;
            ty = y+my;
            oneD = to1D(tx, ty);
            if (!(this.board[oneD] == '0' || this.board[oneD] == 'P' || this.board[oneD] == chance)){
                while (0<=tx && tx<=7 && 0<=ty && ty<=7) {
                    oneD = to1D(tx, ty);
                    if (this.board[oneD] == '0' || this.board[oneD] == 'P') {
                        break;
                    }
                    if (this.board[oneD] == chance) {
                        possible = true;
                        oneD = to1D(x, y);
                        this.board[oneD] = 'P';
                        return possible;
                    }
                    tx += mx;
                    ty += my;
                }
            }
        }
        return possible;
    }

    public void clearP() {
        int oneD;
        for (int x=0; x<8; x++) {
            for (int y=0; y<8; y++) {
                oneD = to1D(x, y);
                if (this.board[oneD] == 'P') {
                    this.board[oneD] = '0';
                }
            }
        }
    }

    public boolean move(int x, int y, char chance) {
        int oneD = to1D(x, y);
        int tx, ty, mx, my;
        if (this.board[oneD] == 'P') {
            this.clearP();
            this.board[oneD] = chance;
            if (chance == 'W') {
                this.wScore++;
            } else {
                this.bScore++;
            }
            for (int m=0; m<8; m++) {
                mx = moveArr[2*m];
                my = moveArr[2*m+1];
                tx = x+mx;
                ty = y+my;
                while (0<=tx && tx<=7 && 0<=ty && ty<=7) {
                    oneD = to1D(tx, ty);
                    if (this.board[oneD] == '0'){
                        break;
                    }
                    if (this.board[oneD] == chance) {
                        tx -= mx;
                        ty -= my;
                        while (!(tx==x && ty==y)) {
                            oneD = to1D(tx, ty);
                            this.board[oneD] = chance;
                            if (chance == 'W') {
                                this.wScore++;
                                this.bScore--;
                            } else {
                                this.bScore++;
                                this.wScore--;
                            }
                            tx -= mx;
                            ty -= my;
                        }
                        break;
                    }
                    tx += mx;
                    ty += my;
                }
            }
            this.movesDone++;
            return true;
        } else {
            return false;
        }
    }

    public void display() {
        StringBuilder s = new StringBuilder();
        s.append("  0 1 2 3 4 5 6 7 x\n");
        for (int i=0; i<=7; i++) {
            s.append(i);
            s.append(" ");
            s.append(this.board[8*i]);
            s.append(" ");
            s.append(this.board[8*i+1]);
            s.append(" ");
            s.append(this.board[8*i+2]);
            s.append(" ");
            s.append(this.board[8*i+3]);
            s.append(" ");
            s.append(this.board[8*i+4]);
            s.append(" ");
            s.append(this.board[8*i+5]);
            s.append(" ");
            s.append(this.board[8*i+6]);
            s.append(" ");
            s.append(this.board[8*i+7]);
            s.append("\n");
        }
        s.append("y");
        System.out.println(s.toString());
    }

    public static void main(String[] args) {
        Othello game = new Othello();
        Scanner s = new Scanner(System.in);
        boolean prevNotStale = true;
        boolean notStale = true;
        boolean rightMove = false;
        int x, y;
        char prevChance = 'B';
        while (game.movesDone <= 64) {
            if (prevChance == 'W') {
                prevChance = 'B';
            } else {
                prevChance = 'W';
            }
            prevNotStale = notStale;
            notStale = game.obtainPlaces(prevChance);
            if (!(notStale || prevNotStale)) {
                break;
            }
            if (!(notStale)) {
                game.clearP();
                continue;
            }
            while (!(rightMove)) {
                System.out.println("Chance: " + prevChance);
                game.display();
                System.out.println("W Score: " + game.wScore);
                System.out.println("B Score: " + game.bScore);
                System.out.println("x: ");
                x = s.nextInt();
                System.out.println("y: ");
                y = s.nextInt();
                rightMove = game.move(x, y, prevChance);
                if (!rightMove) {
                    System.out.println("Wrong Place");
                }
            }
            rightMove = false;
        }
        System.out.println("Game End");
        if (game.wScore>game.bScore) {
            System.out.println("W wins");
        } else if (game.bScore>game.wScore) {
            System.out.println("B wins");
        } else {
            System.out.println("Draw");
        }
        System.out.println("W Score: " + game.wScore);
        System.out.println("B Score: " + game.bScore);
    }
}
