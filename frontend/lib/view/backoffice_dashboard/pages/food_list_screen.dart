import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/services/food_api.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/food_form_screen.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({Key? key}) : super(key: key);

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  List<Food> foods = [];
  String selectedFilter = 'Tous';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  void _fetchFoods() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Food> fetchedFoods = [];
      if (selectedFilter == 'Tous') {
        fetchedFoods = await FoodApi.fetchAllFoods();
      } else if (selectedFilter == 'Populaires') {
        fetchedFoods = await FoodApi.fetchPopularFoods();
      } else if (selectedFilter == 'Recommandés') {
        fetchedFoods = await FoodApi.fetchRecommendFoods();
      }

      setState(() {
        foods = fetchedFoods;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching foods: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToFoodForm({Food? food}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodFormScreen(food: food),
      ),
    );

    if (result != null) {
      _fetchFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des aliments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToFoodForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              isExpanded: true,
              icon: const Icon(Icons.filter_list),
              items: <String>['Tous', 'Populaires', 'Recommandés']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                  _fetchFoods();
                });
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          food.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        food.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Prix: ${food.price}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToFoodForm(food: food),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
