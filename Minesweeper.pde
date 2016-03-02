

import de.bezier.guido.*;
public int NUM_ROWS = 10;
public int NUM_COLS = 10;
public int nBombs = 5;
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
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            if(bombs.contains(buttons[r][c]) && !buttons[r][c].isMarked())
                return false;
        }
    } 
    return true; 
}
public void displayLosingMessage()
{
    stroke(255,50,50);
    String loseMessage = "You Lose!";
    int midRow = (int)(NUM_ROWS / 2);
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            buttons[r][c].lost = true;
            buttons[r][c].setLabel("");
            if(bombs.contains(buttons[r][c])){
                buttons[r][c].setLabel("B");
                buttons[r][c].lost = false;
            }

        }
    }
    for(int i = 0; i < loseMessage.length(); i++){
        buttons[midRow][i+((NUM_COLS - 1 - loseMessage.length())/2)].setLabel(loseMessage.substring(i, i+1));
    }
}
public void displayWinningMessage()
{
    stroke(0,255,0);
    String winMessage = "You Win!";
    int midRow = (int)(NUM_ROWS / 2);
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            buttons[r][c].won = true;
            buttons[r][c].setLabel("");
        }
    }
    for(int i = 0; i < winMessage.length(); i++){
        buttons[midRow][i+((NUM_COLS - winMessage.length())/2)].setLabel(winMessage.substring(i, i+1));
    }
    
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, won, lost;
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
        won = lost = false;
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
        if(keyPressed && key == 'm'){
            marked = !marked;
        }
        else if(bombs.contains(this)){
            displayLosingMessage();
        }
        else if(countBombs(r,c) != 0){
            label = "" + countBombs(r,c);
        }
        else{
            // for(int i = -1; i < 2; i++){
            //     for(int j = -1; j < 2; j++){
            //          if(i != 0 || j != 0){
            //              if(isValid(r+i,c+j) && !buttons[r+i][c+j].isClicked()){
            //                 System.out.println(isValid(r+i,c+j) && !buttons[r+i][c+j].isClicked());
            //                  buttons[r+i][c+j].mousePressed();
            //              }
            //          }
            //     }
            // }
            if(isValid(r-1,c-1) && !buttons[r-1][c-1].isClicked())
                buttons[r-1][c-1].mousePressed();

            if(isValid(r-1,c) && !buttons[r-1][c].isClicked())
                buttons[r-1][c].mousePressed();
            
            if(isValid(r-1,c+1) && !buttons[r-1][c+1].isClicked())
                buttons[r-1][c+1].mousePressed();
            
            if(isValid(r,c-1) && !buttons[r][c-1].isClicked())
                buttons[r][c-1].mousePressed();
            
            if(isValid(r,c+1) && !buttons[r][c+1].isClicked())
                buttons[r][c+1].mousePressed();
            
            if(isValid(r+1,c-1) && !buttons[r+1][c-1].isClicked())
                buttons[r+1][c-1].mousePressed();
            
            if(isValid(r+1,c) && !buttons[r+1][c].isClicked())
                buttons[r+1][c].mousePressed();
            
            if(isValid(r+1,c+1) && !buttons[r+1][c+1].isClicked())
                buttons[r+1][c+1].mousePressed();
            
        }

    }

    public void draw () 
    {   
        if(won)
            fill(0,255,0);
        else if(lost)
            fill(255,0,0); 
        else if (marked)
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
         if(r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0)
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
public void keyPressed(){
    if(keyPressed && keyCode == 32){
        stroke(0);
        for(int rows = 0; rows < NUM_ROWS; rows++){
            for(int cols = 0; cols < NUM_COLS; cols++){
                buttons[rows][cols].won = false;
                buttons[rows][cols].lost = false;
                buttons[rows][cols].marked = false;
                buttons[rows][cols].clicked = false;
                buttons[rows][cols].label = "";
            }
        }
        for(int i = bombs.size()-1; i >= 0; i--){
            bombs.remove(i);
        }
        setBombs();
    }
}
public void keyReleased(){
     if(keyCode == UP && NUM_ROWS < 25){
        System.out.println("up");
        NUM_ROWS += 1;
        NUM_COLS += 1;
        buttons = new MSButton[NUM_ROWS][NUM_COLS];
        background(0);
        for(int rows = 0; rows < NUM_ROWS; rows++){
            for(int cols = 0; cols < NUM_COLS; cols++){
                buttons[rows][cols] = new MSButton(rows, cols);
            }
        }
        nBombs = NUM_ROWS/4;
        setBombs();
    }
    if(keyCode == DOWN && NUM_ROWS > 4){
        System.out.println("down");
        NUM_ROWS -= 1;
        NUM_COLS -= 1;
        buttons = new MSButton[NUM_ROWS][NUM_COLS];
        background(0);
        for(int rows = 0; rows < NUM_ROWS; rows++){
            for(int cols = 0; cols < NUM_COLS; cols++){
                buttons[rows][cols] = new MSButton(rows, cols);
            }
        }
        nBombs = NUM_ROWS/4;
        setBombs();
    }
}
