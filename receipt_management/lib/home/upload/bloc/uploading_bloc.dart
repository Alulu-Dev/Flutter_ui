import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/upload/bloc/uploading_event.dart';
import 'package:receipt_management/home/upload/bloc/uploading_state.dart';
import 'package:receipt_management/home/upload/repository/receipt_upload_repository.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ReceiptUploadRepository receiptUploadRepository =
      ReceiptUploadRepository();
  UploadBloc() : super(UploadInitial()) {
    on<UploadImage>(_onUploadImage);
  }
  Future<void> _onUploadImage(
      UploadImage event, Emitter<UploadState> emit) async {
    try {
      print('object');
      final statusCode =
          await receiptUploadRepository.imageRoute(event.receiptImage);
      print(statusCode);
      emit(UploadingImage());
    } catch (e) {
      emit(UploadFailed(errorMsg: "Upload Failed"));
    }
  }
}
