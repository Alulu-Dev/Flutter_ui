import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/prediction/bloc/bloc.dart';
import 'package:receipt_management/home/prediction/model/prediction_model.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({Key? key}) : super(key: key);

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  late final PredictionBloc _predictionBloc;
  late double _screenHeight;
  late double _screenWidth;
  List<Map> top5PredictionsColors = [
    {
      'color': const Color.fromRGBO(255, 83, 83, 1.0),
    },
    {
      'color': const Color.fromRGBO(106, 103, 206, 1.0),
    },
    {
      'color': const Color.fromRGBO(54, 174, 124, 1.0),
    },
    {
      'color': Color.fromARGB(255, 41, 169, 220),
    },
    {
      'color': const Color.fromRGBO(0, 255, 171, 1),
    }
  ];

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return _pageLayout();
  }

  @override
  void dispose() {
    _predictionBloc.add(PredictionUnload());
    super.dispose();
  }

  @override
  void initState() {
    _predictionBloc = BlocProvider.of<PredictionBloc>(context);
    super.initState();
  }

  Widget _pageLayout() {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
        child: BlocBuilder<PredictionBloc, PredictionState>(
          builder: (context, state) {
            if (state is PredictionLoaded) {
              print(state);
              return Column(
                children: [
                  const Text(
                    "Your Next Purchase",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _predictionList(state.prediction)
                ],
              );
            }
            if (state is PredictionFailed) {
              _predictionBloc = BlocProvider.of<PredictionBloc>(context);
              return const Text("No Data! Error was Raised");
            }
            // _predictionBloc = BlocProvider.of<PredictionBloc>(context);
            _predictionBloc.add(PredictionLoad());
            return const Text("No Data!");
          },
        ),
      ),
    );
  }

  Widget _predictionList(PredictionModel prediction) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: prediction.items.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 20,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return _predictionItems(prediction.items[index], index);
      },
    );
  }

  Widget _predictionItems(PredictionsItemsModel item, int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.item,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '${item.probability.toString()}%',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        _predictionBar(item.probability, index),
      ],
    );
  }

  Widget _predictionBar(double percent, int index) {
    double value = percent / 100;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: LinearProgressIndicator(
        minHeight: 4,
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(
            top5PredictionsColors[index]['color']),
        backgroundColor: const Color(0xffD6D6D6),
      ),
    );
  }
}
