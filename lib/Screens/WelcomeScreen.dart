import 'package:flutter/material.dart';
import 'package:time_tracker/Authentication/SignIn/SignInPage.dart';
import 'package:time_tracker/Components/ButtonOne.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F232E),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 290),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text('Welcome to HFX Statistic',
                            style: TextStyle(fontSize: 30, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  ButtonOne(
                      color: Color(0xFF02B28C),
                      text: 'Create an account',
                      textColor: Colors.white,
                      onTap: () {}),
                  SizedBox(height: 10),
                  FlatButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (context) => SignInPage.create(context))),
                      child: Text('Already have an account? Sign In!', style: TextStyle(color: Colors.grey.shade200),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
