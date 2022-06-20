import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:receipt_management/auth/login/bloc/login_bloc.dart';
import 'package:receipt_management/auth/profile/bloc/profile_bloc.dart';
import 'package:receipt_management/auth/register/bloc/register_bloc.dart';
import 'package:receipt_management/budget/bloc/bloc.dart';
import 'package:receipt_management/expense/bloc/bloc.dart';
import 'package:receipt_management/home/comparison/bloc/bloc.dart';
import 'package:receipt_management/home/prediction/bloc/bloc.dart';
import 'package:receipt_management/home/upload/bloc/uploading_bloc.dart';
import 'package:receipt_management/home/wallet/bloc/bloc.dart';
import 'package:receipt_management/requests/bloc/request_bloc.dart';

import 'config/routes.dart';
import 'home/prediction/bloc/prediction_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => RegistrationBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => WalletBloc()),
        BlocProvider(create: (context) => ReceiptBloc()),
        BlocProvider(create: (context) => RequestBloc()),
        BlocProvider(create: (context) => UploadBloc()),
        BlocProvider(create: (context) => ComparisonBloc()),
        BlocProvider(create: (context) => ComparisonDetailBloc()),
        BlocProvider(create: (context) => ComparisonCreateBloc()),
        BlocProvider(create: (context) => CategorySummaryBloc()),
        BlocProvider(create: (context) => SingleCategorySummaryBloc()),
        BlocProvider(create: (context) => BudgetBloc()),
        BlocProvider(create: (context) => NewBudgetBloc()),
        BlocProvider(create: (context) => UserRequestBloc()),
        BlocProvider(create: (context) => PredictionBloc()),
        BlocProvider(create: (context) => ReceiptsSummaryBloc()),
        BlocProvider(create: (context) => ReceiptsSummaryListBloc()),
        BlocProvider(create: (context) => ReceiptsSummaryDetailsBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Receipt Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: HomePage(),
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
