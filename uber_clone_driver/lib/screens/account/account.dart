import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/account/screen_components/bottom_modal_sheet.dart' as sheet;
import 'package:uber_clone_driver/screens/account/screen_components/driver_info.dart';
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
  TextStyle bottomSheetStyle = TextStyle(
    fontSize: 19,
    color: Colors.black54
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
                    IconButton(
                       onPressed: () async{
                         await showModalBottomSheet(context: context,
                           backgroundColor: Colors.white,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.only(
                               topRight: Radius.circular(20),
                               topLeft: Radius.circular(20)
                             )
                           ),
                           builder: (context) => sheet.BottomSheet()

                         );
                       },
                        icon: Icon(Icons.edit ),
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
                              image: FileImage(Provider.of<ProfilePicturesProvider>(context).profilePicture!),
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
                  DriverInfo(shortDescription: 'Enjoys reading books and watching movies', from: 'Heppenheim,Germany',),
                  Divider(height: 40, color: Colors.grey, thickness: 1,),
                  Row(
                    children: [
                      Expanded(child: Text('Compliments and ratings', style: TextStyle(fontSize: 22),)),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Text('View all', style: TextStyle(color: Colors.blue[900], fontSize: 24),)
                      )
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
