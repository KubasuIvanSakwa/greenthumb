import 'package:flutter/material.dart';
import 'package:greenthumb/pages/about_page.dart';
import 'package:greenthumb/pages/plant_disease_page.dart';
import 'package:greenthumb/pages/plants_page.dart';
import 'package:greenthumb/show_case_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false; // Track loading state
  List<Map<String, dynamic>> plants = []; // ✅ Define the plants list
  List<Map<String, dynamic>> diseases = []; // ✅ Define the plants list

  final GlobalKey _plant = GlobalKey();
  final GlobalKey _disease = GlobalKey();
  final GlobalKey _forum = GlobalKey();
  final GlobalKey _help = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context).startShowCase([_plant, _disease, _forum, _help])
    );
    super.initState();
  }


  Future<void> getPlants() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://perenual.com/api/v2/species-list?key=sk-PI1U67b47156cee1d8714'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print("Raw API Response: $data"); // ✅ Check full response

        if (data.containsKey("data") && data["data"] is List) {
          print("Fetched ${data["data"].length} plants"); // ✅ Print number of plants

          List<Map<String, dynamic>> parsedPlants = List<Map<String, dynamic>>.from(
            data["data"].map((plant) {
              if (plant is Map<String, dynamic>) {
                return plant;
              }
              return null;
            }).where((plant) => plant != null),
          );

          print("Final Parsed Plants: ${parsedPlants.length}"); // ✅ Check filtered list

          setState(() {
            plants = List<Map<String, dynamic>>.from(
              data["data"].where((plant) => plant != null),
            );
          });


          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantsPage(plants: plants), // ✅ Ensure `plants` is passed
            ),
          );

        } else {
          print("API response does not contain 'data' or it is not a list");
          setState(() => plants = []);
        }
      } else {
        print("HTTP Error: ${response.statusCode} - ${response.reasonPhrase}");
        setState(() => plants = []);
      }
    } catch (e) {
      print("Error fetching plants: $e");
      setState(() => plants = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchAndNavigate() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://perenual.com/api/pest-disease-list?key=sk-PI1U67b47156cee1d8714'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey("data") && data["data"] is List) {
          List<Map<String, dynamic>> diseases = List<Map<String, dynamic>>.from(
            data["data"].map((disease) => {
              "id": disease["id"],
              "common_name": disease["common_name"] ?? "Unknown",
              "scientific_name": disease["scientific_name"] ?? "N/A",
              "other_name": (disease["other_name"] is List)
                  ? disease["other_name"].join(", ")
                  : "N/A",
              "host": (disease["host"] is List)
                  ? disease["host"].join(", ")
                  : "Unknown Hosts",
              "description": disease["description"] ?? "No description available",
              "solution": disease["solution"] ?? "No solution provided",
              "images": (disease["images"] is List)
                  ? List<Map<String, dynamic>>.from(disease["images"])
                  : []
            }),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDiseasePage(diseases: diseases),
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching diseases: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ?
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.lightGreen,
                      size: 70,
                    ),
                  ],
                ),
              ),
            )// Show loader when fetching data
             : SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(height: 10), // Move the AppBar down
              PreferredSize(
              preferredSize: const Size.fromHeight(56), // Standard AppBar height
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 3, right: 5), // Adjust further if needed
                child: AppBar(
                  actions: [
                    ShowCaseView(
                      globalKey: _help,
                      title: "button",
                      desc: "about",
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            icon: Icon(Icons.help_outline, size: 30),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AboutPage()),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                  elevation: 0,
                ),
              ),
            ),
        
            Container(
              width: 350,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 330,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border(
                            top: BorderSide(color:
                              Colors.black.withOpacity(0.5),
                              width: 0.4
                            ),
                            bottom:BorderSide(
                                color:Colors.black.withOpacity(0.5),
                                width: 0.4
                            ),
                            left: BorderSide(
                                color:Colors.black.withOpacity(0.5),
                                width: 0.4
                            ),
                            right: BorderSide(
                                color:Colors.black.withOpacity(0.5),
                                width: 0.4
                            ),
                          )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ShowCaseView(
                                  globalKey: _plant,
                                  title: "button",
                                  desc: "discover plants",
                                  child: GestureDetector(
                                      onTap: () => getPlants(),
                                      child: Container(
                                        width: 140,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border(
                                              top: BorderSide(color:
                                              Colors.black.withOpacity(0.3),
                                                  width: 0.4
                                              ),
                                              bottom:BorderSide(
                                                  color:Colors.black.withOpacity(0.3),
                                                  width: 0.4
                                              ),
                                              left: BorderSide(
                                                  color:Colors.black.withOpacity(0.3),
                                                  width: 0.4
                                              ),
                                              right: BorderSide(
                                                  color:Colors.black.withOpacity(0.3),
                                                  width: 0.4
                                              ),
                                            )
                                        ),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Opacity(
                                              opacity: 0.9,
                                              child: Image.asset(
                                                'lib/images/plants.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ),

                                ShowCaseView(
                                  globalKey: _disease,
                                  title: "button",
                                  desc: "plants diseases",
                                  child: GestureDetector(
                                    onTap: () => fetchAndNavigate(),
                                    child: Container(
                                      width: 140,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border(
                                            top: BorderSide(color:
                                            Colors.black.withOpacity(0.3),
                                                width: 0.4
                                            ),
                                            bottom:BorderSide(
                                                color:Colors.black.withOpacity(0.3),
                                                width: 0.4
                                            ),
                                            left: BorderSide(
                                                color:Colors.black.withOpacity(0.3),
                                                width: 0.4
                                            ),
                                            right: BorderSide(
                                                color:Colors.black.withOpacity(0.3),
                                                width: 0.4
                                            ),
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Opacity(
                                            opacity: 0.9,
                                            child: Image.asset(
                                              'lib/images/plant_health.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ShowCaseView(
                                    globalKey: _forum,
                                    title: "button",
                                    desc: "join the community",
                                    child: Container(
                                      width: 140,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border(
                                            top: BorderSide(color:
                                            Colors.black.withOpacity(0.3),
                                                width: 0.4
                                            ),
                                            bottom:BorderSide(
                                                color:Colors.black.withOpacity(0.3),
                                                width: 0.4
                                            ),
                                            left: BorderSide(
                                                color:Colors.black.withOpacity(0.3),
                                                width: 0.4
                                            ),
                                            right: BorderSide(
                                                color:Colors.black.withOpacity(0.3),
                                                width: 0.4
                                            ),
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Opacity(
                                            opacity: 0.9,
                                            child: Image.asset(
                                              'lib/images/forum.png',
                                            ),
                                          ),
                                        ),
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // plants
                      // plant diseases
                      // community Forum
                    ],
                ),
              ),
            ),
        
            Container(
              width: 350,
              height: 320,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                'Latest from Forum',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                ),
                            ),
                          ],
                        ),
        
                        SizedBox(height: 10,),
        
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color:
                                Colors.black.withOpacity(0.3),
                                    width: 0.4
                                ),
                              )
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border(
                                      top: BorderSide(color:
                                      Colors.black.withOpacity(0.3),
                                          width: 0.4
                                      ),
                                      bottom:BorderSide(
                                          color:Colors.black.withOpacity(0.3),
                                          width: 0.4
                                      ),
                                      left: BorderSide(
                                          color:Colors.black.withOpacity(0.3),
                                          width: 0.4
                                      ),
                                      right: BorderSide(
                                          color:Colors.black.withOpacity(0.3),
                                          width: 0.4
                                      ),
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, color:Colors.red.withOpacity(0.6))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
        
        
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
