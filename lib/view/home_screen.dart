import 'package:croctop/services/authentification_service.dart';
import 'package:croctop/view/add_recipes_screen.dart';
import 'package:croctop/view/profil_screen.dart';
import 'package:croctop/view/signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthentificationService _authService = AuthentificationService();
  int _selectedIndex = 0;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _authService.getToken();
    setState(() {
      _token = token;
    });
  }

  void _signout() async {
    await _authService.signout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninScreen()),
    );
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected tab: $_selectedIndex');
      print('Token: $_token');
      if (_selectedIndex == 4) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      }
      if (_selectedIndex == 3) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AddRecipesScreen()));
      }
    });
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
      body: const Center(
        child: Text('Welcome to CrocTop !'),
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
