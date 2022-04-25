import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt_management/auth/register/bloc/bloc.dart';

import '../../../widgets/input_widgets.dart';
import '../../../widgets/predefined_widgets.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? image;

  Future pickImage(ImageSource source, BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => (this.image = imageTemporary));
    } on PlatformException {
      const snackBar = SnackBar(
          content:
              Text("Internal Failure ", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordTextController = TextEditingController();
  final rePasswordTextController = TextEditingController();

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
                profilePictureContainer(),
                spacerSizedBox(h: 50),
                Row(
                  children: [
                    Expanded(
                      child: inputField(
                        firstNameController,
                        'nameValidator',
                        inputLabel: "First Name",
                        inputValue: "John",
                        isObscure: false,
                        fieldIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    spacerSizedBox(w: 25),
                    Expanded(
                      child: inputField(
                        lastNameController,
                        'nameValidator',
                        inputLabel: 'Last Name',
                        inputValue: 'Doe',
                        isObscure: false,
                        fieldIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                  ],
                ),
                spacerSizedBox(h: 40),
                inputField(
                  emailController,
                  'emailValidator',
                  inputLabel: 'Email Address',
                  inputValue: 'john.doe@gmail.com',
                  isObscure: false,
                  fieldIcon: const Icon(Icons.email_outlined),
                ),
                spacerSizedBox(h: 40),
                inputField(
                  passwordTextController,
                  'passwordValidator',
                  inputLabel: 'Password',
                  inputValue: '********',
                  isObscure: true,
                  fieldIcon: const Icon(Icons.lock_outline),
                ),
                spacerSizedBox(h: 40),
                inputField(
                  rePasswordTextController,
                  'rePasswordValidator',
                  password: passwordTextController,
                  inputLabel: 'Re-Password',
                  inputValue: '********',
                  isObscure: true,
                  fieldIcon: const Icon(Icons.lock_outline),
                ),
                spacerSizedBox(h: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Already have an account",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 120,
                    height: 45,
                    child: BlocConsumer<RegistrationBloc, RegistrationState>(
                      listener: (context, state) {
                        if (state is Registered) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                        if (state is RegistrationFailed) {
                          final msg = state.errorMsg;
                          final snackBar = SnackBar(
                              content: Text(msg,
                                  style: const TextStyle(color: Colors.black)),
                              duration: const Duration(seconds: 5),
                              backgroundColor: Colors.white);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterInProgress) {
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
                            }
                            final firstName = firstNameController.text;
                            final lastName = lastNameController.text;
                            final email = emailController.text;
                            final pass = passwordTextController.text;

                            try {
                              image != null
                                  ? pass
                                  : throw Exception("Choose Profile Picture");

                              final register =
                                  BlocProvider.of<RegistrationBloc>(context);
                              register.add(RegisterEvent(
                                profilePic: image!,
                                email: email,
                                password: pass,
                                firstName: firstName,
                                lastName: lastName,
                              ));
                            } catch (e) {
                              const snackBar = SnackBar(
                                  content: Text(
                                      'Profile Picture is Can\'t be  empty',
                                      style: TextStyle(color: Colors.black)),
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.white);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: const Text('REGISTER',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
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

  Widget profilePictureContainer() {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Container(
                  child: image != null
                      ? Image.file(image!)
                      : const Center(child: Icon(Icons.person, size: 150)),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: IconButton(
                onPressed: () {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.white,
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () =>
                                  pickImage(ImageSource.camera, context),
                              child: const Text('Camera',
                                  style: TextStyle(color: Colors.black))),
                          TextButton(
                              onPressed: () =>
                                  pickImage(ImageSource.gallery, context),
                              child: const Text('Gallery',
                                  style: TextStyle(color: Colors.black))),
                        ]),
                    action: SnackBarAction(label: 'Cancel', onPressed: () {}),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: const Icon(Icons.add_a_photo,
                    size: 50, color: const Color.fromRGBO(139, 208, 161, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget registerElevatedButton() {
//   return SizedBox(
//     width: 120,
//     height: 45,
//     child: FloatingActionButton(
//       backgroundColor: const Color(0xff03DAC5),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       onPressed: () {},
//       child: const Text(
//         'REGISTER',
//         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//       ),
//     ),
//   );
// }
