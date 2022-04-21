import milchreis.imageprocessing.*;
import processing.video.*;
import controlP5.*;

ControlP5 cp5;
Capture video;
PImage image;
boolean over = false;

void setup() {
  size(2560, 1080);
  video = new Capture(this, 1920, 1080, "pipeline:autovideosrc");
  video.start(); 
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  if (video.available() == true) {
    video.read();
  }
  setVideoActive();
// AASCII VIDEO 

    int fontSize = (int) map(mouseX, 0, width, 8, 30);
    int foregroundColor = 255;
    int backgroundColor = 0;
    boolean toneInColor = true;
    PImage asciiImage = ASCII.apply(video, ASCII.SHORT_SET, fontSize, foregroundColor, backgroundColor, toneInColor);
    
// GLITCH
    PImage glitchImage = Glitch.apply(video, (int) map(mouseX, 0, width, 0, 4));
    
    
    
    image(asciiImage, 1940, 0, 600, 337);
    image(glitchImage, 1940, 347, 600, 684);
    
    
    PImage master = video;
    if (over) {
      master = asciiImage;
    }
    else {
      // master = video;
    }
    image(master, 0, 0);
    // println(mouseX, mouseY)
    println(over);
    // int intensity = (int) map(mouseX, 0, width, 0, 4);
    // image(Glitch.apply(asciiImage, 7), 0, 0);
}

void setVideoActive() {
  if (mouseX > 1940 && mouseX < 2540 && mouseY > 0 && mouseY < 337) {
    over = true;
  }
}
