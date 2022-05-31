import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/auth/profile/bloc/profile_bloc.dart';
import 'package:receipt_management/auth/profile/bloc/profile_event.dart';

Widget customAppBar2(BuildContext context, {int currentTab = 0}) {
  String title = 'Home';
  switch (currentTab) {
    case 1:
      title = "Wallet";
      break;
    case 2:
      title = "Compare";
      break;
    case 3:
      title = "Predictions";
      break;
    case 4:
      title = "Profile";
      break;
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            const SizedBox(width: 20),
            Text(item.text),
          ],
        ),
      );
  void onSelected(BuildContext context, MenuItem item) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);

    switch (item) {
      case MenuItems.editMenu:
        profileBloc.add(ProfileEdit());
        break;
      case MenuItems.logoutMenu:
        profileBloc.add(ProfileLogout());
        break;
    }
  }

  return AppBar(
    automaticallyImplyLeading: false,
    shadowColor: Colors.black,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    title: Text(title),
    actions: currentTab == 4
        ? <Widget>[
            PopupMenuButton<MenuItem>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.listOfMenus.map(buildItem).toList(),
              ],
            ),
          ]
        : null,
  );
}

class MenuItem {
  final String text;
  final IconData icon;
  const MenuItem({required this.text, required this.icon});
}

class MenuItems {
  static const editMenu = MenuItem(text: 'edit', icon: Icons.edit);

  static const logoutMenu = MenuItem(text: 'Logout', icon: Icons.logout);

  static const List<MenuItem> listOfMenus = [editMenu, logoutMenu];
}

PreferredSize appBar2(BuildContext context, {required String title}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60.0),
    child: Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}

PreferredSize appBar(BuildContext context, {required String title}) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ));
}
