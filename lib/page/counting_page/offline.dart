import 'package:dw_app/bloc/offline_barcode_bloc.dart';
import 'package:dw_app/models/offline_barcode.dart';
import 'package:dw_app/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OfflineCount extends StatelessWidget {
  final _offlineBarcodeBloc = OfflineBarcodeBloc();

  FocusNode _focusNode = FocusNode();

  TextEditingController _quantityController = TextEditingController();
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _showDialogTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offline Sayım"),
        actions: [
          IconButton(
            tooltip: "Kamerayla Okut",
            icon: FaIcon(
              FontAwesomeIcons.barcode,
              color: Colors.black,
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
                    Icons.send,
                    size: 30,
                    color: AppConstant.iconColor,
                  ),
                  onPressed: () {
                    fillBarcodeList(context);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<List<OfflineBarcode>>(
                stream: _offlineBarcodeBloc.offlineBarcode,
                builder: (context, snapshot) {
                  return getBorcodeListWidget(snapshot);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  scanBarcodeNormal() {}

  void _submitButton(String value) {}

  void fillBarcodeList(BuildContext context) async {
    if (_barcodeController.text != "" && _quantityController.text != "0") {
      await _offlineBarcodeBloc.insert(OfflineBarcode(
          barcode: _barcodeController.text,
          quantity: int.parse(_quantityController.text)));

      _barcodeController.clear();
    }
    FocusScope.of(context).requestFocus(_focusNode);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Widget getBorcodeListWidget(AsyncSnapshot<List<OfflineBarcode>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                OfflineBarcode offlineBarcode = snapshot.data[index];

                return Dismissible(
                  background: Container(
                    color: AppConstant.dissmissibleColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Siliniyor",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    _offlineBarcodeBloc.delete(offlineBarcode.id);
                  },
                  direction: DismissDirection.horizontal,
                  key: ObjectKey(offlineBarcode),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey[200],
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      title: Text("Barkod : " + offlineBarcode.barcode),
                      subtitle: Text(
                          "Miktar : " + offlineBarcode.quantity.toString()),
                    ),
                  ),
                );
              },
            )
          : Text("");
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
