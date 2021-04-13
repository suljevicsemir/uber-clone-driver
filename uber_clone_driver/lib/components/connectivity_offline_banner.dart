

import 'package:flutter/material.dart';

class ConnectivityOfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 5,
            width: 3,
            color: Colors.red,
          ),
          SizedBox(width: 1,),
          Container(
            color: const Color(0xff23272A),
            child: SizedBox(
              height: 8,
              width: 3,
            ),
          ),
          SizedBox(width: 1,),
          Container(
            color: const Color(0xff23272A),
            child: SizedBox(
              height: 11,
              width: 3,
            ),
          ),
          SizedBox(width: 10,),
          Text('Network connectivity limited or unavailable.')
        ],
      ),
    );
  }
}
