import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:receipt_management/home/upload/dataProvider/receipt_upload_data.dart';

class ReceiptUploadRepository {
  final ReceiptUploadProvider receiptUploadProvider =
      ReceiptUploadProvider(httpClient: http.Client());

  Future<String> imageRoute(File receipt) async {
    return await receiptUploadProvider.imageRoute(receipt);
  }
}
