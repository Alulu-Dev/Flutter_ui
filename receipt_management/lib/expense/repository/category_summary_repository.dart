import 'package:http/http.dart' as http;
import 'package:receipt_management/expense/data_prodivers/category_summary_data.dart';
import 'package:receipt_management/expense/models/category_summary_model.dart';

class CategorySummaryRepository {
  final CategorySummaryProvider categorySummaryProvider =
      CategorySummaryProvider(httpClient: http.Client());

  Future<FormattedCategorySummary> allCategorySummary() async {
    try {
      final _responseBody =
          await categorySummaryProvider.allCategoriesSummary();

      final _allCategorySummary =
          FormattedCategorySummary.fromJson(_responseBody);
      return _allCategorySummary;
    } catch (e) {
      throw Exception('Not Summary Object');
    }
  }

  Future<SingleCategorySummary> singleCategorySummary(String catId) async {
    try {
      final _responseBody =
          await categorySummaryProvider.singleCategoriesSummary(catId);
      final _allCategorySummary = SingleCategorySummary.fromJson(_responseBody);
      return _allCategorySummary;
    } catch (e) {
      throw Exception('Not Summary Object');
    }
  }
}
