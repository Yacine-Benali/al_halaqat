import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
            title: title,
            content: _message(exception),
            defaultActionText: 'OK');

  static String _message(PlatformException exception) {
    if (exception.message == 'FIRFirestoreErrorDomain') {
      if (exception.code == 'Error 7') {
        return 'Missing or insufficient permissions';
      }
    }
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    ///   • `ERROR_WEAK_PASSWORD` - If the password is not strong enough.
    ///   • `ERROR_INVALID_CREDENTIAL` - If the email address is malformed.
    'ERROR_EMAIL_ALREADY_IN_USE': 'هذا الاسم مستخدم، اختر اسماً آخر',

    ///   • `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
    'ERROR_WRONG_PASSWORD': 'The password is invalid',
    'ERROR_DUPLICATE_NAME': 'اسم المركز موجود يرجى إختيار اسم آخر',
    'ERROR_USED_USERNAME': 'حساب المستخدم  مستخدم من قبل',
    'INVALID_EVALUATION': 'تقييم غير صالح',

    ///   • `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
    ///   • `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    ///   • `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    ///   • `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  };
}
