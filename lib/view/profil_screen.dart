import 'package:croctop/services/authentification_service.dart';
import 'package:croctop/view/add_recipes_screen.dart';
import 'package:croctop/view/home_screen.dart';
import 'package:croctop/view/signin_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthentificationService _authService = AuthentificationService();
  int _selectedIndex = 4;
  String? _token;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _authService.getUserInfo();
    setState(() {
      _userInfo = userInfo;
    });
  }

  Future<void> _loadToken() async {
    final token = await _authService.getToken();
    setState(() {
      _token = token;
    });
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected tab: $_selectedIndex');
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      if (_selectedIndex == 3) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AddRecipesScreen()));
      }
    });
  }

  void _signout() async {
    await _authService.signout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.amber,
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_userInfo?['username']}'),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text('Recettes: ${_userInfo?['posts'].length}'),
                            const SizedBox(width: 20),
                            Text(
                                'Followers: ${_userInfo?['followers'].length}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const Text('All recettes:'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        onTap: _selectTab,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
