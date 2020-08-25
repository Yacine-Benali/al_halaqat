import 'package:al_halaqat/common_widgets/password_generator.dart';
import 'package:flutter/material.dart';

//TODO add enabled disabled field
// ignore: must_be_immutable
class PasswordTextField extends StatefulWidget {
  PasswordTextField({
    Key key,
    @required this.onPasswordCreated,
    @required this.existingPassword,
  }) : super(key: key);

  final ValueChanged<String> onPasswordCreated;
  String existingPassword;

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
    password = widget.existingPassword;
    if (password == null) {
      password = createPassword();
    }
    _controller = TextEditingController(text: password);

    widget.onPasswordCreated(password);
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
            'كلمة السرية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  onChanged: (value) => widget.onPasswordCreated(value),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(0, 16, 8, 8),
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () => changePassword(),
                  child: Icon(Icons.refresh),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
