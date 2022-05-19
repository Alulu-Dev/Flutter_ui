import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/prediction/bloc/prediction_event.dart';
import 'package:receipt_management/home/prediction/bloc/prediction_state.dart';
import 'package:receipt_management/home/prediction/repository/prediction_repository.dart';

class PredictionBloc extends Bloc<PredictionEvent, PredictionState> {
  final PredictionRepository _predictionRepository = PredictionRepository();
  PredictionBloc() : super(PredictionInitial()) {
    on<PredictionLoad>(_onPredictionLoad);
    on<PredictionUnload>(_onPredictionUnload);
  }

  Future<void> _onPredictionLoad(
      PredictionLoad event, Emitter<PredictionState> emit) async {
    try {
      final _prediction = await _predictionRepository.getPrediction();
      emit(PredictionLoaded(prediction: _prediction));
    } catch (e) {
      // emit(PredictionFailed(errorMsg: e.toString()));
    }
  }

  Future<void> _onPredictionUnload(
      PredictionUnload event, Emitter<PredictionState> emit) async {
    try {
      emit(PredictionInitial());
    } catch (e) {
      // emit(PredictionFailed(errorMsg: e.toString()));
    }
  }
}
