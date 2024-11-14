import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/core/navigation/navigation.dart';
import 'package:messenger/core/themes/colors.dart';
import 'package:messenger/core/utils/utils.dart';
import 'package:messenger/features/authentication/view/widgets/widgets.dart';
import 'package:messenger/features/authentication/view_model/cubit/auth_cubit.dart';
import 'package:messenger/features/chats/view_model/cubit/messages_cubit.dart';
import 'package:messenger/features/chats/view_model/cubit/users_cubit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[gradient1, gradient2],
        ),
      ),
      child: Scaffold(
        backgroundColor: transparent,
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSucces) {
              BlocProvider.of<UsersCubit>(context).getUsers();
              BlocProvider.of<MessagesCubit>(context).getMessages();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return const BtmNav();
              }), (_) => false);
            } else if (state is AuthFailure) {
              showMessage(state.message, context);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text("English (US)",
                      style: TextStyle(color: greyTextColor)),
                  const SizedBox(height: 54),
                  Image.asset("assets/images/ic_launcher.png"),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomForm(
                      label: "email",
                      controller: email,
                      inputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomForm(
                      controller: password,
                      label: "Password",
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (!RegExp(r'.{8,}').hasMatch(value)) {
                          return 'Password must be at least 8 characters long';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must include at least one uppercase letter';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must include at least one lowercase letter';
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'Password must include at least one number';
                        }
                        if (!RegExp(r'[\W_]').hasMatch(value)) {
                          return 'Password must include at least one special character';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          BlocProvider.of<AuthCubit>(context)
                              .signin(email.text.trim(), password.text.trim());
                        }
                      },
                      value: "Log in",
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // TODO: Exec Forgot password
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: whiteColor, letterSpacing: 0.8),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    border: Border.all(color: blueColor),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      "Create new account",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: blueColor),
                    ),
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
