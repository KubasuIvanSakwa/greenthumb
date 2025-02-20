import 'package:flutter/material.dart';
import 'disease_detail_page.dart';

class PlantDiseasePage extends StatefulWidget {
  final List<Map<String, dynamic>> diseases;
  const PlantDiseasePage({Key? key, required this.diseases}) : super(key: key);

  @override
  _PlantDiseasePageState createState() => _PlantDiseasePageState();
}

class _PlantDiseasePageState extends State<PlantDiseasePage> {
  List<Map<String, dynamic>> filteredDiseases = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDiseases = widget.diseases;
  }

  void filterDiseases(String query) {
    setState(() {
      filteredDiseases = widget.diseases
          .where((disease) =>
      disease["common_name"].toLowerCase().contains(query.toLowerCase()) ||
          disease["scientific_name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plant Diseases")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search Disease",
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: filterDiseases,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDiseases.length,
              itemBuilder: (context, index) {
                var disease = filteredDiseases[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: disease["images"].isNotEmpty
                        ? Image.network(
                      disease["images"][0]["thumbnail"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, color: Colors.red),
                    ) : Icon(Icons.image_not_supported),

                    title: Text(disease["common_name"]),
                    subtitle: Text(disease["scientific_name"]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiseaseDetailPage(disease: disease),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
