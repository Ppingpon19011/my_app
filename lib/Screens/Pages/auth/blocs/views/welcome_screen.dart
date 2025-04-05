import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/Screens/Pages/auth/blocs/views/sign_in_screen.dart';
import 'package:my_app/Screens/Pages/auth/blocs/views/sign_up_screen.dart';
import '../../../../../blocs/authentication/authentication_bloc.dart';
import '../sign_in/sign_in_bloc.dart';
import '../sign_up/sign_up_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(20, -1.6),
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-2.7, -1.6),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.3,
                  width: MediaQuery.of(context).size.width / 1.3,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(2.7, -1.6),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.3,
                  width: MediaQuery.of(context).size.width / 1.3,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/cattle_logo.png',
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(20, 1.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: TabBar(
                          controller: tabController,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          labelColor:
                              Theme.of(context).colorScheme.onSurface,
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child:
                              TabBarView(controller: tabController, children: [
                        BlocProvider<SignInBloc>(
                          create: (context) => SignInBloc(context
                              .read<AuthenticationBloc>()
                              .userRepository),
                          child: const SignInScreen(),
                        ),
                        BlocProvider<SignUpBloc>(
                          create: (context) => SignUpBloc(context
                              .read<AuthenticationBloc>()
                              .userRepository),
                          child: const SignUpScreen(),
                        ),
                      ]))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
