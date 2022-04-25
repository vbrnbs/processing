import milchreis.imageprocessing.*;
import processing.video.*;
import controlP5.*;

ControlP5 cp5;
Capture video;
Movie movie;
DropdownList d1;

PImage master;
int blendValue;
String[] blending = {"BLEND", "ADD", "SUBTRACT", "DARKEST", "LIGHTEST", "DIFFERENCE", "EXCLUSION", "MULTIPLY", "SCREEN", "REPLACE"};

boolean ascii = false;
boolean invert = false;
boolean gameboy = false;
boolean knitting = false;

void setup() {
  size(2560, 1580);
  movie = new Movie(this, "lp.mp4");
  video = new Capture(this, 1920, 1080, "pipeline:autovideosrc");
  cp5 = new ControlP5(this);
  video.start();
  movie.loop();
  
  
 //DROPDOWN
 d1 = cp5.addDropdownList("myList-d1")
          .setPosition(100, 1200)
          .setSize(200,200);
          
  customize(d1); // customize the first list
}

void customize(DropdownList ddl) {
  
  ddl.setBackgroundColor(color(10));
  ddl.setItemHeight(30);
  ddl.setBarHeight(25);
  ddl.getCaptionLabel().set("BLEND MODE");
  for (int i=0;i<blending.length;i++) {
    ddl.addItem(blending[i], i);
  }
  //ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void captureEvent(Capture c) {
  c.read();
}

void movieEvent(Movie m) {
  m.read();
}
void draw() {
  background(0);
  if (video.available() == true) {
    video.read();
  }
  
// AASCII VIDEO 

    int fontSize = (int) map(mouseX, 0, width, 8, 30);
    int foregroundColor = 255;
    int backgroundColor = 0;
    boolean toneInColor = true;
    PImage asciiImage = ASCII.apply(video, ASCII.SHORT_SET, fontSize, foregroundColor, backgroundColor, toneInColor);
    
// GLITCH
    boolean invertRedChannel = true;
    boolean invertGreenChannel = true;
    boolean invertBlueChannel = true;

    PImage invertImage = InvertColors.apply(
      video, 
      invertRedChannel, 
      invertGreenChannel, 
      invertBlueChannel);
    
// CONSOLE 
    int pixelSize = (int) map(mouseX, 0, width, 1, 50);
    PImage gameboyImage = RetroConsole.applyGameboy(video, pixelSize);
    
// KNITTING

    int size = (int) map(mouseX, 0, width, 5, 50);
    float threshold = map(mouseY, 0, height, 0.0, 1.0);
    PImage knittingImage = Knitting.apply(video, size, threshold, 240, #EE0000);
    
    
    image(asciiImage, 1940, 0, 600, 337);
    image(invertImage, 1940, 347, 600, 337);
    image(gameboyImage, 1940, 694, 600, 337);
    image(knittingImage, 1940, 1041, 600, 337);
    // rect(1940, 694, 600, 337);
    master = video;
    if (ascii) {
      master = asciiImage;
    }
    else if (invert){
      master = invertImage;
    } 
    else if (gameboy){
      master = gameboyImage;
    } 
    else if (knitting){
      master = knittingImage;
    } else {}
    setVideoActive();
    // blend(img, 0, 0, 33, 100, 67, 0, 33, 100, DARKEST);
    // println(mouseX, mouseY);
}

void setVideoActive() {
  if (mousePressed && (mouseX > 1940 && mouseX < 2540 && mouseY > 0 && mouseY < 337)) {
    ascii = true;
    invert = false;
    gameboy = false;
    knitting = false;
  }
  else if (mousePressed && (mouseX > 1940 && mouseX < 2540 && mouseY > 337 && mouseY < 684)) {
    invert = true;
    ascii = false;
    gameboy = false;
    knitting = false;
  }
  else if (mousePressed && (mouseX > 1940 && mouseX < 2540 && mouseY > 694 && mouseY < 1031)) {
    invert = false;
    ascii = false;
    gameboy = true;
    knitting = false;
  }
  else if (mousePressed && (mouseX > 1940 && mouseX < 2540 && mouseY > 1041 && mouseY < 1368)) {
    invert = false;
    ascii = false;
    gameboy = false;
    knitting = true;
  }
  output();
}

void output(){
  // LIGHTEST, DIFFERENCE, EXCLUSION, SCREEN, REPLACE
    blendMode(blendValue);
    image(movie, 0, 0, 1920, 1080);
    image(master, 0, 0);
}

void controlEvent(ControlEvent theEvent) {

  if (theEvent.isGroup()) {
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    blendValue = (int) theEvent.getController().getValue();
  }
}
