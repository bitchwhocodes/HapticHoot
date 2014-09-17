
import processing.serial.*;

import spacebrew.*;
 
String server = "ws://localhost:9000";
String name = "DDR_PROCESSING";
String description = "Testing from processing ";
Spacebrew spacebrewConnection;  // Spacebrew connection object
 

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int a;
int m = 400;
int oldVal = 0;

boolean hasRun = false;



void setup() 
{
  size(m, m);
 
  String portName = Serial.list()[0];     

  //Teensy 3.1 is on port 10
  myPort = new Serial(this, portName, 9600);
  spacebrewConnection = new Spacebrew( this );
   // add each thing you publish to
  spacebrewConnection.addPublish("selection", "string",true);
  spacebrewConnection.addSubscribe("gameover","string"); 
  spacebrewConnection.addSubscribe("userturn","string");
  // connect to spacebrew
  spacebrewConnection.connect(server, name, description );
}

void draw()
{
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.read();  
  }
  
  if (val == 0) 
  {            
   fill(20,150,0);
   rect(0, 0, m, m);
  } 

  if(val == 1) 
  {           
   fill(200,20,0);
   rect(0, 0, m, m);
  }

 if (val == 2) 
 {       
  fill(180,0,180);
   rect(0, 0, m, m);
 } 

  if(val == 3) {       
   fill(20,50,190);
   rect(0, 0, m, m);
  }  
  

  if(val> -1 && val <4)
  {
    if(oldVal!=val){
      spacebrewConnection.send("selection",str(val));
    }
  }
  oldVal= val;
  


}

void onStringMessage( String name, String value ){
    print("got message"+name);
     
   
    int message=0;
 
    // do something here with the message 
    if(name.indexOf("gameover")!=-1)
    {
       myPort.write(6);
    }
  
    if(name.indexOf("userturn")!=-1)
    {
   
      if(int(value)==7){
     
        myPort.write(10);
    }
    else
    {
      
       myPort.write(int(value)+1);
    }
      
  }
 
  if(name.indexOf("selection")!=-1){
      myPort.write(int(value)-1);
 
    
  }
}



