import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/wallet/Models/wallet_model.dart';
import 'package:receipt_management/home/wallet/bloc/bloc.dart';
import 'package:receipt_management/home/wallet/repository/wallet_repository.dart';

import '../../../widgets/search_widget.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final WalletRepository walletRepository = WalletRepository();
  late List<WalletModel> itemsListData = [];
  late List<WalletModel> searchedItems;

  Future getAllReceipt() async {
    final receipts = await walletRepository.userWalletRoute();

    if (!mounted) return;

    setState(() {
      itemsListData = receipts;
      searchedItems = itemsListData;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllReceipt();
    searchedItems = [];
  }

  String query = '';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state is WalletLoaded) {
          return Column(
            children: [
              buildSearch(),
              receiptList(context, searchedItems),
            ],
          );
        }
        if (state is WalletFailed) {
          return Center(
            child: Text(state.errorMsg),
          );
        }
        final walletBloc = BlocProvider.of<WalletBloc>(context);

        walletBloc.add(WalletLoad());
        return Center(
          heightFactor: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.hourglass_empty_rounded,
              ),
              Text('No Receipts Found')
            ],
          ),
        );
      },
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
}

Widget receiptList(BuildContext context, List<WalletModel> receiptListData) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: receiptListData.length,
      itemBuilder: (BuildContext context, int index) {
        return receiptCard(context, index, receiptListData[index].merchant,
            receiptListData[index].totalPrice, receiptListData[index].id);
      },
    ),
  );
}

Widget receiptCard(BuildContext context, index, merchantName, totalPrice, id) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
    child: TextButton(
      onPressed: () {
        final walletBloc = BlocProvider.of<WalletBloc>(context);
        walletBloc.add(WalletUnload());

        Navigator.of(context).pushNamed('/receiptDetails', arguments: id);
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
              text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  text: merchantName),
            ),
            subtitle: Text(
              "\$ $totalPrice",
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
