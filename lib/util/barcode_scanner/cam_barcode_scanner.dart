import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';

class BarcodeScanner {
  multipleBarcodeScan() async {
    await FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#6fa3e5", "Cancel", true, ScanMode.BARCODE)
        .listen((event) {
      FlutterBeep.beep();
      print(event);
    });
  }

  singleBarcodeScan() async {}
}
