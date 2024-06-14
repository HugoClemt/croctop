import 'dart:io';

import 'package:croctop/services/authentification_service.dart';
import 'package:croctop/services/post_service.dart';
import 'package:croctop/view/home_screen.dart';
import 'package:croctop/view/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipesScreen extends StatefulWidget {
  const AddRecipesScreen({super.key});

  @override
  State<AddRecipesScreen> createState() => _AddRecipesScreenState();
}

class _AddRecipesScreenState extends State<AddRecipesScreen> {
  final AuthentificationService _authService = AuthentificationService();
  final PostService _postService = PostService();
  int _selectedIndex = 3;
  String? _token;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _prepTimeController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final _stepControllers = <TextEditingController>[];
  final _ingredientNameControllers = <TextEditingController>[];
  final _ingredientQuantityControllers = <TextEditingController>[];
  final _ingredientUnitControllers = <TextEditingController>[];

  String? _selectedCategory;
  List<XFile>? _imageFiles;
  final ImagePicker _picker = ImagePicker();
  final List<String> _allergens = [
    'Gluten',
    'Crustacés',
    'Oeufs',
    'Poissons',
    'Arachides',
    'Soja',
    'Lait',
    'Fruits à coque',
    'Céleri',
    'Moutarde',
    'Sésame',
    'Sulfites'
  ];
  final Map<String, bool> _selectedAllergens = {};

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _addIngredient() {
    setState(() {
      _ingredientNameControllers.add(TextEditingController());
      _ingredientQuantityControllers.add(TextEditingController());
      _ingredientUnitControllers.add(TextEditingController());
    });
  }

  void _selectImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      setState(() {
        _imageFiles = pickedFiles;
      });
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles!.removeAt(index);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _stepControllers.forEach((controller) => controller.dispose());
    _ingredientNameControllers.forEach((controller) => controller.dispose());
    _ingredientQuantityControllers
        .forEach((controller) => controller.dispose());
    _ingredientUnitControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    _allergens.forEach((allergen) {
      _selectedAllergens[allergen] = false;
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
      if (_selectedIndex == 4) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      }
    });
  }

  void createRecipes() async {
    final title = _titleController.text;
    final prepTime = _prepTimeController.text;
    final cookTime = _cookTimeController.text;
    final category = _selectedCategory;
    final steps =
        _stepControllers.map((controller) => controller.text).toList();
    final ingredients = List.generate(
      _ingredientNameControllers.length,
      (index) => {
        'name': _ingredientNameControllers[index].text,
        'quantity': _ingredientQuantityControllers[index].text,
        'unit': _ingredientUnitControllers[index].text,
      },
    );
    final selectedAllergens = _selectedAllergens.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    final imageFiles = _imageFiles ?? [];

    print('Sending data:');
    print('Title: $title');
    print('Preparation Time: $prepTime');
    print('Cooking Time: $cookTime');
    print('Category: $category');
    print('Steps: $steps');
    print('Ingredients: $ingredients');
    print('Allergens: $selectedAllergens');
    print('Image Files: ${imageFiles.map((file) => file.path).toList()}');

    final response = await _postService.createRecipes(
      title,
      prepTime,
      cookTime,
      category!,
      steps,
      ingredients,
      selectedAllergens,
      imageFiles,
    );

    if (response.success) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()));
    } else {
      print('Failed to create recipe: ${response.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipes'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _selectImages,
                      child: const Text('Select Images'),
                    ),
                  ],
                ),
                if (_imageFiles != null)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _imageFiles!.asMap().entries.map((entry) {
                      int index = entry.key;
                      XFile file = entry.value;
                      return GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Image.file(
                          File(file.path),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: const Text('Select Category'),
                  items: [
                    'Entrée',
                    'Plat principal',
                    'Dessert',
                    'Boisson',
                    'Apéritif',
                    'Snack'
                  ]
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _prepTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Preparation Time (minutes)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cookTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Cooking Time (minutes)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._stepControllers.map((controller) => TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Step',
                      ),
                    )),
                ElevatedButton(
                  onPressed: _addStep,
                  child: const Text('Add Step'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...List.generate(
                  _ingredientNameControllers.length,
                  (index) => Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ingredientNameControllers[index],
                          decoration: const InputDecoration(
                            labelText: 'Ingredient Name',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _ingredientQuantityControllers[index],
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _ingredientUnitControllers[index],
                          decoration: const InputDecoration(
                            labelText: 'Unit',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _addIngredient,
                  child: const Text('Add Ingredient'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Allergens',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._allergens.map((allergen) {
                  return CheckboxListTile(
                    title: Text(allergen),
                    value: _selectedAllergens[allergen],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedAllergens[allergen] = value!;
                      });
                    },
                  );
                }).toList(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: createRecipes,
                  child: const Text('Add Recipe'),
                ),
              ],
            ),
          ),
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
