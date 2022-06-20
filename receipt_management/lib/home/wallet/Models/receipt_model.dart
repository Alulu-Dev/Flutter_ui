import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ReceiptModel extends Equatable {
  final String id;
  final String merchant;
  final double totalAmount;
  final String date;
  final String note;
  final String tinNumber;
  final String registerId;
  final String fsNumber;
  final Image image;

  final List<ItemsModel> items;

  const ReceiptModel({
    required this.id,
    required this.merchant,
    required this.totalAmount,
    required this.date,
    required this.note,
    required this.tinNumber,
    required this.registerId,
    required this.fsNumber,
    required this.items,
    required this.image,
  });

  @override
  List<Object?> get props => [
        id,
        merchant,
        totalAmount,
        date,
        note,
        tinNumber,
        registerId,
        fsNumber,
        items,
        image
      ];

  factory ReceiptModel.fromJson(
      Map<dynamic, dynamic> json, Uint8List? imageBytes) {
    late List<ItemsModel> items = [];
    for (final item in json['items']) {
      final itemModel = ItemsModel.fromJson(item);
      items.add(itemModel);
    }
    return ReceiptModel(
      id: json['id'],
      merchant: json['business place name'],
      totalAmount: json['total price'],
      date: json['issued date'],
      note: json['description'],
      tinNumber: json['tin number'],
      registerId: json['register id'],
      fsNumber: json['fs number'],
      items: items,
      image: imageBytes != null
          ? Image.memory(imageBytes)
          : Image.asset('assets/images/receipt-icon.jpg'),
    );
  }
}

class ItemsModel extends Equatable {
  final String id;
  final String itemName;
  final double itemPrice;
  final double itemQuantity;

  const ItemsModel(
      {required this.id,
      required this.itemName,
      required this.itemPrice,
      required this.itemQuantity});

  @override
  List<Object?> get props => [
        id,
        itemName,
        itemPrice,
        itemQuantity,
      ];

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
        id: json['id'],
        itemName: json['name'],
        itemPrice: json['price'],
        itemQuantity: json['quantity'].toDouble());
  }
}
