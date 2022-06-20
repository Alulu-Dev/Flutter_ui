import 'package:equatable/equatable.dart';

class ReceiptExpenseSummary extends Equatable {
  final String id;
  final String title;
  final String note;
  final double totalPrice;

  const ReceiptExpenseSummary({
    required this.id,
    required this.title,
    required this.note,
    required this.totalPrice,
  });
  @override
  List<Object?> get props => [id, title, note, totalPrice];

  factory ReceiptExpenseSummary.fromJson(Map<String, dynamic> json) {
    return ReceiptExpenseSummary(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      totalPrice: json['total price'],
    );
  }
}

class ReceiptExpenseSummaryDetails extends Equatable {
  final String title;
  final String note;
  final double totalPrice;
  final List<ReceiptData> receipts;

  const ReceiptExpenseSummaryDetails({
    required this.title,
    required this.note,
    required this.totalPrice,
    required this.receipts,
  });

  @override
  List<Object?> get props => [title, note, totalPrice, receipts];

  factory ReceiptExpenseSummaryDetails.fromJson(Map<String, dynamic> json) {
    final List<ReceiptData> receipts = [];
    for (final receipt in json['receipts']) {
      final data = ReceiptData.fromJson(receipt);
      receipts.add(data);
    }
    return ReceiptExpenseSummaryDetails(
      title: json['title'],
      note: json['note'],
      totalPrice: json['total price'].toDouble(),
      receipts: receipts,
    );
  }
}

class ReceiptData extends Equatable {
  final String merchant;
  final double totalReceiptPrice;
  final List<ItemsData> items;

  const ReceiptData({
    required this.merchant,
    required this.totalReceiptPrice,
    required this.items,
  });
  @override
  List<Object?> get props => [merchant, totalReceiptPrice, items];

  factory ReceiptData.fromJson(Map<String, dynamic> json) {
    final List<ItemsData> items = [];
    for (final item in json['items']) {
      final data = ItemsData.fromJson(item);
      items.add(data);
    }

    return ReceiptData(
      merchant: json['shop'],
      totalReceiptPrice: json['total price'].toDouble(),
      items: items,
    );
  }
}

class ItemsData extends Equatable {
  final String name;
  final double quantity;
  final double price;

  const ItemsData({
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [
        name,
        quantity,
        price,
      ];

  factory ItemsData.fromJson(Map<String, dynamic> json) {
    return ItemsData(
      name: json['name'],
      quantity: json["quantity"].toDouble(),
      price: json["price"].toDouble(),
    );
  }
}
