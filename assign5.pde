PImage enemy, bg1,bg2,bg3,bg4,start1,start2,end1,end2,hp,treasure,fighter,bullet;
int gameState;
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;

int x;
int score;
int blood;

int enemyCount = 8;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
int enemyType;

int treasureX,treasureY;

int fighterX,fighterY;
int fighterSpeed=5;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

boolean[] bulletNum= new boolean[5]; 
int n;
int bulletSpeed = 8;
int[] bulletX = new int[5];
int[] bulletY = new int[5];

int min;

PImage[] fire = new PImage [5];
int flame;
int flameCurrent;
int[] hitPositionX  = new int [5];
int[] hitPositionY  = new int [5];

void setup () {
	size(640, 480) ;
  frameRate(60);
  
	enemy = loadImage("img/enemy.png");
  
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  bg3 = loadImage("img/bg1.png");
  bg4 = loadImage("img/bg2.png");
  
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  
  hp = loadImage("img/hp.png");
  
  treasure = loadImage("img/treasure.png");
  
  fighter = loadImage("img/fighter.png");
  
  bullet  = loadImage("img/shoot.png");
  
  for ( int i = 0; i < 5; i++ ){
    fire[i] = loadImage ("img/flame" + (i+1) + ".png" );
  }
  
  initGame();
}

void draw()
{
  switch(gameState){
    case GAME_START:
      image (start2, 0, 0);     
      if (mouseX>=150 && mouseX<=450 && mouseY>=350 && mouseY<=430){
            image(start1, 0, 0);
            if(mousePressed){
              gameState = GAME_RUN;
            }
      }
      break;
    case GAME_RUN:
    	  //bg
        if(640+x%1280>640){
            image(bg1,-1280,0,640,480);
          }
        if(0+x%1280>640){
            image(bg2,-1280,0,640,480);
          }
        if(1280+x%1280>640){
            image(bg3,-1280,0,640,480);
          }
        if(-1280+x%1280>640){
            image(bg4,-1280,0,640,480);
          }
         image(bg1,640+x%1280,0,640,480);
         image(bg2,0+x%1280,0,640,480);
         image(bg3,-640+x%1280,0,640,480);
         image(bg4,-1280+x%1280,0,640,480);
         x+=4;   
         
         //blood
         noStroke();
         fill(255,0,0);
         rect(10,5,blood,20);
         
        //hp
        image(hp,1,0);
         
        //treasure
        image(treasure,treasureX,treasureY);
         
        //fighter
        image(fighter, fighterX, fighterY);
        
        if (upPressed && fighterY > 0) {
          fighterY -= fighterSpeed ;
        }
        if (downPressed && fighterY < 480 - 50) {
          fighterY += fighterSpeed ;
        }
        if (leftPressed && fighterX > 0) {
          fighterX -= fighterSpeed ;
        }
        if (rightPressed && fighterX < 640 - 50) {
          fighterX += fighterSpeed ;
        } 
        
        //bullet
        for (int i = 0; i < 5; i ++){
          if (bulletNum[i] == true){
            image (bullet, bulletX[i], bulletY[i]);
            bulletX[i] -= bulletSpeed;
            closestEnemy(bulletX[i],bulletY[i]);
            if(bulletY[i]>enemyY[min]){
               bulletY[i]--;
            }else if(bulletY[i]<enemyY[min]){
               bulletY[i]++;
            }else{
               bulletY[i]+=0;
            }
          }
          if (bulletX[i] <- bullet.width){
            bulletNum[i] = false;
          } 
        }
        
        //flame
          image(fire[flameCurrent], hitPositionX[flameCurrent], hitPositionY[flameCurrent]);      
          flame++;
          if ( flame%6 == 0){
            flameCurrent ++;
          } 
          if ( flameCurrent > 4){
            flameCurrent = 0;
          }
          if(flame>31){
            for (int i = 0; i < 5; i ++){
              hitPositionX[i] = 1000;
              hitPositionY[i] = 1000;
            }
          }  
       
        //enemy 
      	for (int i = 0; i < enemyCount; ++i) {
      		if (enemyX[i] != -1 || enemyY[i] != -1) {
      			image(enemy, enemyX[i], enemyY[i]);
      			enemyX[i]+=5;
      		}
      	}
        if(enemyType%3==0){
          if(enemyX[4]>width){
            enemyType++;
            addEnemy(enemyType);
            }
          for(int i=0;i<5;i++){
            if(isHit(enemyX[i],enemyY[i],enemy.width,enemy.height,fighterX,fighterY,fighter.width,fighter.height)){
              for(int k=0;k<5;k++){
                  hitPositionX[k] = enemyX[i];
                  hitPositionY[k] = enemyY[i];
                }
              blood-=(200/100)*20;
              if(blood<=0){
                gameState= 2;
              }
              flame= 0;
              enemyY[i]=1000;
            }
             for(int j=0;j<5;j++){
              if(isHit(bulletX[j],bulletY[j],bullet.width,bullet.height,enemyX[i],enemyY[i],enemy.width,enemy.height) && bulletNum[j]==true){
                for(int k=0;k<5;k++){
                  hitPositionX[k] = enemyX[i];
                  hitPositionY[k] = enemyY[i];
                }
                scoreChange(score);
                enemyY[i]=1000;
                bulletNum[j]=false;
                bulletY[j] = -1000;
                flame = 0;
              }
             } 
          }
         }else if(enemyType%3==1){
           if(enemyX[4]>width){
              enemyType++;
              addEnemy(enemyType);
           }
           for(int i=0;i<5;i++){
            if(isHit(enemyX[i],enemyY[i],enemy.width,enemy.height,fighterX,fighterY,fighter.width,fighter.height)){
               for(int k=0;k<5;k++){
                  hitPositionX[k] = enemyX[i];
                  hitPositionY[k] = enemyY[i];
                }
              blood-=(200/100)*20;
              if(blood<=0){
                gameState= 2;
                }
               flame = 0;
                enemyY[i]=1000;
            }
            for(int j=0;j<5;j++){
              if(isHit(bulletX[j],bulletY[j],bullet.width,bullet.height,enemyX[i],enemyY[i],enemy.width,enemy.height) && bulletNum[j]==true){
                for(int k=0;k<5;k++){
                  hitPositionX[k] = enemyX[i];
                  hitPositionY[k] = enemyY[i];
                }
                scoreChange(score);
                enemyY[i]=1000;
                bulletNum[j]=false;
                bulletY[j] = -1000;
                flame = 0;
              }
             } 
          }
         }else{
           if(enemyX[7]>width){
              enemyType-=2;
              addEnemy(enemyType);
         }
           for(int i=0;i<8;i++){
              if(isHit(enemyX[i],enemyY[i],enemy.width,enemy.height,fighterX,fighterY,fighter.width,fighter.height)){
                for(int k=0;k<5;k++){
                  hitPositionX[k] = enemyX[i];
                  hitPositionY[k] = enemyY[i];
                }
                blood-=(200/100)*20;
                if(blood<=0){
                  gameState= 2;
                }
                flame = 0;
                enemyY[i]=1000;
              }
             for(int j=0;j<5;j++){
              if(isHit(bulletX[j],bulletY[j],bullet.width,bullet.height,enemyX[i],enemyY[i],enemy.width,enemy.height)&& bulletNum[j]==true){
                for(int k=0;k<5;k++){
                  hitPositionX[k] = enemyX[i];
                  hitPositionY[k] = enemyY[i];
                }
                scoreChange(score);
                enemyY[i]=1000;
                bulletNum[j]=false;
                bulletY[j] = -1000;
                flame=0;
              }
             } 
          }
       }
       
       //treasure
       if(isHit(treasureX,treasureY,treasure.width,treasure.height,fighterX,fighterY,fighter.width,fighter.height)){
         if(blood>=200){
           blood = 200;
         }else{
           blood+=(200/100)*10;
         }
          treasureX = floor(random(50, 590));
          treasureY = floor(random(50, 430));
       }
       
       //score
        fill(255);
        textSize(20);
        text("Score:"+ score,50,450);
        break;
    case GAME_OVER :
      image(end2, 0, 0);     
      if ( mouseX>=180 && mouseX<=450 && mouseY>=280 && mouseY<=360){
            image(end1, 0, 0);
            if(mousePressed){
              setup();
              gameState = GAME_START;
            }
      }
    break;
  }
}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{	
	for (int i = 0; i < enemyCount; ++i) {
		enemyX[i] = -1;
		enemyY[i] = -1;
	}
	switch (type) {
		case 0:
			addStraightEnemy();
			break;
		case 1:
			addSlopeEnemy();
			break;
		case 2:
			addDiamondEnemy();
			break;
	}
}

void addStraightEnemy()
{
	float t = random(height - enemy.height);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h;
	}
}
void addSlopeEnemy()
{
	float t = random(height - enemy.height * 5);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h + i * 40;
	}
}
void addDiamondEnemy()
{
	float t = random( enemy.height * 3 ,height - enemy.height * 3);
	int h = int(t);
	int x_axis = 1;
	for (int i = 0; i < 8; ++i) {
		if (i == 0 || i == 7) {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h;
			x_axis++;
		}
		else if (i == 1 || i == 5){
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 1 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 1 * 40;
			i++;
			x_axis++;
			
		}
		else {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 2 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 2 * 40;
			i++;
			x_axis++;
		}
	}
}
void keyPressed (){
  if (key == CODED) {
    switch ( keyCode ) {
      case UP :
        upPressed = true ;
        break ;
      case DOWN :
        downPressed = true ;
        break ;
      case LEFT :
        leftPressed = true ;
        break ;
      case RIGHT :
        rightPressed = true ;
        break ;
    }
  }
}

void keyReleased () {
  if (key == CODED) {
    switch ( keyCode ) {
      case UP : 
        upPressed = false ;
        break ;
      case DOWN :
        downPressed = false ;
        break ;
      case LEFT :
        leftPressed = false ;
        break ;
      case RIGHT :
        rightPressed = false ;
        break ;
      }  
    } 
    if ( keyCode == ' '){
          if (gameState == GAME_RUN){
            if (bulletNum[n] == false){
              bulletNum[n] = true;
              bulletX[n] = fighterX-30;
              bulletY[n] = fighterY+15;
              n ++;
            }   
            if (n> 4) {
              n=0;
            }
          }
        }
}

void initGame(){
  blood  = (200/100)*20;
  addEnemy(0);
  
  treasureX = floor(random(50, 590));
  treasureY = floor(random(50, 430));
  
  fighterX = width-50;
  fighterY = height/2 ; 
  
  for(int i=0;i<bulletNum.length;i++){
    bulletNum[i] = false;
  }
  
  flame=0;
  flameCurrent = 0;
  for ( int i = 0; i < hitPositionX.length; i ++){
    hitPositionX[i] = 2000;
    hitPositionY[i] = 2000;
  }
  
  score = 0;
}

boolean isHit(int ax,int ay,int aw,int ah,int bx,int by,int bw,int bh){
  boolean collisionX = (ax + aw >= bx) && (bx + bw >= ax);
  boolean collisionY = (ay + ah >= by) && (by + bh >= ay);
  return collisionX && collisionY;
}

void scoreChange(int value){
  value+=20;
  score=value;  
}

int closestEnemy(int x,int y){
  float distance = sqrt(sq(x-enemyX[0])+sq(y-enemyY[0]));
  if(enemyType%3==0){
    for(int i =0;i<5;i++){
      if(enemyX[i] != -1 || enemyY[i] != -1){
        if(sqrt(sq(x-enemyX[i])+sq(y-enemyY[i]))<=distance){
          distance = sqrt(sq(x-enemyX[i])+sq(y-enemyY[i]));
          min = i;
          }
         }else{
            min = -1;
         }
      }
  }else if(enemyType%3==1){
     for(int i =0;i<5;i++){
      if(enemyX[i] != -1 || enemyY[i] != -1){
        if(sqrt(sq(x-enemyX[i])+sq(y-enemyY[i]))<=distance){
          distance = sqrt(sq(x-enemyX[i])+sq(y-enemyY[i]));
          min = i;
        }
       }else{
          min = -1;
       }
    }
  }else{
    for(int i =0;i<8;i++){
      if(enemyX[i] != -1 || enemyY[i] != -1){
        if(sqrt(sq(x-enemyX[i])+sq(y-enemyY[i]))<=distance){
          distance = sqrt(sq(x-enemyX[i])+sq(y-enemyY[i]));
          min = i;
        }
       }else{
          min = -1;
       }
    }
  } 
  return min;
}
