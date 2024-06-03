import 'package:croctop/services/authentification_service.dart';
import 'package:croctop/view/home_screen.dart';
import 'package:croctop/view/profil_screen.dart';
import 'package:flutter/material.dart';

class AddRecipesScreen extends StatefulWidget {
  const AddRecipesScreen({super.key});

  @override
  State<AddRecipesScreen> createState() => _AddRecipesScreenState();
}

class _AddRecipesScreenState extends State<AddRecipesScreen> {
  final AuthentificationService _authService = AuthentificationService();
  int _selectedIndex = 3;
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

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected tab: $_selectedIndex');
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      if (_selectedIndex == 4) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipes'),
      ),
      body: const Center(
        child: Text('Add Recipes'),
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
