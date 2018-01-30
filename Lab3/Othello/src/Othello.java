import java.util.Scanner;

public class Othello {
    public char[] charArray;
    public int[] moveArray;
    public int wScore;
    public int bScore;
    public static boolean debug = false;

    public Othello() {
        this.charArray = new char[64];
        for (int i = 0; i < 64; i++) {
            this.charArray[i] = 'O';
        }
        this.charArray[27] = 'W';
        this.charArray[28] = 'B';
        this.charArray[36] = 'W';
        this.charArray[35] = 'B';
        this.moveArray = new int[]{1,0, 1,1, 0,1, -1,1, -1,0, -1,-1, 0,-1, 1,-1};
        this.wScore = 2;
        this.bScore = 2;
    }

    public boolean move(char chance, int x, int y) {
        boolean valid = false;
        int arrCoordinate = to1D(x, y);
        char current;

        if (this.charArray[arrCoordinate]=='O') {
            this.charArray[arrCoordinate] = chance;
        } else {
            return false;
        }

        for (int a=0; a<=7; a++) {
            int i = x + this.moveArray[2*a];
            int j = y + this.moveArray[2*a+1];
            Othello.print("move array");
            Othello.print(this.moveArray[2*a]);
            Othello.print(this.moveArray[2*a+1]);
            while (0 <= i && i <= 7 && 0 <= j && j <= 7) {
                Othello.print("forward while");
                Othello.print(i);
                Othello.print(j);
                current = charArray[to1D(i, j)];
                if (current == chance) {
                    Othello.print("cond");
                    Othello.print(i);
                    Othello.print(j);
                    i = i - this.moveArray[2*a];
                    j = j - this.moveArray[2*a+1];
                    Othello.print(i);
                    Othello.print(j);
                    Othello.print(x);
                    Othello.print(y);
                    while (!(i == x && j == y)) {
                        valid = true;
                        Othello.print("back while");
                        Othello.print(i);
                        Othello.print(j);
                        this.charArray[to1D(i, j)] = chance;
                        if (chance=='W') {
                            this.wScore++;
                            this.bScore--;
                        } else {
                            this.bScore++;
                            this.wScore--;
                        }
                        i = i - this.moveArray[2*a];
                        j = j - this.moveArray[2*a+1];
                    }
                    break;
                } else if (current=='O') {
                    Othello.print("empty break");
                    break;
                }
                i = i + this.moveArray[2*a];
                j = j + this.moveArray[2*a+1];
            }
        }


        if (!valid) {
            this.charArray[arrCoordinate] = 'O';
        }

        return valid;
    }

    public int to1D (int x, int y) {
        return y*8 + x;
    }

    public static void print(Object o) {
        if (debug) {
            System.out.println(o);
        }
    }

    @Override
    public String toString() {
        StringBuilder s = new StringBuilder();
        s.append("  0 1 2 3 4 5 6 7 x\n");
        for (int i=0; i<=7; i++) {
            s.append(i);
            s.append(" ");
            s.append(this.charArray[8*i]);
            s.append(" ");
            s.append(this.charArray[8*i+1]);
            s.append(" ");
            s.append(this.charArray[8*i+2]);
            s.append(" ");
            s.append(this.charArray[8*i+3]);
            s.append(" ");
            s.append(this.charArray[8*i+4]);
            s.append(" ");
            s.append(this.charArray[8*i+5]);
            s.append(" ");
            s.append(this.charArray[8*i+6]);
            s.append(" ");
            s.append(this.charArray[8*i+7]);
            s.append("\n");
        }
        s.append("y");
        return s.toString();
    }

    public static void main(String[] args) {
        Othello board = new Othello();
        Scanner input = new Scanner(System.in);
        int moves = 4;
        int x, y;
        boolean forward = false;
        while (moves<=64) {
            for (int i = 0; !forward && i < 4; i++) {
                System.out.println(board);
                System.out.println("Chance W");
                System.out.println("x: ");
                x = input.nextInt();
                System.out.println("y: ");
                y = input.nextInt();
                forward = board.move('W', x, y);
            }

            if (forward) {
                moves++;
                forward = false;
            }

            for (int i = 0; !forward && i < 4; i++) {
                System.out.println(board);
                System.out.println("Chance B");
                System.out.println("x: ");
                x = input.nextInt();
                System.out.println("y: ");
                y = input.nextInt();
                forward = board.move('B', x, y);
            }

            if (forward) {
                moves++;
                forward = false;
            }
        }
        System.out.println("W: ");
        System.out.println(board.wScore);
        System.out.println("B: ");
        System.out.println(board.bScore);

    }
}
