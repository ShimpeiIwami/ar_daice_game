String[] diceList  = {"1","2","3","4","5","6"}; //面の文字を入力

//メイン部分
int state;    // 現在の状態 (0=タイトル, 1=ゲーム, 2=エンディング)
long t_start; // 現在の状態になった時刻[ミリ秒]
float t;      // 現在の状態になってからの経過時間[秒]
int xbox,ybox;
int[] ranx = new int[30];
int[] rany = new int[30];
int[][] ive = new int[31][4];  //升目の情報 x,y,イベント番号,踏んだ花粉でないかとか？
int difficult=-1; //難易度調整
int goal=0;
int[][] chara=new int[2][2];  //プレイヤー [0]升目 [1]イベントで使うなら
int event=0;
int turn=0;    //ターンプレイヤー
int dice=0; //サイコロを降ったか降ってないか
int deme; //出目の値
int eventnum=7; //イベントの種類
int sup;
String yourDice="";
boolean eveIns = false;
//イベント部分
String[] eventdice = {"0","0","0","0","0","0"};
String b="";

int i;
int a=0;

//仮のサイコロ
String[][] playersDice=new String[2][6];

class SecondApplet extends PApplet {
  PApplet parent;
   
  SecondApplet(PApplet _parent) {
    super();
    // set parent
    this.parent = _parent;
    //// init window
    try {
      java.lang.reflect.Method handleSettingsMethod =
        this.getClass().getSuperclass().getDeclaredMethod("handleSettings", null);
      handleSettingsMethod.setAccessible(true);
      handleSettingsMethod.invoke(this, null);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    
    PSurface surface = super.initSurface();
    surface.placeWindow(new int[]{0, 0}, new int[]{0, 0});
    
    this.showSurface();
    this.startSurface();
  }
  
  void settings(){
    size(1600, 800);
  }

void setup(){
  for(int s=0;s<2;s++){
      for(int j=0;j<6;j++){
      playersDice[s][j]=Integer.toString(j+1);
      }
  };
  PFont font = createFont("Meiryo",50);
  textFont(font);
  int n=1;
  size(1600, 800);
  textSize(32);
  textAlign(CENTER);
  fill(255);
  state = 0;
  t_start = millis();
  chara[0][0]=0;
  chara[1][0]=0;
   for(int i=1;i<=30;i++){
     if((i)%8==0){
       n*=-1;
     }
     if(n==1){
       ive[i][0]=10+190*((i)%8);
       ive[i][1]=50+170*((i)/8);
     }else{
       ive[i][0]=10+190*(7-(i)%8);
       ive[i][1]=50+170*((i)/8);
     }
     ive[i][2]=(int)random(eventnum);
   }
   
   
}

void draw(){
  background(0);
  t = (millis() - t_start) / 1000.0; // 経過時間を更新
  //text(nf(t, 1, 3)  + "sec.", width * 0.5, height * 0.9); // 経過時間を表示
  
  int nextState= 0;
  if(state == 0){ nextState = title(); }
  else if(state == 1){ nextState = game(); }
  else if(state == 2){ nextState = ending(); }
  
  if(state != nextState){ t_start = millis(); } // 状態が遷移するので、現在の状態になった時刻を更新する
  state = nextState;
}


int title(){
  chara[0][0]=0;
  chara[1][0]=0;
  for(int i=1;i<=30;i++){
    ive[i][2]=(int)random(eventnum);
  }
  dice=0;
  textSize(50);
  text("AR Dice Game", width * 0.5, height * 0.3);
  textSize(24);
  text("Press 'z' key to start", width * 0.5, height * 0.7);
  if(keyPressed && key == 'z'){ // if 'z' key is pressed
    return 1; // start game
  }
  if(difficult == 0){ // if 'z' key is pressed
    return 1; // start game
  }
  if(difficult == 1){ // if 'z' key is pressed
    return 1; // start game
  }
  if(difficult == 2){ // if 'z' key is pressed
    return 1; // start game
  }
  return 0;
}

int game(){
  isActive = true;
  background(0);
  fill(255);
  ellipse(80, 50, 150, 85);
  ellipse(80, 650, 150, 85); 
  for(int i=1;i<=30;i++){
    fill(255);
     rect(ive[i][0], ive[i][1], 110, 110, 20);
     fill(0,0,0);
     textSize(50);
     text(ive[i][2],ive[i][0]+55,ive[i][1]+75);
     if(i>=2){
       if(ive[i][0]!=ive[i-1][0]){
         if(ive[i][0]-ive[i-1][0]>0){
           fill(255);
           triangle(ive[i-1][0]+130, ive[i-1][1]+30, ive[i-1][0]+130, ive[i-1][1]+80, ive[i-1][0]+150, ive[i-1][1]+(110/2));
         }else{
           fill(255);
           triangle(ive[i-1][0]-20, ive[i-1][1]+30, ive[i-1][0]-20, ive[i-1][1]+80, ive[i-1][0]-40, ive[i-1][1]+(110/2));
         }
       }else{
         fill(255);
          triangle(ive[i-1][0]+30, ive[i-1][1]+130, ive[i-1][0]+80, ive[i-1][1]+130, ive[i-1][0]+(110/2), ive[i-1][1]+150);
       }
     }
  }

    fill(255);
    yourDice="";
    for(int t=0;t<2;t++){
      yourDice=yourDice+"Player"+Integer.toString(t+1)+":";
    for(int i=0;i<MARKER_NUM;i++){
      if(i==0){
        yourDice=yourDice+playersDice[t][i];
      }else{
  yourDice=yourDice+","+ playersDice[t][i];
      }
  }
  yourDice = yourDice+"\n";
    }
    textSize(28);
    text(yourDice,300,730);
    textSize(28);
    text("イベント一覧:[Q]",1400,770);
    textSize(30);
    text("Player"+Integer.toString(turn+1)+"のターン",800,770);
  if(event==0){
    if(dice==0){
     for(int i=0;i<MARKER_NUM;i++){
     diceList[i] = playersDice[turn][i]; 
    }
    if(!comfirmedResult.equals("")){
     dice=1; 
     deme = Integer.parseInt(comfirmedResult);
     comfirmedResult = "";
    }else{
     dice=0; 
    } 
    }
    if(dice==1){
      if(chara[turn][0]+deme>30){
        goal=1;
      }else{
        if(chara[turn][0]+deme<0){
          chara[turn][0]=0;
        }else{
        chara[turn][0]+=deme;
        }
        dice=0;
        event=1;
      }
    }
  }
  if(goal==1){
    if(turn==0){
      fill(255,0,0);
      ellipse(50, 650, 40, 40);
      fill(0,255,255);
      ellipse(ive[chara[1][0]][0]+55, ive[chara[1][0]][1]+55,40,40);
    }else{
      fill(0,255,355);
      ellipse(50, 650, 40, 40);
      fill(255,0,0);
      ellipse(ive[chara[1][0]][0]+55, ive[chara[1][0]][1]+55,40,40);
    }
  }else{
  if(chara[0][0]==0){
    fill(255,0,0);
    ellipse(50, 50, 40, 40);
  }
  if(chara[1][0]==0){
    fill(0,255,255);
    ellipse(110, 50, 40, 40);
  }
  if(chara[0][0]>0&&chara[0][0]==chara[1][0]){
     fill(255,0,0);
     ellipse(ive[chara[0][0]][0]+30, ive[chara[0][0]][1]+55,40,40);
     fill(0,255,255);
     ellipse(ive[chara[1][0]][0]+80, ive[chara[1][0]][1]+55,40,40);
  }else{ 
    if(chara[0][0]>0){
      fill(255,0,0);
      ellipse(ive[chara[0][0]][0]+55, ive[chara[0][0]][1]+55,40,40);
    }
    if(chara[1][0]>0){
      fill(0,255,255);
      ellipse(ive[chara[1][0]][0]+55, ive[chara[1][0]][1]+55,40,40);
    }
  }
  }
  
  if(eveIns){
    fill(210);
     rect(50, 50, width-100, height-100, 20);
     fill(0);
     textSize(45);
     text("0:1回サイコロを投げて、出た数ぶん次回のサイコロの出目にプラス\n"+
"1:1回サイコロを投げて、出た数が次回のサイコロで出現率アップ\n"+
"2:サイコロを投げて、次プレイヤーの次回のサイコロを決める\n"+
"3:次回のターンのプレイヤーは1回休み\n"+
"4:次回のターンのプレイヤーのサイコロの出目が(-1,0,1,2,3,4)になる\n"+
"5:次回のサイコロが(2,2,3,3,4,4)になる\n"+
"6:何も起こらない",800,170);
  }
    if(chara[turn][1]==1){
        chara[turn][1]=0;
        if(turn==0){
                  turn=1;
        }else{
                  turn=0;
        }
    }
    
    if(event==1&&ive[chara[turn][0]][2]==0){
      fill(190);
      rect(width/2-300,height/2-80,600,160);
      fill(255,0,0);
        textSize(30);
        text("＼イベント／",width/2,height/2-40);
        fill(0);
        textSize(20);
        text("1回サイコロを投げて、でた数分次回のサイコロの出目にプラス！",width/2,height/2);
      
        /*
        for(int p=0;p<6;p++){
            playersDice[turn][p]=Integer.toString(p+1);
        }
        */
        for(int i=0;i<MARKER_NUM;i++){
         diceList[i] = Integer.toString(i+1); 
        }
        
        if(!comfirmedResult.equals("")){
        b = comfirmedResult;//サイコロを認識
        comfirmedResult = "";
        }
        
        //b = comfirmedResult;//サイコロを認識
        //b = key();//実際はサイコロ入力の部分をキーボートでとりあえず実行
        if(!b.equals("")){
            text("次回のサイコロは("+(1+int(b))+","+(2+int(b))+","+(3+int(b))+","+(4+int(b))+","+(5+int(b))+","+(6+int(b))+")です",width/2,height/2+40);
            eventdice[0] = Integer.toString((1+int(b)));
            eventdice[1] = Integer.toString((2+int(b)));
            eventdice[2] = Integer.toString((3+int(b)));
            eventdice[3] = Integer.toString((4+int(b)));
            eventdice[4] = Integer.toString((5+int(b)));
            eventdice[5] = Integer.toString((6+int(b)));
            i +=1;
            if(i>=100){//サイコロの出目が確定後数秒後にイベント画面を閉じて、サイコロの出目を反映
                for(int i=0;i<6;i++){
                    playersDice[turn][i]=eventdice[i];//実際はここでダイスの出目をかえる
                }
                event=0;
                print("ok");
                print(eventdice[0],eventdice[1],eventdice[2],eventdice[3],eventdice[4],eventdice[5]);
                dice=0;
                i=0;
                a=0;
                b="";
                if(turn==0){
                  turn=1;
                }else{
                  turn=0;
                }
            }
        }
    }if(event==1&&ive[chara[turn][0]][2]==1){
      fill(190);
      rect(width/2-300,height/2-80,600,160);
      fill(255,0,0);
        textSize(30);
        text("＼イベント／",width/2,height/2-40);
        fill(0);
        textSize(20);
        text("1回サイコロを投げて、でた数が次回のサイコロで出現率アップ！",width/2,height/2);
        for(int i=0;i<MARKER_NUM;i++){
         diceList[i] = Integer.toString(i+1); 
        }
        
        if(!comfirmedResult.equals("")){
        b = comfirmedResult;//サイコロを認識
        comfirmedResult = "";
        }
        if(b!=""){
            text("次回のサイコロは("+b+","+b+","+b+",3,4,5)です",width/2,height/2+40);
            eventdice[0] = b;
            eventdice[1] = b;
            eventdice[2] = b;
            eventdice[3] = "3";
            eventdice[4] = "4";
            eventdice[5] = "5";
            i +=1;
            if(i>=100){//サイコロの出目が確定後数秒後にイベント画面を閉じて、サイコロの出目を反映
                for(int i=0;i<6;i++){
                    playersDice[turn][i]=eventdice[i];//実際はここでダイスの出目をかえる
                }
                event=0;
                print("ok");
                print(eventdice[0],eventdice[1],eventdice[2],eventdice[3],eventdice[4],eventdice[5]);
                dice=0;
                i=0;
                a=0;
                b="";
                if(turn==0){
                  turn=1;
                }else{
                  turn=0;
                }
            }
        }
    }if(event==1&&ive[chara[turn][0]][2]==2){
      fill(190);
      rect(width/2-300,height/2-80,600,160);
      fill(255,0,0);
        textSize(30);
        text("＼イベント／",width/2,height/2-40);
        fill(0);
        textSize(20);
        text("サイコロを投げて、次プレイヤーの次回のサイコロを決める",width/2,height/2-10);
        text("(A:良いサイコロ,B:悪いサイコロ)",width/2,height/2+10);
        
        for(int i=0;i<MARKER_NUM;i++){
          if(i%2==0){
         diceList[i] = "A"; 
          }else{
           diceList[i]="B"; 
          }
        }
        
        if(!comfirmedResult.equals("")){
        b = comfirmedResult;//サイコロを認識
        comfirmedResult = "";
        }
        
        for(int i=0; i<3;i++){
            //playersDice[i]="良";
        }
        for(int i=3; i<6;i++){
            //playersDice[i]="悪";
        }
        //b = comfirmedResult;//サイコロを認識;
        if(!b.equals("")){
        if(b.equals("A")){//サイコロ実装までキーボード入力出来るように数字で対応
            text("次回の相手のサイコロは良い出目のサイコロです",width/2,height/2+40);
            eventdice[0] = "4";
            eventdice[1] = "5";
            eventdice[2] = "6";
            eventdice[3] = "4";
            eventdice[4] = "5";
            eventdice[5] = "6";
            i +=1;
            if(i>=100){//サイコロの出目が確定後数秒後にイベント画面を閉じて、サイコロの出目を反映
                for(int i=0;i<6;i++){
                    if(turn == 0){
                        playersDice[1][i]=eventdice[i];//実際はここでダイスの出目をかえる
                    }    
                    if(turn == 1){
                        playersDice[0][i]=eventdice[i];//実際はここでダイスの出目をかえる
                    }         
                }
                for(int p=0;p<6;p++){
                    playersDice[turn][p]=Integer.toString(p+1);
                }
                event=0;
                print("ok");
                print(eventdice[0],eventdice[1],eventdice[2],eventdice[3],eventdice[4],eventdice[5]);
                dice=0;
                i=0;
                a=0;
                b="";
                if(turn==0){
                  turn=1;
                }else{
                  turn=0;
                }
            }
        }
        if(b.equals("B")){
            text("次回の相手のサイコロは悪い出目のサイコロです",width/2,height/2+40);
            eventdice[0] = "1";
            eventdice[1] = "2";
            eventdice[2] = "3";
            eventdice[3] = "1";
            eventdice[4] = "2";
            eventdice[5] = "3";
            i +=1;
            if(i>=100){//サイコロの出目が確定後数秒後にイベント画面を閉じて、サイコロの出目を反映
                for(int i=0;i<6;i++){
                    if(turn == 0){
                        playersDice[1][i]=eventdice[i];//実際はここでダイスの出目をかえる
                    }    
                    if(turn == 1){
                        playersDice[0][i]=eventdice[i];//実際はここでダイスの出目をかえる
                    }    
                }
                for(int p=0;p<6;p++){
                    playersDice[turn][p]=Integer.toString(p+1);
                }
                event=0;
                print("ok");
                print(eventdice[0],eventdice[1],eventdice[2],eventdice[3],eventdice[4],eventdice[5]);
                dice=0;
                i=0;
                a=0;
                b="";
                if(turn==0){
                  turn=1;
                }else{
                  turn=0;
                }
            }
        }
        }
    }if(event==1&&ive[chara[turn][0]][2]==3){
      fill(190);
      rect(width/2-300,height/2-80,600,160);
      fill(255,0,0);
        textSize(30);
        text("＼イベント／",width/2,height/2-40);
        fill(0);
        textSize(20);
        text("次回のターンのプレイヤーは1回休み",width/2,height/2);
        if(turn==0){
            b = "1";//現在のプレイヤーを取得し、次のプレイヤーを見つける
        }else{
            b = "0";
        }
        //b=key();
        if(b!=""){
            text("次回休みのプレイヤーは"+(int(b)+1)+"です",width/2,height/2+40);
            i +=1;
            if(i>=100){//サイコロの出目が確定後数秒後にイベント画面を閉じて、サイコロの出目を反映
                chara[int(b)][1]=1;//実際はここで休みを記録する
                for(int p=0;p<6;p++){
                    playersDice[turn][p]=Integer.toString(p+1);
                }
                event=0;
                a=0;
                print("ok");
                dice=0;
                i=0;
                if(turn==0){
                  turn=1;
                }else{
                  turn=0;
                }
            }
        }
    }if(event==1&&ive[chara[turn][0]][2]==4){
      fill(190);
      rect(width/2-300,height/2-80,600,160);
      fill(255,0,0);
        textSize(30);
        text("＼イベント／",width/2,height/2-40);
        fill(0);
        textSize(20);
        text("次回のターンのプレイヤーのサイコロの出目が(-1,0,1,2,3,4)になる！",width/2,height/2);
        b = Integer.toString(turn);//現在のプレイヤーを取得し、次のプレイヤーを見つける
        b=key();
        text("次回のサイコロは(-1,0,1,2,3,4)です",width/2,height/2+40);
        eventdice[0] = "-1";
        eventdice[1] = "0";
        eventdice[2] = "1";
        eventdice[3] = "2";
        eventdice[4] = "3";
        eventdice[5] = "4";
        i +=1;
        if(i>=100){//サイコロの出目が確定後数秒後にイベント画面を閉じて、サイコロの出目を反映
            for(int i=0;i<6;i++){
                    if(turn == 0){
                        playersDice[1][i]=eventdice[i];//実際はここでダイスの出目をかえる
                    }    
                    if(turn == 1){
                        playersDice[0][i]=eventdice[i];//実際はここでダイスの出目をかえる
                    }  
                }
            for(int p=0;p<6;p++){
                playersDice[turn][p]=Integer.toString(p+1);
            }
                event=0;
                print("ok");
                print(eventdice[0],eventdice[1],eventdice[2],eventdice[3],eventdice[4],eventdice[5]);
                dice=0;
                i=0;
                a=0;
                if(turn==0){
                  turn=1;
                }else{
                  turn=0;
                }
            }
        }
    if(event==1&&ive[chara[turn][0]][2]==5){
      fill(190);
      rect(width/2-300,height/2-80,600,160);
      fill(255,0,0);
        textSize(30);
        text("＼イベント／",width/2,height/2-40);
        fill(0);
        textSize(20);
        text("次回のサイコロが(2,2,3,3,4,4)になる",width/2,height/2);
        eventdice[0] = "2";
        eventdice[1] = "2";
        eventdice[2] = "3";
        eventdice[3] = "3";
        eventdice[4] = "4";
        eventdice[5] = "4";
        i +=1;
        if(i>=100){//サイコロの出目が確定後数秒後にイベント画面を閉じて、サイコロの出目を反映
            for(int i=0;i<6;i++){
                    playersDice[turn][i]=eventdice[i];//実際はここでダイスの出目をかえる
                }
                event=0;
                print("ok");
                print(eventdice[0],eventdice[1],eventdice[2],eventdice[3],eventdice[4],eventdice[5]);
                dice=0;
                i=0;
                a=0;
                if(turn==0){
                  turn=1;
                }else{
                  turn=0;
                }
            }
        }
    if(event==1&&ive[chara[turn][0]][2]==6){
      fill(190);
      rect(width/2-300,height/2-80,600,160);
      i +=1;
      fill(0);
      textSize(20);
      text("何も起こらなかった",width/2,height/2);
      if(i>=100){
          for(int p=0;p<6;p++){
            playersDice[turn][p]=Integer.toString(p+1);
        }
        dice=0;
        i=0;
        event=0;
        a=0;
      if(turn==0){
         turn=1;
      }else{
         turn=0;
     }
      }
    }
  
  if(goal == 1){  // if ellapsed time is larger than 5 seconds
    return 2; // go to ending
  } 
  
  return 1;
}

int ending(){
  textSize(100);
  if(turn==0){
    fill(255,0,0);
  }else{
    fill(0,255,255);
  }
  text("Player"+(turn+1)+" Win!!", width * 0.5, height * 0.5);
  if(t > 3){
    text("Press 'a' to restart.", width * 0.5, height * 0.7);
    if(keyPressed && key == 'a'){
      goal=0;
      return 0;
    }
  }
  return 2;
}

void keyPressed() {//ダイス入力,kawari
  if (key == 'a') {     
        dice=1;
        deme=int(playersDice[turn][(int)random(6)]);
        if(a==0){
            for(int i=0; i<6;i++){
                print(playersDice[turn][i]);
            }
            print(deme);
            a=1;
        }
  }
  if(key=='q'){
    eveIns = !eveIns;
  }
}

String key(){//実際はサイコロ入力の部分をキーボートでとりあえず実行
    String z="";
    keyPressed();
    if(key == '1'){
        z = "1";
    }
    if(key == '2'){
        z = "2";
    }
    if(key == '3'){
        z = "3";
    }
    if(key == '4'){
        z = "4";
    }
    if(key == '5'){
        z = "5";
    }
    if(key == '6'){
        z = "6";
    }
    return z;
}
}
