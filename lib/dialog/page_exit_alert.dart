import 'package:flutter/material.dart';

Future<bool> onBackPressed(BuildContext context) {
  return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Emin Misiniz?'),
          content:
              new Text('Sayfayı kapatırsanız tüm ürünleriniz silinecektir.'),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(true),
              child: Text(
                "Kapat",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text(
                "Devam Et",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ) ??
      false;
}
