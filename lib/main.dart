import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/layout/drawer/drawer.dart';
import 'package:finance_tracker/layout/drawer/drawer_item.dart';
import 'package:finance_tracker/layout/nav_bar/nav_bar.dart';
import 'package:finance_tracker/layout/nav_bar/nav_bar_item.dart';
import 'package:finance_tracker/theme.dart';
import 'package:finance_tracker/utils/domain_layer/track_storage.dart';
import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:finance_tracker/views/accounts.dart';
import 'package:finance_tracker/views/add_view.dart';
import 'package:finance_tracker/views/charts.dart';
import 'package:finance_tracker/views/queries.dart';
import 'package:finance_tracker/views/settings.dart';
import 'package:finance_tracker/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

Future<void> main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  WidgetsFlutterBinding.ensureInitialized();
  // cache

  // Initialinzing Local storage
  final instance = await SharedPreferences.getInstance();
  final localStorage = TrackStorage(instance);
  final mode = PlatformDispatcher.instance.platformBrightness;

  SystemChrome.setSystemUIOverlayStyle(mode == Brightness.light
      ? SystemUiOverlayStyle.light.copyWith(
          statusBarColor: lightColorScheme.surface,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: lightColorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        )
      : SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: darkColorScheme.surface,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: darkColorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.light,
        ));
  print(json.decode('{"categories": [1, 2, 3, 4]}'));
  // Add localStorage Repo to provider
  runApp(RepositoryProvider.value(
    value: localStorage,
    child: BlocProvider(
      create: (_) => TrackCollectionBloc(localStorage),
      child: MultiBlocListener(
        listeners: [
          BlocListener<TrackCollectionBloc, TrackCollectionState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.data.length != current.data.length ||
                  previous.name != current.name,
              listener: (context, state) {
                print('After listening ${state.status}');
                if (state.status == TrackCreationStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar(context,
                      title: 'Error in listener', onPressed: () {}));
                }
              })
        ],
        child: const MyApp(),
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    context
        .read<TrackCollectionBloc>()
        .add(const TrackCollectionGetDataEvent());
    Timer.periodic(const Duration(minutes: 10), (_) {
      context
          .read<TrackCollectionBloc>()
          .add(const TrackCollectionPushDataEvent());
    });
    TextStyle textStyle(double fontSize, {String? fontFamily}) {
      FontWeight weight = FontWeight.w400;
      if (fontSize < 8) weight = FontWeight.w100;
      if (fontSize < 12) weight = FontWeight.w200;
      if (fontSize < 15) weight = FontWeight.w300;
      if (fontSize > 16) weight = FontWeight.w400;
      if (fontSize > 18) weight = FontWeight.w500;
      if (fontSize > 20) weight = FontWeight.w600;
      if (fontSize > 24) weight = FontWeight.w700;
      if (fontSize > 28) weight = FontWeight.w800;
      if (fontSize > 32) weight = FontWeight.w900;
      return TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontFamily: fontFamily ?? 'Poppins',
          fontWeight: weight);
    }

    return MaterialApp(
      title: 'Finance Tracker',
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: lightColorScheme,
        fontFamily: 'Poppins',
        inputDecorationTheme: InputDecorationTheme(
          hoverColor: Colors.red,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.black),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1.0, color: Theme.of(context).colorScheme.error),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.black),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: textStyle(24),
          titleMedium: textStyle(20),
          titleSmall: textStyle(12),
          headlineLarge: textStyle(28),
          headlineMedium: textStyle(24),
          headlineSmall: textStyle(20),
          bodyLarge: textStyle(16),
          bodyMedium: textStyle(12),
          bodySmall: textStyle(8),
          labelLarge: textStyle(18),
          labelMedium: textStyle(16),
          labelSmall: textStyle(12),
          displayLarge: textStyle(32),
          displayMedium: textStyle(24),
          displaySmall: textStyle(16),
        ),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            hoverColor: Colors.red,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.black),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 2.0, color: Theme.of(context).colorScheme.error),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.black),
            ),
          ),
          textTheme: TextTheme(
            titleLarge: textStyle(28),
            titleMedium: textStyle(24),
            titleSmall: textStyle(20),
            headlineLarge: textStyle(28),
            headlineMedium: textStyle(24),
            headlineSmall: textStyle(20),
            bodyLarge: textStyle(16),
            bodyMedium: textStyle(12),
            bodySmall: textStyle(8),
            labelLarge: textStyle(18),
            labelMedium: textStyle(16),
            labelSmall: textStyle(12),
            displayLarge: textStyle(32),
            displayMedium: textStyle(24),
            displaySmall: textStyle(16),
          ),
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Theme.of(context).colorScheme.surface,
              systemNavigationBarColor: Theme.of(context).colorScheme.surface,
              systemStatusBarContrastEnforced: true,
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          colorScheme: darkColorScheme,
          fontFamily: 'Poppins'),
      home: const AppContainer(),
    );
  }
}

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  bool isSelectedCategoryMenuOpen = false;
  bool dragEnded = true;
  bool dragStart = false;
  double dragNow = 0;
  double dragMin = 145;
  double dragMax = (145 + 340) - 85;

  late OverlayEntry entry;
  final List<String> categoriesNames = [
    'OverAll',
    'Personal',
    'Tuition',
    'Home',
    'Vacation',
    'Savings',
  ];
  String selectedCategory = '';

  double headerHeight = 145;
  int index = 0;
  List<Icon> navIcons = [
    Icon(
      MdiIcons.receiptText,
      size: 32,
    ),
    Icon(
      MdiIcons.walletBifold,
      size: 32,
    ),
    Icon(
      MdiIcons.chartDonut,
      size: 32,
    ),
    Icon(
      MdiIcons.cog,
      size: 32,
    )
  ];
  List<String> navTitle = ['Queries', 'Accounts', 'Charts', 'Settings'];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [
      ViewBootStrap(QueriesView()),
      ViewBootStrap(AccountsView()),
      ViewBootStrap(ChartsView()),
      ViewBootStrap(SettingsView()),
    ];
    List<Icon> sideIcons = [
      Icon(
        MdiIcons.viewGrid,
        size: 32,
      ),
      Icon(
        MdiIcons.formatListChecks,
        size: 32,
      ),
      const Icon(
        UniconsLine.transaction,
        size: 32,
      ),
    ];
    List<DrawerItem> sideItems = List.generate(sideIcons.length, (i) {
      return DrawerItem(icon: sideIcons[i], onTap: () {});
    });
    List<NavBarItem> items = List.generate(navIcons.length, (i) {
      return NavBarItem(
          label: navTitle[i], icon: navIcons[i], onPressed: () {});
    });
    return Scaffold(
        key: _key,
        drawerScrimColor: Colors.transparent,
        primary: true,
        endDrawer: Material(
          child: Ink(
            child: const Text('Hello'),
          ),
        ),
        drawer: NewDrawer(scaffoldKey: _key, items: sideItems),
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, headerHeight),
          child: SafeArea(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 2))),
              child: SizedBox(
                height: 85,
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              style: IconButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: () {
                                _key.currentState!.openDrawer();
                              },
                              icon: Icon(
                                MdiIcons.menu,
                                size: 36,
                                opticalSize: 32,
                              )),
                          Row(
                            children: [
                              const Text(''),
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    setState(() {
                                      isSelectedCategoryMenuOpen =
                                          !isSelectedCategoryMenuOpen;
                                    });
                                  },
                                  isSelected: isSelectedCategoryMenuOpen,
                                  visualDensity: VisualDensity.compact,
                                  highlightColor: Color.alphaBlend(
                                      Colors.white70, Colors.black),
                                  selectedIcon: Icon(
                                    MdiIcons.chevronUp,
                                    color: Colors.black,
                                    size: 24,
                                    opticalSize: 24,
                                  ),
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                    size: 24,
                                    opticalSize: 24,
                                  )),
                              const Text(
                                'Over All',
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                _key.currentState!.openEndDrawer();
                              },
                              icon: Icon(
                                MdiIcons.dotsVertical,
                                size: 32,
                                opticalSize: 32,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: views[index],

        //Center(child: DropMenu()),
        bottomNavigationBar: NavBar(
          items: items,
          onChange: (i) {
            print('Jump to $i');
            setState(() => index = i);
          },
          onActionPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const AddView()));
          },
        ));
  }
}
