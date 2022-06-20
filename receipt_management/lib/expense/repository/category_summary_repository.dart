import 'package:http/http.dart' as http;
import 'package:receipt_management/expense/data_providers/category_summary_data.dart';
import 'package:receipt_management/expense/models/category_summary_model.dart';
import 'package:receipt_management/expense/models/receipts_summary_model.dart';

class CategorySummaryRepository {
  final CategorySummaryProvider summaryProvider =
      CategorySummaryProvider(httpClient: http.Client());

  Future<FormattedCategorySummary> allCategorySummary() async {
    try {
      final _responseBody = await summaryProvider.allCategoriesSummary();
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
          await summaryProvider.singleCategoriesSummary(catId);
      final _allCategorySummary = SingleCategorySummary.fromJson(_responseBody);
      return _allCategorySummary;
    } catch (e) {
      throw Exception('Not Summary Object');
    }
  }

  Future<String> createSummary(
      String title, String note, List<Map> receipts) async {
    try {
      final _response =
          await summaryProvider.createSummary(title, note, receipts);
      return _response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ReceiptExpenseSummary>> allReceiptSummaries() async {
    try {
      final _responseBody = await summaryProvider.allReceiptSummaries();
      List<ReceiptExpenseSummary> _summaries = [];
      for (final data in _responseBody) {
        final _summary = ReceiptExpenseSummary.fromJson(data);
        _summaries.add(_summary);
      }

      return _summaries;
    } catch (e) {
      rethrow;
    }
  }

  Future<ReceiptExpenseSummaryDetails> receiptSummary(String summaryId) async {
    try {
      final _responseBody = await summaryProvider.receiptSummary(summaryId);
      final _receiptSummary =
          ReceiptExpenseSummaryDetails.fromJson(_responseBody);
      return _receiptSummary;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteReceiptSummary(String summaryID) async {
    try {
      final _responseStatus =
          await summaryProvider.deleteReceiptSummary(summaryID);

      return _responseStatus;
    } catch (e) {
      throw Exception('Not Summary Object');
    }
  }
}
