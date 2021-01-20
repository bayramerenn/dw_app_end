import 'dart:io';

import 'package:dw_app/dialog/page_exit_alert.dart';
import 'package:dw_app/dialog/save_file_dialog.dart';
import 'package:dw_app/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class OfflineCounting extends StatefulWidget {
  @override
  _OfflineCountingState createState() => _OfflineCountingState();
}

class _OfflineCountingState extends State<OfflineCounting> {
  FocusNode _focusNode;

  TextEditingController _quantityController;
  TextEditingController _barcodeController;
  TextEditingController _showDialogTextField;

  String _itemCount = "0";
  int _itemQtySum = 0;
  List<BarcodeList> items = [];
  String value = "1";

  @override
  void initState() {
    // TODO: implement initState
    _quantityController = TextEditingController();
    _barcodeController = TextEditingController();
    _showDialogTextField = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() async {
    _quantityController.dispose();
    _barcodeController.dispose();
    _focusNode.dispose();
    _showDialogTextField.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Offline Sayım"),
          actions: [
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.barcode,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => scanBarcodeNormal(),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: TextFormField(
                      cursorColor: AppConstant.colorPrimary,
                      autofocus: true,
                      focusNode: _focusNode,
                      controller: _barcodeController,
                      decoration: InputDecoration(
                        hintText: "Barkod Okutunuz",
                      ),
                      onFieldSubmitted: _submitButton,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _quantityController..text = "1",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      size: 30,
                      color: AppConstant.colorPrimary,
                    ),
                    onPressed: () {
                      fillBarcodeList();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Okutulan Ürün Sayısı: $_itemCount",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Toplam Miktar : ${_itemQtySum.toString()}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ListView.builder(
                    itemExtent: 60,
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text("Barkod : ${items[index].barcode}"),
                        subtitle: Text("Miktar : ${items[index].qty}"),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red[400],
                          ),
                          onPressed: () {
                            setState(() {
                              _itemQtySum -= int.parse(items[index].qty);
                              items.remove(items[index]);
                              _itemCount = items.length.toString();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createButtonList,
          child: Icon(Icons.save),
          backgroundColor: AppConstant.colorPrimary,
        ),
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      FlutterBeep.beep();
      if (barcodeScanRes != "-1") {
        _barcodeController.text = barcodeScanRes;
        // setState(() {
        //  items.add(BarcodeList(barcodeScanRes, "1"));
        //_itemCount = items.length.toString();
        //_itemQtySum += 1;
        //});
      }
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  multipleBarcodeScan() async {
    // FlutterBarcodeScanner.getBarcodeStreamReceiver(
    //         "#6fa3e5", "Cancel", true, ScanMode.BARCODE)
    //     .listen((barcode) {
    //   setState(() {
    //     if (barcode != "-1") {
    //       _itemCount = items.length.toString();
    //       _itemQtySum += 1;
    //       items.add(BarcodeList(barcode, "1"));
    //       FlutterBeep.beep();
    //     }
    //   });
    // });
  }

  Future<bool> _onBackPressed() async {
    if (items.isNotEmpty) {
      if (await onBackPressed(context)) {
        items.clear();
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  void createButtonList() {
    showFileDialog(
        context: context,
        controller: _showDialogTextField,
        saveButton: _saveButton);
    //_showDialog();
  }

  _submitButton(value) {
    fillBarcodeList();
  }

  void fillBarcodeList() {
    if (_barcodeController.text != "" && _quantityController.text != "0") {
      print("girdi");
      setState(() {
        items.add(
            BarcodeList(_barcodeController.text, _quantityController.text));
        _itemCount = items.length.toString();
        _itemQtySum += int.parse(_quantityController.text);
        _barcodeController.clear();
        _quantityController.clear();
      });
    }
    FocusScope.of(context).requestFocus(_focusNode);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _saveButton() async {
    if (_showDialogTextField.text.isEmpty) {
      await writeCounting(list: items, fileName: DateTime.now().toString());
    } else {
      await writeCounting(list: items, fileName: _showDialogTextField.text);
    }
    _showDialogTextField.clear();
    setState(() {
      items = [];
      _itemCount = "0";
      _itemQtySum = 0;
    });
    Navigator.pop(context);
  }
}

class BarcodeList {
  String barcode;
  String qty;
  BarcodeList(this.barcode, this.qty);
}

Future<void> writeCounting(
    {List<BarcodeList> list, String fileName = ""}) async {
  Directory data = await getApplicationDocumentsDirectory();

  File file = File('${AppConstant.storageHomeDirectory}$fileName.txt');
  String text = "";

  print(file);
  if (await Permission.storage.request().isGranted) {
    list.forEach((element) {
      text = "${element.barcode}    ${element.qty}\r\n";
      file.writeAsStringSync(text, mode: FileMode.append);
    });
    print(file.path);
    await MediaScanner.loadMedia(path: file.path);
  }
}
