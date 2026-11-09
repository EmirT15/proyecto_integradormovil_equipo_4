import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'services/task_service.dart';
import 'screens/task_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(TaskService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taskly — Práctica 07',
        theme: AppTheme.light(),
        home: const TaskListScreen(),
      ),
    );
  }
}