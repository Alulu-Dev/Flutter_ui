import 'dart:io';

import 'package:flutter/material.dart';
import 'package:receipt_management/budget/screens/budgets_screens.dart';
import 'package:receipt_management/budget/screens/new_budget_screen.dart';
import 'package:receipt_management/expense/screens/receipts_summaries.dart';
import 'package:receipt_management/expense/screens/receipts_summary_details.dart';
import 'package:receipt_management/expense/screens/summary_by_receipt.dart';
import 'package:receipt_management/home/comparison/screens/comparison_detail_screen.dart';
import 'package:receipt_management/expense/screens/summary_by_category_details.dart';
import 'package:receipt_management/expense/screens/summary_category_screens.dart';
import 'package:receipt_management/home/home_page.dart';
import 'package:receipt_management/home/upload/screens/receipt_upload_page.dart';
import 'package:receipt_management/requests/screens/requests_screen.dart';

import '../auth/login/screens/login_screen.dart';
import '../auth/register/screens/register_screen.dart';
import '../home/upload/screens/receipt_reading_screen.dart';
import '../home/wallet/screens/receipt_detail_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/receiptUpload':
        return MaterialPageRoute(builder: (_) => const ReceiptUploadPage());
      case '/receiptDetails':
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => ReceiptDetailScreen(
                    receiptId: args,
                  ));
        }
        return _errorRoute();

      case '/comparisonDetail':
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => ComparisonDetailScreen(
                    comparisonId: args,
                  ));
        }
        return _errorRoute();

      case '/receiptScanning':
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => ReceiptScanningScreen(
                    image: args[0],
                    receiptData: args[1],
                  ));
        }
        return _errorRoute();
      case '/expenseSummary':
        return MaterialPageRoute(builder: (_) => const ExpenseSummaryScreen());
      case '/expenseDetail':
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => ExpenseDetail(
                    catId: args,
                  ));
        }
        return _errorRoute();
      case '/summaryOfReceipts':
        return MaterialPageRoute(builder: (_) => const SummaryByReceipt());
      case '/budgets':
        return MaterialPageRoute(builder: (_) => const BudgetScreen());

      case '/newBudgets':
        return MaterialPageRoute(builder: (_) => const BudgetAddScreen());

      case '/requests':
        return MaterialPageRoute(builder: (_) => const RequestScreen());

      case "/receiptSummary":
        return MaterialPageRoute(builder: (_) => const ReceiptsSummaryScreen());
      case "/receiptSummaryDetails":
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => ReceiptsSummaryScreenDetails(
                    summaryId: args,
                  ));
        }
        return _errorRoute();

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
