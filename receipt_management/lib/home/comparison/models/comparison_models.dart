import 'package:equatable/equatable.dart';

class ComparisonModel extends Equatable {
  final String id;
  final String itemName;
  final String generatedOn;

  const ComparisonModel({
    required this.id,
    required this.itemName,
    required this.generatedOn,
  });

  @override
  List<Object?> get props => [id, itemName, generatedOn];

  factory ComparisonModel.fromJson(Map<String, dynamic> json) {
    return ComparisonModel(
      id: json['id'],
      itemName: json['tag'],
      generatedOn: json['date'],
    );
  }
}

class ComparisonDetailModel extends Equatable {
  final String id;
  final String itemName;
  final String generatedOn;
  final List<ComparisonResultModel> results;

  const ComparisonDetailModel({
    required this.id,
    required this.itemName,
    required this.generatedOn,
    required this.results,
  });

  @override
  List<Object?> get props => [
        id,
        itemName,
        generatedOn,
        results,
      ];

  factory ComparisonDetailModel.fromJson(Map<String, dynamic> json) {
    late List<ComparisonResultModel> items = [];
    for (final item in json['result']) {
      final itemModel = ComparisonResultModel.fromJson(item);
      items.add(itemModel);
    }

    return ComparisonDetailModel(
      id: json['id'],
      itemName: json['tag'],
      generatedOn: json['date'],
      results: items,
    );
  }
}

class ComparisonResultModel extends Equatable {
  final String shop;
  final double price;

  const ComparisonResultModel({required this.shop, required this.price});

  @override
  List<Object?> get props => [
        shop,
        price,
      ];

  factory ComparisonResultModel.fromJson(Map<String, dynamic> json) {
    return ComparisonResultModel(
      shop: json['Shop'],
      price: json['price'],
    );
  }
}

class ComparableItemsModel extends Equatable {
  final String name;
  final String id;

  const ComparableItemsModel({
    required this.name,
    required this.id,
  });
  @override
  List<Object?> get props => throw UnimplementedError();

  factory ComparableItemsModel.fromJson(Map<String, dynamic> json) {
    return ComparableItemsModel(id: json['id'], name: json['name']);
  }
}
