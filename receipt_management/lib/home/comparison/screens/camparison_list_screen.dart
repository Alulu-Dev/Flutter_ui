import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/comparison/bloc/bloc.dart';
import 'package:receipt_management/home/comparison/models/comparison_models.dart';
import 'package:receipt_management/home/comparison/repository/comparison_repository.dart';
import 'package:receipt_management/home/comparison/screens/new_comparison_screen.dart';

import '../../../widgets/search_widget.dart';

const Color themeColor = Color(0xff74F2C4);

class ComparisonListScreen extends StatefulWidget {
  const ComparisonListScreen({Key? key}) : super(key: key);

  @override
  State<ComparisonListScreen> createState() => _ComparisonListScreenState();
}

class _ComparisonListScreenState extends State<ComparisonListScreen> {
  final ComparisonRepository comparisonRepository = ComparisonRepository();
  late ComparisonBloc _compareBloc;

  late List<ComparisonModel> itemsListData = [];
  late List<ComparisonModel> searchedItems;

  Future getAllReceipt() async {
    final items = await comparisonRepository.userComparisonList();

    if (!mounted) return;

    setState(() {
      itemsListData = items;
      searchedItems = itemsListData;
    });
  }

  @override
  void dispose() {
    _compareBloc.add(ComparisonUnload());
    super.dispose();
  }

  @override
  void deactivate() {
    _compareBloc.add(ComparisonUnload());
    super.deactivate();
  }

  @override
  void initState() {
    getAllReceipt();
    super.initState();
  }

  String query = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: Row(
            children: [
              Expanded(flex: 7, child: buildSearch()),
              Expanded(
                flex: 2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 1,
                    primary: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        context: context,
                        builder: (context) {
                          return const NewComparisonScreen();
                        });
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.add_box_outlined,
                        size: 30,
                      ),
                      Text(
                        "New",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<ComparisonBloc, ComparisonState>(
          builder: (context, state) {
            if (state is ComparisonLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (state is ComparisonLoaded) {
              getAllReceipt();
              return receiptList(context, searchedItems);
            }
            if (state is ComparisonFailed) {
              return Center(
                child: Text(state.errorMsg),
              );
            }
            _compareBloc = BlocProvider.of<ComparisonBloc>(context);
            _compareBloc.add(ComparisonLoad());
            return const Text(
                "Save Money by getting the best \n price for your next purchase");
          },
        ),
      ],
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Items Name',
        onChanged: searchBook,
      );

  void searchBook(String query) {
    List<ComparisonModel> matchQuery = [];
    for (var item in itemsListData) {
      if (item.itemName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    setState(() {
      this.query = query;
      searchedItems = matchQuery;
    });
  }

  Widget receiptList(BuildContext context, List<ComparisonModel> itemsList) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemsList.length,
        itemBuilder: (BuildContext context, int index) {
          return itemCard(
              context,
              itemsList[index].id,
              itemsList[index].itemName,
              itemsList[index].generatedOn.split(' ')[0]);
        },
      ),
    );
  }

  Widget itemCard(BuildContext context, id, item, date) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/comparisonDetail', arguments: id);
          _compareBloc.add(ComparisonUnload());
        },
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              title: RichText(
                overflow: TextOverflow.visible,
                strutStyle: const StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    text: item),
              ),
              trailing: Text(date),
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
}
