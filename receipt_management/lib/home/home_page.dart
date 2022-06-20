import 'package:flutter/material.dart';
import 'package:receipt_management/home/comparison/screens/camparison_list_screen.dart';
import 'package:receipt_management/home/prediction/screens/prediction_screen.dart';
import 'package:receipt_management/home/upload/screens/receipt_upload_page.dart';
import 'package:receipt_management/home/wallet/screens/wallet_page.dart';

import '../auth/profile/screens/profile_page.dart';
import '../widgets/app_bar.dart';
import '../widgets/nav_bar.dart';

const Color themeColor = Color(0xff74F2C4);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _goToWalletPage() {
    setState(() {
      currentPage = const WalletPage();
      currentTab = 1;
    });
  }

  void _goToComparePage() {
    setState(() {
      currentPage = const ComparisonListScreen();
      currentTab = 2;
    });
  }

  void _goToPredictionPage() {
    setState(() {
      currentPage = const PredictionScreen();
      currentTab = 3;
    });
  }

  void _goToSettingsPage() {
    setState(() {
      currentPage = const ProfilePage();
      currentTab = 4;
    });
  }

  final List<Widget> screens = [
    const ReceiptUploadPage(),
    const WalletPage(),
    const ProfilePage(),
    const ComparisonListScreen(),
    const PredictionScreen()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  int currentTab = 0;
  Widget currentPage = const ReceiptUploadPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: currentTab == 0
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: customAppBar2(context, currentTab: currentTab),
              ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: PageStorage(
            child: currentPage,
            bucket: bucket,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(139, 208, 161, 1),
          onPressed: () {
            setState(() {
              currentPage = const ReceiptUploadPage();
              currentTab = 0;
            });
          },
          tooltip: 'Home',
          child: Icon(
            Icons.add,
            size: 30,
            color: currentTab == 0 ? Colors.black45 : Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.hardEdge,
          // color: const Color(0xff74F2C4),
          // color: Color.fromARGB(163, 137, 231, 170),
          color: const Color.fromRGBO(139, 208, 161, 1),
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                walletPageButton(_goToWalletPage, currentTab),
                comparisonPageButton(_goToComparePage, currentTab),
                const Spacer(),
                predictionPageButton(_goToPredictionPage, currentTab),
                settingsPageButton(_goToSettingsPage, currentTab),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
