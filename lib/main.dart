import 'package:flutter/material.dart';

import 'app.dart';
import 'config/config.dart';
import 'services/progress_service.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validateConfiguration();
  await ProgressService.instance.initialize();
  await SettingsService.instance.initialize();
  runApp(const BlockChangeApp());
}
