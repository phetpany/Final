// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'package:getapi/utills/History_places.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../utills/popular_places_list.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({ Key? key }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

 class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
                Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("History",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(children: [
                          HistoryPlaces(imgProvider: AssetImage("assets/images/image1.png"), textSubtitle: "You know I want you It's not a secret I try to hide I know you want me So don't keep sayin' our hands are tied You claim it's not in the cards And fate is pullin' you miles away And out of reach from me But you're here in my heart So who can stop me if I decide That you're my destiny? What if we rewrite the stars? Say you were made to be mine Nothing could keep us apart You'd be the one I was meant to find It's up to you, and it's up to me No one can say what we get to be So why don't we rewrite the stars? Maybe the world could be ours Tonight You think it's easy You think I don't wanna run to you But there are mountains And there are doors that we can't walk through I know you're wondering why because we're able to be Just you and me within these walls But when we go outside, you're gonna wake up and see That it was hopeless after all No one can rewrite the stars How can you say you'll be mine? Everything keeps us apart And I'm not the one you were meant to find It's not up to you It's not up to me When everyone tells us what we can be How can we rewrite the stars? Say that the world can be ours Tonight All I want is to fly with you All I want is to fall with you So just give me all of you It feels impossible It's not impossible Is it impossible? Say that it's possible How do we rewrite the stars? Say you were made to be mine? Nothing can keep us apart 'Cause you are the one I was meant to find It's up to you And it's up to me No one can say what we get to be And why don't we rewrite the stars? Changing the world to be ours You know I want you It's not a secret I try to hide But I can't have you We're bound to break and my hands are tied", textTitle: "Wat XeingThong", textOpenhour: "10AM-9PM",), 
                    HistoryPlaces(imgProvider: AssetImage("assets/images/image2.png"), textSubtitle: "Oral traditions tell that Vat Aham was built near the site chosen by Fa Ngum, founder of the Kingdom of Lane Xang. The site was selected for the erection of an altar dedicated to the town’s deities, Pou Gneu Gna Gneu.", textTitle: "Wat Aham",textOpenhour: "5:00PM-22:00PM",),
                    HistoryPlaces(imgProvider: AssetImage("assets/images/image2.png"), textSubtitle: "Oral traditions tell that Vat Aham was built near the site chosen by Fa Ngum, founder of the Kingdom of Lane Xang. The site was selected for the erection of an altar dedicated to the town’s deities, Pou Gneu Gna Gneu.", textTitle: "Wat Aham",textOpenhour: "8AM-6PM",),
                     HistoryPlaces(imgProvider: AssetImage("assets/images/image2.png"), textSubtitle: "Oral traditions tell that Vat Aham was built near the site chosen by Fa Ngum, founder of the Kingdom of Lane Xang. The site was selected for the erection of an altar dedicated to the town’s deities, Pou Gneu Gna Gneu.", textTitle: "Wat Aham",textOpenhour: "7:30AM-20:00PM",),
                     HistoryPlaces(imgProvider: AssetImage("assets/images/image2.png"), textSubtitle: "Oral traditions tell that Vat Aham was built near the site chosen by Fa Ngum, founder of the Kingdom of Lane Xang. The site was selected for the erection of an altar dedicated to the town’s deities, Pou Gneu Gna Gneu.", textTitle: "Wat Aham",textOpenhour: "7:30AM-20:00PM",),
                     HistoryPlaces(imgProvider: AssetImage("assets/images/image2.png"), textSubtitle: "Oral traditions tell that Vat Aham was built near the site chosen by Fa Ngum, founder of the Kingdom of Lane Xang. The site was selected for the erection of an altar dedicated to the town’s deities, Pou Gneu Gna Gneu.", textTitle: "Wat Aham",textOpenhour: "7:30AM-20:00PM",),
                     HistoryPlaces(imgProvider: AssetImage("assets/images/image2.png"), textSubtitle: "Oral traditions tell that Vat Aham was built near the site chosen by Fa Ngum, founder of the Kingdom of Lane Xang. The site was selected for the erection of an altar dedicated to the town’s deities, Pou Gneu Gna Gneu.", textTitle: "Wat Aham",textOpenhour: "7:30AM-20:00PM",),
                    HistoryPlaces(imgProvider: AssetImage("assets/images/image2.png"), textSubtitle: "Oral traditions tell that Vat Aham was built near the site chosen by Fa Ngum, founder of the Kingdom of Lane Xang. The site was selected for the erection of an altar dedicated to the town’s deities, Pou Gneu Gna Gneu.", textTitle: "Wat Aham",textOpenhour: "7:30AM-20:00PM",),
                        ],)
                      ],
                    
                    
                    ),
                  ),
                  
          
                ],
                
                ),
                

        ),
        
      ),
      
     
    );
  }
}