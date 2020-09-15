class Strings {
  //
  static const String yourCenterisArchived = 'المركز الخاص بك تم تعطيله';
  static const String youAreArchived = 'لقد تم تعطيل الحساب الخاص بك ';
  static const String contactUs =
      'إتصل بالأدمن على هذا البريد: ' + 'Alhalaqatt@gmail.com';

  // Generic strings
  static const String ok = 'حسنا';
  static const String cancel = 'إلغاء';

  // Logout
  static const String logout = 'تسجيل خروج';
  static const String logoutAreYouSure = 'هل أنت متأكد أنك تريد تسجيل الخروج ؟';
  static const String logoutFailed = 'فشل تسجيل الخروج';

  // Sign In Page
  static const String signIn = 'تسجيل الدخول';
  static const String signInWithEmailPassword =
      'تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور';
  static const String signInWithUsernmaePassword =
      'تسجيل الدخول باسم المستخدم وكلمة المرور';
  static const String signInWithFacebook = 'Sign in with Facebook';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String goAnonymous = 'Go anonymous';
  static const String or = 'or';

  // Email & Password page
  static const String register = 'تسجيل الدخول';
  static const String forgotPassword = 'إنشاء نسيت كلمة المرور';
  static const String forgotPasswordQuestion = 'هل نسيت كلمة المرور؟';
  static const String createAnAccount = 'انشئ حساب';
  static const String needAnAccount = 'تحتاج الى حساب؟ قم بإنشاء حساب';
  static const String haveAnAccount = 'هل لديك حساب؟ قم بتسجيل الدخول';
  static const String signInFailed = 'فشل تسجيل الدخول';
  static const String registrationFailed = 'فشل في التسجيل';
  static const String passwordResetFailed = 'فشل إعادة تعيين كلمة المرور';
  static const String sendResetLink = 'إرسال رابط إعادة تعيين';
  static const String backToSignIn = 'العودة لتسجيل الدخول';
  static const String resetLinkSentTitle = 'تم إرسال رابط إعادة التعيين';
  static const String resetLinkSentMessage =
      'تحقق من بريدك الإلكتروني لإعادة تعيين كلمة المرور الخاصة بك';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String emailHint = 'test@test.com';
  static const String usernameLabel = 'اسم المستخدم';
  static const String usernameHint = 'mohammed.ahmed';
  static const String password8CharactersLabel = 'كلمة المرور (أكثر من 6 أحرف)';
  static const String passwordLabel = 'كلمه السر';
  static const String invalidEmailErrorText = 'البريد الإلكتروني خاطئ';
  static const String invalidEmailEmpty =
      'لا يمكن أن يكون البريد الإلكتروني فارغًا';
  static const String invalidUsernameErrorText = 'إسم المستخدم خاطئ';
  static const String invalidUsernameEmpty =
      'لا يمكن أن يكون اسم المستخدم فارغًا';
  static const String invalidPasswordTooShort = 'كلمة المرور قصيرة جدا';
  static const String invalidPasswordEmpty =
      'لا يمكن أن تكون كلمة المرور فارغة';

  // Email link page
  static const String submitEmailAddressLink =
      'Submit your email address to receive an activation link.';
  static const String checkYourEmail = 'Check your email';
  static String activationLinkSent(String email) =>
      'We have sent an activation link to $email';
  static const String errorSendingEmail = 'Error sending email';
  static const String sendActivationLink = 'Send activation link';
  static const String activationLinkError = 'Email activation error';
  static const String submitEmailAgain =
      'Please submit your email address again to receive a new activation link.';
  static const String userAlreadySignedIn =
      'Received an activation link but you are already signed in.';
  static const String isNotSignInWithEmailLinkMessage =
      'Invalid activation link';
}
