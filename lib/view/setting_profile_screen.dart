import 'package:croctop/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingProfileScreen extends StatefulWidget {
  const SettingProfileScreen({super.key});

  @override
  State<SettingProfileScreen> createState() => _SettingProfileScreenState();
}

class _SettingProfileScreenState extends State<SettingProfileScreen> {
  final UserService _userService = UserService();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _birthdayDisplayController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String? _birthdayIso;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _userInfo = _userInfo;
    if (_userInfo != null) {
      _firstnameController.text = _userInfo?['firstname'] ?? '';
      _lastnameController.text = _userInfo?['lastname'] ?? '';
      _emailController.text = _userInfo?['email'] ?? '';
      if (_userInfo?['birthday'] != null) {
        DateTime parsedDate = DateTime.parse(_userInfo?['birthday']);
        _birthdayDisplayController.text =
            DateFormat('d MMMM yyyy').format(parsedDate);
        _birthdayIso = DateFormat('yyyy-MM-dd').format(parsedDate);
      }
      _usernameController.text = _userInfo?['username'] ?? '';
    }
  }

  void _loadUserInfo() async {
    final Map<String, dynamic>? _userInfo = await _userService.getUserInfo();
    if (_userInfo != null) {
      setState(() {
        _firstnameController.text = _userInfo['firstname'];
        _lastnameController.text = _userInfo['lastname'];
        _emailController.text = _userInfo['email'];
        if (_userInfo['birthday'] != null) {
          DateTime parsedDate = DateTime.parse(_userInfo['birthday']);
          _birthdayDisplayController.text =
              DateFormat('d MMMM yyyy').format(parsedDate);
          _birthdayIso = DateFormat('yyyy-MM-dd').format(parsedDate);
        }
        _usernameController.text = _userInfo['username'];
      });
    }
  }

  void _updateProfile() async {
    final Map<String, dynamic> data = {
      'firstname': _firstnameController.text,
      'lastname': _lastnameController.text,
      'email': _emailController.text,
      'birthday': _birthdayIso,
      'username': _usernameController.text,
    };

    print('Data to update: $data');
    final response = await UserService().updateProfile(data);
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: _firstnameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: _lastnameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: _birthdayDisplayController,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.calendar_today),
                              labelText: 'Birthday',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.brown,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final DateTime? birthday = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (birthday != null) {
                                _birthdayIso =
                                    DateFormat('yyyy-MM-dd').format(birthday);
                                _birthdayDisplayController.text =
                                    DateFormat('d MMMM yyyy').format(birthday);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 350,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown[200],
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: const Text(
                              'Update Profile',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
