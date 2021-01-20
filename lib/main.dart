import 'package:dw_app/page/counting.dart';
import 'package:dw_app/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget/home_page_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DW',
      theme: ThemeData(
        primaryColor: AppConstant.colorPrimary,
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
