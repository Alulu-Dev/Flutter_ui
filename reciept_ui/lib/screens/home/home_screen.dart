import 'package:flutter/material.dart';



import '../../components/my_bottom_nav_bar.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {},
      ),
    );
  }
}
