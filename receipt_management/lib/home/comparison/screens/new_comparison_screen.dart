import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/comparison/bloc/bloc.dart';
import 'package:receipt_management/home/comparison/models/comparison_models.dart';
import 'package:receipt_management/home/comparison/repository/comparison_repository.dart';
import 'package:receipt_management/widgets/search_widget.dart';

class NewComparisonScreen extends StatefulWidget {
  const NewComparisonScreen({Key? key}) : super(key: key);

  @override
  State<NewComparisonScreen> createState() => _NewComparisonScreenState();
}

class _NewComparisonScreenState extends State<NewComparisonScreen> {
  final ComparisonRepository comparisonRepository = ComparisonRepository();
  late ComparisonCreateBloc _compareCreateBloc;

  late List<ComparableItemsModel> itemsListData = [];
  late List<ComparableItemsModel> searchedItems;

  Future getAllReceipt() async {
    final items = await comparisonRepository.getComparableItems();

    if (!mounted) return;

    setState(() {
      itemsListData = items;
      searchedItems = itemsListData;
    });
  }

  @override
  void dispose() {
    _compareCreateBloc.add(ComparisonCreateUnload());
    super.dispose();
  }

  @override
  void deactivate() {
    _compareCreateBloc.add(ComparisonCreateUnload());
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
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: buildSearch()),
        BlocConsumer<ComparisonCreateBloc, ComparisonCreateState>(
          listener: ((context, state) {
            if (state is ComparisonCreated) {
              Navigator.of(context).pushReplacementNamed('/comparisonDetail',
                  arguments: state.id);
            }
          }),
          builder: (context, state) {
            if (state is ComparisonCreated) {
              _compareCreateBloc.add(ComparisonCreateUnload());
            }
            if (state is ComparisonCreateLoaded) {
              return receiptList(context, searchedItems);
            }
            if (state is ComparisonCreationFailed) {
              return Center(
                child: Text(state.errorMsg),
              );
            }
            _compareCreateBloc = BlocProvider.of<ComparisonCreateBloc>(context);
            _compareCreateBloc.add(ComparisonCreateLoad());
            return const Text("No Data!");
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
    List<ComparableItemsModel> matchQuery = [];
    for (var item in itemsListData) {
      if (item.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    setState(() {
      this.query = query;
      searchedItems = matchQuery;
    });
  }

  Widget receiptList(
      BuildContext context, List<ComparableItemsModel> itemsList) {
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
            itemsList[index].name,
          );
        },
      ),
    );
  }

  Widget itemCard(
    BuildContext context,
    id,
    item,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: TextButton(
        onPressed: () {
          _compareCreateBloc.add(ComparisonCreate(id: id));
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
