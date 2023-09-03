import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AuthUser _authUser;

  @override
  void initState(){
    super.initState();
    Amplify.Auth.getCurrentUser().then((user) {
      setState(() {
        _authUser = user;
      });
    }).catchError((error){
      print(error.cause);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          MaterialButton(
            onPressed: (){
              Amplify.Auth.signOut().then((_){
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
            child: Icon(
              Icons.logout,
              color: Colors.black87,
            ),
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_authUser == null)
                Text('Loading...')
              else ...{
                Text('Hello!'),
                Text(_authUser.userId),
                Text(_authUser.username)
              }
            ],
          ),
        ),
      ),
    );
  }
}
