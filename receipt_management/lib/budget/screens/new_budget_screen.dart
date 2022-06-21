import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/budget/bloc/bloc.dart';
import 'package:receipt_management/budget/repository/budget_repository.dart';
import 'package:receipt_management/widgets/predefined_widgets.dart';

class BudgetAddScreen extends StatefulWidget {
  const BudgetAddScreen({Key? key}) : super(key: key);

  @override
  State<BudgetAddScreen> createState() => _BudgetAddScreenState();
}

class _BudgetAddScreenState extends State<BudgetAddScreen> {
  final BudgetRepository budgetRepository = BudgetRepository();
  late final NewBudgetBloc _newBudgetBloc;
<<<<<<< HEAD
  late final BudgetBloc _budgetBloc;
=======
>>>>>>> ae7ddb1279a7d89d582327484da89ccb8d68af8a

  late double screenHeight;
  late double screenWidth;

  int selected = -1;

  final _budgetController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  final GlobalKey expansionTile = GlobalKey();
  late String selectedCategoryName = "Category";
  late String selectedCategoryId;
  late IconData selectedCategoryIcon = Icons.category;

  late List<Map> categoriesApi = [];

  late List<Map> categories = [
    {
      'name': "Groceries",
      'icon': Icons.local_grocery_store_outlined,
      'color': Colors.primaries[Random().nextInt(Colors.primaries.length)],
    },
  ];

  Future getAllCategories() async {
    final _budgets = await budgetRepository.getAllCategories();
    late List<Map> _categories = [];
    for (final _budget in _budgets) {
      final data = {
        'id': _budget.id,
        'name': _budget.name,
        'icon': Icons.local_grocery_store_outlined,
        'color': Colors.primaries[Random().nextInt(Colors.primaries.length)],
      };
      _categories.add(data);
    }

    if (!mounted) return;

    setState(() {
      categoriesApi = _categories;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCategories();
<<<<<<< HEAD
    _newBudgetBloc = BlocProvider.of<NewBudgetBloc>(context);
    _budgetBloc = BlocProvider.of<BudgetBloc>(context);
=======
>>>>>>> ae7ddb1279a7d89d582327484da89ccb8d68af8a
  }

  @override
  void dispose() {
    _newBudgetBloc.add(NewBudgetUnload());
<<<<<<< HEAD
    _budgetBloc.add(BudgetUnload());
=======
>>>>>>> ae7ddb1279a7d89d582327484da89ccb8d68af8a
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        body: _pageLayout(),
        floatingActionButton: _saveButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _pageLayout() {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Form(
        key: _globalKey,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight < 600
                  ? screenHeight * 0.06
                  : screenHeight * 0.125,
            ),
            _pageTitle(),
            const SizedBox(
              height: 30,
            ),
            budgetInput(),
            SizedBox(
              height:
                  screenHeight < 600 ? screenHeight * 0.8 : screenHeight * 0.1,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.075, 0, screenWidth * 0.075, 0),
              width: screenWidth,
              height: screenHeight * 0.4,
              child: ListView(
                children: [
                  BlocConsumer<NewBudgetBloc, NewBudgetState>(
                    listener: (context, state) {
                      if (state is NewBudgetSaved) {
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is NewBudgetLoaded) {
                        return autoCollapseExpansionTile(categoriesApi);
                      }
                      if (state is NewBudgetFailed) {
<<<<<<< HEAD
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(child: Text(state.errorMsg)),
                        );
                      }
                      if (state is NewBudgetInitial) {}
=======
                        print(state.errorMsg);
                      }
                      if (state is NewBudgetInitial) {
                        _newBudgetBloc =
                            BlocProvider.of<NewBudgetBloc>(context);
                      }
>>>>>>> ae7ddb1279a7d89d582327484da89ccb8d68af8a

                      _newBudgetBloc.add(NewBudgetLoad());
                      return autoCollapseExpansionTile([]);
                    },
                  ),
                  spacerSizedBox(h: 30),
                  noteInput(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return SizedBox(
      width: screenWidth,
      child: const Text(
        "Add Budgets",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget budgetInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 0),
      width: screenWidth * 0.60,
      height: screenHeight * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(minWidth: 0, maxWidth: screenWidth * 0.5),
          height: screenHeight * 0.075,
          child: IntrinsicWidth(
            child: TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: _budgetController,
              style: TextStyle(
                  fontSize: (screenHeight * 0.05), color: Colors.amber),
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
              decoration: const InputDecoration(
                prefixIconConstraints: BoxConstraints(maxWidth: 25),
                prefixIcon: Icon(
                  Icons.attach_money,
                  size: 20,
                  color: Colors.black,
                ),
                hintText: "0",
                hintStyle: TextStyle(color: Colors.amber),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0.0),
                ),
                errorStyle: TextStyle(fontSize: 0, height: 0),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryCard(String id, String title, IconData icon, Color color) {
    return SizedBox(
      width: 120,
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedCategoryName = title;
            selectedCategoryIcon = icon;
            selectedCategoryId = id;
            selected = -1;
          });
        },
        child: Card(
          elevation: 10,
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noteInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      width: screenWidth * 0.80,
      constraints: const BoxConstraints(minHeight: 25, maxHeight: 60),
      child: const Center(
        child: Text(
          "Budget for: 1 month",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget autoCollapseExpansionTile(List<Map> categories) {
    return Container(
      width: screenWidth * 0.80,
      constraints: const BoxConstraints(minHeight: 80, maxHeight: 400),
      child: IntrinsicHeight(
        child: collapseOncesSelected(categories),
      ),
    );
  }

  Widget collapseOncesSelected(List<Map> listOfCategories) {
    return Builder(
      key: Key('builder ${selected.toString()}'),
      builder: (context) {
        return Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(
                key: const Key("category"),
                title: Text(selectedCategoryName),
                leading: Icon(selectedCategoryIcon),
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
                          String _id = listOfCategories[index]['id'];
                          String _name = listOfCategories[index]['name'];
                          IconData _icon = listOfCategories[index]['icon'];
                          Color _color = listOfCategories[index]['color'];
                          return categoryCard(_id, _name, _icon, _color);
                        }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      width: screenWidth * 0.8,
      child: FloatingActionButton(
        onPressed: () {
          final valid = _globalKey.currentState!.validate();
          if (!valid && selectedCategoryName == "Category") {
            return;
          }
          _newBudgetBloc.add(NewBudgetSave(
              catId: selectedCategoryId, amount: _budgetController.text));
          print([_budgetController.text, selectedCategoryId]);
        },
        backgroundColor: const Color.fromRGBO(139, 208, 161, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Text(
          'SAVE',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
