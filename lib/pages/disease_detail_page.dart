import 'package:flutter/material.dart';

class DiseaseDetailPage extends StatelessWidget {
  final Map<String, dynamic> disease;

  const DiseaseDetailPage({Key? key, required this.disease}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract and ensure description is a List
    final descriptionList = disease["description"];
    final solutionList = disease["solution"];

    List<Map<String, dynamic>> descriptions = [];

    if (descriptionList is List) {
      descriptions = List<Map<String, dynamic>>.from(descriptionList);
    }

    List<Map<String, dynamic>> solutions = [];

    if (solutionList is List) {
      solutions = List<Map<String, dynamic>>.from(solutionList);
    }



    return Scaffold(
      appBar: AppBar(title: Text(disease["common_name"])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              disease["common_name"],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Scientific Name: ${disease["scientific_name"]}",
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 6),
            Text(
              "Other Names: ${disease["other_name"]}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "Hosts: ${disease["host"]}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Display images
            if (disease["images"].isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: disease["images"].length,
                  itemBuilder: (context, imgIndex) {
                    var image = disease["images"][imgIndex];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image["regular_url"],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 200,
                            height: 200,
                            color: Colors.grey.shade300,
                            child: Icon(Icons.image_not_supported, size: 50, color: Colors.red),
                          ),
                        ),

                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
              ),

            const SizedBox(height: 10),
            ...descriptions.map((desc) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      desc["subtitle"] ?? "No Subtitle",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      desc["description"] ?? "No Description Available",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: 20,),

            Center(child: Text('Solutions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),)),

            SizedBox(height: 20,),


            ...solutions.map((desc) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      desc["subtitle"] ?? "No Subtitle",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      desc["description"] ?? "No Description Available",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
