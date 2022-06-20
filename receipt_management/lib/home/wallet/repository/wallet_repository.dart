import 'package:http/http.dart' as http;
import 'package:receipt_management/home/wallet/Models/receipt_model.dart';
import 'package:receipt_management/home/wallet/Models/wallet_model.dart';
import 'package:receipt_management/home/wallet/dataProvider/wallet_data_providers.dart';

class WalletRepository {
  final WalletListProvider walletDataProvider =
      WalletListProvider(httpClient: http.Client());

  Future<List<WalletModel>> userWalletRoute() async {
    try {
      final _userReceiptsList = await walletDataProvider.userWalletRoute();
      final _receipts = _userReceiptsList
          .map((receipt) => WalletModel.fromJson(receipt))
          .toList();
      return _receipts;
    } catch (e) {
      throw Exception('Not Receipt Object');
    }
  }

  Future<ReceiptModel> receiptDetails(String receiptID) async {
    final _receiptDetails = await walletDataProvider.receiptDetails(receiptID);
    late final ReceiptModel _receipt;
    switch (_receiptDetails.length) {
      case 1:
        _receipt = ReceiptModel.fromJson(_receiptDetails[0], null);
        break;
      case 2:
        _receipt =
            ReceiptModel.fromJson(_receiptDetails[0], _receiptDetails[1]);
        break;
      default:
    }
    return _receipt;
  }

  Future<String> receiptVerificationRequest(String receiptId) async {
    final _request =
        await walletDataProvider.receiptVerificationRequest(receiptId);
    return _request;
  }

  Future<String> receiptVerificationStatusCheck(String receiptId) async {
    final _request =
        await walletDataProvider.receiptVerificationStatusCheck(receiptId);
    return _request;
  }

  Future<bool> receiptDelete(String receiptId) async {
    final _request = await walletDataProvider.receiptDelete(receiptId);
    return _request;
  }
}
