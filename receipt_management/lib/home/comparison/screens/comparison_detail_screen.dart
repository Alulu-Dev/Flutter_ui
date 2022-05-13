import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/comparison/bloc/bloc.dart';
import 'package:receipt_management/home/comparison/models/comparison_models.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/predefined_widgets.dart';

class ComparisonDetailScreen extends StatefulWidget {
  final String comparisonId;
  const ComparisonDetailScreen({Key? key, required this.comparisonId})
      : super(key: key);

  @override
  State<ComparisonDetailScreen> createState() => _ComparisonDetailScreenState();
}

class _ComparisonDetailScreenState extends State<ComparisonDetailScreen> {
  late ComparisonDetailBloc _comparisonDetailBloc;

  @override
  void dispose() {
    _comparisonDetailBloc.add(ComparisonDetailUnload());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBar(context, title: "Comparison Details"),
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<ComparisonDetailBloc, ComparisonDetailState>(
            listener: (context, state) {
              if (state is ComparisonDeleted) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is ComparisonDetailsLoading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (state is ComparisonDetailsLoaded) {
                final result = state.result;
                return Column(
                  children: [
                    comparisonDetail(result),
                    spacerSizedBox(h: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          updateButton(),
                          spacerSizedBox(w: 10),
                          deleteButton(),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (state is ComparisonDetailFailed) {
                return Center(
                  child: Text(state.errorMsg),
                );
              }

              _comparisonDetailBloc =
                  BlocProvider.of<ComparisonDetailBloc>(context);
              _comparisonDetailBloc
                  .add(ComparisonDetailLoad(id: widget.comparisonId));
              return const Center(
                heightFactor: 5,
                child: Text("NO Data!"),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget comparisonDetail(ComparisonDetailModel result) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacerSizedBox(h: 10),
              const Text(
                "Item Name:",
                style: TextStyle(fontSize: 15),
              ),
              spacerSizedBox(h: 10),
              Row(
                children: [
                  spacerSizedBox(w: 30),
                  Flexible(
                    child: Text(
                      result.itemName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              spacerSizedBox(h: 20),
              const Text(
                "Generated on:",
                style: TextStyle(fontSize: 15),
              ),
              spacerSizedBox(h: 10),
              Row(
                children: [
                  spacerSizedBox(w: 30),
                  Text(
                    result.generatedOn.split(' ')[0],
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              spacerSizedBox(h: 20),
              const Text(
                "Top 5 Best Prices:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              spacerSizedBox(h: 10),
              bestPriceList(result.results),
            ],
          ),
        ),
      ),
    );
  }

  Widget bestPriceList(List<ComparisonResultModel> foreRunners) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foreRunners.length,
      itemBuilder: (BuildContext context, int index) {
        String shop = foreRunners[index].shop;
        double price = foreRunners[index].price;
        return Column(
          children: [
            ListTile(
              leading: Text('${index + 1}.'),
              title: Text(shop),
              trailing: Text(
                '\$ $price',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 10,
            )
          ],
        );
      },
    );
  }

  Widget deleteButton() {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: OutlinedButton(
          onPressed: () {
            _comparisonDetailBloc
                .add(ComparisonDelete(id: widget.comparisonId));
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

  Widget updateButton() {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: OutlinedButton(
          onPressed: () {
            _comparisonDetailBloc
                .add(ComparisonDetailUpdate(id: widget.comparisonId));
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1.0, color: Color(0xff03DAC5)),
          ),
          child: const Text(
            'UPDATE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff03DAC5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
