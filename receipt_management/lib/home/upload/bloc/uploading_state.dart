import 'dart:io';

import 'package:receipt_management/home/upload/models/receipt_upload_model.dart';

abstract class UploadState {}

class UploadInitial extends UploadState {}

class UploadedImage extends UploadState {
  final String receiptID;

  UploadedImage({required this.receiptID});
}

class UploadingImage extends UploadState {
  final File receiptImage;
  final ReceiptUploadModel receiptData;

  UploadingImage({required this.receiptImage, required this.receiptData});
}

class UploadedReceipt extends UploadState {
  final String receiptID;
  UploadedReceipt({required this.receiptID});
}

class UploadProcessing extends UploadState {}

class UploadFailed extends UploadState {
  final String errorMsg;

  UploadFailed({required this.errorMsg});
}
