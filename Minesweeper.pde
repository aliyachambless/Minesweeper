

import de.bezier.guido.*;
public int NUM_ROWS = 20;
public int NUM_COLS = 20;
public int nBombs = 10;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined


void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    for(int rows = 0; rows < NUM_ROWS; rows++){
        for(int cols = 0; cols < NUM_COLS; cols++){
            buttons[rows][cols] = new MSButton(rows, cols);
        }
    }
    
    
    setBombs();
}
public void setBombs()
{
    int numB = 0;
    while(numB < nBombs){
        int r = (int)(Math.random()*NUM_ROWS);
        int c = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[r][c])){
            bombs.add(buttons[r][c]);
            numB ++;
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    //your code here
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(keyPressed){
            marked = !marked;
        }
        else if(bombs.contains(this)){
            displayLosingMessage();
        }
        else if(countBombs(r,c) != 0){
            label = "" + countBombs(r,c);
        }
        else{
            for(int i = -1; i < 2; i++){
                for(int j = -1; j < 2; j++){
                    System.out.println(i != 0 || j != 0);
                     if(i != 0 || j != 0){
                    //     if(isValid(r+i,c+j) && !buttons[r+i][c+j].isClicked()){
                    //         buttons[r+i][c+j].mousePressed();
                    //     }
                     }
                }
            }
        }

    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
         if(r < NUM_ROWS && c < NUM_COLS)
             return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int i = -1; i < 2; i++){
            for(int j = -1; j < 2; j++){
                if(isValid(row + i,col + j) && bombs.contains(buttons[row + i][col + j]))
                    numBombs++;
            }
        }
        return numBombs;
    }
}



