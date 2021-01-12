import 'dart:io';

import 'package:dw_app/dialog/page_exit_alert.dart';
import 'package:dw_app/dialog/save_file_dialog.dart';
import 'package:dw_app/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void dispose() {
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 30,
                          ),
                          onPressed: () {
                            fillBarcodeList();
                          },
                        ),
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

  Future<bool> _onBackPressed() async {
    if (items.isNotEmpty) {
      return await onBackPressed(context);
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
    setState(() {
      items.add(BarcodeList(_barcodeController.text, _quantityController.text));
      _itemCount = items.length.toString();
      _itemQtySum += int.parse(_quantityController.text);
      _barcodeController.clear();
      _quantityController.clear();
    });
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
  final file = File('${AppConstant.storageHomeDirectory}${fileName}.txt');
  String text = "";

  if (await Permission.storage.request().isGranted) {
    list.forEach((element) {
      text += "${element.barcode}    ${element.qty}\n";
    });

    await file.writeAsString(text, flush: true);
  }
}
