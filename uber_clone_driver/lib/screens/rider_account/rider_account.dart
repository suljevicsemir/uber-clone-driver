import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/models/chat_info.dart';
import 'package:uber_clone_driver/models/rider/rider.dart';
import 'package:uber_clone_driver/providers/driver_data_provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/chat/chat.dart';
import 'package:uber_clone_driver/screens/rider_account/components/call_rider.dart';
import 'package:uber_clone_driver/screens/rider_account/components/sms_rider.dart';
import 'package:url_launcher/url_launcher.dart';

class RiderAccount extends StatefulWidget {
  static const String route = '/riderAccount';
  final Rider rider;

  RiderAccount({required this.rider});

  @override
  _RiderAccountState createState() => _RiderAccountState();
}

class _RiderAccountState extends State<RiderAccount> with TickerProviderStateMixin{

  double top = 0;

  late AnimationController clickedController;
  bool showContactTypes = true;
  double begin = 0.5, end = 1;


  @override
  void initState() {
    super.initState();
    clickedController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this
    );
  }

  void rotateIcon() {
    clickedController.reset();
    if(!showContactTypes) {
      setState(() {
        begin = 0;
        end = 0.5;
        showContactTypes = !showContactTypes;
      });
    }
    else {
      setState(() {
        begin = 0.5;
        end = 1;
        showContactTypes = !showContactTypes;
      });
    }
    clickedController.forward();
  }


  @override
  void dispose() {
    clickedController.dispose();
    super.dispose();
  }


  File? picture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance!.addPostFrameCallback((_) async{
      File x = await Provider.of<ProfilePicturesProvider>(context, listen: false).getRiderPicture(widget.rider.firebaseId);
      setState(() {
        picture = x;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    if( picture == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
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
                          icon: Icon(Icons.star_border),
                          onPressed: () {}
                      ),
                    ],
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        return  FlexibleSpaceBar(
                          centerTitle: false,
                          title: Text(widget.rider.firstName, style: TextStyle(color: Colors.white, fontSize: 22),),
                          background: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(picture!),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                        );
                      },
                    )
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  MaterialButton(
                    minWidth: 150,
                    height: 50,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    onPressed: () async => await launch("tel://" + widget.rider.phoneNumber),
                    child: Text('Phone call', style: TextStyle(color: Colors.white, fontSize: 16),),
                    splashColor: Colors.white,
                  ),
                  Spacer(),
                  MaterialButton(
                    minWidth: 150,
                    height: 50,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    onPressed: () async {
                      Map<String, dynamic> map = {};
                      map['driver'] = Provider.of<DriverDataProvider>(context, listen: false).driver;
                      map['rider'] = widget.rider;
                      await Navigator.pushNamed(context, Chat.route, arguments: map);
                    },
                    child: Text('Send message', style: TextStyle(color: Colors.white, fontSize: 16),),
                    splashColor: Colors.white,
                  ),
                  Spacer()
                ],
              ),
              SizedBox(height: 20,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: rotateIcon,
                  splashColor: Colors.grey,
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Text(widget.rider.phoneNumber, style: TextStyle(fontSize: 18),),
                        Spacer(),
                        RotationTransition(
                            turns: Tween<double>(begin: begin, end: end).animate(clickedController),
                            child: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black,)
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Divider(height: 30, color: Colors.grey, thickness: 0.5,)
              ),
              AnimatedSize(
                      vsync: this,
                      duration: const Duration(milliseconds: 200),
                      child: showContactTypes ?
                      Container(
                        child: Column(
                          children: [
                            SMSRider(phoneNumber: widget.rider.phoneNumber,),
                            CallRider(phoneNumber: widget.rider.phoneNumber,),
                            //ScheduleRide(),
                          ],
                        ),
                      ) : Container(),

                    ),
            ],
          ),
        ),
      ),
    );
  }
}
