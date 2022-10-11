
void setup(){
  size(1000, 1000, P3D);  
}

float rotmot;                
float rotcam = 0;    
float rotlaser = 0;          
float rotpixX;               
float rotpixY;              

float pixangleX = 50.0/640*PI/180;  
float pixangleY = 50.0/640*PI/180;  

float[] A,B,AB;               
float[] C,D,CD;               
float n,t;                     
float pointX, pointY, pointZ;  

float[] drawpointX;           
float[] drawpointY;         
float[] drawpointZ;         

int k = 0;  

void draw(){
  background(0);                                  
  perspective(PI/3.0,(float)width/height,1,500);  
  stroke(255, 0, 0);                              
  line(0,0,0,50,0,0);                            
  stroke(0, 255, 0);                              
  line(0,0,0,0,50,0);                             
  stroke(0, 0, 255);                              
  line(0,0,0,0,0,50);                             
  
  camera(50*cos(mouseX/100.0)+10, 20, -50*sin(mouseX/100.0)-30,  
        10, 0, -30,                                              
        0.0, -1.0, 0.0);                                         
  
  if(keyPressed){  // only renders point cloud if a key is pressed on the keyboard
    
    String[] myString = loadStrings("test.txt");                     
    drawpointX = new float[splitTokens(myString[0], ",").length/2]; 
    drawpointY = new float[splitTokens(myString[0], ",").length/2];  
    drawpointZ = new float[splitTokens(myString[0], ",").length/2];  
    myString = splitTokens(myString[0], ";");                      
    
    k = 0;  // reset "k" to zero
    
    for(int i = 0; i < myString.length; i++){              
      String[] stringPart = splitTokens(myString[i], ",");  
      rotmot = float(stringPart[0]);                        
      
      pushMatrix();             // create set of local coordinates
      rotateY(-rotmot*PI/180);  // rotate everything in Y by the motor angle
      
      pushMatrix();             // create another set of local coordinates
      translate(-19, 2, 0);     // move everything along the scanner arm to the laser position in 3D space
      rotateY(rotlaser);        // rotate everything in Y by the laser angle
      
      //Plane Equation
      C = new float[]{modelX(0,0,0), modelY(0,0,0), modelZ(0,0,0)};  
      translate(10, 0, 0);                                         
      D = new float[]{modelX(0,0,0), modelY(0,0,0), modelZ(0,0,0)};  
      CD = new float[]{D[0]-C[0], D[1]-C[1], D[2]-C[2]};             
      // CD[0]x + CD[1]y + CD[2]z = n
      
      popMatrix();  // close off local coordinates to return current position to the motor shaft with the motor's angle
      
      for(int j = 1; j < stringPart.length; j = j+2){      
        rotpixX = (float(stringPart[j])-320)*pixangleX;     
        rotpixY = (240-float(stringPart[j+1]))*pixangleY; 
        
        pushMatrix();           
        translate(18, 4.5, 0); 
        rotateY(rotcam);        
        rotateX(rotpixY);       
        rotateY(rotpixX);       
        
        //Line Equation
        A = new float[]{modelX(0,0,0), modelY(0,0,0), modelZ(0,0,0)};  
        translate(0,0,10);                                             
        B = new float[]{modelX(0,0,0), modelY(0,0,0), modelZ(0,0,0)};  
        AB = new float[]{B[0]-A[0], B[1]-A[1], B[2]-A[2]};         
        
        popMatrix();  // close off local coordinates to return current position to the motor shaft with the motor's angle
        
        // Intersection of Line and Plane
        t = (n - CD[0]*A[0] - CD[1]*A[1] - CD[2]*A[2])
        /   (CD[0]*AB[0] + CD[1]*AB[1] + CD[2]*AB[2]);  
        pointX = A[0] + AB[0]*t;                        
        pointY = A[1] + AB[1]*t;                        
        pointZ = A[2] + AB[2]*t;                        
        
        drawpointX[k] = (pointX);  
        drawpointY[k] = (pointY);  
        drawpointZ[k] = (pointZ);  
        k++;                   
      }
      popMatrix();  // close off local coordinates to return current position to (0,0,0) in global space
    }
  }
  
  if(k > 0){                                               
    for (int i = 0; i < drawpointX.length; i++){           
      stroke(255);                                         
      point(drawpointX[i], drawpointY[i], drawpointZ[i]); 
    }
  }
}
