import 'package:receipt_management/home/prediction/model/prediction_model.dart';

abstract class PredictionState {}

class PredictionInitial extends PredictionState {}

class PredictionLoaded extends PredictionState {
  final PredictionModel prediction;
  PredictionLoaded({required this.prediction});
}

class PredictionFailed extends PredictionState {
  final String errorMsg;
  PredictionFailed({required this.errorMsg});
}
