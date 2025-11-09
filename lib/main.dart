import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listynest/app.dart';
import 'package:listynest/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
