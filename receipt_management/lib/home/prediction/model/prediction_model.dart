import 'package:equatable/equatable.dart';

class PredictionModel extends Equatable {
  final int year;
  final int week;
  final List<PredictionsItemsModel> items;

  const PredictionModel({
    required this.year,
    required this.week,
    required this.items,
  });
  @override
  List<Object?> get props => [year, week, items];

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    late List<PredictionsItemsModel> items = [];
    for (final data in json['items']) {
      final item = PredictionsItemsModel.fromJson(data);
      items.add(item);
    }
    return PredictionModel(
      year: json['year'],
      week: json['week_no'],
      items: items,
    );
  }
}

class PredictionsItemsModel extends Equatable {
  final String item;
  final double probability;

  const PredictionsItemsModel({
    required this.item,
    required this.probability,
  });

  @override
  List<Object?> get props => [item, probability];

  factory PredictionsItemsModel.fromJson(Map<String, dynamic> json) {
    return PredictionsItemsModel(
      item: json['item'],
      probability: num.parse(json['probability']).toDouble(),
    );
  }
}
