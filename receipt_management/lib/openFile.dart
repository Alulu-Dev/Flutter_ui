import 'dart:io';
import 'dart:io' show Platform;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  late final String? _path;
  if (Platform.isAndroid) {
    _path = (await getExternalStorageDirectory())?.path;
  } else if (Platform.isIOS) {
    _path = (await getApplicationDocumentsDirectory()).path;
  }

  final file = File('$_path/$fileName');

  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$_path/$fileName');
}
