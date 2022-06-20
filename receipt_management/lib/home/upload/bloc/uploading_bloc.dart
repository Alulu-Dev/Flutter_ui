import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/upload/bloc/uploading_event.dart';
import 'package:receipt_management/home/upload/bloc/uploading_state.dart';
import 'package:receipt_management/home/upload/repository/receipt_upload_repository.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ReceiptUploadRepository receiptUploadRepository =
      ReceiptUploadRepository();
  UploadBloc() : super(UploadInitial()) {
    on<UploadImage>(_onUploadImage);
    on<ReceiptsSave>(_onReceiptSave);
  }
  Future<void> _onUploadImage(
      UploadImage event, Emitter<UploadState> emit) async {
    try {
      emit(UploadProcessing());
      final _receiptData =
          await receiptUploadRepository.imageRoute(event.receiptImage);
      emit(UploadingImage(
        receiptImage: event.receiptImage,
        receiptData: _receiptData,
      ));
    } catch (e) {
      emit(UploadFailed(errorMsg: "Upload Failed"));
    }
  }

  Future<void> _onReceiptSave(
      ReceiptsSave event, Emitter<UploadState> emit) async {
    try {
      final _receiptData = await receiptUploadRepository.uploadReceipt(
          event.receiptImage, event.receiptData, event.catId, event.note);
      emit(UploadedReceipt(receiptID: _receiptData));
    } catch (e) {
      emit(UploadFailed(errorMsg: "Upload Failed"));
    }
  }
}
