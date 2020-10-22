import 'package:alhalaqat/app/sign_in/validator.dart';
import 'package:alhalaqat/constants/strings.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/foundation.dart';

enum EmailPasswordSignInFormType { signIn, register }

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
    print('submitting...');
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
    }[formType];
  }

  String get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.haveAnAccount,
      EmailPasswordSignInFormType.signIn: Strings.needAnAccount,
    }[formType];
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
    }[formType];
  }

  String get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.registrationFailed,
      EmailPasswordSignInFormType.signIn: Strings.signInFailed,
    }[formType];
  }

  String get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.register,
      EmailPasswordSignInFormType.signIn: Strings.signIn,
    }[formType];
  }

  bool get canSubmitEmail {
    return <EmailPasswordSignInFormType, bool>{
      EmailPasswordSignInFormType.register:
          usernameSubmitValidator.isValid(email),
      EmailPasswordSignInFormType.signIn:
          usernameSubmitValidator.isValid(email),
    }[formType];
    //return usernameSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    return passwordRegisterSubmitValidator.isValid(password);
  }

  bool get canSubmitConfirmPassword {
    return password == confirmPassword;
  }

  bool get canSubmit {
    bool canSubmitFields;
    if (formType == EmailPasswordSignInFormType.register) {
      canSubmitFields =
          canSubmitEmail && canSubmitPassword && canSubmitConfirmPassword;
    } else {
      canSubmitFields = canSubmitEmail && canSubmitPassword;
    }

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
    if (submitted &&
        !passwordRegisterSubmitValidator.isValid(confirmPassword)) {
      return confirmPassword.isEmpty
          ? Strings.invalidPasswordEmpty
          : Strings.invalidPasswordTooShort;
    } else if (submitted && !canSubmitConfirmPassword) {
      return Strings.unidenticalPasswords;
    } else
      return null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
