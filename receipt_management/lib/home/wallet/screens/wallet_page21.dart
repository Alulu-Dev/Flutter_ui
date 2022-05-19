import 'package:flutter/material.dart';

import '../../../widgets/receipt_search_bar.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        receiptSearchBar(context),
        receiptList(context),
      ],
    );
  }
}

Widget receiptList(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 30, 0, 25),
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return receiptCard(context, index);
      },
    ),
  );
}

Widget receiptCard(BuildContext context, index) {
  return Container(
    padding: const EdgeInsets.fromLTRB(40, 0, 45, 15),
    child: TextButton(
      onPressed: () {
        Navigator.of(context)
            .pushNamed('/receiptDetails', arguments: index.toString());
      },
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            leading: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                image: const DecorationImage(
                  image: AssetImage('assets/images/receipt_icon.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(100.0)),
              ),
            ),
            title: RichText(
              overflow: TextOverflow.ellipsis,
              strutStyle: const StrutStyle(fontSize: 12.0),
              text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                  text: 'kaldis Coffee Bole Eden branch'),
            ),
            subtitle: Text(
              "\$ $index.00",
              style: const TextStyle(color: Colors.green, fontSize: 15),
            ),
          ),
          Container(
            height: 1.5,
            color: const Color(0xff74F2C4),
          )
        ],
      ),
    ),
  );
}
