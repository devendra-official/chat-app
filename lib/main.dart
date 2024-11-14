import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/core/navigation/navigation.dart';
import 'package:messenger/core/themes/theme.dart';
import 'package:messenger/features/authentication/model/auth.dart';
import 'package:messenger/features/authentication/view/pages/login.dart';
import 'package:messenger/features/authentication/view_model/cubit/auth_cubit.dart';
import 'package:messenger/features/chats/model/users.dart';
import 'package:messenger/features/chats/view_model/cubit/messages_cubit.dart';
import 'package:messenger/features/chats/view_model/cubit/users_cubit.dart';
import 'package:messenger/init_dependency.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthCubit(serviceLocator<Authentication>())),
        BlocProvider(
            create: (context) => UsersCubit(serviceLocator<UsersRepo>())),
        BlocProvider(
            create: (context) => MessagesCubit(serviceLocator<UsersRepo>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: StreamBuilder<bool>(
        stream: serviceLocator<StreamController<bool>>().stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            BlocProvider.of<UsersCubit>(context).getUsers();
            BlocProvider.of<MessagesCubit>(context).getMessages();
            return const BtmNav();
          }
          return const Login();
        },
      ),
    );
  }
}
