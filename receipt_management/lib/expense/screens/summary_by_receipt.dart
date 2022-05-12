import 'package:flutter/material.dart';
import 'package:receipt_management/widgets/app_bar.dart';

class SummaryByReceipt extends StatefulWidget {
  const SummaryByReceipt({Key? key}) : super(key: key);

  @override
  State<SummaryByReceipt> createState() => _SummaryByReceiptState();
}

class _SummaryByReceiptState extends State<SummaryByReceipt> {
  final List<String> _texts = [
    "InduceSmile.com",
    "Flutter.io",
    "google.com",
    "youtube.com",
    "yahoo.com",
    "gmail.com"
  ];

  late List<Map> _isCheck;

  late List<bool> _isChecked;

  @override
  void initState() {
    super.initState();
    _isCheck = List<Map>.filled(_texts.length, {"id": 1, "checked": false});
    _isChecked = List<bool>.filled(_texts.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "Receipts Summary"),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _texts.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  secondary: Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/receipt_icon.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100.0)),
                    ),
                  ),
                  title: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        text: _texts[index]),
                  ),
                  subtitle: Text(
                    "\$ totalPrice",
                    style: const TextStyle(color: Colors.green, fontSize: 15),
                  ),
                  value: _isCheck[index]['checked'],
                  onChanged: (val) {
                    setState(
                      () {
                        _isCheck[index] = {"id": 1, "checked": val};
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: TextButton(
          onPressed: () {
            print(_isCheck);
          },
          child: Container(
              width: 100,
              height: 50,
              color: Colors.amber,
              child: Center(child: Text("Next"))),
        ),
      ),
    );
  }
}
