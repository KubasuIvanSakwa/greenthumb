import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About This App"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🌱 Plant Disease Identifier & Community",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "This app helps users identify plant diseases using images and descriptions. "
                  "It also provides plant details, growth guides, and a community forum where users can share knowledge.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Features Section
            Text(
              "🔹 Features:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            BulletPoint(text: "🔍 Search for plant diseases by name"),
            BulletPoint(text: "📸 View multiple images for each disease"),
            BulletPoint(text: "💡 Get treatment solutions and plant care tips"),
            BulletPoint(text: "🌿 Access plant details and growth instructions"),
            BulletPoint(text: "💬 Join the community forum to discuss plant health"),

            SizedBox(height: 20),

            // Community Forum Section
            Row(
              children: [
                Container(
                  width: 40,
                  child: Image.asset(
                    'lib/images/forum.png',
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  "Community Forum",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              "Connect with other plant enthusiasts! Share your gardening experiences, ask questions, "
                  "and get advice from experts and fellow plant lovers in the community forum.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Plant Growth Section
            Row(
              children: [
                Container(
                  width: 40,
                  child: Image.asset(
                    'lib/images/plants.png',
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  "Plant Details & Growth Guide",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ]
            ),
            SizedBox(height: 5),
            Text(
              "Learn about different plant species, their growth conditions, watering schedules, "
                  "and the best ways to keep them healthy and disease-free.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 30),

            // Developer Info
            Text(
              "👨‍💻 Developed by Kubasu Ivan Sakwa",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
