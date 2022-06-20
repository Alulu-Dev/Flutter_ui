import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/expense/bloc/bloc.dart';
import 'package:receipt_management/home/wallet/Models/wallet_model.dart';
import 'package:receipt_management/home/wallet/repository/wallet_repository.dart';
import 'package:receipt_management/widgets/app_bar.dart';
import 'package:receipt_management/widgets/predefined_widgets.dart';
import 'package:receipt_management/widgets/search_widget.dart';

class SummaryByReceipt extends StatefulWidget {
  const SummaryByReceipt({Key? key}) : super(key: key);

  @override
  State<SummaryByReceipt> createState() => _SummaryByReceiptState();
}

class _SummaryByReceiptState extends State<SummaryByReceipt> {
  final WalletRepository walletRepository = WalletRepository();
  late final ReceiptsSummaryBloc _receiptsSummaryBloc;
  late List<WalletModel> itemsListData = [];
  late List<WalletModel> searchedItems;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Future getAllReceipt() async {
    final receipts = await walletRepository.userWalletRoute();

    if (!mounted) return;

    setState(() {
      itemsListData = receipts;
      searchedItems = itemsListData;
    });
  }

  late List<Map> _isCheck;

  @override
  void dispose() {
    super.dispose();
    _receiptsSummaryBloc.add(ReceiptsSummaryUnload());
  }

  @override
  void initState() {
    super.initState();
    searchedItems = [];
    _receiptsSummaryBloc = BlocProvider.of<ReceiptsSummaryBloc>(context);
    getAllReceipt().then((value) => _isCheck =
        List<Map>.filled(searchedItems.length, {"id": 1, "checked": false}));
  }

  String query = '';
  @override
  Widget build(BuildContext context) {
    if (itemsListData.isEmpty) {
      getAllReceipt();
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(context, title: "Receipts Summary"),
        body: Form(
          key: _formKey,
          child: BlocConsumer<ReceiptsSummaryBloc, ReceiptsSummaryState>(
            listener: ((context, state) {
              if (state is ReceiptsSummaryCreated) {
                Navigator.of(context).pushReplacementNamed(
                    '/receiptSummaryDetails',
                    arguments: state.summaryId);
              }
            }),
            builder: (context, state) {
              if (state is ReceiptsSummarySelected) {
                return _newSummaryData(state.receipt);
              }
              if (state is ReceiptsSummaryFailed) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(state.errorMsg),
                  ),
                );
              }
              return SingleChildScrollView(
                child: _allReceiptList(),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            BlocBuilder<ReceiptsSummaryBloc, ReceiptsSummaryState>(
          builder: (context, state) {
            if (state is ReceiptsSummarySelected) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      final valid = _formKey.currentState!.validate();
                      if (!valid) {
                        return;
                      }

                      List<Map> _selectedReceipts = [];
                      for (var item in _isCheck) {
                        if (item['checked']) {
                          _selectedReceipts.add({
                            "receipt id": item['id'],
                          });
                        }
                      }

                      _receiptsSummaryBloc.add(ReceiptsSummaryCreate(
                          title: _titleController.text,
                          note: _noteController.text,
                          receiptsId: _selectedReceipts));
                    },
                    child: const SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(
                            child: Text(
                          "Save",
                          style: TextStyle(
                            color: Color.fromRGBO(139, 208, 161, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                  ),
                  TextButton(
                    onPressed: () {
                      _receiptsSummaryBloc.add(ReceiptsSummaryUnload());
                    },
                    child: const SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                  ),
                ],
              );
            }
            return TextButton(
              onPressed: () {
                List<WalletModel> _selectedReceipts = [];
                for (final selectedReceipt in _isCheck) {
                  if (selectedReceipt['checked'] == true) {
                    for (final receipt in itemsListData) {
                      if (receipt.id == selectedReceipt['id']) {
                        _selectedReceipts.add(receipt);
                      }
                    }
                  }
                }

                if (_selectedReceipts.isNotEmpty) {
                  _receiptsSummaryBloc
                      .add(ReceiptsSummarySelect(receipts: _selectedReceipts));
                }
              },
              child: const SizedBox(
                  width: 100,
                  height: 50,
                  child: Center(
                      child: Text(
                    "Next",
                    style: TextStyle(
                      color: Color.fromRGBO(139, 208, 161, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
            );
          },
        ),
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search by Shop or item name',
        onChanged: searchBook,
      );

  void searchBook(String query) {
    List<WalletModel> matchQuery = [];
    for (var receipt in itemsListData) {
      if (receipt.merchant.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(receipt);
      }
      for (var item in receipt.items) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          if (!matchQuery.contains(receipt)) {
            matchQuery.add(receipt);
          }
        }
      }
    }

    setState(() {
      this.query = query;
      searchedItems = matchQuery;
    });
  }

  Widget _allReceiptList() {
    return Column(
      children: [
        buildSearch(),
        Container(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: searchedItems.length,
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
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      text: searchedItems[index].merchant),
                ),
                subtitle: Text(
                  searchedItems[index].totalPrice.toString(),
                  style: const TextStyle(color: Colors.green, fontSize: 15),
                ),
                value: _isCheck[index]['checked'],
                onChanged: (val) {
                  setState(
                    () {
                      _isCheck[index] = {
                        "id": searchedItems[index].id,
                        "checked": val
                      };
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _newSummaryData(List<WalletModel> receipt) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 20, 10, 60),
      child: Column(
        children: [
          const Text("Summary Title"),
          _newSummaryTitle(),
          spacerSizedBox(h: 20),
          const Text("Description"),
          _newSummaryNote(),
          spacerSizedBox(h: 20),
          const Text("Receipts"),
          SizedBox(height: 200, child: _newSummaryReceiptList(receipt)),
        ],
      ),
    );
  }

  Widget _newSummaryTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextFormField(
        controller: _titleController,
        textAlign: TextAlign.center,
        validator: (value) =>
            (value!.isEmpty) ? 'Title must not be empty' : null,
      ),
    );
  }

  Widget _newSummaryNote() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextFormField(
        controller: _noteController,
        validator: (value) =>
            (value!.isEmpty) ? 'description must not be empty' : null,
      ),
    );
  }

  Widget _newSummaryReceiptList(List<WalletModel> _receipt) {
    return ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _receipt.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: RichText(
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyle(fontSize: 12.0),
            text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                text: _receipt[index].merchant),
          ),
          subtitle: Text(
            "\$ ${_receipt[index].totalPrice}",
            style: const TextStyle(color: Colors.green, fontSize: 15),
          ),
        );
      },
    );
  }
}
