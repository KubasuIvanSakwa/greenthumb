import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PlantDetailScreen extends StatefulWidget {
  final int plantId;

  const PlantDetailScreen({Key? key, required this.plantId}) : super(key: key);

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late Future<Map<String, dynamic>> plantDetails;

  @override
  void initState() {
    super.initState();
    plantDetails = fetchPlantDetails(widget.plantId);
  }

  // Function to fetch plant details from API
  Future<Map<String, dynamic>> fetchPlantDetails(int plantId) async {
    const String apiKey = "sk-PI1U67b47156cee1d8714"; // Replace with your actual API key
    final String url = "https://perenual.com/api/v2/species/details/$plantId?key=$apiKey";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Convert JSON response to a Map
      } else {
        throw Exception("Failed to load plant details: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching plant details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plant Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: plantDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:
              LoadingAnimationWidget.threeArchedCircle(
                color: Colors.lightGreen,
                size: 70,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No Data Found"));
          } else {
            var plant = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plant Image
                    if (plant['default_image'] != null)
                      Image.network(
                        plant['default_image']['original_url'],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        height: 250,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Plant Details
                    Text(
                      "Common Name: ${plant['common_name'] ?? 'Unknown'}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Scientific Name: ${plant['scientific_name']?.join(", ") ?? 'N/A'}",
                      style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Type: ${plant['type'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Watering: ${plant['watering'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Growth Rate: ${plant['growth_rate'] ?? 'Unknown'}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 6),

                    if (plant['description'] != null)
                      Text(
                        "Description: ${plant['description']}",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
