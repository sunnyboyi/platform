import 'package:b2b_commerce/src/_shared/widgets/authorization_dector.dart';
import 'package:b2b_commerce/src/business/index.dart';
import 'package:b2b_commerce/src/common/app_provider.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/home/_shared/models/navigation_menu.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/bottom_navigation.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/notifications.dart';
import 'package:b2b_commerce/src/home/account/client_select.dart';
import 'package:b2b_commerce/src/home/index.dart';
import 'package:b2b_commerce/src/my/index.dart';
import 'package:b2b_commerce/src/my/messages/index.dart';
import 'package:b2b_commerce/src/observer/b2b_navigator_observer.dart';
import 'package:b2b_commerce/src/production/index.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_constants.dart';
import '../common/app_keys.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) => globalInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<UserBLoC>(
      bloc: UserBLoC.instance,
      child: StreamBuilder<UserModel>(
          initialData: UserBLoC.instance.currentUser,
          stream: UserBLoC.instance.stream,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            // 未登录
            if (snapshot.data.type == UserType.ANONYMOUS) {
              final botToastBuilder = BotToastInit(); //1.调用BotToastInit
              return MaterialApp(
                home: ClientSelectPage(),
                builder: (context, child) {
                  child = botToastBuilder(context, child);
                  return MaxScaleTextWidget(
                    max: 1.0,
                    child: child,
                  );
                },
              );
            }
            return MyAppHomeDelegate(
              userType: snapshot.data.type,
            );
          }),
    );
  }

  ///全局初始化
  void globalInit() {
    // //初始化helpers
    // Provider.of<CertificationStatusHelper>(context)
    //     .checkCertificationStatus(context);

    //友盟初始化
    initUMeng();

    // 预加载全局数据
    AppProvider().preloading(context);
  }

  ///友盟初始化
  initUMeng() {
    if (!GlobalConfigs.DEBUG) {
      TargetPlatform platform = defaultTargetPlatform;
      FlutterUmplus.init(
        platform == TargetPlatform.android
            ? GlobalConfigs.UMENG_APP_KEY_ANDROID
            : GlobalConfigs.UMENG_APP_KEY_IOS,
        reportCrash: false,
        logEnable: GlobalConfigs.DEBUG,
        encrypt: true,
      );
    }
  }

//监听异常消息,dialog
// void listenMessage() {
//   MessageBLoC.instance.errorMessageStream.listen((value) {
//     final appContext = _navigatorKey.currentState.overlay.context;
//     final dialog = AlertDialog(
//       content: Text('$value'),
//     );
//     try {
//       showDialog(context: appContext, builder: (x) => dialog);
//     } catch (e) {
//       print(e);
//     }
//   });
// }
}

class MyAppHomeDelegate extends StatefulWidget {
  MyAppHomeDelegate({
    Key key,
    @required this.userType,
  }) : super(key: key);

  final UserType userType;

  _MyAppHomeDelegateState createState() => _MyAppHomeDelegateState();
}

class _MyAppHomeDelegateState extends State<MyAppHomeDelegate> {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) => initListener());
    super.initState();
  }

  //初始化监听
  void initListener() {
    // listenMessage();
    listenLogin();
  }

  //监听未登录接口调用跳转登录页
  void listenLogin() {
    UserBLoC.instance.loginJumpStream.listen((value) {
      if (true) {
        if (NavigatorStack.instance.currentRouteName == AppRoutes.ROUTE_LOGIN) {
          return;
        } else {
          // //获取记录跳转登录页面的时间
          // DateTime loginPageLogTime = AppBLoC.instance.getLoginPageLogTime;
          // DateTime now = DateTime.now();

          // int diff = -1;
          // if (loginPageLogTime != null)
          //   diff = now.difference(loginPageLogTime).inMilliseconds;

          // print('$loginPageLogTime===>$now==>相差:$diff 毫秒');
          // print('HASH:${AppBLoC.instance.hashCode}');
          // if (loginPageLogTime == null || diff > 1000) {
          // AppBLoC.instance.setloginPageLogTime(now);
          Navigator.of(_navigatorKey.currentState.overlay.context)
              .pushNamedAndRemoveUntil(
              AppRoutes.ROUTE_LOGIN, ModalRoute.withName('/'));
          // }
        }
      }
    });
  }

  /// 处理底部导航
  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// 获取导航菜单
  List<NavigationMenu> _getNavigationMenus() {
    List<NavigationMenu> menus = <NavigationMenu>[
      NavigationMenu(
        BottomNavigationBarItem(
          icon: Container(
            child: const Icon(B2BIcons.home),
          ),
          activeIcon: Container(
            child: const Icon(B2BIcons.home_active),
          ),
          title: const Text('商机'),
        ),
        HomePage(userType: widget.userType),
      ),
      NavigationMenu(
          BottomNavigationBarItem(
            icon: Container(
              child: const Icon(B2BIcons.production),
            ),
            activeIcon: Container(
              child: const Icon(B2BIcons.production_active),
            ),
            title: Container(
              child: const Text('生产'),
            ),
          ),
          AuthorizationDector(
            authorizations: [Authorization.PURCHASE_ORDER],
            show: false,
            message: '无操作权限',
            child: ProductionPage(),
          )),
      NavigationMenu(
        BottomNavigationBarItem(
          icon: Container(
            child: BottomNotificationsIcon(),
          ),
          activeIcon: Container(
            child: BottomNotificationsActiveIcon(),
          ),
          title: Container(
            child: const Text('消息'),
          ),
        ),
        MessagePage(),
      ),
      NavigationMenu(
        BottomNavigationBarItem(
            icon: Container(
              child: const Icon(B2BIcons.business),
            ),
            activeIcon: Container(
              child: const Icon(B2BIcons.business_active),
            ),
            title: Container(
              child: const Text('工作'),
            )),
        BusinessHomePage(userType: widget.userType),
      ),
      NavigationMenu(
        BottomNavigationBarItem(
            icon: Container(
              child: const Icon(
                B2BIcons.my,
              ),
            ),
            activeIcon: Container(
              child: const Icon(
                B2BIcons.my_active,
              ),
            ),
            title: Container(
              child: const Text('我的'),
            )),
        MyHomePage(turnToHome: () {
          _handleNavigation(0);
        }),
      ),
    ];
    return menus;
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigationMenu> menus = _getNavigationMenus();
    final botToastBuilder = BotToastInit(); //1.调用BotToastInit

    return //1.使用BotToastInit直接包裹MaterialApp
        MaterialApp(
      navigatorKey: _navigatorKey,
      title: AppConstants.appTitle,
      navigatorObservers: [BotToastNavigatorObserver(), B2BNavigatorObserver()],
      //2.注册路由观察者
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color.fromRGBO(255, 214, 12, 1),
        bottomAppBarColor: Colors.grey,
      ),
      home: Builder(builder: (context) {
        AppVersionHelper appVersionHelper =
            Provider.of<AppVersionHelper>(context);
        //  appVersionHelper.getAppVersionInfo('nbyjy');
        appVersionHelper.checkVersion(
            context, AppBLoC.instance.packageInfo.version, 'nbyjy');

        return Scaffold(
          key: AppKeys.appPage,
          body: menus[_currentIndex].page,
          bottomNavigationBar: BottomNavigation(
            currentIndex: _currentIndex,
            onChanged: _handleNavigation,
            items: menus.map((menu) => menu.item).toList(),
          ),
        );
      }),
      routes: AppRoutes.allRoutes,
      onUnknownRoute: (RouteSettings settings) {
        print(settings.name);
      },
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate
      ],
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return MaxScaleTextWidget(
          max: 1.0,
          child: child,
        );
      },
      supportedLocales: AppConstants.supportedLocales(),
    );
  }
}

class MaxScaleTextWidget extends StatelessWidget {
  final double max;
  final Widget child;

  const MaxScaleTextWidget({
    Key key,
    this.max = 1.0,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(
          textScaleFactor:
              max > data.textScaleFactor ? data.textScaleFactor : max),
      child: child,
    );
  }
}
