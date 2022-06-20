import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/budget/repository/budget_repository.dart';
import 'package:receipt_management/home/upload/bloc/bloc.dart';

import 'package:receipt_management/home/upload/models/receipt_upload_model.dart';
import 'package:receipt_management/home/wallet/Models/receipt_model.dart';
import 'package:receipt_management/widgets/app_bar.dart';
import 'package:receipt_management/widgets/predefined_widgets.dart';

class ReceiptScanningScreen extends StatefulWidget {
  final File image;
  final ReceiptUploadModel receiptData;

  const ReceiptScanningScreen(
      {Key? key, required this.image, required this.receiptData})
      : super(key: key);

  @override
  State<ReceiptScanningScreen> createState() => _ReceiptScanningScreenState();
}

class _ReceiptScanningScreenState extends State<ReceiptScanningScreen> {
  late double _screenWidth;
  late double _screenHeight;
  final BudgetRepository budgetRepository = BudgetRepository();
  late String selectedCategoryName = "Category";
  late String selectedCategoryId;
  final GlobalKey expansionTile = GlobalKey();
  final _globalKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  int selected = -1;
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
  late List<Map> categoriesApi = [];
  Future getAllCategories() async {
    final _budgets = await budgetRepository.getAllCategories();
    late List<Map> _categories = [];
    for (final _budget in _budgets) {
      final data = {
        'id': _budget.id,
        'name': _budget.name,
      };
      _categories.add(data);
    }

    if (!mounted) return;

    setState(() {
      categoriesApi = _categories;
    });
  }

  late final UploadBloc _uploadBloc;

  @override
  void initState() {
    super.initState();
    getAllCategories();
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    if (categoriesApi.isEmpty) {
      getAllCategories();
    }
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
    return BlocConsumer<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadedReceipt) {
          Navigator.of(context)
              .pushNamed('/receiptDetails', arguments: state.receiptID)
              .then((value) => deactivate());
        }
        if (state is UploadFailed) {
          Navigator.of(context)
              .pushNamed(
                '/home',
              )
              .then((value) => deactivate());
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            _uploadImage(),
            spacerSizedBox(h: 20),
            _warningMessage(),
            spacerSizedBox(h: 20),
            _receiptDataRead(),
          ],
        );
      },
    );
  }

  Widget _uploadImage() {
    return Container(
      color: Colors.black.withOpacity(0.2),
      width: double.infinity,
      height: _screenHeight * 0.75 - 50,
      child: Image.file(widget.image),
    );
  }

  Widget _receiptDataRead() {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
        width: _screenWidth * 0.85,
        child: Column(children: [
          _dataRow(
            title: "Merchant",
            data: widget.receiptData.merchant,
          ),
          greenLineBreak(),
          spacerSizedBox(h: 20),
          _dataRow(title: "Date", data: widget.receiptData.date),
          greenLineBreak(),
          spacerSizedBox(h: 20),
          Row(
            children: [
              Expanded(
                child: _dataRow(
                    title: "Register ID", data: widget.receiptData.registerId),
              ),
              Expanded(
                child: _dataRow(
                    title: "Tin Number", data: widget.receiptData.tinNumber),
              ),
            ],
          ),
          greenLineBreak(),
          spacerSizedBox(h: 20),
          Row(
            children: [
              Expanded(
                child: _dataRow(
                    title: "Total Amount",
                    data: "\$" + widget.receiptData.totalAmount.toString()),
              ),
              Expanded(
                child: _dataRow(
                    title: "FS number", data: widget.receiptData.fsNumber),
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
          purchasedItems(widget.receiptData.items),
          greenLineBreak(),
          spacerSizedBox(h: 20),
          SizedBox(
            child: ExpansionTile(
              key: const Key("category"),
              title: Text(selectedCategoryName),
              initiallyExpanded: 1 == selected,
              onExpansionChanged: (expanded) {
                if (expanded) {
                  setState(() {
                    selected = 1;
                  });
                } else {
                  setState(() {
                    selected = -1;
                  });
                }
              },
              children: [
                SizedBox(
                  height: screenHeight * 0.25,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriesApi.length,
                    itemBuilder: (context, index) {
                      String _id = categoriesApi[index]['id'];
                      String _name = categoriesApi[index]['name'];

                      return categoryCard(_id, _name);
                    },
                  ),
                )
              ],
            ),
          ),
          const Text("Description"),
          TextFormField(
            controller: _noteController,
            validator: (value) {
              if (value != "") {
                if (int.parse(value!) > 1) {
                  return null;
                } else {
                  return "1";
                }
              } else {
                return "1";
              }
            },
          ),
          spacerSizedBox(h: 20),
          _controlButtons(),
          spacerSizedBox(h: 20),
        ]));
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
      itemBuilder: (BuildContext context, int index) {
        final name = items[index].itemName;
        final price = items[index].itemPrice;
        final quantity = items[index].itemQuantity;
        return ListTile(
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
    return Form(
      key: _globalKey,
      child: Row(
        children: [
          spacerSizedBox(w: 15),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                final valid = _globalKey.currentState!.validate();
                if (!valid && selectedCategoryName == "Category") {
                  return;
                }
                _uploadBloc.add(ReceiptsSave(
                  receiptImage: widget.image,
                  receiptData: widget.receiptData,
                  catId: selectedCategoryId,
                  note: _noteController.text,
                ));
              },
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
      ),
    );
  }

  Widget categoryCard(
    String id,
    String title,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 120,
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedCategoryName = title;
            selectedCategoryId = id;
            selected = -1;
          });
        },
        child: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
