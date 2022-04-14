import 'package:flutter/material.dart';


 class Body extends StatefulWidget  {
  @override
  State<StatefulWidget> createState() {
    return homestate();
  }
  }

class homestate extends State<Body> {
 

 

  

  @override

  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:<Widget> [
          Center(
            child:Container(
            height: MediaQuery.of(context).size.height/3,
            width: MediaQuery.of(context).size.width/3,
            child: Image.asset('/images/alulu.jpg'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white
            ),
           ),
          ),
          

          Center(
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    IconButton(
                    icon: Icon(Icons.info), 
                    onPressed: () { print("Pressed"); }
                      ),
                     TextButton(	
                      child: Text('Help',
                              style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                    ),),
                      onPressed: () {print('Pressed');}
                      ),


                  ],
                  ),
          ),


          SizedBox(),
          Center(
            child:Container(
            margin: EdgeInsets.all(10),
            child: SizedBox(
                width: MediaQuery.of(context).size.width/6,
                height: 40,
                
                child: FlatButton(
                  padding: EdgeInsets.all(16.0), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Color.fromARGB(255, 21, 241, 194),
                  onPressed: () {},
                  child: Text(
                    "UPLOAD",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ),
          ),
          
           
             

            SizedBox(
                width:  MediaQuery.of(context).size.width/4,
                height: 40,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Color.fromARGB(255, 21, 241, 194),
                  onPressed: () {},
                  child: Text(
                    "TAKE PHOTO",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
        
        ]),
    );
  }
  
}
