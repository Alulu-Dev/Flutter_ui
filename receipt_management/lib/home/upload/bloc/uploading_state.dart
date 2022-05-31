abstract class UploadState {}

class UploadInitial extends UploadState {}

class UploadedImage extends UploadState {
  final String receiptID;

  UploadedImage({required this.receiptID});
}

class UploadingImage extends UploadState {}

class UploadFailed extends UploadState {
  final String errorMsg;

  UploadFailed({required this.errorMsg});
}
