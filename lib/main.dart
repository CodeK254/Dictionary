import 'package:flutter/material.dart';
import "package:dictionary/search.dart";

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context)=> const SearchPage(),
      }
    )
  );
}