import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt_management/auth/profile/bloc/bloc.dart';
import 'package:receipt_management/auth/profile/repository/profile_repository.dart';

import '../../../widgets/input_widgets.dart';
import '../../../widgets/predefined_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileRepository profileRepository = ProfileRepository();
  late ProfileBloc _profileBloc;
  File? image;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _rePasswordTextController =
      TextEditingController();

  Future pickImage(ImageSource source, BuildContext context) async {
    try {
      var image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => (this.image = imageTemporary));
    } on PlatformException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Text("failed to get photos $e"),
        action: SnackBarAction(label: 'Cancel', onPressed: () {}),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future getProfile() async {
    final profile = await profileRepository.profileRoute();

    if (!mounted) return;

    setState(() {
      _firstNameController.text = profile.firstName;
      _lastNameController.text = profile.lastName;
      _emailController.text = profile.email;
    });
  }

  @override
  void dispose() {
    _profileBloc.add(ProfileUnload());
    super.dispose();
  }

  @override
  void initState() {
    getProfile();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileEditing) {
            setState(() {
              image = state.profileImage;
            });
          }
          if (state is ProfileLoaded) {
            setState(() {
              image = state.profileImage;
            });
          }
          if (state is ProfileLoggedOut) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state is ProfileLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                spacerSizedBox(h: 20),
                profilePictureContainer(context, state, state.profileImage),
                spacerSizedBox(h: 50),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Basic info', style: TextStyle(fontSize: 25))),
                spacerSizedBox(h: 25),
                Row(children: [
                  Expanded(
                      child: profileOutput(
                          inputLabel: state.firstName,
                          inputValue: '',
                          fieldIcon: const Icon(Icons.person_outline),
                          readOnly: false)),
                  spacerSizedBox(w: 25),
                  Expanded(
                      child: profileOutput(
                          inputLabel: state.lastName,
                          inputValue: '',
                          fieldIcon: const Icon(Icons.person_outline),
                          readOnly: false)),
                ]),
                spacerSizedBox(h: 40),
                profileOutput(
                    inputLabel: state.email,
                    inputValue: '',
                    fieldIcon: const Icon(Icons.email_outlined),
                    readOnly: false),
                spacerSizedBox(h: 40),
                const Align(
                    alignment: Alignment.topLeft,
                    child:
                        Text('System Summary', style: TextStyle(fontSize: 20))),
                spacerSizedBox(h: 25),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      infoCard(data: state.receiptData, title: "receipt"),
                      infoCard(data: state.requestsData, title: "requests"),
                      infoCard(data: state.daysWithUs, title: "days since"),
                    ]),
                spacerSizedBox(h: 30),
                expenseReportElevatedButton(context),
                spacerSizedBox(h: 30),
                budgetElevatedButton(context),
                spacerSizedBox(h: 30),
                requestElevatedButton(context),
                spacerSizedBox(h: 20),
              ],
            );
          }
          if (state is ProfileEditing) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  spacerSizedBox(h: 20),
                  profilePictureContainer(context, state, state.profileImage),
                  spacerSizedBox(h: 50),
                  const Align(
                      alignment: Alignment.topLeft,
                      child:
                          Text('Basic info', style: TextStyle(fontSize: 25))),
                  spacerSizedBox(h: 25),
                  Row(children: [
                    Expanded(
                      child: inputField(
                        _firstNameController,
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
                        _lastNameController,
                        'nameValidator',
                        inputLabel: 'Last Name',
                        inputValue: 'Doe',
                        isObscure: false,
                        fieldIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                  ]),
                  spacerSizedBox(h: 30),
                  inputField(
                    _emailController,
                    'emailValidator',
                    inputLabel: 'Email Address',
                    inputValue: state.email,
                    isObscure: false,
                    fieldIcon: const Icon(Icons.email_outlined),
                  ),
                  spacerSizedBox(h: 30),
                  inputField(
                    _oldPasswordTextController,
                    'passwordValidator',
                    inputLabel: 'Old Password',
                    inputValue: '********',
                    isObscure: true,
                    fieldIcon: const Icon(Icons.lock_outline),
                  ),
                  spacerSizedBox(h: 30),
                  inputFieldEdit(
                    _passwordTextController,
                    'passwordValidator',
                    inputLabel: 'Password',
                    inputValue: '********',
                    isObscure: true,
                    fieldIcon: const Icon(Icons.lock_outline),
                  ),
                  spacerSizedBox(h: 20),
                  inputFieldEdit(
                    _rePasswordTextController,
                    'rePasswordValidator',
                    password: _passwordTextController,
                    inputLabel: 'Re-Password',
                    inputValue: '********',
                    isObscure: true,
                    fieldIcon: const Icon(Icons.lock_outline),
                  ),
                  spacerSizedBox(h: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      spacerSizedBox(h: 25),
                      TextButton.icon(
                          onPressed: () {
                            final valid = _formKey.currentState!.validate();
                            if (!valid) {
                              return;
                            }
                            final firstName = _firstNameController.text;
                            final lastName = _lastNameController.text;
                            final email = _emailController.text;
                            final pass = _passwordTextController.text;
                            final oldPass = _oldPasswordTextController.text;

                            try {
                              image != null
                                  ? pass
                                  : throw Exception("Choose Profile Picture");

                              _profileBloc.add(ProfileSave(
                                profileImage: image!,
                                email: email,
                                oldPassword: oldPass,
                                password: pass,
                                firstName: firstName,
                                lastName: lastName,
                              ));
                            } catch (e) {
                              var snackBar = SnackBar(
                                  content: Text(e.toString(),
                                      // 'Profile Picture is Can\'t be  empty',
                                      style: TextStyle(color: Colors.black)),
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.white);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      spacerSizedBox(w: 30),
                      TextButton.icon(
                          onPressed: () {
                            _profileBloc.add(ProfileUnload());
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'Discard',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            );
          }

          _profileBloc.add(ProfileLoad());
          return const SizedBox();
        },
      ),
    );
  }

  Widget profilePictureContainer(
      BuildContext context, ProfileState state, File profileImage) {
    if (state is ProfileLoaded) {
      return Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(100)),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(100)),
            child: Center(
              child: Image.file(profileImage),
            ),
          ));
    }
    if (state is ProfileEditing) {
      return Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(100)),
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                  child: Image.file(
                image!,
              )),
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
                      size: 50, color: Colors.blue)),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  } // profilePictureContainer

  Card infoCard({int data = 0, String title = "data"}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 3,
      color: const Color.fromARGB(255, 203, 237, 207),
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(data.toString(), style: const TextStyle(fontSize: 20)),
            Text(title),
          ])),
    );
  } // infoCard

}

Widget requestElevatedButton(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 0.5,
          blurRadius: 3,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: ElevatedButton(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Requests",
                style: TextStyle(color: Colors.black, fontSize: 20)),
            Icon(Icons.arrow_forward, size: 25, color: Colors.black),
          ]),
      onPressed: () {
        Navigator.of(context).pushNamed('/requests');
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(20)),
    ),
  );
}

Widget budgetElevatedButton(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 0.5,
          blurRadius: 3,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: ElevatedButton(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Budget", style: TextStyle(color: Colors.black, fontSize: 20)),
            Icon(Icons.arrow_forward, size: 25, color: Colors.black),
          ]),
      onPressed: () {
        Navigator.of(context).pushNamed('/budgets');
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(20)),
    ),
  );
}

Widget expenseReportElevatedButton(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 0.5,
          blurRadius: 3,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(20)),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Expense Reports",
                style: TextStyle(color: Colors.black, fontSize: 20)),
            Icon(Icons.arrow_forward, size: 25, color: Colors.black),
          ]),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Expense',
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                summaryByCategoryElevatedButton(context),
                spacerSizedBox(h: 15),
                summaryOfReceiptsElevatedButton(context),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget summaryByCategoryElevatedButton(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 0.5,
          blurRadius: 3,
          offset: const Offset(0, -1), // changes position of shadow
        ),
      ],
    ),
    child: ElevatedButton(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Summary by Category",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            Icon(Icons.arrow_forward, size: 18, color: Colors.black),
          ]),
      onPressed: () {
        Navigator.of(context).pushNamed('/expenseSummary');
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 20,
          padding: const EdgeInsets.all(20)),
    ),
  );
}

Widget summaryOfReceiptsElevatedButton(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 0.5,
          blurRadius: 3,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: ElevatedButton(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Summary of Receipts",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            Icon(Icons.arrow_forward, size: 18, color: Colors.black),
          ]),
      onPressed: () {
        Navigator.of(context).pushNamed('/summaryOfReceipts');
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 10,
          padding: const EdgeInsets.all(20)),
    ),
  );
}
