import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyTest());
}

class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "app 主题测试",
      home: Scaffold(
        appBar: AppBar(
          title: Text("app主题测试"),
        ),
        body: Center(),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.print),
                  title: Text("页面一")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  title: Text("页面2")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.remove),
                  title: Text("页面3")
              )
            ]),

      ),

    );
  }

}
