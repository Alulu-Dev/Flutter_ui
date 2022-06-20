import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:receipt_management/home/upload/dataProvider/receipt_upload_data.dart';
import 'package:receipt_management/home/upload/models/receipt_upload_model.dart';

class ReceiptUploadRepository {
  final ReceiptUploadProvider receiptUploadProvider =
      ReceiptUploadProvider(httpClient: http.Client());

  Future imageRoute(File receipt) async {
    final _responseBody = await receiptUploadProvider.imageRoute(receipt);

    final _receiptData = ReceiptUploadModel.fromJson(_responseBody);
    return _receiptData;
  }

  Future uploadReceipt(
      File image, ReceiptUploadModel data, String catId, String note) async {
    final _responseBody =
        await receiptUploadProvider.uploadReceipt(image, data, catId, note);

    return _responseBody;
  }
}
