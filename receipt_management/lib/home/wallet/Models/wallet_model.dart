import 'package:equatable/equatable.dart';

class WalletModel extends Equatable {
  final String id;
  final String merchant;
  final double totalPrice;
  final List items;

  const WalletModel({
    required this.id,
    required this.merchant,
    required this.totalPrice,
    required this.items,
  });

  @override
  List<Object?> get props => [
        id,
        merchant,
        totalPrice,
      ];

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      merchant: json['business place name'],
      totalPrice: json['total price'].toDouble(),
      items: json['items'].toList().map((item) => item['name']).toList(),
    );
  }
}
