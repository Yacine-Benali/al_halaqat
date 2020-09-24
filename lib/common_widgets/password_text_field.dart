import 'package:alhalaqat/common_widgets/password_generator.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField({
    Key key,
    @required this.onPasswordCreated,
    @required this.existingPassword,
    @required this.isEnabled,
    @required this.hidePassword,
  }) : super(key: key);

  final ValueChanged<String> onPasswordCreated;
  final String existingPassword;
  final bool isEnabled;
  final bool hidePassword;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  String password;
  TextEditingController _controller;

  String createPassword() {
    String _generatedPassword = generatePassword(true, false, true, false, 6);
    return _generatedPassword;
  }

  @override
  void initState() {
    password = widget.hidePassword ? '******' : widget.existingPassword;
    if (password == null) {
      password = createPassword();
      widget.onPasswordCreated(password);
    }
    _controller = TextEditingController(text: password);

    super.initState();
  }

  void changePassword() {
    password = createPassword();
    _controller.text = password;
    widget.onPasswordCreated(password);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'كلمة المرور ية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  enabled: widget.isEnabled,
                  controller: _controller,
                  onChanged: (value) => widget.onPasswordCreated(value),
                ),
              ),
              widget.isEnabled
                  ? Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(0, 16, 8, 8),
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: () => changePassword(),
                        child: Icon(Icons.refresh),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
