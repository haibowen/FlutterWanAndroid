import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android_wan/utils/screen_adapter.dart';
import 'package:flutter_android_wan/utils/utils.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return SplashScreenState();
  }

}
class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context)=>MainScreen()),
          (route)=>route==null);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);

    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(48.0))
                  ),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.all(2.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(46.0)),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(Utils.getImgPath("ic_launcher_news")),
                      radius: 46.0,
                    ),
                  ),
                )
              ],
            ),

          )
        ],
      ),
    );
  }

}