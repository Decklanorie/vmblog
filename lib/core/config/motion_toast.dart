import 'package:motion_toast/motion_toast.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:vmblog/src/shared/utils/colors.dart';

class MToast {
  MToast();

  void error(context, text){
    MotionToast(
      icon: Icons.alarm,
      height: 40,
      width: 300,
      iconSize: 30,
      primaryColor: Colors.red,
      description: Text(text+'    '),
    ).show(context);
  }


  void pop(context, text){
    MotionToast(
      icon: Icons.info_outline,
      height: 40,
      width: 300,
      iconSize: 30,
      primaryColor: brown,
      description: Text(text,style: TextStyle(color: white),),
    ).show(context);
  }
}