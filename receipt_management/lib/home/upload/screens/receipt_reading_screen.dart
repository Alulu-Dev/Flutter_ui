import 'dart:io';

import 'package:flutter/material.dart';
import 'package:receipt_management/home/wallet/Models/receipt_model.dart';
import 'package:receipt_management/widgets/app_bar.dart';
import 'package:receipt_management/widgets/predefined_widgets.dart';

class ReceiptScanningScreen extends StatefulWidget {
  final File image;

  const ReceiptScanningScreen({Key? key, required this.image})
      : super(key: key);

  @override
  State<ReceiptScanningScreen> createState() => _ReceiptScanningScreenState();
}

class _ReceiptScanningScreenState extends State<ReceiptScanningScreen> {
  late double _screenWidth;
  late double _screenHeight;
  late List<ItemsModel> items = [
    const ItemsModel(
        id: 'id',
        itemName: 'itemName itemNameitemName',
        itemPrice: 20.0,
        itemQuantity: 1),
    const ItemsModel(
        id: 'id', itemName: 'itemName', itemPrice: 20.0, itemQuantity: 1),
    const ItemsModel(
        id: 'id', itemName: 'itemName', itemPrice: 20.0, itemQuantity: 1),
    const ItemsModel(
        id: 'id', itemName: 'itemName', itemPrice: 20.0, itemQuantity: 1),
  ];
  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "New Receipt"),
        body: SingleChildScrollView(
          child: _pageLayout(),
        ),
      ),
    );
    ;
  }

  Widget _pageLayout() {
    return Column(
      children: [
        _uploadImage(),
        spacerSizedBox(h: 20),
        _warningMessage(),
        spacerSizedBox(h: 20),
        _receiptDataRead(),
      ],
    );
  }

  Widget _uploadImage() {
    return Container(
      color: Colors.black.withOpacity(0.2),
      width: double.infinity,
      height: _screenHeight * 0.75 - 50,
      // child: Image.asset('assets/images/receipt-image-101.jpg'),
      child: Image.file(widget.image),
    );
  }

  Widget _receiptDataRead() {
    return SizedBox(
      width: _screenWidth * 0.85,
      // height: _screenHeight,
      child: Column(children: [
        _dataRow(
          title: "Merchant",
          data:
              "MYUNGGSUNG INTERNATIONAL DEV,T PLC ADDIS ABABA S/CITY BOLE K.11 H.No NEW GERJI NEAR UNITY UNIVERSITY TEL.0116295428/0116295422-27",
        ),
        greenLineBreak(),
        spacerSizedBox(h: 20),
        _dataRow(title: "Date", data: "20022-04-28 20:10:53"),
        greenLineBreak(),
        spacerSizedBox(h: 20),
        Row(
          children: [
            Expanded(
              child: _dataRow(title: "Register ID", data: "FGF009040"),
            ),
            Expanded(
              child: _dataRow(title: "Tin Number", data: "0004296855"),
            ),
          ],
        ),
        greenLineBreak(),
        spacerSizedBox(h: 20),
        Row(
          children: [
            Expanded(
              child: _dataRow(title: "Total Amount", data: "\$400.42"),
            ),
            Expanded(
              child: _dataRow(title: "FS number", data: "00018830"),
            ),
          ],
        ),
        greenLineBreak(),
        spacerSizedBox(h: 20),
        const Text(
          "Items",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        spacerSizedBox(h: 10),
        purchasedItems(items),
        greenLineBreak(),
        spacerSizedBox(h: 20),
        _controlButtons(),
        spacerSizedBox(h: 20),
      ]),
    );
  }

  // move to predefined widget
  Widget _dataRow({required String title, required String data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        spacerSizedBox(h: 10),
        Row(
          children: [
            spacerSizedBox(w: 30),
            Flexible(
              child: Text(
                data,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        spacerSizedBox(h: 10),
        // greenLineBreak(),
        spacerSizedBox(h: 10),
      ],
    );
  }

  Widget purchasedItems(List items) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      // itemExtent: 100.0,
      itemBuilder: (BuildContext context, int index) {
        final id = items[index].id;
        final name = items[index].itemName;
        final price = items[index].itemPrice;
        final quantity = items[index].itemQuantity;
        return ListTile(
          onLongPress: () {
            print(name);
          },
          visualDensity: const VisualDensity(vertical: 3),
          leading: SizedBox(
            width: 150,
            child: Text('${index + 1}. $name'),
          ),
          title: Text(
            '\$ $price',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Text(
            'Qty: $quantity',
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  Widget _warningMessage() {
    return const Text(
      "!! Check if the data is correctly !!",
      style: TextStyle(
        fontSize: 15,
        color: Colors.red,
      ),
    );
  }

  Widget _controlButtons() {
    return Row(
      children: [
        // Expanded(
        //   child: OutlinedButton(
        //     onPressed: () {},
        //     style: OutlinedButton.styleFrom(
        //       side: const BorderSide(
        //           width: 1.0, color: Color.fromARGB(255, 3, 143, 218)),
        //     ),
        //     child: const Text(
        //       'Retake',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //           color: Color.fromARGB(255, 3, 143, 218),
        //           fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ),
        spacerSizedBox(w: 15),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 1.0, color: Color(0xff03DAC5)),
            ),
            child: const Text(
              'Save',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff03DAC5), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        spacerSizedBox(w: 15),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                  width: 1.0, color: Color.fromARGB(255, 218, 50, 3)),
            ),
            child: const Text(
              'Cancel',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 218, 50, 3),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
