import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:receipt_management/config/shared_preferences.dart';
import 'package:receipt_management/home/upload/models/receipt_upload_model.dart';

class ReceiptUploadProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1/upload';
  final http.Client httpClient;
  late http.MultipartRequest httpMultipartRequest;

  final _preference = SharedPreferenceStorage();
  ReceiptUploadProvider({required this.httpClient});

  Future imageRoute(File receipt) async {
    final sessionID = await _preference.getSession();
    httpMultipartRequest =
        http.MultipartRequest("POST", Uri.parse("$_baseUrl/Scan"));
    httpMultipartRequest.headers.addAll({'cookie': 'session=$sessionID'});

    httpMultipartRequest.files.add(await http.MultipartFile.fromPath(
      "file",
      receipt.path,
      contentType: MediaType('image', '*'),
    ));

    final _response = await httpMultipartRequest.send();

    if (_response.statusCode == 200) {
      final _responseBody = jsonDecode(await _response.stream.bytesToString());
      return _responseBody;
    } else {
      throw Exception('Failed to upload Receipt Image');
    }
  }

  Future uploadReceipt(
      File image, ReceiptUploadModel data, String catId, String note) async {
    final sessionID = await _preference.getSession();

    List items = [];
    for (var item in data.items) {
      final x = {
        "name": item.itemName,
        "quantity": item.itemQuantity,
        "item_price": item.itemPrice
      };
      items.add(x);
      items.add("~");
    }

    httpMultipartRequest =
        http.MultipartRequest("POST", Uri.parse("$_baseUrl/upload"));
    httpMultipartRequest.headers.addAll({'cookie': 'session=$sessionID'});

    httpMultipartRequest.files.add(await http.MultipartFile.fromPath(
      "file",
      image.path,
      contentType: MediaType('image', '*'),
    ));
    httpMultipartRequest.fields["tin_number"] = data.tinNumber;
    httpMultipartRequest.fields["fs_number"] = data.fsNumber;
    httpMultipartRequest.fields["issued_date"] = data.date;
    httpMultipartRequest.fields["business_place_name"] = data.merchant;
    httpMultipartRequest.fields["description"] = note;
    httpMultipartRequest.fields["register_id"] = data.registerId;
    httpMultipartRequest.fields["category_id"] = catId;
    httpMultipartRequest.fields["total_price"] = data.totalAmount.toString();
    httpMultipartRequest.fields["Items"] = items.toString();

    final _response = await httpMultipartRequest.send();

    if (_response.statusCode == 200) {
      final _responseBody = jsonDecode(await _response.stream.bytesToString());
      print(_responseBody);
      return _responseBody;
    } else {
      throw Exception('Failed to upload Receipt Image');
    }
  }
}
