
import processing.video.*;
import processing.serial.*;
Serial port;                
int linefeed = 10;         

PrintWriter output;        

Capture video;             

PImage img1;               
PImage img2;                

void setup(){
  size(640,960);                          
  video = new Capture(this, 640, 480);    
  video.start();                          
  port = new Serial(this, "COM4", 9600);  
  port.clear();                           
  output = createWriter("test69.txt");     
}

String myString;     
float motangle = 0; 

void draw(){
  img1 = createImage(640, 480, RGB);  
  img2 = createImage(640, 480, RGB);  
  background(0);                      
  
  output.print(";");       
  output.print(motangle); 
  
  if(video.available()){   
    video.read();          
  }
  
  if (port.available() >= 4){                   
    myString = port.readStringUntil(linefeed);   
    if(myString !=null){                        
      motangle = float(myString);               
    }
  }
  
  for (int i = 0; i < width*height/2; i++){  
    if(red(video.pixels[i]) > 50){           
      img1.pixels[i] = color(255);           
    }
  }
  
  for (int i = 0; i < width*height/2; i++){  
    int k = 0;                               
    
    while(brightness(img1.pixels[i]) == 255 && i < (width*height/2)-1 && (i/width)%5 == 0){  
                                                                                             
                                                                                             
      k++;  // increase "k" by 1. This counts the number of white pixels in a consecutive row
      i++;  // increase "i" by 1. moves along to next pixel
    }
    
    if(k > 0 && !(i-(k/2) == 195201)){    
      img2.pixels[i-(k/2)] = color(255);  
      output.print(",");                  
      output.print(i%640);                
      output.print(",");                
      output.print(i/640);           
    }
  }
    
  image(video,0,0);   
  image(img2,0,480); 
  
  println(motangle); 
  
  if (motangle >200.0){ 
    output.flush();       
    output.close();      
    exit();              
  }
}

void keyPressed(){     
  output.flush();       
  output.close();       
  exit();               
}
