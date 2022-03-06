import processing.video.*;
import jp.nyatla.nyar4psg.*;

SecondApplet second;
Capture cam;
MultiMarker nya;
final int MARKER_NUM = 6;
float[][] vertexList = new float[MARKER_NUM][4];
boolean[] exist = {false,false,false,false,false,false};
String result = "";
String resultMessage = "";
String comfirmedResult = ""; //目の最終結果(出力)
boolean confirmed = false;
boolean isActive = false;
void settings(){
  size(640,480,P3D);
}
void setup() {
  second = new SecondApplet(this);
  colorMode(RGB, 100);
  
  //カメラ設定（各環境ごとに合わせること）
  cam=new Capture(this,640,480);
  String[] cameras = Capture.list();
  //cam = new Capture(this, cameras[20]); //webcam -> 3,20
  nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  cam.start();
  
  for(int i=0;i<MARKER_NUM;i++){
   nya.addNyIdMarker(i,80); 
  }
  float[] initElem = {(float)height,(float)height,(float)height,(float)height};
  for(int i=0;i<MARKER_NUM;i++){
   vertexList[i] = initElem; 
  }
  
}

void draw(){
  if(!isActive){
    fill(0);
    rect(0,0,width,height);
  }else{
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);
  
  //各面のマーカーを読む
  for(int i=0;i<MARKER_NUM;i++){
   readMarker(i); 
  }  
  
  //暫定の出目を表示
  fill(255,0,0);
  textSize(50);
  int res = calcDiceResult(vertexList);
  if(res==-1){
    textAlign(LEFT,TOP);
    text("Roll a dice",50,50);
    result = "";
  }else{
    result = (diceList[res]);
    text(result,50,50);
  }
  
  //最終結果を表示
  fill(0,255,0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text(resultMessage,width/2,height/2); 
  }
}

void readMarker(int i){ //マーカーを読んだときの処理
  if(nya.isExist(i)){
  exist[i] = true;
  nya.beginTransform(i);
  fill(0,0,255);
  translate(0,0,0);
  rotate(PI);
  textSize(80);
  text(diceList[i],0,0);
  
  float[] vertexElem = new float[4];
  for(int j=0;j<4;j++){
  vertexElem[j] = nya.getMarkerVertex2D(i)[j].y;
  }
  vertexList[i] = vertexElem;
  nya.endTransform();
  }
}

float calcMinFloatList(float[] arr){ //floatの配列の最小値を出力
  float min = arr[0];
  for(int i=1;i<arr.length; i++){
   if(min > arr[i]){
    min = arr[i]; 
   }
  }
  return min;
}

int calcDiceResult(float[][] ver){ //出目のマーカIDを出力
  float[] minList = new float[MARKER_NUM];
  String vertex = "";
  for(int i=0;i<MARKER_NUM;i++){
   if(nya.isExist(i)){
     vertex += Integer.toString(i);
  minList[i] = calcMinFloatList(ver[i]);
   }else{
     minList[i] = height;
   }
  }
  int minId = -1;
  float min = calcMinFloatList(minList);
  
  if(min == height){
   minId = -1; 
  }else{
  for(int i=0;i<MARKER_NUM;i++){
    if(minList[i] == min){
     minId = i; 
    }
  }
  }
  //println(vertex);
  return minId;
}

void keyPressed(){
  if(key == 'a'){
    isActive = true;
  }
  if(confirmed){
   confirmed = false;
   resultMessage = "";
  }else if(key == ' '){
   if(result == ""){
     resultMessage = "Doesn't recognize a dice.";
  }else{
   confirmed = true;
   comfirmedResult = result;
   resultMessage = "Your result is "+result+".\nPress space key to restart.";
  }
 }
}
