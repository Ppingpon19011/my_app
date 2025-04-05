import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/Screens/Pages/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:my_app/components/my_text_field.dart';
import 'package:my_app/user_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Lenght = false;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isNameFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
    _nameFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isEmailFocused = _emailFocus.hasFocus;
      _isPasswordFocused = _passwordFocus.hasFocus;
      _isNameFocused = _nameFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    _emailFocus.removeListener(_onFocusChange);
    _passwordFocus.removeListener(_onFocusChange);
    _nameFocus.removeListener(_onFocusChange);
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            setState(() {
              signUpRequired = false;
            });
          } else if (state is SignUpLoading) {
            setState(() {
              signUpRequired = true;
            });
          } else if (state is SignUpFailure) {
            return;
          }
        },
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(CupertinoIcons.mail_solid),
                      focusNode: _emailFocus,
                      isFocused: _isEmailFocused,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                            .hasMatch(val)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      }),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
                      focusNode: _passwordFocus,
                      isFocused: _isPasswordFocused,
                      OnChanged: (val) {
                        if (val!.contains(RegExp(r'[A-Z]'))) {
                          setState(() {
                            containsUpperCase = true;
                          });
                        } else {
                          setState(() {
                            containsUpperCase = false;
                          });
                        }
                        if (val.contains(RegExp(r'[a-z]'))) {
                          setState(() {
                            containsLowerCase = true;
                          });
                        } else {
                          setState(() {
                            containsLowerCase = false;
                          });
                        }
                        if (val.contains(RegExp(r'[0-9]'))) {
                          setState(() {
                            containsNumber = true;
                          });
                        } else {
                          setState(() {
                            containsNumber = false;
                          });
                        }
                        if (val.contains(RegExp(
                            r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                          setState(() {
                            containsSpecialChar = true;
                          });
                        } else {
                          setState(() {
                            containsSpecialChar = false;
                          });
                        }
                        if (val.length >= 8) {
                          setState(() {
                            contains8Lenght = true;
                          });
                        } else {
                          setState(() {
                            contains8Lenght = false;
                          });
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                            iconPassword = obscurePassword
                                ? CupertinoIcons.eye_fill
                                : CupertinoIcons.eye_slash_fill;
                          });
                        },
                        icon: Icon(iconPassword),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (!RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                            .hasMatch(val)) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      }),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• 1 uppercase",
                          style: TextStyle(
                              color: containsUpperCase
                                  ? Colors.lightGreen
                                  : Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          "• 1 lowercase",
                          style: TextStyle(
                              color: containsLowerCase
                                  ? Colors.lightGreen
                                  : Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          "• 1 number",
                          style: TextStyle(
                              color: containsNumber
                                  ? Colors.lightGreen
                                  : Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• 1 special character",
                          style: TextStyle(
                              color: containsSpecialChar
                                  ? Colors.lightGreen
                                  : Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          "• 8 minimum character",
                          style: TextStyle(
                              color: contains8Lenght
                                  ? Colors.lightGreen
                                  : Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(CupertinoIcons.person_fill),
                      focusNode: _nameFocus,
                      isFocused: _isNameFocused,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (val.length > 30) {
                          return 'Name too long';
                        }
                        return null;
                      }),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                !signUpRequired
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              MyUser myUser = MyUser.empty;
                              myUser = myUser.copyWith(email: emailController.text);
                              myUser = myUser.copyWith(name: nameController.text);

                              setState(() {
                                context.read<SignUpBloc>().add(SignUpRequired(
                                    myUser, passwordController.text));
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator()
              ],
            ),
          ),
        ));
  }
}
