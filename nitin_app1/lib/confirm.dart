import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_login/flutter_login.dart';

class Confirm extends StatefulWidget {
  final LoginData data;

  Confirm({required this.data});

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<Confirm> {
  final controller = TextEditingController();
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        isEnabled = controller.text.isNotEmpty;
      });
    });
  }

  void _verifyCode(BuildContext context, LoginData data, String code) async {
    try{
      final res = await Amplify.Auth.confirmSignUp(username: data.name, confirmationCode: code);
      if(res.isSignUpComplete) {
        //Login user
        final user = await Amplify.Auth.signIn(username: data.name, password: data.password);

        if(user.isSignedIn){
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      }
    }catch(e){
      _showError(context, e.toString());
    }
  }

  void resendCode(BuildContext context, LoginData data) async{
    try{
      await Amplify.Auth.resendSignUpCode(username: data.name);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text('Confirmation code resent. Check your Email!',
              style: TextStyle(fontSize: 15)),
        ),
      );
    }catch(e){
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            filled: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 4.0),
                            prefixIcon: Icon(Icons.lock),
                            labelText: "Enter Confirmation Code",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(40)),
                            )
                        ),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        onPressed: isEnabled ? () {
                          _verifyCode(context, widget.data, controller.text);
                        } : null,
                        elevation: 4,
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                        disabledColor: Colors.deepPurple.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          'Verify',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          resendCode(context, widget.data);
                        },
                        child: Text(
                          'Resend Code',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
