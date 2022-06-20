import 'package:http/http.dart' as http;
import 'package:receipt_management/home/prediction/data_provider/prediction_data.dart';
import 'package:receipt_management/home/prediction/model/prediction_model.dart';

class PredictionRepository {
  final PredictionProvider _requestProvider =
      PredictionProvider(httpClient: http.Client());

  Future<PredictionModel> getPrediction() async {
    try {
      final _responseBody = await _requestProvider.getPrediction();

      if (_responseBody is String) {
        throw Exception(_responseBody);
      }

      final _prediction = PredictionModel.fromJson(_responseBody);

      return _prediction;
    } catch (e) {
      rethrow;
    }
  }
}
