import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/configuration/category.dart';
import 'package:food_order_ui/services/food_api.dart';

class FoodFormScreen extends StatefulWidget {
  final Food? food;

  const FoodFormScreen({Key? key, this.food}) : super(key: key);

  @override
  _FoodFormScreenState createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categoriesController;
  late TextEditingController _imagePathController;
  late bool isFavorite;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food?.name ?? '');
    _priceController = TextEditingController(text: widget.food?.price ?? '');
    _categoriesController = TextEditingController(
      text: widget.food?.categories.map((c) => c.categoryName).join(', ') ?? '',
    );
    _imagePathController = TextEditingController(
      text: widget.food?.imageUrl ?? 'assets/food/GrilledChicken.jpg',
    );
    isFavorite = widget.food?.isFavorite ?? false;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {

      List<Category> categories = _categoriesController.text
          .split(',')
          .map((name) => Category(
        categoryId: '',
        categoryName: name.trim(),
        categoryImage: 'assets/images/default_category_image.png',
      ))
          .toList();

      final food = Food(
        id: widget.food?.id ?? '',
        name: _nameController.text,
        price: _priceController.text,
        categories: categories,

        imageUrl: _imageFile?.path ?? _imagePathController.text,
        isFavorite: isFavorite,
      );

      try {
        if (widget.food == null) {

          await FoodApi.createFood(food);
        } else {

          await FoodApi.updateFood(food.id, food);
        }
        Navigator.pop(context, true);
      } catch (e) {
        print('Error saving food: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food == null ? 'Ajouter un aliment' : 'Modifier un aliment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom de l\'aliment'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom ne peut pas être vide';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le prix ne peut pas être vide';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _categoriesController,
                decoration: const InputDecoration(labelText: 'Catégories (séparées par des virgules)'),
              ),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(labelText: 'Chemin de l\'image dans les assets'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez fournir un chemin d\'image valide';
                  }
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    _imageFile != null
                        ? Image.file(
                      _imageFile!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                        : widget.food != null && widget.food!.imageUrl.isNotEmpty
                        ? Image.network(
                      widget.food!.imageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                        : const Text('Aucune image sélectionnée'),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Choisir une image'),
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                title: const Text('Favori'),
                value: isFavorite,
                onChanged: (bool value) {
                  setState(() {
                    isFavorite = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.food == null ? 'Ajouter' : 'Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
