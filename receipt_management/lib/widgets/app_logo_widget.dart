import 'package:flutter/material.dart';

Container greenAppLogoContainer() {
  return Container(
    width: 200,
    height: 200,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 6,
            blurRadius: 10,
          )
        ]),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xff74F2C4),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset('assets/images/alulu-logo-102.png'),
    ),
  );
}

Container whiteAppLogoContainer() {
  return Container(
    width: 200,
    height: 200,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: const Color(0xffBAF5DF),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 1,
          )
        ]),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset('assets/images/alulu-logo-101.png'),
    ),
  );
}
