import 'package:flutter/material.dart';

String logGenerator(String logs, String arg){
  var now = DateTime.now();
  if (arg != null  && arg != "") return "{$now} --- {${arg.toUpperCase()}} --- {$logs}";
  else return "{$now} --- {NOARGS} --- {$logs}";
}
