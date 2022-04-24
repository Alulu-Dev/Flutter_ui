import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/auth/login/bloc/bloc.dart';
import 'package:receipt_management/validators.dart';

import '../../../widgets/app_logo_widget.dart';
import '../../../widgets/input_widgets.dart';
import '../../../widgets/predefined_widgets.dart';

const Color themeColor = Color(0xff74F2C4);
const Color buttonColor = Color(0xff03DAC5);

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                spacerSizedBox(h: 20),
                greenAppLogoContainer(),
                spacerSizedBox(h: 70),
                emailInputField(emailTextController),
                spacerSizedBox(h: 50),
                passwordInputField(passwordTextController),
                spacerSizedBox(h: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: const Text(
                    "Don't have an account",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 120,
                    height: 45,
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is LoggedIn) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                        if (state is AuthFailed) {
                          final msg = state.errorMsg;
                          final snackBar = SnackBar(
                            content: Text(
                              msg,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            duration: const Duration(
                              seconds: 5,
                            ),
                            backgroundColor: Colors.white,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      builder: (context, state) {
                        if (state is LoginInProgress) {
                          return const LinearProgressIndicator();
                        }
                        return FloatingActionButton(
                          backgroundColor:
                              const Color.fromRGBO(139, 208, 161, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            final valid = _formKey.currentState!.validate();
                            if (!valid) {
                              return;
                            } //ii
                            final email = emailTextController.text;
                            final pass = passwordTextController.text;

                            final loginBloc =
                                BlocProvider.of<AuthBloc>(context);
                            loginBloc
                                .add(LoginEvent(email: email, password: pass));
                          },
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget emailInputField(TextEditingController emailController) {
  return TextFormField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.email_outlined),
      hintText: "Email",
      labelText: 'Email',
      enabledBorder: defaultInputBorder(),
      focusedBorder: onFocusInputBorder(),
    ),
    validator: (String? value) => emailValidator(emailController.text),
  );
}

Widget passwordInputField(TextEditingController passwordController) {
  return TextFormField(
    controller: passwordController,
    obscureText: true,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.lock_outline),
      hintText: "Password",
      labelText: 'Password',
      enabledBorder: defaultInputBorder(),
      focusedBorder: onFocusInputBorder(),
    ),
    validator: (String? value) => passwordValidator(passwordController.text),
  );
}
