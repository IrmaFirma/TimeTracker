import 'dart:async';
import 'package:flutter/foundation.dart';
import '../Models/EmailSignInModel.dart';
import 'package:time_tracker/Services/auth.dart';
import 'package:flutter/material.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => modelController.stream;
  EmailSignInModel model = EmailSignInModel();

  void dispose() {
    modelController.close();
  }

  //moving submit logic form form to bloc
  Future<void> submitButton() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailPassword(model.email, model.password);
      } else {
        await auth.createUserWithEmailPassword(model.email, model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  //is like the set method
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    //update model add updated model to modelController
    model = model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    modelController.add(model);
  }
}
