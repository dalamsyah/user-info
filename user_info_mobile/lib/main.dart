import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_info_mobile/auth_checker_page.dart';
import 'di_container.dart' as di;
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/profile/profile_bloc.dart';
import 'presentation/bloc/user/user_bloc.dart';
import 'core/util/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => di.sl<ProfileBloc>()),
        BlocProvider<UserBloc>(create: (_) => di.sl<UserBloc>()),
      ],
      child: MaterialApp(
        title: 'User Info',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: const Color(0xFF6366F1),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            secondary: const Color(0xFF818CF8),
          ),
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        home: AuthCheckerPage(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
