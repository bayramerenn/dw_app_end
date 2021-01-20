class OfflineBarcode {
  int id;
  final String barcode;
  final int quantity;

  OfflineBarcode({this.barcode, this.quantity});

  OfflineBarcode.withId({this.id, this.barcode, this.quantity});

  factory OfflineBarcode.fromMap(Map<String, dynamic> map) =>
      OfflineBarcode.withId(
        id: map['id'],
        barcode: map['barcode'],
        quantity: map['quantity'],
      );
  Map<String, dynamic> toMap(OfflineBarcode data) {
    var map = Map<String, dynamic>();
    map['id'] = data.id;
    map['barcode'] = data.barcode;
    map['quantity'] = data.quantity;
    return map;
  }
}
