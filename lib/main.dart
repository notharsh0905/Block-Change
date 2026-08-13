import 'package:flutter/material.dart';
import 'app.dart';
import 'config/config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validateConfiguration();
  runApp(const BlockChangeApp());
}
