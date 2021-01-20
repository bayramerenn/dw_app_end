import 'package:dw_app/widget/home_page_button.dart';
import 'package:flutter/material.dart';

import 'counting_page/offline.dart';

class Counting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sayım"),
        ),
        body: Scaffold(
          body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HomePageButton(
                  buttonName: 'Offline Sayim',
                  func: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          //  builder: (context) => OfflineCounting(),
                          ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                HomePageButton(
                  buttonName: 'Online Sayim',
                  func: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfflineCount(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
