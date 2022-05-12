import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:receipt_management/expense/models/category_summary_model.dart';

/// Example of hiding both axis.
class HiddenTicksAndLabelsAxis extends StatelessWidget {
  final List<charts.Series<MonthlyExpense, String>> seriesList;
  final bool animate;

  HiddenTicksAndLabelsAxis(this.seriesList, {required this.animate});

  factory HiddenTicksAndLabelsAxis.withSampleData() {
    return HiddenTicksAndLabelsAxis(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  factory HiddenTicksAndLabelsAxis.withMonthlySummary(
      List<MonthlySummary> summaries, String month) {
    return HiddenTicksAndLabelsAxis(
      _createDataFromList(summaries, month),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 45,
          labelJustification: charts.TickLabelJustification.outside,
          // Tick and Label styling here.
          labelStyle: charts.TextStyleSpec(
              fontSize: 10, // size in Pts.
              color: charts.MaterialPalette.white),

          // Change the line colors to match text color.
          lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.white),
        ),
      ),
      primaryMeasureAxis:
          const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
  }

  /// Create series list with single series
  static List<charts.Series<MonthlyExpense, String>> _createSampleData() {
    final globalSalesData = [
      MonthlyExpense('Jan', 5, Colors.amber),
      MonthlyExpense('Feb', 10, Colors.amber.shade100),
      MonthlyExpense('Mar', 11, Colors.amber.shade100),
      MonthlyExpense('Apr', 3, Colors.amber.shade100),
      MonthlyExpense('May', 5, Colors.amber.shade100),
      MonthlyExpense('Jun', 6, Colors.amber.shade100),
      MonthlyExpense('Jul', 1, Colors.amber.shade100),
      MonthlyExpense('Agu', 1, Colors.amber.shade100),
      MonthlyExpense('Sep', 1, Colors.amber.shade100),
      MonthlyExpense('Oct', 1, Colors.amber.shade100),
      MonthlyExpense('Nov', 1, Colors.amber.shade100),
      MonthlyExpense('Dec', 1, Colors.amber.shade100),
    ];

    return [
      charts.Series<MonthlyExpense, String>(
        id: 'Global Revenue',
        domainFn: (MonthlyExpense expense, _) => expense.month,
        measureFn: (MonthlyExpense expense, _) => expense.total,
        colorFn: (MonthlyExpense expense, _) =>
            charts.ColorUtil.fromDartColor(expense.color),
        data: globalSalesData,
      ),
    ];
  }

  static List<charts.Series<MonthlyExpense, String>> _createDataFromList(
      List<MonthlySummary> summaries, String month) {
    final List<MonthlyExpense> summaryData = [];
    Color currentMonthColor = Colors.amber.shade700;
    const Color monthsColor = Colors.amber;

    for (final MonthlySummary summary in summaries) {
      final data = MonthlyExpense(summary.month, summary.total,
          month == summary.month ? currentMonthColor : monthsColor);
      summaryData.add(data);
    }

    return [
      charts.Series<MonthlyExpense, String>(
        id: 'Monthly Summary',
        domainFn: (MonthlyExpense expense, _) => expense.month,
        measureFn: (MonthlyExpense expense, _) => expense.total,
        colorFn: (MonthlyExpense expense, _) =>
            charts.ColorUtil.fromDartColor(expense.color),
        data: summaryData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class MonthlyExpense {
  final String month;
  final double total;
  final Color color;

  MonthlyExpense(this.month, this.total, this.color);
}
