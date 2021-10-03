import 'package:flutter/material.dart';
import 'package:we_tech/home_page.dart';


class DrawerItem {
  String title;
  IconData icon;

  DrawerItem({
    required this.title,
    required this.icon,
  }) : assert(icon is IconData || icon is Widget,
            'TabItem only support IconData and Widget');
}

class ProfileDrawer extends StatefulWidget {
  final drawerItems = [
    DrawerItem(title: "Home", icon: Icons.home),

  ];

  @override
  State<StatefulWidget> createState() {
    return ProfileDrawerState();
  }
}

class ProfileDrawerState extends State<ProfileDrawer> {
  final bottomNavigationBarIndex = 0;
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomePage();

      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(
        MaterialPageRoute(builder: (context) => _getDrawerItemWidget(index)));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var item = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(
          item.icon,
          color: Colors.blue,
        ),
        title: Text(
          item.title,
          style: TextStyle(color: Colors.black),
        ),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    return Scaffold(
      backgroundColor: Colors.black,
     appBar: AppBar(),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              accountName: Text(
                "WE Tech",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              accountEmail: Text(
                "Master",
                style: TextStyle(color: Colors.white),
              ),
              //currentAccountPicture: Image.asset('assets/images/photo.png'),
            ),
            Column(children: drawerOptions),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          HomePage(),
                    ),
                        (route) => false,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Sign out ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(
                          Icons.cancel_presentation,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
