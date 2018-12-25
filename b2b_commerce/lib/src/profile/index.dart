import 'package:flutter/material.dart';

import './settings.dart';

class ProfileHomePage extends StatefulWidget {
  static const String ROUTE_SETTINGS = '/settings';

  @override
  _ProfileHomePageState createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> menus = <Widget>[
      Card(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('我的账户'),
                leading: const Icon(Icons.settings),
              ),
            ),
          ],
        ),
      ),
      Card(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('需求订单'),
                leading: const Icon(Icons.shopping_basket),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('销售订单'),
                leading: const Icon(Icons.shopping_basket),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('生产订单'),
                leading: const Icon(Icons.shopping_basket),
              ),
            ),
          ],
        ),
      ),
      Card(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('商品管理'),
                leading: const Icon(Icons.shopping_basket),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('库存管理'),
                leading: const Icon(Icons.shopping_basket),
              ),
            ),
          ],
        ),
      ),
      Card(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('认证信息'),
                leading: const Icon(Icons.settings),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('员工管理'),
                leading: const Icon(Icons.shopping_basket),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('会员管理'),
                leading: const Icon(Icons.shopping_basket),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('地址管理'),
                leading: const Icon(Icons.settings),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('发票管理'),
                leading: const Icon(Icons.settings),
              ),
            ),
          ],
        ),
      ),
      Card(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileSettingsPage()),
                );
              },
              child: ListTile(
                trailing: Icon(Icons.chevron_right),
                title: const Text('设置'),
                leading: const Icon(Icons.settings),
              ),
            ),
          ],
        ),
      )
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.create),
                tooltip: 'Edit',
                onPressed: () {
                  _scaffoldKey.currentState
                      .showSnackBar(const SnackBar(content: Text("Editing isn't supported in this screen.")));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('湛红波'),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    'temp/lake.jpg',
                    package: 'assets',
                    fit: BoxFit.cover,
                    height: _appBarHeight,
                  ),
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(menus),
          ),
        ],
      ),
    );
  }
}