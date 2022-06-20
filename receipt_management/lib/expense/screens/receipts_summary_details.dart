import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/expense/bloc/bloc.dart';
import 'package:receipt_management/expense/models/receipts_summary_model.dart';
import 'package:receipt_management/widgets/app_bar.dart';
import 'package:receipt_management/widgets/predefined_widgets.dart';

class ReceiptsSummaryScreenDetails extends StatefulWidget {
  final String summaryId;
  const ReceiptsSummaryScreenDetails({Key? key, required this.summaryId})
      : super(key: key);

  @override
  State<ReceiptsSummaryScreenDetails> createState() =>
      _ReceiptsSummaryScreenDetailsState();
}

class _ReceiptsSummaryScreenDetailsState
    extends State<ReceiptsSummaryScreenDetails> {
  late final ReceiptsSummaryDetailsBloc _detailsBloc;
  late final ReceiptsSummaryListBloc _summaryListBloc;

  @override
  void dispose() {
    super.dispose();
    _detailsBloc.add(ReceiptsSummaryDetailsUnload());
    _summaryListBloc.add(ReceiptSummaryUnload());
  }

  @override
  void initState() {
    super.initState();
    _detailsBloc = BlocProvider.of<ReceiptsSummaryDetailsBloc>(context);
    _summaryListBloc = BlocProvider.of<ReceiptsSummaryListBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "Summary Details"),
        body: SingleChildScrollView(
          child: _pageLayout(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {},
              child: _exportButton(context),
            ),
            spacerSizedBox(w: 20),
            TextButton(
              onPressed: () {},
              child: _deleteButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageLayout() {
    final _height = MediaQuery.of(context).size.height;
    return BlocConsumer<ReceiptsSummaryDetailsBloc,
        ReceiptsSummaryDetailsState>(
      listener: (context, state) {
        if (state is ReceiptsSummaryDetailsDeleted) {
          Navigator.of(context).pop();
          _summaryListBloc.add(ReceiptSummaryUnload());
        }
      },
      builder: (context, state) {
        if (state is ReceiptsSummaryDetailsLoaded) {
          String title = state.summaryDetails.title;
          String note = state.summaryDetails.note;
          double totalPrice = state.summaryDetails.totalPrice;
          return Column(
            children: [
              _pageTitle(title, note, totalPrice),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                height: _height * 0.45,
                child: _receiptListBuilder(state.summaryDetails.receipts),
              ),
            ],
          );
        }
        if (state is ReceiptsSummaryDetailsFailed) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(state.errorMsg),
            ),
          );
        }
        _detailsBloc
            .add(ReceiptsSummaryDetailsLoad(summaryId: widget.summaryId));
        return const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text("No Data!"),
          ),
        );
      },
    );
  }

  Widget _pageTitle(String title, String note, double totalPrice) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
        child: Table(
          border: TableBorder.all(),
          columnWidths: const {0: FractionColumnWidth(.4)},
          children: [
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
                    child: Text(title)),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Total Price",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
                  child: Text(totalPrice.toString()),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Note",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
                  child: Text(note),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _receiptListBuilder(List<ReceiptData> receipts) {
    return ListView.builder(
      itemCount: receipts.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: _receiptTile(receipts[index]),
        );
      },
    );
  }

  Widget _receiptTile(ReceiptData receipt) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ]),
      child: ExpansionTile(
        title: RichText(
          overflow: TextOverflow.ellipsis,
          strutStyle: const StrutStyle(fontSize: 12.0),
          text: TextSpan(
              style: const TextStyle(color: Colors.black),
              text: receipt.merchant),
        ),
        subtitle: Text(receipt.totalReceiptPrice.toString()),
        children: _listItems(receipt.items),
      ),
    );
  }

  List<Widget> _listItems(List<ItemsData> receipt_items) {
    final List<Widget> items = [];

    for (final item in receipt_items) {
      final itemTile = ListTile(
        title: Text(item.name),
        subtitle: Text(item.quantity.toString()),
        trailing: Text(item.price.toString()),
      );
      items.add(itemTile);
    }

    return items;
  }

  Widget _exportButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      width: 80,
      child: FloatingActionButton(
        heroTag: 'export_summary',
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          // Navigator.of(context).pushNamed('/summaryOfReceipts');
        },
        child: const Text(
          'Export',
          style: TextStyle(
            color: Color.fromRGBO(139, 208, 161, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      width: 80,
      child: FloatingActionButton(
        heroTag: 'delete_summary',
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          _detailsBloc
              .add(ReceiptsSummaryDetailsDelete(summaryId: widget.summaryId));
        },
        child: const Text(
          'Delete',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
