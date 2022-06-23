import 'package:flutter/material.dart';
import 'package:olx/models/user.dart' as my_user;
import 'package:olx/views/widgets/button_customized.dart';
import 'package:olx/views/widgets/input_customized.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _controllerEmail = TextEditingController(text: 'hugo@gmail.com');
  final TextEditingController _controllerPassword = TextEditingController(text: 'cueiozim');

  bool _register = false;
  String _errorMessage = '';
  String _textButton = 'Entrar';

  _validateFields() {

    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    _registerUser(my_user.User user) {

      FirebaseAuth auth = FirebaseAuth.instance;
      auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password
      ).then((firebaseUser) {
        // Redirect to main screen
        Navigator.pushReplacementNamed(context, '/');

      });
    }

    _logUser(my_user.User user) {
      FirebaseAuth auth = FirebaseAuth.instance;

      auth.signInWithEmailAndPassword(
          email: user.email,
          password: user.password
      ).then((firebaseUser) {
        // Redirect to main screen
        Navigator.pushReplacementNamed(context, '/');

      });


    }

    if (email.isNotEmpty && email.contains('@')) {
      if (password.isNotEmpty && password.length > 6) {

        // Configurate user
        my_user.User user = my_user.User();
        user.email = email;
        user.password = password;

        if (_register) {
          _registerUser(user);
        } else {
          _logUser(user);
        }

      } else {
        setState(() {
          _errorMessage = "preencha a senha ! Digite mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Preencha um email válido";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 150,
                    ),
                  ),
                  InputCustomized(
                    controller: _controllerEmail,
                    hint: 'Email',
                    autofocus: true,
                    type: TextInputType.emailAddress,
                  ),
                  InputCustomized(
                    controller: _controllerPassword,
                    hint: 'Senha',
                    maxLines: 1,
                    obscure: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Logar'),
                      Switch(
                          value: _register,
                          onChanged: (bool value) {
                            setState(() {
                              _register = value;
                              _textButton = 'Entrar';
                              if (_register) {
                                _textButton = 'Cadastrar';
                              }
                            });
                          }
                      ),
                      const Text('Cadastrar'),
                    ],
                  ),
                  ButtonCustomized(
                      text: _textButton,
                      onPressed: () {
                        _validateFields();
                      },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red
                      ),
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
