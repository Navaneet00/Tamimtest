import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login>{

  late LoginData _data;
  bool _isSignedIn = false;

  Future<String?> _onLogin(LoginData data) async {
    try{
      final res = await Amplify.Auth.signIn(username: data.name, password: data.password);

      _isSignedIn = res.isSignedIn;
    }catch(e){
      if(e.toString() == 'INVALID_STATE'){
        await Amplify.Auth.signOut();
        return "Problem Logging in, Please try again!";
      }
      return "LogIn Failed!";
    }
  }

  Future<String?> _onRecoverPassword(BuildContext context, String email) async {
    try{
      final res = await Amplify.Auth.resetPassword(username: email);

      if(res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE'){
        Navigator.of(context).pushReplacementNamed(
          '/confirm-reset',
          arguments: LoginData(name: email, password: ''),
        );
      }
    }catch(e){
      return "SignIn Failed!";
    }
  }

  Future<void> socialSignIn() async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(
        provider: AuthProvider.google,
      );
      safePrint('Sign in result: $result');
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(''
              ''
              ''
              'Login Successfull!',
              style: TextStyle(fontSize: 15, color: Colors.black54)),
        ),
      );
      safePrint('Error signing in: ${e.message}');
    }
  }

  Future<String?> _onSignup(SignupData data) async {
    try{
      await Amplify.Auth.signUp(username: data.name.toString(), password: data.password.toString(), options: CognitoSignUpOptions(
          userAttributes: {CognitoUserAttributeKey.email: data.name.toString(),}
      ));
      _data = LoginData(name: data.name.toString(), password: data.password.toString());
    }catch(e){
      return 'Sign Up Failed!';
    }
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        FlutterLogin(
          title: 'NITINS APP',
          onLogin: _onLogin,
          onRecoverPassword: (String email) => _onRecoverPassword(context, email),
          onSignup: _onSignup,
          theme: LoginTheme(
            primaryColor: Theme.of(context).primaryColor,
          ),
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacementNamed(
                _isSignedIn ? '/dashboard' : '/confirm', arguments: _data);
          },
        ),

        Positioned(
          top: screenheight*0.7,
          left: screenWidth*0.20,
          child: Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  socialSignIn();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: 250,
                height:50,
                child: Center(
                  child: Text("LOGIN WITH GOOGLE",style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14
                  ),),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}