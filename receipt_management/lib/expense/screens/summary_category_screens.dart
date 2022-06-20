import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/expense/bloc/bloc.dart';
import 'package:receipt_management/expense/models/category_summary_model.dart';

import 'package:receipt_management/expense/screens/charts_flut.dart';
import 'package:receipt_management/widgets/app_bar.dart';

class ExpenseSummaryScreen extends StatefulWidget {
  const ExpenseSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> {
  late final CategorySummaryBloc _summaryBloc;

  @override
  void dispose() {
    _summaryBloc.add(CategorySummaryUnload());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _summaryBloc = BlocProvider.of<CategorySummaryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "Expense Summary"),
        body: SingleChildScrollView(
          child: BlocBuilder<CategorySummaryBloc, CategorySummaryState>(
            builder: (context, state) {
              if (state is CategorySummaryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CategorySummaryLoaded) {
                final summary = state.summary;
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    monthlySummeryCard(
                        summary.monthlyTotal.total,
                        state.summary.monthlySummary,
                        summary.monthlyTotal.name),
                    const SizedBox(height: 40),
                    summeryList(
                        summary.categoricalSummary, summary.monthlyTotal.name),
                  ],
                );
              }
              if (state is CategorySummaryFailed) {
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

              _summaryBloc.add(CategorySummaryLoad());
              return const SizedBox(
                height: 100,
                child: Center(
                  child: Text("No data!"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget monthlySummeryCard(
      double total, List<MonthlySummary> summaries, String month) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
      width: width * 0.85,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        // color: const Color.fromRGBO(49, 23, 58, 1),
        color: const Color.fromRGBO(139, 208, 161, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Month\'s Expense',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Row(
            children: [
              const Text(
                '\$',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(total.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
            ],
          ),
          monthlyExpenseChart(summaries, month),
        ],
      ),
    );
  }

  Widget monthlyExpenseChart(List<MonthlySummary> summaries, String month) {
    return SizedBox(
      width: double.infinity,
      height: 125,
      child: HiddenTicksAndLabelsAxis.withMonthlySummary(summaries, month),
    );
  }

  Widget summeryList(List<CategorySummary> catSummaries, String month) {
    final width = MediaQuery.of(context).size.width * 0.80;
    return Center(
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              month,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            summeryItem(catSummaries),
          ],
        ),
      ),
    );
  }

  Widget summeryItem(List<CategorySummary> catSummaries) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: catSummaries.length,
      itemExtent: 80,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/expenseDetail',
                arguments: catSummaries[i].id.toString());
          },
          leading: Container(
              width: 65,
              height: 65,
              // padding: EdgeInsets.all(3),
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
            catSummaries[i].categoryName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(catSummaries[i].count.toString()),
          trailing: Text(catSummaries[i].spent.toString()),
        );
      },
    );
  }
}
