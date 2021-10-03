import 'package:flutter/material.dart';

String parseDate(DateTime _date){
  String _day = "${_date.day}", _month = "${_date.month}", _year = "${_date.year}";
  if (_date.day < 10) _day = "0$_day";
  if (_date.month < 10) _month = "0$_month";
  String _dateText = "${_day}/${_month}/${_year}";

  return _dateText;
}
