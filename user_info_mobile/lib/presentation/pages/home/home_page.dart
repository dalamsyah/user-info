import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_info_mobile/presentation/bloc/auth/auth_bloc.dart';
import 'package:user_info_mobile/presentation/bloc/auth/auth_event.dart';
import 'package:user_info_mobile/presentation/bloc/auth/auth_state.dart';
import 'package:user_info_mobile/presentation/bloc/profile/profile_bloc.dart';
import 'package:user_info_mobile/presentation/bloc/profile/profile_event.dart';
import 'package:user_info_mobile/core/util/constants.dart';
import 'package:user_info_mobile/presentation/pages/dashboard/dashboard_page.dart';
import 'package:user_info_mobile/presentation/pages/profile/profile_page.dart';
import 'package:user_info_mobile/presentation/pages/user/users_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _pages = [
    const DashboardPage(),
    const UserListPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Check if user is authenticated
    context.read<AuthBloc>().add(AuthCheckRequested());
    // Load current user profile
    context.read<ProfileBloc>().add(GetProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
