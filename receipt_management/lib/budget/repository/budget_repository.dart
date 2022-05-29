import 'package:http/http.dart' as http;
import 'package:receipt_management/budget/data_providers/budget_data.dart';
import 'package:receipt_management/budget/models/budget_model.dart';

class BudgetRepository {
  final BudgetProvider categorySummaryProvider =
      BudgetProvider(httpClient: http.Client());

  Future<List<BudgetModel>> allBudgets() async {
    try {
      final _responseBody = await categorySummaryProvider.allBudgets();

      final List<BudgetModel> _allBudgets = [];
      for (final budget in _responseBody) {
        final data = BudgetModel.fromJson(budget);
        _allBudgets.add(data);
      }
      return _allBudgets;
    } catch (e) {
      throw Exception('No budget Object');
    }
  }

  Future<String> setBudget(String catId, String amount) async {
    try {
      final _responseBody =
          await categorySummaryProvider.setBudget(catId, amount);

      return _responseBody;
    } catch (e) {
      throw Exception('Budget Creation Failed');
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final _responseBody = await categorySummaryProvider.getAllCategories();

      late List<CategoryModel> _allCategories = [];
      for (final item in _responseBody) {
        final category = CategoryModel.fromJson(item);
        _allCategories.add(category);
      }

      return _allCategories;
    } catch (e) {
      throw Exception('Budget Creation Failed');
    }
  }
}
