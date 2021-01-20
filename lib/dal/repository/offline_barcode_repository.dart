import 'package:dw_app/dal/dao/dao/offline_barcode_dao.dart';
import 'package:dw_app/models/offline_barcode.dart';

class OfflineBarcodeRepository {
  final _offlineBarcodeDao = OfflineBarcodeDao();
  Future getAll({String query}) => _offlineBarcodeDao.getAll(query);
  Future insert(OfflineBarcode offlineBarcode) =>
      _offlineBarcodeDao.insert(offlineBarcode);
  Future delete(int id) => _offlineBarcodeDao.delete(id);
  Future update(OfflineBarcode offlineBarcode) =>
      _offlineBarcodeDao.update(offlineBarcode);
  Future<OfflineBarcode> findById(int id) => _offlineBarcodeDao.findById(id);
}
