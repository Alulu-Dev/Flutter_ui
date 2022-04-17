import 'package:flutter/material.dart';


class Profile extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your profile',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: const Text('Your Profile'),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.shade300],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        minRadius: 35.0,
                        child: Icon(
                          Icons.savings,
                          size: 30.0,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              NetworkImage('data:image/jpeg;base64,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'),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.green.shade400,
                        minRadius: 35.0,
                        child: Icon(
                          Icons.message,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                 
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.green.shade200,
                      child: ListTile(
                        title: Text(
                          'Expenses',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'saved',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.green,
                      child: ListTile(
                        title: Text(
                          'Reciept',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'saved',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'your.email@gmail.com',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'a',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'b',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}