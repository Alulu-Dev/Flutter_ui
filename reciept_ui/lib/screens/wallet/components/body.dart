import 'package:flutter/material.dart';


class Wallet extends StatelessWidget {
  final List<ListItem> items=List<ListItem>.generate(
        31,
        (i) => i % 31 == 0
            ? HeadingItem('month 1')
            : DaiylExpenses('day $i', 'payment '),
      );

  @override
  Widget build(BuildContext context) {
    const title = 'wallet';

    return  Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
         
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
    );
  }
}
abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
}
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline3,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

class DaiylExpenses implements ListItem {
  final String day;
  final String expenses;

  DaiylExpenses(this.day, this.expenses);

  @override
  Widget buildTitle(BuildContext context) => Text(day);

  @override
  Widget buildSubtitle(BuildContext context) => Text(expenses);
}
