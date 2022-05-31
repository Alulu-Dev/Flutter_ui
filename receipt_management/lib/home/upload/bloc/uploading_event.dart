import 'dart:io';

abstract class UploadEvent {}

class UploadImage extends UploadEvent {
  File receiptImage;

  UploadImage({required this.receiptImage});
}
