import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/lay_out/home_layout.dart';

import 'bloc_observe.dart';

void main(){
  Bloc.observer = MyBlocObserver();

  runApp(app());
}
class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home_Layout(),
      debugShowCheckedModeBanner: false,
    );
  }
}