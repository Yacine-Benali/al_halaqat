import 'package:alhalaqat/app/sign_in/validator.dart';
import 'package:alhalaqat/constants/strings.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/foundation.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailPasswordSignInModel
    with UsernameAndPasswordValidators, ChangeNotifier {
  EmailPasswordSignInModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailPasswordSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final Auth auth;

  String email;
  String password;
  String confirmPassword;
  EmailPasswordSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }

      updateWith(isLoading: true);
      String email2 = convertUsernameToEmail();
      print(email + ':' + password);
      switch (formType) {
        case EmailPasswordSignInFormType.signIn:
          await auth.signInWithEmailAndPassword(email2, password);
          break;
        case EmailPasswordSignInFormType.register:
          await auth.createUserWithEmailAndPassword(email2, password);
          break;
        case EmailPasswordSignInFormType.forgotPassword:
          updateWith(isLoading: false);
          break;
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String convertUsernameToEmail() {
    return email + '@al-halaqat.firebaseapp.com';
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);
  void updateConfirmPassword(String confirmPassword) =>
      updateWith(confirmPassword: confirmPassword);
  void updateFormType(EmailPasswordSignInFormType formType) {
    updateWith(
      email: '',
      password: '',
      confirmPassword: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String email,
    String password,
    String confirmPassword,
    EmailPasswordSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return Strings.password8CharactersLabel;
    }
    return Strings.passwordLabel;
  }

  String get confirmPasswordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return Strings.confirmPasswordLabel;
    }
    return Strings.passwordLabel;
  }

  // Getters
  String get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.createAnAccount,
      EmailPasswordSignInFormType.signIn: Strings.signIn,
      EmailPasswordSignInFormType.forgotPassword: Strings.sendResetLink,
    }[formType];
  }

  String get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.haveAnAccount,
      EmailPasswordSignInFormType.signIn: Strings.needAnAccount,
      EmailPasswordSignInFormType.forgotPassword: Strings.backToSignIn,
    }[formType];
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInFormType.signIn,
    }[formType];
  }

  String get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.registrationFailed,
      EmailPasswordSignInFormType.signIn: Strings.signInFailed,
      EmailPasswordSignInFormType.forgotPassword: Strings.passwordResetFailed,
    }[formType];
  }

  String get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.register,
      EmailPasswordSignInFormType.signIn: Strings.signIn,
      EmailPasswordSignInFormType.forgotPassword: Strings.forgotPassword,
    }[formType];
  }

  bool get canSubmitEmail {
    return <EmailPasswordSignInFormType, bool>{
      EmailPasswordSignInFormType.register:
          usernameSubmitValidator.isValid(email) && password == confirmPassword,
      EmailPasswordSignInFormType.signIn:
          usernameSubmitValidator.isValid(email),
      EmailPasswordSignInFormType.forgotPassword:
          usernameSubmitValidator.isValid(email),
    }[formType];
    //return usernameSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password) &&
          password == confirmPassword;
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType == EmailPasswordSignInFormType.forgotPassword
            ? canSubmitEmail
            : canSubmitEmail && canSubmitPassword;
    return canSubmitFields && !isLoading;
  }

  String get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty
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

  String get confirmPasswordErrorText {
    //TODO implement this part and re-check the whole thing
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? Strings.invalidPasswordEmpty
        : Strings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
