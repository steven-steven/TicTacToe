int screenMode = 0;  //0:initScreen 1:gameScreen 2:tieScreen 3:tieScreen

//UI Controls
ArrayList<Button> btnList = new ArrayList<Button>();    //UI Buttons to display


//gameItems
PImage xImg;
PImage yImg;
char[] gridVal = {' ',' ',' ',' ',' ',' ',' ',' ',' '};
int margin = 50;
int gridSize;
int gridBoxSize;
int currPlayer;
PImage currImg;

boolean win;  //flag if win
int stepCount = 0;

char winner;
int Player1;

/*------ Setup -------*/
void setup() {
  size(500, 500);
  
  xImg = loadImage("X.PNG");
  yImg = loadImage("Y.PNG");
  
  gridSize = width-margin*2;
  gridBoxSize = gridSize/3;
  
  btnList.add(new Button("start", "Click To Begin", 20, new PVector(300, 80), new PVector(width/2, height/2)));
  btnList.add(new Button("restart_game", "Restart", 15, new PVector(100, 25), new PVector(80, height-20)));
  btnList.add(new Button("pause", "Pause", 15, new PVector(100, 25), new PVector(200, height-20)));
  btnList.add(new Button("continue", "Continue >>", 20, new PVector(300, 80), new PVector(width/2, 150)));
  btnList.add(new Button("restart_pause", "Restart", 20, new PVector(300, 80), new PVector(width/2, 300)));
  
  Player1 = 1;
  currImg = xImg;
  currPlayer = 1;
}
void restart(){
  screenMode = 0; 
  stepCount = 0;
  for (int i = 0; i<gridVal.length; ++i) {
     gridVal[i] = ' '; 
  }
}

/*------ DRAW -------*/
void draw() {
  if (screenMode == 0) {
    initScreen();
  } else if (screenMode == 1) {
    gameScreen();
  } else if (screenMode == 2) {
    tieScreen();
  } else if (screenMode == 3) {
    pauseScreen();
  }else {
    winScreen();
  }
  buttonHandler();
}

/*------ SCREEN DRAW --------*/
void initScreen() {
  background(0);
  textAlign(CENTER);
  textSize(80);
  fill(255);
  text("TIC TAC TOE", width/2, 100);
}
void gameScreen() {
  background(255);
  drawText();
  drawGrid();
  gridHandler();
  if(win){
    checkWin();
  }
}
void tieScreen() {
  gameScreen();
  stroke(0);
  strokeWeight(1);
  fill(0,100);
  rectMode(CORNER);
  rect(0,0,width,height);
  
  textAlign(CENTER);
  textSize(80);
  fill(255);
  text("TIC TAC TOE", width/2, 100);
  textAlign(CENTER);
  text("TIE", width/2, height-50);
}
void winScreen() {
  gameScreen();
  stroke(0);
  strokeWeight(1);
  fill(0,100);
  rectMode(CORNER);
  rect(0,0,width,height);
  
  textAlign(CENTER);
  textSize(80);
  fill(255);
  text("TIC TAC TOE", width/2, 100);
  textAlign(CENTER);
  text(winner+" WIN!!", width/2, height-50);
}
void pauseScreen() {
  gameScreen();
  fill(0,200);
  rectMode(CORNER);
  rect(0,0,width,height);
}

/*--Input Interrupts--*/
public void mousePressed() {
  if (screenMode == 0) {
    if (btnList.get(0).btnHovered) {
      startGame();
    }
  } else if (screenMode == 1) {  //play
    if (btnList.get(1).btnHovered) {  //restart Button
      restart();
    }else if (btnList.get(2).btnHovered) {  //restart Button
      pause();
    }
    gridClickHandler();
    
  } else if (screenMode == 3) {  //pause
    if (btnList.get(3).btnHovered) {  //restart Button
      screenMode = 1;
    }else if (btnList.get(4).btnHovered) {  //restart Button
      restart();
    }
  }else if (screenMode == 2 || screenMode == 4) {  //Win
    if (btnList.get(4).btnHovered) {  //restart Button
      restart();
    }
  }
  
}

/*Other Functions*/
void startGame() {
  screenMode = 1;
}
void tie() {
  //Reset Game
  screenMode = 2;
}
void pause(){
  screenMode = 3; 
}
void drawText() {
  textAlign(RIGHT);
  fill(0);
  textSize(15);
  if(Player1 == 1){
    text("Player1: X  and  Player: O", height-20, width-20);
  }else{
    text("Player1: O  and  Player: X", height-20, width-20);
  }
}
void drawGrid(){
   stroke(0);
   fill(255);
   
   rectMode(CENTER);
   
   rect(width/2,height/2,gridSize, gridSize);
   for(int i = 0; i<3; ++i){
     line(gridSize/3*i + margin, height/2-gridSize/2, gridSize/3*i + margin, height/2+gridSize/2 );
   }
   for(int i = 0; i<3; ++i){
     line(width/2-gridSize/2, gridSize/3*i + margin, width/2+gridSize/2 , gridSize/3*i + margin);
   }
   
}


void buttonHandler() {
  if (screenMode ==0) {  //init
    //Submit input button
    for (int i = 0; i<1; ++i) {  //control/display first 'click to begin' button
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  }else if(screenMode ==1){  //game
    for (int i = 1; i<3; ++i) {  //control/display 'restart_game', 'pause'
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  }else if(screenMode == 3){  //pause
    for (int i = 3; i<5; ++i) {  //control/display 'continue', 'restart_pause' button
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  } else if(screenMode == 2 || screenMode == 4){  //tie or win
    for (int i = 4; i<btnList.size(); ++i) {  //control/display 'restart_pause' button
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  } 
}

void gridHandler(){
    for (int i = 0; i<gridVal.length; ++i) {
      int col = i%3;
      int row = i/3;
        
      if(gridVal[i] == 'x'){  //if true
        //rectMode(CORNER);
        //fill(0);
        //rect(margin+col*gridBoxSize, margin+row*gridBoxSize, gridBoxSize, gridBoxSize);
        imageMode(CORNER);
        tint(255,150);
        image(xImg, margin+col*gridBoxSize, margin+row*gridBoxSize, gridBoxSize-5, gridBoxSize-5);  
        tint(255,255);
      }else if(gridVal[i] == 'o'){
        imageMode(CORNER);
        tint(255,150);
        image(yImg, margin+col*gridBoxSize, margin+row*gridBoxSize, gridBoxSize-5, gridBoxSize-5);  
        tint(255,255);
      }else if(overRect(new PVector(margin+gridBoxSize/2+col*gridBoxSize, margin+gridBoxSize/2+row*gridBoxSize), new PVector(gridBoxSize,gridBoxSize))){
        imageMode(CORNER);
        tint(255,20);
        image(currImg, margin+col*gridBoxSize, margin+row*gridBoxSize, gridBoxSize-5, gridBoxSize-5);  
        tint(255,255);
      }
    } 
  
}
void gridClickHandler(){  //handle clicked box
  for (int i = 0; i<gridVal.length; ++i) {
      int col = i%3;
      int row = i/3;
        
      //if clicked on the box
      if(gridVal[i]==' ' && overRect(new PVector(margin+gridBoxSize/2+col*gridBoxSize, margin+gridBoxSize/2+row*gridBoxSize), new PVector(gridBoxSize,gridBoxSize))){
        stepCount++;
        rectMode(CORNER);
        fill(0);  //black flash on click
        rect(margin+col*gridBoxSize, margin+row*gridBoxSize, gridBoxSize, gridBoxSize);
  
        currPlayer ^=1;  //toggle player
        if(currPlayer == 1){
          currImg = xImg; 
          gridVal[i] = 'o';  //value to display(before toggle)
        }else{
          currImg = yImg; 
          gridVal[i] = 'x';
        }
        
        if(checkWin()){
          win = true;
        }else if(stepCount == 9){  //tie
          screenMode = 2;
        }
      }
    }
}

boolean checkWin(){
  
    int winStrokeWeight = 8;
    //check diagonals
    if(gridVal[0]!=' ' && gridVal[0]==gridVal[4] && gridVal[4]==gridVal[8]){
       stroke(255,0,0);
       strokeWeight(winStrokeWeight);
       line(0, 0, width-margin, height-margin);
       screenMode = 4; //win
       winner = gridVal[0];
       return true;
    }
    if(gridVal[2]!=' ' && gridVal[2]==gridVal[4] && gridVal[4]==gridVal[6]){
       stroke(255,0,0);
       strokeWeight(winStrokeWeight);
       line(width-margin, margin, margin, height-margin);
       screenMode = 4; //win
       winner = gridVal[2];
       return true;
    }
    
    //check rows
    for (int i = 0; i+2<gridVal.length; i+=3) {
      if(gridVal[i]!=' ' && gridVal[i]==gridVal[i+1] && gridVal[i+1]==gridVal[i+2] ){
          stroke(255,0,0);
          strokeWeight(winStrokeWeight);
          int row = i/3;
          line(margin, margin+gridBoxSize*row+gridBoxSize/2, width-margin, margin+gridBoxSize*row+gridBoxSize/2);
          screenMode = 4; //win
          winner = gridVal[i];
          return true;
      }
    }
    
    //check columns
    for (int i = 0; i<3; ++i) {
      if(gridVal[i]!=' ' && gridVal[i]==gridVal[i+3] && gridVal[i+3]==gridVal[i+6] ){
         stroke(255,0,0);
         strokeWeight(winStrokeWeight);
          int col = i%3;
          line(margin+gridBoxSize*col+gridBoxSize/2, margin, margin+gridBoxSize*col+gridBoxSize/2, height-margin);
          screenMode = 4; //win
          winner = gridVal[2];
          return true;
      }
    }
    
    return false;
}

boolean overRect(PVector pos, PVector size) {
  if (mouseX >= pos.x-size.x/2 && mouseX <= pos.x+size.x/2 &&
    mouseY >= pos.y-size.y/2 && mouseY <= pos.y+size.y/2) {
    return true;
  } else {
    return false;
  }
}

//Button Class: Implemented property of all UI Buttons

class Button {
  String id;
  String tag;
  PVector size; //x = width; y = height
  PVector pos; //left top corner
  boolean btnHovered;
  int fontSize;

  public Button(String id, String text, int font_size, PVector size, PVector pos) {
    this.id = id;
    tag = text;
    this.size = size;
    this.pos = pos;
    btnHovered = false;
    fontSize = font_size;
  }

  void drawBtn() {
    if (btnHovered) {
      fill(0);  //background black if hovered
    } else {
      fill(255); //else white (default)
    }
    stroke(0);
    rectMode(CENTER);
    rect(pos.x, pos.y, size.x, size.y);

    if (btnHovered) {
      fill(255);
    } else {
      fill(0);
    }
    textSize(fontSize);
    textAlign(CENTER, CENTER);
    text(tag, pos.x, pos.y, size.x, size.y);
  }
}