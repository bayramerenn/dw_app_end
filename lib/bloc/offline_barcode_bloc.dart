import 'dart:async';

import 'package:dw_app/dal/repository/offline_barcode_repository.dart';
import 'package:dw_app/models/offline_barcode.dart';

class OfflineBarcodeBloc {
  final _offlineBarcodeRepository = OfflineBarcodeRepository();

  final _offlineBarcodeStreamController =
      StreamController<List<OfflineBarcode>>();

  Stream<List<OfflineBarcode>> get offlineBarcode =>
      _offlineBarcodeStreamController.stream;

  OfflineBarcodeBloc() {
    getAll();
  }

  void getAll({String query}) async {
    _offlineBarcodeStreamController.sink
        .add(await _offlineBarcodeRepository.getAll(query: query));
  }

  Future<int> insert(OfflineBarcode offlineBarcode) async {
    var result = await _offlineBarcodeRepository.insert(offlineBarcode);
    getAll();
    return result;
  }

  Future<int> delete(int id) async {
    var result = await _offlineBarcodeRepository.delete(id);
    getAll();
    return result;
  }

  Future<int> update(OfflineBarcode offlineBarcode) async {
    var result = await _offlineBarcodeRepository.update(offlineBarcode);
    getAll();
    return result;
  }

  Future<OfflineBarcode> findById(int id) async {
    var result = await _offlineBarcodeRepository.findById(id);

    return result;
  }
}
