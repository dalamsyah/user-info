import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_info_mobile/presentation/bloc/auth/auth_bloc.dart';
import 'package:user_info_mobile/presentation/bloc/auth/auth_event.dart';
import 'package:user_info_mobile/presentation/bloc/auth/auth_state.dart';
import 'package:user_info_mobile/core/util/constants.dart';

class AuthCheckerPage extends StatefulWidget {
  const AuthCheckerPage({super.key});

  @override
  State<AuthCheckerPage> createState() => _AuthCheckerPageState();
}

class _AuthCheckerPageState extends State<AuthCheckerPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
    context.read<AuthBloc>().add(AuthGetCurrentUserRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
