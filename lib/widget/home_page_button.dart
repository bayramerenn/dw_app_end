import 'package:dw_app/util/app_constant.dart';
import 'package:flutter/material.dart';

class HomePageButton extends StatelessWidget {
  final String buttonName;
  final Function func;

  const HomePageButton({Key key, this.buttonName, this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width - 50,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstant.colorPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          buttonName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
