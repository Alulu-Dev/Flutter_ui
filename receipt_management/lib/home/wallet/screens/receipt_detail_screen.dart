import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/wallet/bloc/bloc.dart';
import 'package:receipt_management/widgets/app_bar.dart';

import '../../../widgets/predefined_widgets.dart';

class ReceiptDetailScreen extends StatefulWidget {
  final String receiptId;
  const ReceiptDetailScreen({Key? key, required this.receiptId})
      : super(key: key);

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
  late final ReceiptBloc _receiptBloc;
  late final RequestBloc _requestBloc;

  @override
  void dispose() {
    _receiptBloc.add(ReceiptUnload());
    _requestBloc.add(RequestUnload());
    super.dispose();
  }

  @override
  void initState() {
    _receiptBloc = BlocProvider.of<ReceiptBloc>(context);
    _requestBloc = BlocProvider.of<RequestBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 237, 237, 237),
        appBar: appBar(context, title: "Receipts Details"),
        body: SingleChildScrollView(
          child: BlocConsumer<ReceiptBloc, ReceiptState>(
            listener: ((context, state) {
              if (state is ReceiptDeleted) {
                Navigator.pop(context);
              }
            }),
            builder: (context, state) {
              if (state is ReceiptLoading) {
                return const Center(
                    heightFactor: 3,
                    child: CircularProgressIndicator.adaptive());
              }
              if (state is ReceiptLoaded) {
                final receipt = state.receipt;

                return Column(
                  children: [
                    Container(
                      color: Colors.black.withOpacity(0.2),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 1.5 - 50,
                      // child: Image.asset('assets/images/receipt-image-101.jpg'),
                      child: receipt.image,
                    ),
                    receiptDetail(
                      id: receipt.id,
                      merchant: receipt.merchant,
                      totalPrice: receipt.totalAmount,
                      date: receipt.date,
                      note: receipt.note,
                      tinNumber: receipt.tinNumber,
                      registerId: receipt.registerId,
                      fsNumber: receipt.fsNumber,
                      items: receipt.items,
                    ),
                    spacerSizedBox(h: 50)
                  ],
                );
              }
              if (state is ReceiptFailed) {
                final msg = state.errorMsg;

                return Center(
                  heightFactor: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.hourglass_empty_rounded,
                      ),
                      Text(msg)
                    ],
                  ),
                );
              }
              _receiptBloc.add(ReceiptLoad(receiptID: widget.receiptId));

              return Center(
                heightFactor: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.hourglass_empty_rounded,
                    ),
                    Text('No receipt Found')
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget receiptDetail({
    required String id,
    required String merchant,
    required double totalPrice,
    required String date,
    required String note,
    required String tinNumber,
    required String registerId,
    required String fsNumber,
    required List items,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dataRow(
                title: "Merchant",
                data: merchant,
              ),
              dataRow(
                title: "Total Amount",
                data: "\$$totalPrice",
              ),
              const Text(
                "Items",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              spacerSizedBox(h: 10),
              purchasedItems(items),
              receiptAdditionalInfo(
                id: id,
                date: date,
                note: note,
                tinNumber: tinNumber,
                registerId: registerId,
                fsNumber: fsNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget receiptAdditionalInfo(
      {required String id,
      required String date,
      required String note,
      required String tinNumber,
      required String registerId,
      required String fsNumber}) {
    return ExpansionTile(
      trailing: const SizedBox(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("More Info"),
          spacerSizedBox(w: 20),
        ],
      ),
      children: [
        dataRow(
          title: "Date",
          data: date,
        ),
        dataRow(
          title: "Note",
          data: note,
        ),
        dataRow(
          title: "Tin Number",
          data: tinNumber,
        ),
        dataRow(
          title: "Register ID",
          data: registerId,
        ),
        dataRow(
          title: "FS Number",
          data: fsNumber,
        ),
        spacerSizedBox(h: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            requestButton(id: id),
            spacerSizedBox(w: 10),
            deleteButton(),
          ],
        ),
        spacerSizedBox(h: 5),
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
          onLongPress: () {},
          visualDensity: const VisualDensity(vertical: 3),
          leading: SizedBox(
            width: 100,
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

  Widget dataRow({required String title, required String data}) {
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
        greenLineBreak(),
        spacerSizedBox(h: 10),
      ],
    );
  }

  Widget deleteButton() {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: OutlinedButton(
          onPressed: () {
            _receiptBloc.add(ReceiptDelete(receiptID: widget.receiptId));
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1.0, color: Colors.red),
          ),
          child: const Text(
            'DELETE',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget requestButton({required String id}) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        if (state is RequestUnsent) {
          return Expanded(
            child: SizedBox(
              height: 60,
              child: OutlinedButton(
                onPressed: () {
                  _requestBloc.add(ReceiptVerify(receiptId: id));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: Color(0xff03DAC5)),
                ),
                child: const Text(
                  'Request Verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff03DAC5), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }
        if (state is RequestSent) {
          return Expanded(
            child: SizedBox(
              height: 60,
              child: Row(
                children: const [
                  Icon(
                    Icons.watch_later_outlined,
                    color: Color(0xff03DAC5),
                  ),
                  Text(
                    'Request Sent',
                    style: TextStyle(
                        color: Color(0xff03DAC5), fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        }
        if (state is ReceiptVerified) {
          return Expanded(
            child: SizedBox(
                height: 60,
                child: Row(
                  children: const [
                    Icon(
                      Icons.check,
                    ),
                    Text('Receipt verified',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )),
          );
        }

        _requestBloc.add(ReceiptCheckStatus(receiptId: id));
        return const SizedBox(
          child: Text('Read'),
        );
      },
    );
  }
}
