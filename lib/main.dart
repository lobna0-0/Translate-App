import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:translate/lang.dart';
import 'package:translate/translate_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LangAdapter());
  Hive.registerAdapter(ResponseDataAdapter());
  Hive.registerAdapter(MatchAdapter());
  if (!Hive.isBoxOpen('translationsbox')) {
    await Hive.openBox('translationsbox');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: TranslatePage(),
    );
  }
}
