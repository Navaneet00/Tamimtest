import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:nitin_app1/confirm.dart';
import 'package:nitin_app1/confirm_reset.dart';
import 'package:nitin_app1/dashboard.dart';
import 'entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings){
        if(settings.name == '/confirm'){
          return PageRouteBuilder(pageBuilder: (_,__,___) => Confirm(data: settings.arguments as LoginData),
            transitionsBuilder: (_,__,___, child) => child,);
        }

        if(settings.name == '/confirm-reset'){
          return PageRouteBuilder(pageBuilder: (_,__,___) => Confirm_Reset(data: settings.arguments as LoginData),
            transitionsBuilder: (_,__,___, child) => child,);
        }

        if(settings.name == '/dashboard'){
          return PageRouteBuilder(pageBuilder: (_,__,___) => Dashboard(),
            transitionsBuilder: (_,__,___, child) => child,);
        }
        return MaterialPageRoute(builder: (_) => EntryScreen());
      },
    );
  }
}

