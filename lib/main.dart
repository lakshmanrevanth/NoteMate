import 'package:promissorynotemanager/dataprovider/authprovider.dart'
    as authprovider;
import 'package:flutter/material.dart';
import 'package:promissorynotemanager/dataprovider/themeprovider.dart';

import 'package:promissorynotemanager/screens/home_page.dart';
import 'package:promissorynotemanager/screens/login_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:promissorynotemanager/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const PromissoryNoteManagerApp(),
    ),
  );
}

class PromissoryNoteManagerApp extends StatelessWidget {
  const PromissoryNoteManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authprovider.AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Consumer<authprovider.AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.user != null
                  ? const HomePage()
                  : const LogInPage();
            },
          ),
        );
      },
    );
  }
}
