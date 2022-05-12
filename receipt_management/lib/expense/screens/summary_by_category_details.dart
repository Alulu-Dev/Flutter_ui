import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/expense/bloc/bloc.dart';
import 'package:receipt_management/expense/models/category_summary_model.dart';
import 'package:receipt_management/widgets/app_bar.dart';

class ExpenseDetail extends StatefulWidget {
  final String catId;
  const ExpenseDetail({Key? key, required this.catId}) : super(key: key);

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  late final SingleCategorySummaryBloc _summaryBloc;
  final List<String> _category = [
    "Food & Drink",
    "Clothing & Shoes",
    "Car",
    "House",
    "Electric"
  ];

  @override
  void dispose() {
    _summaryBloc.add(SingleCategorySummaryUnload());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "Summary details"),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: BlocBuilder<SingleCategorySummaryBloc,
              SingleCategorySummaryState>(
            builder: (context, state) {
              if (state is SingleCategorySummaryLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state is SingleCategorySummaryLoaded) {
                final spent = state.summary.totalPrice;
                final catName = state.summary.catName;
                final date = state.summary.date;
                final budget = state.summary.budget;
                final usagePercent = ((spent.toDouble() * 100) / budget)
                    .toStringAsExponential(3);
                final receipts = state.summary.receipts;
                return Stack(
                  children: [
                    _headerTitle(
                        spent.toString(), catName, date, budget.toString()),
                    Positioned(
                      right: 20,
                      child: IconButton(
                          onPressed: () {}, icon: Icon(Icons.adaptive.share)),
                    ),
                    Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        child:
                            _budgetChart(num.parse(usagePercent).toDouble())),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: _expenseListContainer(receipts)),
                  ],
                );
              }
              if (state is SingleCategorySummaryFailed) {
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

              _summaryBloc =
                  BlocProvider.of<SingleCategorySummaryBloc>(context);

              _summaryBloc.add(SingleCategorySummaryLoad(catId: widget.catId));
              return const Center(
                child: Text("No Data!"),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _headerTitle(
      String spent, String catName, String date, String budget) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spent,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                catName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                'Budget: \$$budget',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _budgetChart(double usagePercent) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        height: 100,
        child: Stack(children: [
          Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                value: usagePercent / 100,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(255, 83, 83, 1.0)),
                backgroundColor: const Color(0xffD6D6D6),
              ),
            ),
          ),
          Center(child: Text("$usagePercent%"))
        ]),
      ),
      // ),
    );
  }

  Widget _expenseListContainer(List<SummaryReceipts> receipts) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: ((_category.length) * 80) >= height / 2.25
          ? height / 2.25
          : (_category.length) * 100,
      width: width,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 15,
          )
        ],
      ),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: receipts.length,
          itemExtent: 80,
          itemBuilder: (BuildContext context, int index) {
            return expenseItems(receipts[index]);
          }),
    );
  }

  Widget expenseItems(SummaryReceipts receipt) {
    final id = receipt.id;
    final name = receipt.name;
    final date = receipt.date;
    final price = receipt.price;
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/receiptDetails', arguments: id);
      },
      leading: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 203, 237, 207),
          ),
          child: const Icon(
            Icons.attach_money_outlined,
            size: 30,
            color: Color.fromARGB(255, 255, 0, 76),
          )),
      title: Text(
        name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
      subtitle: Text(
        "Date: $date",
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w200,
        ),
      ),
      trailing: Text(
        "\$$price",
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
