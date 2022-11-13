import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jd_shop/route.dart';
import 'package:jd_shop/services/auth_service.dart';
import 'package:jd_shop/services/database_service.dart';
import 'package:jd_shop/services/google_sign_in.dart';
import 'package:jd_shop/services/storage_service.dart';
import 'package:jd_shop/themes/style.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      child: Text(
        'Error: ${details.exception}',
        style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  };
  runApp(MyApp());
}

final messageKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<StorageService>(create: (_) => StorageService()),
        ProxyProvider<DatabaseService, AuthService>(
            update: (_, dbService, __) => AuthService(dbService: dbService)),
      ],
      
      child: MaterialApp(
        scaffoldMessengerKey: messageKey,
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        initialRoute: "/login",
        routes: routes,
      ),
    );
  }
}
