import 'package:al_halaqat/app/sign_in/username_password/username_password_sign_in_model.dart';
import 'package:al_halaqat/common_widgets/form_submit_button.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/constants/strings.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UsernamePasswordSignIn extends StatefulWidget {
  const UsernamePasswordSignIn._(
      {Key key, @required this.model, this.onSignedIn})
      : super(key: key);
  final UsernamePasswordSignInModel model;
  final VoidCallback onSignedIn;

  static Future<void> show(BuildContext context,
      {VoidCallback onSignedIn}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) =>
            UsernamePasswordSignIn.create(context, onSignedIn: onSignedIn),
      ),
    );
  }

  static Widget create(BuildContext context, {VoidCallback onSignedIn}) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return ChangeNotifierProvider<UsernamePasswordSignInModel>(
      create: (_) => UsernamePasswordSignInModel(auth: auth),
      child: Consumer<UsernamePasswordSignInModel>(
        builder: (_, UsernamePasswordSignInModel model, __) =>
            UsernamePasswordSignIn._(model: model, onSignedIn: onSignedIn),
      ),
    );
  }

  @override
  _UsernamePasswordSignInState createState() => _UsernamePasswordSignInState();
}

class _UsernamePasswordSignInState extends State<UsernamePasswordSignIn> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  UsernamePasswordSignInModel get model => widget.model;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(
      UsernamePasswordSignInModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle,
      exception: exception,
    ).show(context);
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == UsernamePasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: Strings.resetLinkSentTitle,
            content: Strings.resetLinkSentMessage,
            defaultActionText: Strings.ok,
          ).show(context);
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn();
          }
        }
      }
    } on PlatformException catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitUsername) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitUsername) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  Widget _buildEmailField() {
    return TextField(
      key: Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: Strings.usernameLabel,
        hintText: Strings.usernameHint,
        errorText: model.usernameErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateUsername,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model.usernameInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      key: Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: model.passwordLabelText,
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePassword,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildContent() {
    return FocusScope(
      node: _node,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          _buildEmailField(),
          if (model.formType !=
              UsernamePasswordSignInFormType.forgotPassword) ...<Widget>[
            SizedBox(height: 8.0),
            _buildPasswordField(),
          ],
          SizedBox(height: 8.0),
          FormSubmitButton(
            key: Key('primary-button'),
            text: model.primaryButtonText,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : _submit,
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(model.title),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}
