import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/presentation/bloc/user/user_bloc.dart';
import 'package:user_info_mobile/presentation/bloc/user/user_event.dart';
import 'package:user_info_mobile/presentation/bloc/user/user_state.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailsPage extends StatefulWidget {
  final int userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  UserDetailsPageState createState() => UserDetailsPageState();
}

class UserDetailsPageState extends State<UserDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() {
    context.read<UserBloc>().add(GetUserDetailsRequested(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserDetailsLoaded) {
            return _buildUserDetails(state.user);
          } else if (state is UserFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadUserDetails,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user details available'));
          }
        },
      ),
    );
  }

  Widget _buildUserDetails(User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Center(
            child: Column(
              children: [
                user.profilePhotoUrl != null
                    ? CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(user.profilePhotoUrl!),
                    )
                    : CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                if (user.occupation != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.occupation!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bio
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            _buildSectionTitle('Bio'),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(user.bio!),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Contact Information
          _buildSectionTitle('Contact Information'),
          _buildContactInfo(user),
          const SizedBox(height: 16),

          // Personal Information
          _buildSectionTitle('Personal Information'),
          _buildPersonalInfo(user),
          const SizedBox(height: 16),

          // Hobbies & Interests
          if (user.hobbies != null && user.hobbies!.isNotEmpty) ...[
            _buildSectionTitle('Hobbies & Interests'),
            _buildHobbies(user.hobbies!),
            const SizedBox(height: 16),
          ],

          // Favorite Foods
          if (user.favoriteFoods != null && user.favoriteFoods!.isNotEmpty) ...[
            _buildSectionTitle('Favorite Foods'),
            _buildFavoriteFoods(user.favoriteFoods!),
            const SizedBox(height: 16),
          ],

          // Social Media
          if (user.socialMediaLinks != null &&
              user.socialMediaLinks!.isNotEmpty) ...[
            _buildSectionTitle('Social Media'),
            _buildSocialMedia(user.socialMediaLinks!),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6366F1),
        ),
      ),
    );
  }

  Widget _buildContactInfo(User user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildInfoTile(
            'Email',
            user.email,
            Icons.email_outlined,
            onTap: () => _launchEmail(user.email),
          ),
          if (user.phone != null)
            _buildInfoTile(
              'Phone',
              user.phone!,
              Icons.phone_outlined,
              onTap: () => _launchPhone(user.phone!),
            ),
          if (user.address != null)
            _buildInfoTile(
              'Address',
              user.address!,
              Icons.location_on_outlined,
              onTap: () => _launchMaps(user.address!),
            ),
          if (user.website != null)
            _buildInfoTile(
              'Website',
              user.website!,
              Icons.language_outlined,
              onTap: () => _launchUrl(user.website!),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(User user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          if (user.birthdate != null)
            _buildInfoTile('Birthdate', user.birthdate!, Icons.cake_outlined),
          if (user.height != null)
            _buildInfoTile(
              'Height',
              '${user.height} cm',
              Icons.height_outlined,
            ),
          if (user.weight != null)
            _buildInfoTile(
              'Weight',
              '${user.weight} kg',
              Icons.fitness_center_outlined,
            ),
          if (user.bmi != null)
            _buildInfoTile(
              'BMI',
              user.bmi!.toStringAsFixed(1),
              Icons.monitor_weight_outlined,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6366F1)),
      title: Text(title),
      subtitle: Text(value),
      onTap: onTap,
    );
  }

  Widget _buildHobbies(List<String> hobbies) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          hobbies.map((hobby) {
            return Chip(
              label: Text(hobby),
              backgroundColor: Colors.blue[50],
              labelStyle: TextStyle(color: Colors.blue[700]),
            );
          }).toList(),
    );
  }

  Widget _buildFavoriteFoods(List<String> foods) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          foods.map((food) {
            return Chip(
              label: Text(food),
              backgroundColor: Colors.green[50],
              labelStyle: TextStyle(color: Colors.green[700]),
            );
          }).toList(),
    );
  }

  Widget _buildSocialMedia(List<String> socialMedia) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children:
            socialMedia.map((link) {
              final platform = _getPlatformFromLink(link);
              final icon = _getSocialMediaIcon(platform);

              return _buildInfoTile(
                platform,
                link,
                icon,
                onTap: () => _launchURL(link),
              );
            }).toList(),
      ),
    );
  }

  String _getPlatformFromLink(String link) {
    if (link.contains("instagram.com")) return "Instagram";
    if (link.contains("twitter.com")) return "Twitter";
    if (link.contains("facebook.com")) return "Facebook";
    if (link.contains("linkedin.com")) return "LinkedIn";
    return "Unknown";
  }

  IconData _getSocialMediaIcon(String link) {
    switch (link.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'twitter':
        return Icons.alternate_email;
      case 'instagram':
        return Icons.camera_alt_outlined;
      case 'linkedin':
        return Icons.business_center_outlined;
      default:
        return Icons.link;
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    _launchUri(emailUri);
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    _launchUri(phoneUri);
  }

  void _launchMaps(String address) async {
    final Uri mapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {'query': address},
    );
    _launchUri(mapsUri);
  }

  void _launchUrl(String url) async {
    Uri uri;
    if (url.startsWith('http://') || url.startsWith('https://')) {
      uri = Uri.parse(url);
    } else {
      uri = Uri.parse('https://$url');
    }
    _launchUri(uri);
  }

  void _launchUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $uri'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
