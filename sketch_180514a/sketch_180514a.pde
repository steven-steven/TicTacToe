int screenMode = 0;  //0:initScreen 1:gameScreen 2:gameOverScreen 3:gameOverScreen

//UI Controls
ArrayList<Button> btnList = new ArrayList<Button>();    //UI Buttons to display


//gameItems
boolean[] gridVal = {false,false,true,false,false,false,false,true,false};
int margin = 50;
int gridSize;
int gridBoxSize;

/*------ Setup -------*/
void setup() {
  size(500, 500);
  
  gridSize = width-margin*2;
  gridBoxSize = gridSize/3;
  
  btnList.add(new Button("start", "Click To Begin", 20, new PVector(300, 80), new PVector(width/2, height/2)));
  btnList.add(new Button("restart_game", "Restart", 15, new PVector(100, 25), new PVector(80, height-20)));
  btnList.add(new Button("pause", "Pause", 15, new PVector(100, 25), new PVector(200, height-20)));
  btnList.add(new Button("continue", "Continue >>", 20, new PVector(300, 80), new PVector(width/2, 150)));
  btnList.add(new Button("restart_pause", "Restart", 20, new PVector(300, 80), new PVector(width/2, 300)));
}
void restart(){
  screenMode = 0; 
  
}

/*------ DRAW -------*/
void draw() {
  if (screenMode == 0) {
    initScreen();
  } else if (screenMode == 1) {
    gameScreen();
  } else if (screenMode == 2) {  //gameOver built on top of init
    initScreen();
    gameOverScreen();
  } else if (screenMode == 3) {
    pauseScreen();
  }else {
    initScreen();
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
}
void gameOverScreen() {
  textAlign(CENTER);
  text("YOU LOSE", width/2, height-50);
}
void winScreen() {
  textAlign(CENTER);
  text("YOU WIN!!", width/2, height-50);
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
    
  } else if (screenMode == 3) {  //pause
    if (btnList.get(3).btnHovered) {  //restart Button
      screenMode = 1;
    }else if (btnList.get(4).btnHovered) {  //restart Button
      restart();
    }
  }else if (screenMode == 2) {  //gameOver
    if (btnList.get(4).btnHovered) {  //restart Button
      restart();
    }
  }
}

/*Other Functions*/
void startGame() {
  screenMode = 1;
}
void gameOver() {
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
  text("Life: ", height-20, width-20);
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
    for (int i = 0; i<1; ++i) {  //control/display first 2 botton in arraylist
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  }else if(screenMode ==1){  //game
    for (int i = 1; i<3; ++i) {  //control/display first 2 botton in arraylist
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  }else if(screenMode == 3){  //pause
    for (int i = 3; i<5; ++i) {  //control/display first 2 botton in arraylist
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  } else if(screenMode == 2){  //pause
    for (int i = 4; i<btnList.size(); ++i) {  //control/display first 2 botton in arraylist
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
      if(gridVal[i]){  //if true
        int col = i%3;
        int row = i/3;
        rectMode(CORNER);
        fill(0);
        rect(margin+col*gridBoxSize, margin+row*gridBoxSize, gridBoxSize, gridBoxSize);
      }
    }
  
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