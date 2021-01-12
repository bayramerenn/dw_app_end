import 'package:dw_app/page/counting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget/home_page_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DW',
      theme: ThemeData(
        primaryColor: Colors.red[400],
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("DataWarehouse")),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomePageButton(
              buttonName: 'Sayim',
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Counting(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
