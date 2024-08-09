import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'layout/layout.dart';
import 'modules/shared/blocobserver.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
