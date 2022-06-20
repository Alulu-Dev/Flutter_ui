import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/openFile.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:receipt_management/expense/bloc/bloc.dart';
import 'package:receipt_management/expense/models/category_summary_model.dart';
import 'package:receipt_management/widgets/app_bar.dart';

class ExpenseDetail extends StatefulWidget {
  final String catId;
  const ExpenseDetail({Key? key, required this.catId}) : super(key: key);

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  late final SingleCategorySummaryBloc _summaryBloc;
  final List<String> _category = [
    "Food & Drink",
    "Clothing & Shoes",
    "Car",
    "House",
    "Electric"
  ];

  @override
  void dispose() {
    _summaryBloc.add(SingleCategorySummaryUnload());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _summaryBloc = BlocProvider.of<SingleCategorySummaryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "Summary details"),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: BlocBuilder<SingleCategorySummaryBloc,
              SingleCategorySummaryState>(
            builder: (context, state) {
              if (state is SingleCategorySummaryLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state is SingleCategorySummaryLoaded) {
                final spent = state.summary.totalPrice;
                final catName = state.summary.catName;
                final date = state.summary.date;
                final budget = state.summary.budget;
                String usagePercent = "0";
                if (budget != 0) {
                  usagePercent = ((spent.toDouble() * 100) / budget)
                      .toStringAsExponential(3);
                }
                final receipts = state.summary.receipts;

                return Stack(
                  children: [
                    _headerTitle(
                        spent.toString(), catName, date, budget.toString()),
                    Positioned(
                      right: 20,
                      child: IconButton(
                          onPressed: () {
                            _pdfExport(state.summary);
                          },
                          icon: Icon(Icons.adaptive.share)),
                    ),
                    Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        child:
                            _budgetChart(num.parse(usagePercent).toDouble())),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: _expenseListContainer(receipts)),
                  ],
                );
              }
              if (state is SingleCategorySummaryFailed) {
                final msg = state.errorMsg;

                return Center(
                  heightFactor: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.hourglass_empty_rounded,
                      ),
                      Text(msg)
                    ],
                  ),
                );
              }

              _summaryBloc.add(SingleCategorySummaryLoad(catId: widget.catId));
              return const Center(
                child: Text("No Data!"),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _headerTitle(
      String spent, String catName, String date, String budget) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spent,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                catName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                'Budget: \$$budget',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _budgetChart(double usagePercent) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        height: 100,
        child: Stack(children: [
          Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                value: usagePercent / 100,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(255, 83, 83, 1.0)),
                backgroundColor: const Color(0xffD6D6D6),
              ),
            ),
          ),
          Center(child: Text("$usagePercent%"))
        ]),
      ),
      // ),
    );
  }

  Widget _expenseListContainer(List<SummaryReceipts> receipts) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: ((_category.length) * 80) >= height / 2.25
          ? height / 2.25
          : (_category.length) * 100,
      width: width,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 15,
          )
        ],
      ),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: receipts.length,
          itemExtent: 80,
          itemBuilder: (BuildContext context, int index) {
            return expenseItems(receipts[index]);
          }),
    );
  }

  Widget expenseItems(SummaryReceipts receipt) {
    final id = receipt.id;
    final name = receipt.name;
    final date = receipt.date;
    final price = receipt.price;
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/receiptDetails', arguments: id);
      },
      leading: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 203, 237, 207),
          ),
          child: const Icon(
            Icons.attach_money_outlined,
            size: 30,
            color: Color.fromARGB(255, 255, 0, 76),
          )),
      title: Text(
        name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
      subtitle: Text(
        "Date: $date",
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w200,
        ),
      ),
      trailing: Text(
        "\$$price",
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }

  Future<void> _pdfExport(SingleCategorySummary summary) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    String _pdfTitleLabel = "Expense Category: ";
    String _pdfTitleValue = summary.catName;

    String _pdfTotalPriceLabel = "Total Price: ";
    String _pdfTotalPriceValue = summary.totalPrice.toString();

    String _pdfDateLabel = "Month:";
    String _pdfDateValue = summary.date;

    String _pdfBudgetLabel = "Total Price: ";
    String _pdfBudgetValue = "\$" + summary.budget.toString();

    final PdfLayoutResult _pdfTitleLabelLayout = PdfTextElement(
            text: _pdfTitleLabel,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
    PdfTextElement(
            text: _pdfTitleValue,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(_pdfTitleLabelLayout.bounds.right / 2.5, 0,
                page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

    final PdfLayoutResult _pdfTotalPriceLabelLayout = PdfTextElement(
            text: _pdfTotalPriceLabel,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(0, _pdfTitleLabelLayout.bounds.bottom + 20,
                page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
    PdfTextElement(
            text: _pdfTotalPriceValue,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                _pdfTotalPriceLabelLayout.bounds.right / 2.5,
                _pdfTitleLabelLayout.bounds.bottom + 20,
                page.getClientSize().width,
                page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

    final PdfLayoutResult _pdfDateLabelLayout = PdfTextElement(
            text: _pdfDateLabel,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                0,
                _pdfTotalPriceLabelLayout.bounds.bottom + 20,
                page.getClientSize().width,
                page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
    PdfTextElement(
            text: _pdfDateValue,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                _pdfTotalPriceLabelLayout.bounds.right / 2.5,
                _pdfTotalPriceLabelLayout.bounds.bottom + 20,
                page.getClientSize().width,
                page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

    final PdfLayoutResult _pdfBudgetLabelLayout = PdfTextElement(
            text: _pdfBudgetLabel,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(0, _pdfDateLabelLayout.bounds.bottom + 20,
                page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
    PdfTextElement(
            text: _pdfBudgetValue,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                _pdfTotalPriceLabelLayout.bounds.right / 2.5,
                _pdfDateLabelLayout.bounds.bottom + 20,
                page.getClientSize().width,
                page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

    page.graphics.drawLine(
        PdfPen(PdfColor(255, 0, 0)),
        Offset(0, _pdfBudgetLabelLayout.bounds.bottom + 25),
        Offset(page.getClientSize().width,
            _pdfBudgetLabelLayout.bounds.bottom + 25));

    final PdfLayoutResult _pdfReceiptTitleLayout = PdfTextElement(
            text: 'Receipts',
            font: PdfStandardFont(PdfFontFamily.helvetica, 30),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(0, _pdfDateLabelLayout.bounds.bottom + 100,
                page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

    double lastBounder = _pdfReceiptTitleLayout.bounds.bottom + 20;
    for (final receipt in summary.receipts) {
      final PdfLayoutResult _pdfNameLabelLayout = PdfTextElement(
              text: "Merchant:",
              font: PdfStandardFont(PdfFontFamily.helvetica, 20),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(0, lastBounder, page.getClientSize().width,
                  page.getClientSize().height),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
      final PdfLayoutResult _pdfNameValueLayout = PdfTextElement(
              text: receipt.name,
              font: PdfStandardFont(PdfFontFamily.helvetica, 20),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(50, _pdfNameLabelLayout.bounds.bottom + 20,
                  page.getClientSize().width, page.getClientSize().height),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
      final PdfLayoutResult _pdfReceiptDateLabelLayout = PdfTextElement(
              text: "Date:",
              font: PdfStandardFont(PdfFontFamily.helvetica, 20),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(0, _pdfNameValueLayout.bounds.bottom + 20,
                  page.getClientSize().width, page.getClientSize().height),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
      final PdfLayoutResult _pdfReceiptDateValueLayout = PdfTextElement(
              text: receipt.date,
              font: PdfStandardFont(PdfFontFamily.helvetica, 20),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(
                  50,
                  _pdfReceiptDateLabelLayout.bounds.bottom + 20,
                  page.getClientSize().width,
                  page.getClientSize().height),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
      print(page.getClientSize().height);
      print(_pdfReceiptDateLabelLayout.bounds.bottom);
      print(_pdfReceiptDateValueLayout.bounds.bottom);

      final PdfLayoutResult _pdfPriceLabelLayout = PdfTextElement(
              text: "Price:",
              font: PdfStandardFont(PdfFontFamily.helvetica, 20),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(
                  0,
                  _pdfReceiptDateValueLayout.bounds.bottom + 20,
                  page.getClientSize().width,
                  page.getClientSize().height),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
      final PdfLayoutResult _pdfPriceValueLayout = PdfTextElement(
              text: receipt.price.toString(),
              font: PdfStandardFont(PdfFontFamily.helvetica, 20),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(50, _pdfPriceLabelLayout.bounds.bottom + 20,
                  page.getClientSize().width, page.getClientSize().height),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

      page.graphics.drawLine(
          PdfPen(PdfColor(0, 0, 0)),
          Offset(100, _pdfPriceValueLayout.bounds.bottom + 25),
          Offset(page.getClientSize().width - 100,
              _pdfPriceValueLayout.bounds.bottom + 25));
      lastBounder = _pdfPriceValueLayout.bounds.bottom + 45;
    }

    List<int> byte = document.save();
    document.dispose();

    saveAndLaunchFile(byte, 'Output.pdf');
  }
}
