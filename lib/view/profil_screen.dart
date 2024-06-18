import 'package:croctop/services/authentification_service.dart';
import 'package:croctop/services/user_service.dart';
import 'package:croctop/view/add_recipes_screen.dart';
import 'package:croctop/view/home_screen.dart';
import 'package:croctop/view/setting_profile_screen.dart';
import 'package:croctop/view/signin_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthentificationService _authService = AuthentificationService();
  final UserService _userService = UserService();
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
    final userInfo = await _userService.getUserInfo();
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

  void _navigateToSettings() async {
    final updatedUserInfo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingProfileScreen()),
    );

    if (updatedUserInfo != null) {
      setState(() {
        _userInfo = updatedUserInfo;
      });
    }
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
        centerTitle: true,
        title: Text('${_userInfo?['username']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              print('userInfo: $_userInfo');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingProfileScreen();
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadUserInfo();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.brown[200],
                    radius: 45,
                    child: ClipOval(
                      child: Image.network(
                        'https://picsum.photos/250',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person_off_rounded, size: 45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_userInfo?['posts'].length} Recpies'),
                      const SizedBox(width: 50),
                      Text('${_userInfo?['followers'].length} Followers'),
                    ],
                  ),
                ],
              ),
            ),
            /* SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.brown[200],
                      radius: 25,
                      child: ClipOval(
                        child: Image.network(
                          'https://picsum.photos/250',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person_off_rounded, size: 25),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ), */
            const Divider(),
            const Text('Your Recipes'),
          ],
        ),
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
