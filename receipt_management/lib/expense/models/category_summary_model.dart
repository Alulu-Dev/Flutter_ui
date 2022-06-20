import 'package:equatable/equatable.dart';

class FormattedCategorySummary extends Equatable {
  final List<CategorySummary> categoricalSummary;
  final List<MonthlySummary> monthlySummary;
  final CurrentMonthSummary monthlyTotal;

  const FormattedCategorySummary(
      {required this.categoricalSummary,
      required this.monthlySummary,
      required this.monthlyTotal});
  @override
  List<Object?> get props => [categoricalSummary, monthlySummary];

  factory FormattedCategorySummary.fromJson(Map<String, dynamic> json) {
    late List<CategorySummary> catSummaries = [];
    for (final item in json['list_of_summary']) {
      final summary = CategorySummary.fromJson(item);
      catSummaries.add(summary);
    }
    late List<MonthlySummary> monthlySummaries = [];
    for (final item in json['monthly_expense']) {
      final summary = MonthlySummary.fromJson(item);
      monthlySummaries.add(summary);
    }
    final CurrentMonthSummary currentMonthSummary =
        CurrentMonthSummary.fromJson(json["current_month_expense"]);

    return FormattedCategorySummary(
      categoricalSummary: catSummaries,
      monthlySummary: monthlySummaries,
      monthlyTotal: currentMonthSummary,
    );
  }
}

class CategorySummary extends Equatable {
  final String id;
  final String categoryName;
  final int count;
  final double spent;
  final double budget;

  const CategorySummary(
      {required this.id,
      required this.categoryName,
      required this.count,
      required this.spent,
      required this.budget});

  @override
  List<Object?> get props => [id, categoryName, count, spent, budget];

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      id: json['cat_id'],
      categoryName: json['category_name'],
      count: json['count'].toInt(),
      spent: json['spent'].toDouble(),
      budget: json['budget'].toDouble(),
    );
  }
}

class MonthlySummary extends Equatable {
  final String month;
  final double total;

  const MonthlySummary({required this.month, required this.total});

  @override
  List<Object?> get props => [month, total];

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      month: json['name'],
      total: json['Total'].toDouble(),
    );
  }
}

class CurrentMonthSummary extends Equatable {
  final String name;
  final double total;

  const CurrentMonthSummary({required this.name, required this.total});

  @override
  List<Object?> get props => [name, total];
  factory CurrentMonthSummary.fromJson(Map<String, dynamic> json) {
    return CurrentMonthSummary(
      name: json['name'],
      total: json['Total'].toDouble(),
    );
  }
}

class SingleCategorySummary extends Equatable {
  final double totalPrice;
  final double budget;
  final String catName;
  final String date;
  final List<SummaryReceipts> receipts;

  const SingleCategorySummary(
      {required this.totalPrice,
      required this.budget,
      required this.catName,
      required this.date,
      required this.receipts});

  @override
  List<Object?> get props => [totalPrice, budget, date, receipts];

  factory SingleCategorySummary.fromJson(Map<String, dynamic> json) {
    late List<SummaryReceipts> receiptsList = [];
    for (final receipts in json['receipts']) {
      final data = SummaryReceipts.fromJson(receipts);
      receiptsList.add(data);
    }
    return SingleCategorySummary(
      totalPrice: json['total'],
      date: json['date'],
      budget: json['budget'].toDouble(),
      catName: json['category_name'],
      receipts: receiptsList,
    );
  }
}

class SummaryReceipts extends Equatable {
  final String id;
  final String name;
  final String date;
  final double price;

  const SummaryReceipts(
      {required this.id,
      required this.name,
      required this.date,
      required this.price});

  @override
  List<Object?> get props => [name, date, price];

  factory SummaryReceipts.fromJson(Map<String, dynamic> json) {
    return SummaryReceipts(
        id: json['id'],
        name: json['name'],
        date: json['date'],
        price: json['total_price']);
  }
}
