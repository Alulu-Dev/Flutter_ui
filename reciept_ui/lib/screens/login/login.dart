import 'package:flutter/material.dart';
import 'package:plant_app/screens/register/register.dart';

class Login extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Signin(),
      ),
    );
  }
}
 
class Signin extends StatefulWidget {
 
  @override
  State<Signin> createState() => _MyStatefulWidgetState();
}
 
class _MyStatefulWidgetState extends State<Signin> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 156, 236, 198)
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
              padding: const EdgeInsets.fromLTRB(50,50,50,5),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 40),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height: 50,
                width: 20,
                padding: const EdgeInsets.fromLTRB(150, 0, 150, 0),
                
                child: ElevatedButton(
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 37, 218, 160),
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
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign UP',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Register(),
                ),
              );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        )),);
   
  }
}

