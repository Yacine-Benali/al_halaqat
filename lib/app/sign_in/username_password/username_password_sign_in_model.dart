import 'package:al_halaqat/app/sign_in/validator.dart';
import 'package:al_halaqat/constants/strings.dart';
import 'package:al_halaqat/services/auth_service.dart';
import 'package:flutter/foundation.dart';

enum UsernamePasswordSignInFormType { signIn, register, forgotPassword }

class UsernamePasswordSignInModel
    with UsernameAndPasswordValidators, ChangeNotifier {
  UsernamePasswordSignInModel({
    @required this.auth,
    this.username = '',
    this.password = '',
    this.formType = UsernamePasswordSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthService auth;

  String username;
  String password;
  UsernamePasswordSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      String email = convertUsernameToEmail();
      print('email: $email');
      print('password: $password');
      switch (formType) {
        case UsernamePasswordSignInFormType.signIn:
          await auth.signInWithEmailAndPassword(email, password);
          break;
        case UsernamePasswordSignInFormType.register:
          await auth.createUserWithEmailAndPassword(email, password);
          break;
        case UsernamePasswordSignInFormType.forgotPassword:
          await auth.sendPasswordResetEmail(email);
          updateWith(isLoading: false);
          break;
      }
      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String convertUsernameToEmail() {
    return username + '@al-halaqat.firebaseapp.com';
  }

  void updateUsername(String username) => updateWith(username: username);

  void updatePassword(String password) => updateWith(password: password);

  void updateFormType(UsernamePasswordSignInFormType formType) {
    updateWith(
      username: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String username,
    String password,
    UsernamePasswordSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.username = username ?? this.username;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == UsernamePasswordSignInFormType.register) {
      return Strings.password8CharactersLabel;
    }
    return Strings.passwordLabel;
  }

  // Getters
  String get primaryButtonText {
    return <UsernamePasswordSignInFormType, String>{
      UsernamePasswordSignInFormType.register: Strings.createAnAccount,
      UsernamePasswordSignInFormType.signIn: Strings.signIn,
      UsernamePasswordSignInFormType.forgotPassword: Strings.sendResetLink,
    }[formType];
  }

  String get secondaryButtonText {
    return <UsernamePasswordSignInFormType, String>{
      UsernamePasswordSignInFormType.register: Strings.haveAnAccount,
      UsernamePasswordSignInFormType.signIn: Strings.needAnAccount,
      UsernamePasswordSignInFormType.forgotPassword: Strings.backToSignIn,
    }[formType];
  }

  UsernamePasswordSignInFormType get secondaryActionFormType {
    return <UsernamePasswordSignInFormType, UsernamePasswordSignInFormType>{
      UsernamePasswordSignInFormType.register:
          UsernamePasswordSignInFormType.signIn,
      UsernamePasswordSignInFormType.signIn:
          UsernamePasswordSignInFormType.register,
      UsernamePasswordSignInFormType.forgotPassword:
          UsernamePasswordSignInFormType.signIn,
    }[formType];
  }

  String get errorAlertTitle {
    return <UsernamePasswordSignInFormType, String>{
      UsernamePasswordSignInFormType.register: Strings.registrationFailed,
      UsernamePasswordSignInFormType.signIn: Strings.signInFailed,
      UsernamePasswordSignInFormType.forgotPassword:
          Strings.passwordResetFailed,
    }[formType];
  }

  String get title {
    return <UsernamePasswordSignInFormType, String>{
      UsernamePasswordSignInFormType.register: Strings.register,
      UsernamePasswordSignInFormType.signIn: Strings.signIn,
      UsernamePasswordSignInFormType.forgotPassword: Strings.forgotPassword,
    }[formType];
  }

  bool get canSubmitUsername {
    return usernameSubmitValidator.isValid(username);
  }

  bool get canSubmitPassword {
    if (formType == UsernamePasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType == UsernamePasswordSignInFormType.forgotPassword
            ? canSubmitUsername
            : canSubmitUsername && canSubmitPassword;
    return canSubmitFields && !isLoading;
  }

  String get usernameErrorText {
    final bool showErrorText = submitted && !canSubmitUsername;
    final String errorText = username.isEmpty
        ? Strings.invalidUsernameEmpty
        : Strings.invalidUsernameErrorText;
    return showErrorText ? errorText : null;
  }

  String get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? Strings.invalidPasswordEmpty
        : Strings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'username: $username, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
