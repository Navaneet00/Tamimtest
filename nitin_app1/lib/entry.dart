import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';


import 'amplifyconfiguration.dart';
import 'login.dart';

class EntryScreen extends StatefulWidget{
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen>{
  bool _amplifyConfigured = false;

  @override
  void initState(){
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    final auth = AmplifyAuthCognito();
    final analytics = AmplifyAnalyticsPinpoint();
    List<AmplifyPluginInterface> plugins = [auth, analytics];
    try {
      Amplify.addPlugins(plugins);
      await Amplify.configure(amplifyconfig);

      setState(() {
        _amplifyConfigured = true;
      });
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body:Center(
        child: _amplifyConfigured ? Login() : CircularProgressIndicator(),
      ),
    );
  }
}