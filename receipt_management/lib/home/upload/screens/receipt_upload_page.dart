import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt_management/home/upload/bloc/bloc.dart';
import 'package:receipt_management/home/upload/screens/receipt_reading_screen.dart';

import '../../../widgets/app_logo_widget.dart';
import '../../../widgets/predefined_widgets.dart';

class ReceiptUploadPage extends StatefulWidget {
  const ReceiptUploadPage({Key? key}) : super(key: key);

  @override
  State<ReceiptUploadPage> createState() => _ReceiptUploadPageState();
}

class _ReceiptUploadPageState extends State<ReceiptUploadPage> {
  File? image;
  // late UploadBloc _uploadBloc;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => (this.image = imageTemporary));

      final _uploadBloc = BlocProvider.of<UploadBloc>(context);
      _uploadBloc.add(UploadImage(receiptImage: File(image.path)));
    } on PlatformException catch (e) {
      log('failed to get photos $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadingImage) {
          Navigator.of(context).pushNamed('/receiptScanning', arguments: [
            state.receiptImage,
            state.receiptData,
          ]);
        }
      },
      builder: (context, state) {
        if (state is UploadProcessing) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return Row(
          children: [
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  spacerSizedBox(h: 50),
                  greenAppLogoContainer(),
                  spacerSizedBox(h: 20),
                  helpButton(),
                  spacerSizedBox(h: 50),
                  SizedBox(
                    width: 120,
                    height: 45,
                    child: FloatingActionButton(
                      heroTag: 'upload-photo',
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () => pickImage(ImageSource.gallery),
                      child: const Text(
                        'UPLOAD',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  spacerSizedBox(h: 40),
                  SizedBox(
                    width: 155,
                    height: 45,
                    child: FloatingActionButton(
                      heroTag: 'take-photo',
                      backgroundColor: Colors
                          .white, // const Color.fromRGBO(139, 208, 161, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () => pickImage(ImageSource.camera),
                      child: const Text(
                        'TAKE PHOTO',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 2,
              child: SizedBox(),
            )
          ],
        );
      },
    );
  }
}

Widget helpButton() {
  return TextButton(
    style: TextButton.styleFrom(
      elevation: 1, primary: Colors.black, backgroundColor: Colors.white,
      // slap effect
      // splashFactory: NoSplash.splashFactory,
    ),
    onPressed: () {
      gettingSessionId();
    },
    child: SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.info_outlined,
            size: 30,
          ),
          SizedBox(width: 5),
          Text(
            "Help",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    ),
  );
}

void hashValue(String string) {
  var key = utf8.encode('pass');
  var bytes = utf8.encode(string); // data being hashed
// SHA-512
  var digest = sha512.convert(bytes);
  var hmacSha256 = Hmac(sha256, key);
  var dig = hmacSha256.convert(bytes);

  // print("Digest as bytes: ${digest.bytes}");
  print('##############################################');
  print("Digest as hex string: $dig");
}

void gettingSessionId() {
  const sessionString =
      'Set-Cookie: session=.eJwlzj0OwjAMQOG7ZGawYzd2uAzyXwRrSyfE3anEm9_wfdpj7XU82_29n3Vrj1e2e-sQS4FAxbkLUrfSZWSRLFkAWENLaatJUMbdlC0iemGITPMhnGGOuFHWHJWK7qmLAWxMt6kGWQlAVzPXVsuxXNl5KOlqF-Q8av9rRicMEiGnEpR-DcBp1r4_i7Q2Pg.Ym64LQ.QmHh3aNNhuKRjktadIYgg6DX8Wk; HttpOnly; Path=/';

  const session = {
    'Set-Cookie':
        ' session=.eJwlzj0OwjAMQOG7ZGawYzd2uAzyXwRrSyfE3anEm9_wfdpj7XU82_29n3Vrj1e2e-sQS4FAxbkLUrfSZWSRLFkAWENLaatJUMbdlC0iemGITPMhnGGOuFHWHJWK7qmLAWxMt6kGWQlAVzPXVsuxXNl5KOlqF-Q8av9rRicMEiGnEpR-DcBp1r4_i7Q2Pg.Ym64LQ.QmHh3aNNhuKRjktadIYgg6DX8Wk; HttpOnly; Path=/'
  };
  print(session['Set-Cookie']!.split(';')[0].split('=')[1]);
}
