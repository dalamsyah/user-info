import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/presentation/bloc/profile/profile_bloc.dart';
import 'package:user_info_mobile/presentation/bloc/profile/profile_event.dart';
import 'package:user_info_mobile/presentation/bloc/profile/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _occupationController = TextEditingController();
  final _websiteController = TextEditingController();

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  List<String> _hobbies = [];
  List<String> _favoriteFoods = [];
  List<String> _socialMediaLinks = [];

  File? _profilePhoto;
  bool _isEditing = false;
  bool _obscureCurrentPassword = true;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileRequested());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
    _occupationController.dispose();
    _websiteController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _loadUserData(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _bioController.text = user.bio ?? '';
    _phoneController.text = user.phone ?? '';
    _addressController.text = user.address ?? '';
    _birthdateController.text = user.birthdate ?? '';
    _occupationController.text = user.occupation ?? '';
    _websiteController.text = user.website ?? '';

    if (user.height != null) {
      _heightController.text = user.height.toString();
    }
    if (user.weight != null) {
      _weightController.text = user.weight.toString();
    }

    _hobbies = user.hobbies ?? [];
    _favoriteFoods = user.favoriteFoods ?? [];
    _socialMediaLinks = user.socialMediaLinks ?? [];
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profilePhoto = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _birthdateController.text.isNotEmpty
              ? DateFormat('yyyy-MM-dd').parse(_birthdateController.text)
              : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _addHobby(String hobby) {
    if (hobby.isNotEmpty && !_hobbies.contains(hobby)) {
      setState(() {
        _hobbies.add(hobby);
      });
    }
  }

  void _removeHobby(String hobby) {
    setState(() {
      _hobbies.remove(hobby);
    });
  }

  void _addFavoriteFood(String food) {
    if (food.isNotEmpty && !_favoriteFoods.contains(food)) {
      setState(() {
        _favoriteFoods.add(food);
      });
    }
  }

  void _removeFavoriteFood(String food) {
    setState(() {
      _favoriteFoods.remove(food);
    });
  }

  void _addSocialMediaLink(String link) {
    if (link.isNotEmpty) {
      setState(() {
        _socialMediaLinks.add(link);
      });
    }
  }

  void _removeSocialMediaLink(String link) {
    setState(() {
      _socialMediaLinks.remove(link);
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        UpdateProfileRequested(
          name: _nameController.text,
          email: _emailController.text,
          currentPassword:
              _currentPasswordController.text.isEmpty
                  ? null
                  : _currentPasswordController.text,
          password:
              _passwordController.text.isEmpty
                  ? null
                  : _passwordController.text,
          passwordConfirmation:
              _passwordConfirmationController.text.isEmpty
                  ? null
                  : _passwordConfirmationController.text,
          bio: _bioController.text.isEmpty ? null : _bioController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          address:
              _addressController.text.isEmpty ? null : _addressController.text,
          hobbies: _hobbies.isEmpty ? null : _hobbies,
          favoriteFoods: _favoriteFoods.isEmpty ? null : _favoriteFoods,
          height:
              _heightController.text.isEmpty
                  ? null
                  : int.tryParse(_heightController.text),
          weight:
              _weightController.text.isEmpty
                  ? null
                  : int.tryParse(_weightController.text),
          birthdate:
              _birthdateController.text.isEmpty
                  ? null
                  : _birthdateController.text,
          occupation:
              _occupationController.text.isEmpty
                  ? null
                  : _occupationController.text,
          socialMediaLinks:
              _socialMediaLinks.isEmpty ? null : _socialMediaLinks,
          website:
              _websiteController.text.isEmpty ? null : _websiteController.text,
          profilePhotoPath: _profilePhoto,
        ),
      );

      setState(() {
        _isEditing = false;
        _currentPasswordController.clear();
        _passwordController.clear();
        _passwordConfirmationController.clear();
      });
    }
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  _profilePhoto != null
                      ? FileImage(_profilePhoto!)
                      : (user.profilePhotoUrl != null
                          ? NetworkImage(user.profilePhotoUrl!) as ImageProvider
                          : null),
              child:
                  _profilePhoto == null && user.profilePhotoUrl == null
                      ? Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      )
                      : null,
            ),
            if (_isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (user.occupation != null)
          Text(
            user.occupation!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        if (!_isEditing)
          TextButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Basic Information
          _buildSectionHeader('Basic Information'),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password Section
          _buildSectionHeader('Change Password (Optional)'),
          TextFormField(
            controller: _currentPasswordController,
            obscureText: _obscureCurrentPassword,
            decoration: InputDecoration(
              labelText: 'Current Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrentPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'New Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordConfirmationController,
            obscureText: _obscurePasswordConfirmation,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePasswordConfirmation
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePasswordConfirmation =
                        !_obscurePasswordConfirmation;
                  });
                },
              ),
            ),
            validator: (value) {
              if (_passwordController.text.isNotEmpty &&
                  value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Personal Information
          _buildSectionHeader('Personal Information'),
          TextFormField(
            controller: _bioController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Bio',
              prefixIcon: Icon(Icons.short_text),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              prefixIcon: Icon(Icons.home),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _birthdateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            onTap: _selectDate,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _occupationController,
            decoration: const InputDecoration(
              labelText: 'Occupation',
              prefixIcon: Icon(Icons.work),
            ),
          ),
          const SizedBox(height: 16),

          // Physical Attributes
          _buildSectionHeader('Physical Attributes'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final height = int.tryParse(value);
                      if (height == null || height <= 0 || height > 300) {
                        return 'Invalid height';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Icons.monitor_weight),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final weight = int.tryParse(value);
                      if (weight == null || weight <= 0 || weight > 500) {
                        return 'Invalid weight';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hobbies
          _buildSectionHeader('Hobbies'),
          _buildChipInputField(
            hint: 'Add hobby',
            icon: Icons.sports_esports,
            items: _hobbies,
            onAdd: _addHobby,
            onRemove: _removeHobby,
          ),
          const SizedBox(height: 16),

          // Favorite Foods
          _buildSectionHeader('Favorite Foods'),
          _buildChipInputField(
            hint: 'Add favorite food',
            icon: Icons.fastfood,
            items: _favoriteFoods,
            onAdd: _addFavoriteFood,
            onRemove: _removeFavoriteFood,
          ),
          const SizedBox(height: 16),

          // Social Media Links
          _buildSectionHeader('Social Media Links'),
          _buildChipInputField(
            hint: 'Add Social Media Links',
            icon: Icons.web,
            items: _socialMediaLinks,
            onAdd: _addSocialMediaLink,
            onRemove: _removeSocialMediaLink,
          ),
          const SizedBox(height: 16),

          // Website
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(
              labelText: 'Website',
              prefixIcon: Icon(Icons.web),
            ),
            keyboardType: TextInputType.url,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final urlRegExp = RegExp(
                  r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
                );
                if (!urlRegExp.hasMatch(value)) {
                  return 'Enter a valid URL';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    context.read<ProfileBloc>().add(GetProfileRequested());
                  });
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                onPressed: _saveProfile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const Divider(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildChipInputField({
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String) onAdd,
    required Function(String) onRemove,
  }) {
    final TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: hint,
                  prefixIcon: Icon(icon),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    onAdd(value);
                    controller.clear();
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onAdd(controller.text);
                  controller.clear();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children:
              items.map((item) {
                return Chip(
                  label: Text(item),
                  deleteIcon: const Icon(Icons.cancel, size: 16),
                  onDeleted: () => onRemove(item),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(User user) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (user.bio != null && user.bio!.isNotEmpty) ...[
          _buildSectionHeader('Bio'),
          Text(user.bio!),
          const SizedBox(height: 16),
        ],

        _buildSectionHeader('Contact Information'),
        _buildInfoTile(Icons.email, 'Email', user.email),
        if (user.phone != null)
          _buildInfoTile(Icons.phone, 'Phone', user.phone!),
        if (user.address != null)
          _buildInfoTile(Icons.home, 'Address', user.address!),
        if (user.website != null)
          _buildInfoTile(Icons.web, 'Website', user.website!),
        const SizedBox(height: 16),

        _buildSectionHeader('Personal Details'),
        if (user.birthdate != null)
          _buildInfoTile(Icons.cake, 'Birthday', user.birthdate!),
        if (user.occupation != null)
          _buildInfoTile(Icons.work, 'Occupation', user.occupation!),
        if (user.height != null)
          _buildInfoTile(Icons.height, 'Height', '${user.height} cm'),
        if (user.weight != null)
          _buildInfoTile(Icons.monitor_weight, 'Weight', '${user.weight} kg'),
        const SizedBox(height: 16),

        if (user.hobbies != null && user.hobbies!.isNotEmpty) ...[
          _buildSectionHeader('Hobbies'),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                user.hobbies!.map((hobby) {
                  return Chip(
                    label: Text(hobby),
                    backgroundColor: Colors.blue.shade100,
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        if (user.favoriteFoods != null && user.favoriteFoods!.isNotEmpty) ...[
          _buildSectionHeader('Favorite Foods'),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                user.favoriteFoods!.map((food) {
                  return Chip(
                    label: Text(food),
                    backgroundColor: Colors.green.shade100,
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        if (user.socialMediaLinks != null &&
            user.socialMediaLinks!.isNotEmpty) ...[
          _buildSectionHeader('Social Media'),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                user.socialMediaLinks!.map((food) {
                  return Chip(
                    label: Text(food),
                    backgroundColor: Colors.green.shade100,
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProfileBloc>().add(GetProfileRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            _loadUserData(state.user);
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          } else if (state is ProfileLoaded) {
            _loadUserData(state.user);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded || state is ProfileUpdated) {
            final User user =
                state is ProfileLoaded
                    ? state.user
                    : (state as ProfileUpdated).user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileHeader(user),
                  const SizedBox(height: 16),
                  if (_isEditing)
                    _buildProfileForm()
                  else
                    _buildProfileInfo(user),
                ],
              ),
            );
          } else if (state is ProfileFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(GetProfileRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
