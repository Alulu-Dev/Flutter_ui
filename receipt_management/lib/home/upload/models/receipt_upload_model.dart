import 'package:equatable/equatable.dart';

class ReceiptUploadModel extends Equatable {
  final String merchant;
  final double totalAmount;
  final String date;
  final String tinNumber;
  final String registerId;
  final String fsNumber;

  final List<ItemsUploadModel> items;

  const ReceiptUploadModel({
    required this.merchant,
    required this.totalAmount,
    required this.date,
    required this.tinNumber,
    required this.registerId,
    required this.fsNumber,
    required this.items,
  });

  @override
  List<Object?> get props => [
        merchant,
        totalAmount,
        date,
        tinNumber,
        registerId,
        fsNumber,
        items,
      ];

  factory ReceiptUploadModel.fromJson(Map<dynamic, dynamic> json) {
    late List<ItemsUploadModel> items = [];
    for (final item in json['Items']) {
      final itemModel = ItemsUploadModel.fromJson(item);
      items.add(itemModel);
    }
    return ReceiptUploadModel(
      merchant: json['business_place_name'],
      totalAmount: json['total_price'].toDouble(),
      date: json['issued_date'],
      tinNumber: json['tin_number'],
      registerId: json['register_id'],
      fsNumber: json['fs_number'],
      items: items,
    );
  }
}

class ItemsUploadModel extends Equatable {
  final String itemName;
  final double itemPrice;
  final double itemQuantity;

  const ItemsUploadModel(
      {required this.itemName,
      required this.itemPrice,
      required this.itemQuantity});

  @override
  List<Object?> get props => [
        itemName,
        itemPrice,
        itemQuantity,
      ];

  factory ItemsUploadModel.fromJson(Map<String, dynamic> json) {
    return ItemsUploadModel(
        itemName: json['name'],
        itemPrice: json['item_price'].toDouble(),
        itemQuantity: json['quantity'].toDouble());
  }
}
