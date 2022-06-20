import 'package:http/http.dart' as http;
import 'package:receipt_management/requests/data_providers/request_data.dart';
import 'package:receipt_management/requests/models/requests_model.dart';

class RequestRepository {
  final UserRequestProvider _requestProvider =
      UserRequestProvider(httpClient: http.Client());

  Future<List<RequestModel>> allRequest() async {
    try {
      final _responseBody = await _requestProvider.allRequest();

      final List<RequestModel> _allBudgets = [];
      for (final budget in _responseBody) {
        final data = RequestModel.fromJson(budget);
        _allBudgets.add(data);
      }
      return _allBudgets;
    } catch (e) {
      throw Exception('No budget Object');
    }
  }
}
