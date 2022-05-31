import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/requests/bloc/bloc.dart';
import 'package:receipt_management/requests/models/requests_model.dart';
import 'package:receipt_management/widgets/app_bar.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late final UserRequestBloc _userRequestBloc;

  @override
  void dispose() {
    _userRequestBloc.add(RequestUnLoad());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "Verification Requests"),
        body: SingleChildScrollView(
          child: _pageLayout(context),
        ),
      ),
    );
  }

  Widget _pageLayout(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<UserRequestBloc, UserRequestState>(
          builder: (context, state) {
            if (state is RequestLoaded) {
              return receiptList(context, state.requests);
            }
            _userRequestBloc = BlocProvider.of<UserRequestBloc>(context);
            _userRequestBloc.add(RequestLoad());
            return receiptList(context, []);
          },
        ),
      ],
    );
  }

  Widget receiptList(BuildContext context, List<RequestModel> requests) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: requests.length,
        itemBuilder: (BuildContext context, int index) {
          return receiptCard(
            context,
            requests[index].name,
            requests[index].status,
            requests[index].id,
          );
        },
      ),
    );
  }

  Widget receiptCard(BuildContext context, merchantName, status, id) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/receiptDetails', arguments: id);
        },
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              leading: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/receipt_icon.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                ),
              ),
              title: RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: const StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    text: merchantName),
              ),
              subtitle: Text(
                "Status: $status",
                style: const TextStyle(color: Colors.green, fontSize: 15),
              ),
            ),
            Container(
              height: 1.5,
              color: const Color(0xff74F2C4),
            )
          ],
        ),
      ),
    );
  }
}
