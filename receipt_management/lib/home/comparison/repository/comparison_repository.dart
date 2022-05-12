import 'package:http/http.dart' as http;
import 'package:receipt_management/home/comparison/dataProvider/comparison_data_provider.dart';
import 'package:receipt_management/home/comparison/models/comparison_models.dart';

class ComparisonRepository {
  final ComparisonDataProvider comparisonDataProvider =
      ComparisonDataProvider(httpClient: http.Client());

  Future<List<ComparisonModel>> userComparisonList() async {
    try {
      final _comparisonList = await comparisonDataProvider.userComparisonList();
      final _formattedList = _comparisonList
          .map((record) => ComparisonModel.fromJson(record))
          .toList();
      return _formattedList;
    } catch (e) {
      rethrow;
    }
  }

  Future<ComparisonDetailModel> comparisonDetailRepository(
      String recordId) async {
    try {
      final _comparisonDetail =
          await comparisonDataProvider.comparisonDetailRoute(recordId);
      final _formattedDetail =
          ComparisonDetailModel.fromJson(_comparisonDetail);
      return _formattedDetail;
    } catch (e) {
      rethrow;
    }
  }

  Future createComparisonRepository(String itemId) async {
    try {
      final _comparisonDetail =
          await comparisonDataProvider.createComparisonRoute(itemId);
      final _id = _comparisonDetail['id'];
      return _id;
    } catch (e) {
      throw Exception('Comparison Not Created!');
    }
  }

  Future getComparableItems() async {
    try {
      final _responseBody = await comparisonDataProvider.getComparableItems();
      final List<ComparableItemsModel> _itemsList = [];
      for (final data in _responseBody) {
        final item = ComparableItemsModel.fromJson(data);
        _itemsList.add(item);
      }

      return _itemsList;
    } catch (e) {
      throw Exception('No Data!');
    }
  }

  Future<ComparisonDetailModel> updateComparison(String recordId) async {
    try {
      final _comparisonDetail =
          await comparisonDataProvider.updateComparison(recordId);
      final _formattedDetail =
          ComparisonDetailModel.fromJson(_comparisonDetail);
      return _formattedDetail;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteComparison(String recordId) async {
    try {
      final _result = await comparisonDataProvider.deleteComparison(recordId);
      return _result;
    } catch (e) {
      rethrow;
    }
  }
}
