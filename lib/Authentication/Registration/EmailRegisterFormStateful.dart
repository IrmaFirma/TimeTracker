import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'EmailRegisterModel.dart';
import 'package:time_tracker/Components/ButtonOne.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'file:///C:/Users/F-IRMA/AndroidStudioProjects/time_tracker/lib/home/RecordsPage.dart';
import 'package:time_tracker/Services/auth.dart';

class EmailRegisterFormStateful extends StatefulWidget {
  @override
  _EmailRegisterFormStatefulState createState() =>
      _EmailRegisterFormStatefulState();
}

class _EmailRegisterFormStatefulState extends State<EmailRegisterFormStateful> {
  //editing controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //getters for password fields
  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  //focus nodes for next and done
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //methods for using focus nodes
  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  //enum variable
  EmailRegisterFormType _formType = EmailRegisterFormType.register;

  //creating or signing the user using Auth class
  Future<void> submitButton() async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailRegisterFormType.signIn) {
        await auth.signInWithEmailPassword(_email, _password);
      } else {
        await auth.createUserWithEmailPassword(_email, _password);
      }
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (context) => RecordsPage()));
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Registration Failed',
        exception: e,
      ).show(context);
    }
  }

  //changing between text for creating account and signIn
  void toggleFormType() {
    setState(() {
      _formType = _formType == EmailRegisterFormType.register
          ? EmailRegisterFormType.signIn
          : EmailRegisterFormType.register;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final _primaryText = _formType == EmailRegisterFormType.register
        ? 'Create an account'
        : 'Sign In';
    final _secondary = _formType == EmailRegisterFormType.register
        ? 'Have an account? Sign In'
        : 'Don\'t have an account? Create one';
    return [
      emailTextField(),
      SizedBox(height: 8),
      passwordTextField(),
      SizedBox(height: 8),
      ButtonOne(
        color: Color(0xFFA379C9),
        textColor: Colors.white,
        text: _primaryText,
        onTap: submitButton,
      ),
      SizedBox(height: 8),
      FlatButton(
          onPressed: () {
            toggleFormType();
          },
          child: Text(_secondary))
    ];
  }

  TextField passwordTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      onEditingComplete: submitButton,
      textInputAction: TextInputAction.done,
    );
  }

  TextField emailTextField() {
    return TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'hfx@hfx.com',
        ),
        controller: _emailController,
        focusNode: _emailFocusNode,
        autocorrect: false,
        onEditingComplete: _emailEditingComplete,
        keyboardType: TextInputType.emailAddress,
        onChanged: (email) {
          updateState();
        },
        textInputAction: TextInputAction.next);
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren()),
    );
  }
}