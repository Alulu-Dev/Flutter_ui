import 'package:flutter/material.dart';

Widget walletPageButton(ValueGetter onPressed, int currentTab) {
  return MaterialButton(
    // color: currentTab == 1 ? const Color(0xff3F9C5D) : null,
    onPressed: onPressed,
    padding: const EdgeInsets.all(0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          color: currentTab == 1 ? Colors.black45 : Colors.white,
        ),
        Text(
          "Wallet",
          style: TextStyle(
            color: currentTab == 1 ? Colors.black45 : Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget comparisonPageButton(ValueGetter onPressed, currentTab) {
  return MaterialButton(
    // color: currentTab == 2 ? const Color(0xff3F9C5D) : null,
    onPressed: onPressed,
    padding: const EdgeInsets.all(0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          color: currentTab == 2 ? Colors.black45 : Colors.white,
        ),
        Text(
          "Compare",
          style: TextStyle(
            color: currentTab == 2 ? Colors.black45 : Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget predictionPageButton(ValueGetter onPressed, currentTab) {
  return MaterialButton(
    // color: currentTab == 3 ? const Color(0xff3F9C5D) : null,
    onPressed: onPressed,
    padding: const EdgeInsets.all(0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          color: currentTab == 3 ? Colors.black45 : Colors.white,
        ),
        Text(
          "Prediction",
          style: TextStyle(
            color: currentTab == 3 ? Colors.black45 : Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget settingsPageButton(ValueGetter onPressed, currentTab) {
  return MaterialButton(
    // color: currentTab == 4 ? const Color(0xff3F9C5D) : null,
    onPressed: onPressed,
    padding: const EdgeInsets.all(0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          color: currentTab == 4 ? Colors.black45 : Colors.white,
        ),
        Text(
          "Settings",
          style: TextStyle(
            color: currentTab == 4 ? Colors.black45 : Colors.white,
          ),
        ),
      ],
    ),
  );
}
