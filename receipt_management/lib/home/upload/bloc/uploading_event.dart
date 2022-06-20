import 'dart:io';

import 'package:receipt_management/home/upload/models/receipt_upload_model.dart';

abstract class UploadEvent {}

class UploadImage extends UploadEvent {
  File receiptImage;

  UploadImage({required this.receiptImage});
}

class ReceiptsSave extends UploadEvent {
  final File receiptImage;
  final ReceiptUploadModel receiptData;
  final String catId;
  final String note;
  ReceiptsSave({
    required this.receiptImage,
    required this.receiptData,
    required this.catId,
    required this.note,
  });
}
