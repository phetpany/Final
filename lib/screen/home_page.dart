// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, unused_field, prefer_final_fields

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/unity/app_search.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:getapi/admin/widget/widget_places_details.dart';
import 'package:getapi/admin/widget/widget_text.dart';
import 'package:getapi/screen/Mylocation_page.dart';
import 'package:getapi/screen/history_page.dart';
import 'package:getapi/screen/user_profile_page.dart';
import 'package:getapi/utills/category_places.dart'; // Ensure this path is correct
import 'package:getapi/utills/popular_places.dart'; // Ensure this path is correct
import 'package:getapi/utills/popular_places_list.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'places_info_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  int selectedIndex = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MylocationPage(),
    HistoryPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        
        title: WidgetText(data: 'LuangPrabang'),
        actions: [
          IconButton(
  icon: Icon(Icons.search),
  onPressed: () async {
    // Fetch places data from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('places').get();

    // Show search bar with custom delegate
    showSearch(context: context, delegate: PlacesSearch(places: snapshot.docs));
  },
),

          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AppService().processLogout();
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      //  homeScreen(controller: _controller),
      bottomNavigationBar: Container(
        decoration: ShapeDecoration(
          color: Colors.blue.shade500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
          child: GNav(
            tabBorderRadius: 25,
            color: Colors.white,
            activeColor: Colors.blue[900],
            tabBackgroundColor: Colors.blue.shade200,
            gap: 6,
            onTabChange: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            padding: EdgeInsets.all(10),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconSize: 25,
              ),
              GButton(
                icon: Icons.location_on,
                text: 'MyLocation',
                iconSize: 25,
              ),
              GButton(
                icon: Icons.ads_click_rounded,
                text: 'travel agency',
                iconSize: 25,
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                iconSize: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final _controller = PageController();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= _pageController.positions.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('advertise').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  var documents = snapshot.data!.docs;
                  return PageView.builder(
                    controller: _pageController,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: documents[index]['urlImage'],
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              width: 300,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 5),
            Expanded(
  flex: 2, // Make this section smaller
  child: FutureBuilder(
    future: FirebaseFirestore.instance.collection('group').get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      var documents = snapshot.data!.docs;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: documents.map((doc) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {

                    // Add navigation logic to category page
                    Get.to(() => PlacesData(
                                      groupId: doc.id,
                                      groupName: doc['nameGroup'],
                                    ));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40, // Adjust the radius as needed
                        backgroundImage: CachedNetworkImageProvider(
                          doc['urlImage'],
                        ),
                        onBackgroundImageError: (_, __) {
                          // Handle image loading error
                        },
                        child: doc['urlImage'] == null || doc['urlImage'].isEmpty
                            ? Icon(Icons.error) // Default icon if no image
                            : null,
                      ),
                      SizedBox(height: 5),
                      Text(doc['nameGroup']),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  ),
),

            SizedBox(height: 10),
            Expanded(
  flex: 3,
  child: FutureBuilder(
    future: FirebaseFirestore.instance.collection('places').get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      var documents = snapshot.data!.docs;
      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          var place = documents[index];
          String imageUrl = (documents[index]['urlImages'] is List)
              ? documents[index]['urlImages'][0]
              : documents[index]['urlImages'];
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margin
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceDetails(
                      name: place['name'],
                      description: place['description'],
                      imageUrls: List<String>.from(place['urlImages']),
                      googleMapsUrl: place['urlGoogleMap'],
                    ),
                  ),
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 100,
                  height: 100, // Adjust height to fit within ListTile
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                documents[index]['name'],
                style: TextStyle(fontSize: 16), // Adjust font size if needed
              ),
              subtitle: Text(
                documents[index]['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      );
    },
  ),
),

          ]
          
      ),
  
          
        )
    );
        
      
  }
}

