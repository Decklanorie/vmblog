import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  // Create a formatter with the desired format
  final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ");

  // Format the DateTime object
  final formattedString = formatter.format(dateTime);

  return formattedString;
}

class DateClass{
  DateClass();

  String toPDF(DateTime date){
      var dateTime = DateTime.now();
      return  formatDateTime(dateTime);
  }

  String toWDF(String date){
    try {
      var dateTime = DateTime.parse(date);
      return DateFormat('MMM d, HH:mm').format(dateTime);
    }catch(e){
      print(date);
      print(e);
      return 'Date';
    }
  }


}