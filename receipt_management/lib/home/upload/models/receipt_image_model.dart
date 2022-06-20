import 'dart:io';

import 'package:equatable/equatable.dart';

class ReceiptImage extends Equatable {
  final File receiptImage;

  const ReceiptImage({required this.receiptImage});

  @override
  List<Object?> get props => [receiptImage];

  // factory ReceiptImage.fromJson(Map<String, dynamic> json) {
  //   return ReceiptImage(receiptImage: json['file']);
  // }
}


