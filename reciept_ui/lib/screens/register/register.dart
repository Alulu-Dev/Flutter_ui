import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('register'),),
        body: SignUp(),
      ),
    );
  }
}
 
class SignUp extends StatefulWidget {
 
  @override
  State<SignUp> createState() => _MyStatefulWidgetState();
}
 
class _MyStatefulWidgetState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       color:Colors.white,
      ), 
      child:Padding(
        padding: const EdgeInsets.all(10),
        
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width/3,
                padding: const EdgeInsets.all(10),
                child: Image.asset('/images/alulu.jpg'),
                ),
           
            Container(
              padding: const EdgeInsets.fromLTRB(0,50,50,5),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0,5,50,5),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'last Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0,5,50,5),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 50, 5),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 50, 5),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            Container(
                height: 50,
                width: 20,
                padding: const EdgeInsets.fromLTRB(150, 0, 150, 0),
                
                child: ElevatedButton(
                  child: const Text('SIGN UP'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 33, 222, 178),
                     shape: RoundedRectangleBorder( 
                borderRadius: BorderRadius.circular(30)
                    ),
                    
                  ),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                  },
                ),
                
            ),
            Row(
              children: <Widget>[
                const Text('I have an account'),
                TextButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        )),);
   
  }
}


