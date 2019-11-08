import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'auth.dart';
import 'auth_provider.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;
  Color primaryColor = Color(0xFF6290A8);
  Color darkPrimaryColor = Color(0xFF295578);
  Color secondaryColor = Color(0xFFACDEE9);

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        final BaseAuth auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          final String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          final String userId =
              await auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text('Authentication App'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: loginImage() + buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> loginImage() {
    return <Widget>[
      Image.asset('assets/2.png'),
    ];
  }

  List<Widget> buildInputs() {
    return <Widget>[
      TextFormField(
        key: Key('email'),
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(color: darkPrimaryColor),
        ),
        validator: EmailFieldValidator.validate,
        onSaved: (String value) => _email = value,
      ),
      TextFormField(
        key: Key('password'),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: darkPrimaryColor),
        ),
        obscureText: true,
        validator: PasswordFieldValidator.validate,
        onSaved: (String value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 14.0,
                color: primaryColor,
              ),
            ),
            onPressed: () {},
          ),
        ),
        RaisedButton(
          key: Key('signIn'),
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          color: darkPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'New User? Register Here.',
            style: TextStyle(
              fontSize: 18.0,
              color: primaryColor,
            ),
          ),
          onPressed: moveToRegister,
        ),
        Container(
          child: Row(
            children: <Widget>[
              Divider(),
              Text(
                'OR',
                style: TextStyle(),
              ),
            ],
          ),
        ),
        InkWell(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: darkPrimaryColor,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.google,
                  color: darkPrimaryColor,
                ),
                Text(
                  'Sign In with Google',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {},
        )
      ];
    } else {
      return <Widget>[
        RaisedButton(
          child: Text('Create an account', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child:
              Text('Have an account? Login', style: TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
