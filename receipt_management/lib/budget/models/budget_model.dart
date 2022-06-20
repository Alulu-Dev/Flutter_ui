import 'package:equatable/equatable.dart';

class BudgetModel extends Equatable {
  final String catName;
  final double amount;

  const BudgetModel({required this.catName, required this.amount});

  @override
  List<Object?> get props => [catName, amount];

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(catName: json['category_name'], amount: json['amount']);
  }
}

class CategoryModel extends Equatable {
  final String id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }
}
