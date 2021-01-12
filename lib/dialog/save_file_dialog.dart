import 'package:flutter/material.dart';

showFileDialog(
    {BuildContext context,
    TextEditingController controller,
    Function saveButton}) async {
  await showDialog<String>(
    context: context,
    builder: (_) => new AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Dosya Adı',
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            child: const Text(
              'KAPAT',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
          child: const Text(
            'KAYDET',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            saveButton();
          },
        )
      ],
    ),
  );
}
