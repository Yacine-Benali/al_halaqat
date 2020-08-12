import 'package:al_halaqat/common_widgets/password_generator.dart';
import 'package:flutter/material.dart';

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
    widget.onPasswordCreated(password);
    super.initState();
  }

  void changePassword() {
    password = createPassword();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      password,
                    ),
                    SizedBox(height: 15),
                    Divider(
                      thickness: 1.25,
                      color: Colors.grey,
                    ),
                  ],
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
