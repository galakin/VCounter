import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/services/wrapper.dart';
import 'package:vcounter/firestore/savegame.dart';
import 'package:vcounter/resources/logGenerator.dart';

Future <List<Map>> retriveOnlineGames() async{
  return [];
}
