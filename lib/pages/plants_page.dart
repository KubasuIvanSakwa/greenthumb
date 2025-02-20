import 'package:flutter/material.dart';
import 'package:greenthumb/modals/plant_card.dart';

class PlantsPage extends StatefulWidget {
  final List<Map<String, dynamic>> plants;

  const PlantsPage({Key? key, required this.plants}) : super(key: key);

  @override
  _PlantsPageState createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  List<Map<String, dynamic>> filteredPlants = [];
  String selectedCategory = "All";

  final List<String> categories = ["All", "Trees", "Flowers", "Herbs", "Shrubs"];

  @override
  void initState() {
    super.initState();
    filteredPlants = widget.plants; // Default to showing all plants
  }

  void filterPlants(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All") {
        filteredPlants = widget.plants;
      } else {
        filteredPlants = widget.plants
            .where((plant) => plant["category"]?.contains(category) ?? false)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plants List")),
      body: Column(
        children: [
          // 🔹 Categories Bar
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      if (selected) filterPlants(category);
                    },
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey[300],
                    labelStyle: TextStyle(
                      color: selectedCategory == category ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 Plants List
          Expanded(
            child: filteredPlants.isEmpty
                ? const Center(child: Text("No plants found."))
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredPlants.length,
              itemBuilder: (context, index) {
                final plant = filteredPlants[index];

                return PlantCard(plantData: plant);
              },
            ),
          ),
        ],
      ),
    );
  }
}
