import 'package:b2b_commerce/src/business/index.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/index.dart';
import 'package:b2b_commerce/src/my/index.dart';
import 'package:b2b_commerce/src/production/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class BrandClient extends StatefulWidget {
  BrandClient({Key key}) : super(key: key);

    final List<Widget> modules = <Widget>[
    HomePage(),
    ProductionPage(),
    BusinessHomePage(),
    MyHomePage(),
  ];

  _BrandClientState createState() => _BrandClientState();
}

class _BrandClientState extends State<BrandClient> {
  int _currentIndex = 0;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '衣加衣供应链',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        textSelectionColor: Colors.black,
        accentColor: Colors.orangeAccent[400],
        bottomAppBarColor: Colors.grey,
      ),
      home: Builder(
        builder: (context) => Scaffold(
              key: const Key('__appPage__'),
              body: widget.modules[_currentIndex],
              bottomNavigationBar: BottomNavigation(
                currentIndex: _currentIndex,
                onChanged: _handleNavigation,
              ),
              floatingActionButton: FloatingActionButton(
                elevation: 0,
                tooltip: '发布需求',
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequirementOrderFrom(),
                    ),
                  );
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
      ),
      routes: AppRoutes.allRoutes,
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
    );
  }
}


class BottomNavigation extends StatelessWidget {
  BottomNavigation({Key key, this.currentIndex: 0, @required this.onChanged})
      : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onChanged;

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: const Icon(B2BIcons.home),
      title: const Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(B2BIcons.production),
      title: const Text('生产'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(B2BIcons.business),
      title: const Text('生意'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(B2BIcons.my),
      title: const Text('我的'),
    )
  ];

  void _handleTap(int index) {
    onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _handleTap,
      fixedColor: themeData.accentColor,
    );
  }
}