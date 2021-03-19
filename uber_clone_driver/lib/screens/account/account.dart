import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/account/screen_components/trips_years.dart';

class Account extends StatefulWidget {

  static const String route = '/account';

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  final Color grey = const Color(0xff8f8f95);

  List<String> languages = [
    'English',
    'Italian',
    'German'
  ];

  double top = 0.0;

  final TextStyle greyText = TextStyle(
    fontSize: 18,
    color: const Color(0xff8f8f95),
  );

  final TextStyle boldText = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 16
  );

  Timestamp timestamp = Timestamp.fromDate(DateTime.utc(2007, DateTime.february, 10));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          print(isScrolled.toString());
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Colors.white
                  ),
                  brightness: Brightness.dark,
                  elevation: 0.0,
                  expandedHeight: MediaQuery.of(context).size.height * 0.45,
                  pinned: true,
                  actions: [
                    ClipOval(
                      child: Material(
                        color: Colors.black, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // inkwell color
                          child: SizedBox(width: 56, height: 56, child: Icon(Icons.edit, color: Colors.white,)),
                          onTap: () {},
                        ),
                      ),
                    )
                  ],
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      top = constraints.biggest.height;
                      return FlexibleSpaceBar(
                        centerTitle: false,
                        title: Container(
                            decoration: (constraints.biggest.height == MediaQuery.of(context).padding.top + kToolbarHeight) ?
                            null : BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),
                            child: Text('Sebastian', style: TextStyle(color: Colors.white, fontSize: 22),)),
                        background: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(Provider.of<ProfilePicturesProvider>(context, listen: false).profilePicture!),
                              fit: BoxFit.cover
                            )
                          ),
                        )
                      );
                    },
                  ),
                ),
              ),
            )
          ];
        },



        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 15),

            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TripsAndStart(numberOfTrips: 3104, dateOfStart: timestamp,),

                  Container(
                   margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Spacer(),
                        // rating
                        /*

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 2)
                                )
                              ],
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.green[900],),
                              SizedBox(width: 10,),
                              Text('4.9', style: TextStyle(fontSize: 24, color: Colors.grey),),
                            ],
                          ),
                        ),
                         */
                        Spacer(),
                      ],
                    ),
                  ),

                  SizedBox(height: 15,),
                  Text('Enjoys reading books and watching movies', style: greyText),
                  SizedBox(height: 10,),
                  RichText(
                    text: TextSpan(
                        text: 'Knows ',
                        style: greyText,
                        children: [
                          TextSpan(
                              text: 'English',
                              style: boldText
                          ),
                          TextSpan(
                              text: ' Italian',
                              style: boldText
                          ),
                          TextSpan(
                              text: ' German',
                              style: boldText
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 10,),
                  RichText(
                    text: TextSpan(
                        text: 'From ',
                        style: greyText,
                        children: [
                          TextSpan(
                              text: 'Heppenheim, ',
                              style: boldText
                          ),
                          TextSpan(
                              text: 'Germany',
                              style: boldText
                          ),
                        ]
                    ),
                  ),

                  Divider(height: 40, color: Colors.grey, thickness: 3,),
                  Row(
                    children: [
                      Expanded(child: Text('Compliments', style: TextStyle(fontSize: 26),)),
                      Text('View all', style: TextStyle(color: Colors.blue[900], fontSize: 24),)
                    ],
                  )
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
}