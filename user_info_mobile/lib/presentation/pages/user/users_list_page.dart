import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/presentation/bloc/user/user_bloc.dart';
import 'package:user_info_mobile/presentation/bloc/user/user_event.dart';
import 'package:user_info_mobile/presentation/bloc/user/user_state.dart';
import 'package:user_info_mobile/core/util/constants.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  int _currentPage = 1;
  final int _perPage = 10;
  List<User> _userList = [];
  bool _isLoadingMore = false;
  bool _hasReachedMax = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadUsers() {
    context.read<UserBloc>().add(
      GetUsersRequested(
        search: _searchController.text,
        page: _currentPage,
        perPage: _perPage,
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoadingMore &&
        !_hasReachedMax) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });
      _loadUsers();
    }
  }

  void _onSearch() {
    setState(() {
      _userList = [];
      _currentPage = 1;
      _hasReachedMax = false;
    });
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UsersLoaded) {
                  setState(() {
                    if (_currentPage == 1) {
                      _userList = state.users;
                    } else {
                      _userList.addAll(state.users);
                    }
                    _hasReachedMax = state.currentPage >= state.lastPage;
                    _isLoadingMore = false;
                  });
                }
                if (state is UserFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                  setState(() {
                    _isLoadingMore = false;
                  });
                }
              },
              builder: (context, state) {
                if (state is UserLoading && _currentPage == 1) {
                  return const Center(child: CircularProgressIndicator());
                } else if (_userList.isEmpty) {
                  return const Center(child: Text('No users found'));
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _userList = [];
                        _currentPage = 1;
                        _hasReachedMax = false;
                      });
                      _loadUsers();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _userList.length + (_hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index < _userList.length) {
                          return _buildUserItem(_userList[index]);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child:
                                  _isLoadingMore
                                      ? const CircularProgressIndicator()
                                      : const SizedBox(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(User user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.userDetails,
            arguments: {'id': user.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    user.profilePhotoUrl != null
                        ? NetworkImage(user.profilePhotoUrl!)
                        : null,
                child:
                    user.profilePhotoUrl == null
                        ? Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(user.email, style: TextStyle(color: Colors.grey[600])),
                    if (user.occupation != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.occupation!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
