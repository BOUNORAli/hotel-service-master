import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/services/food_api.dart';
import 'package:food_order_ui/view/food_detail_page/food_detail_view.dart';
import 'package:food_order_ui/view/search_page/widgets/search_textfield.dart';

class SearchPageView extends StatefulWidget {
  const SearchPageView({Key? key}) : super(key: key);

  @override
  _SearchPageViewState createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  List<dynamic> _searchResults = [];
  Food? _selectedFood;

  void _onSearch(String keywords) async {
    try {
      List<dynamic> results = await FoodApi.searchFoods(keywords);
      setState(() {
        _searchResults = results;
        _selectedFood =
            null; // Réinitialiser l'aliment sélectionné lors d'une nouvelle recherche
      });
    } catch (e) {
      // Afficher un message d'erreur à l'utilisateur si la recherche échoue
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Search", style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          SearchTextField(
            hintText: "Search",
            onSearch: _onSearch,
          ),
          Expanded(
            child: _selectedFood != null
                ? FoodDetailView(
                    food:
                        _selectedFood!) // Afficher les détails de l'aliment sélectionné
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        var foodJson = _searchResults[index];
        var food = Food.fromJsonTwo(foodJson);
        var categories =
            food.categories.map((category) => category.categoryName).join(', ');
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFood = food;
            });
          },
          child: ListTile(
            leading: food.imageUrl != null
                ? Image.network(
                    food.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(),
            title: Text(food.name),
            subtitle: Text(categories),
            trailing: Text(
                '${food.price}\$'), // Ajout de guillemets autour de ${food.price}
          ),
        );
      },
    );
  }
}
