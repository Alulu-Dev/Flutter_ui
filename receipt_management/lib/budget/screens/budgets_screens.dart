import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/budget/bloc/bloc.dart';
import 'package:receipt_management/budget/models/budget_model.dart';
import 'package:receipt_management/widgets/app_bar.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late final BudgetBloc _budgetBloc;

  @override
  void dispose() {
    _budgetBloc.add(BudgetUnload());
    super.dispose();
  }

  @override
  void deactivate() {
    _budgetBloc.add(BudgetUnload());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "Budgets"),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: BlocBuilder<BudgetBloc, BudgetState>(
            builder: (context, state) {
              if (state is BudgetLoaded) {
                final budgets = state.budget;
                return Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: const Text("This Month's Budget")),
                    SizedBox(
                      height: height * 0.65,
                      child: SingleChildScrollView(
                        child: _listOfBudgets(budgets),
                      ),
                    ),
                  ],
                );
              }
              if (state is BudgetFailed) {
                return const Center(
                  child: Text("No Data"),
                );
              }
              _budgetBloc = BlocProvider.of<BudgetBloc>(context);
              _budgetBloc.add(BudgetLoad());
              return Column(
                children: [
                  _listOfBudgets([]),
                ],
              );
            },
          ),
        ),
        floatingActionButton: _addNewBudgetButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _listOfBudgets(List<BudgetModel> budgets) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: budgets.length,
      itemExtent: 80,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return ListTile(
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
            budgets[i].catName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          trailing: Text(
            "\$${budgets[i].amount.toString()}",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }

  Widget _addNewBudgetButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      width: 200,
      child: FloatingActionButton(
        heroTag: 'add_budget',
        backgroundColor: const Color.fromRGBO(139, 208, 161, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          Navigator.of(context).pushNamed('/newBudgets');
        },
        child: const Text(
          'Set A Budget',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
