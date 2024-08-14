import 'package:finance_tracker/components/filter_tracks.dart';
import 'package:finance_tracker/components/searchbar.dart';
import 'package:finance_tracker/utils/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:json_theme/json_theme.dart';
import 'dart:convert';
import 'dart:io';

import 'package:finance_tracker/views/modal_form.dart';
import 'package:finance_tracker/views/income_view.dart';
import 'package:finance_tracker/views/expense_view.dart';
import 'package:finance_tracker/views/view.dart';

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

  WidgetsFlutterBinding.ensureInitialized();
  final darkThemeSrc = await rootBundle.loadString('assets/dark_theme.json');
  final themeSrc = await rootBundle.loadString('assets/light_theme.json');

  final darkThemeJson = jsonDecode(darkThemeSrc);
  final themeJson = jsonDecode(themeSrc);

  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme, darkTheme: darkTheme));
}

Map<String, dynamic> store = {};

class MyApp extends StatelessWidget {
  final ThemeData theme;
  final ThemeData darkTheme;
  const MyApp({super.key, required this.theme, required this.darkTheme});
  @override
  Widget build(BuildContext context) {
    store['category'] = TrackCategory.values;
    return MaterialApp(
      title: 'Finance Tracker',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const AppContainer(title: 'Finance Tracker'),
    );
  }
}

class AppContainer extends StatefulWidget {
  const AppContainer({super.key, required this.title});
  final String title;

  @override
  State<AppContainer> createState() => _AppContainerState();
}

List<TrackData> data = List.generate(10, (i) {
  i++;
  TrackData data = TrackData(
      name: 'Income $i',
      value: 123,
      type: random.nextInt(2) == 1 ? TrackType.income : TrackType.expense,
      category: rand(),
      description: '''
            This is a test description and i use it to develope the Ui i designed to put it on my portfolio
            ''');
  return data;
});
List<TrackData> incomeData = [];
List<TrackData> expenseData = [];

List<TrackData> getData(e) {
  if (e == TrackType.income) {
    return incomeData;
  }
  return expenseData;
}

class _AppContainerState extends State<AppContainer> {
  var index = 0;
  @override
  void initState() {
    super.initState();
  }
  // TODO: Add Tags to tracks
  // By adding a checkbox for adding tags in "New Track Modal"
  // - add an ability to add a tags and groups and collections
  // - add an ability to add custom filters to user's prefrenced
  // - add a comment for expense or income
  // - add a level of importance (Importance Rate) in modal and add an ability to just ignore it
  // - Monthly log & Weekly log for expenses and incomes
  // - suggest what to expenses to avoid by "Importance Rate"

  List<IconButton> items(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
          (Set<WidgetState> states) {
        return const EdgeInsets.symmetric(vertical: 8, horizontal: 24);
      }),
    );
    return [
      IconButton(
        isSelected: index == 0 ? true : false,
        onPressed: () {
          setState(() {
            index = 0;
            control.animateToPage(0,
                duration: Durations.medium2, curve: Curves.linearToEaseOut);
          });
        },
        style: buttonStyle,
        tooltip: 'Incomes',
        enableFeedback: true,
        iconSize: 28,
        focusColor: Colors.red,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        selectedIcon: Icon(
          MdiIcons.walletBifold,
        ),
        icon: Icon(
          MdiIcons.walletBifoldOutline,
        ),
      ),
      IconButton(
        isSelected: index == 1 ? true : false,
        onPressed: () {
          setState(() {
            index = 1;
            control.animateToPage(1,
                duration: Durations.medium2, curve: Curves.linearToEaseOut);
          });
        },
        tooltip: 'Expenses',
        enableFeedback: true,
        iconSize: 28,
        focusColor: Colors.red,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        style: buttonStyle,
        selectedIcon: Icon(
          MdiIcons.creditCard,
        ),
        icon: Icon(
          MdiIcons.creditCardOutline,
        ),
      ),
    ];
  }

  PageController control =
      PageController(keepPage: true, initialPage: 0, viewportFraction: 0.9999);
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    double navigationSideMargin = screen.width * 0.05;
    double navigationBottomMargin = navigationSideMargin * 0.5;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(screen.width, 56 + 12 + 24 + 32),
          child: const Column(
            children: [
              SearchBarWidget(),
              FilterTracks(),
            ],
          )),
      body: PageView(
        controller: control,
        pageSnapping: true,
        onPageChanged: (i) {
          setState(() {
            index = i;
          });
        },
        children: [
          ViewBootStrap(IncomeView(getData(TrackType.income))),
          const ViewBootStrap(ExpenseView())
        ],
      ),
      bottomNavigationBar: SafeArea(
          key: const Key('Navigation Safe Area'),
          child: Container(
              margin: EdgeInsets.fromLTRB(navigationSideMargin, 0,
                  navigationSideMargin, navigationBottomMargin),
              key: const Key('Navigation Container'),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              transformAlignment: Alignment.center,
              width: screen.width,
              height: 64.0,
              child: SizedBox(
                  key: const Key('Navigation Sized Box'),
                  width: screen.width - (screen.width * 0.1),
                  height: 64.0,
                  child: DecoratedBox(
                      key: const Key('Navigation Decorated Box'),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: items(context),
                      ))))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ModalForm(),
                fullscreenDialog: true,
                allowSnapshotting: true,
                maintainState: true,
              ));
        },
        elevation: 5,
        enableFeedback: true,
        tooltip: 'Add Expense',
        child: Icon(Icons.add,
            color: Theme.of(context).colorScheme.onTertiaryContainer),
      ),
    );
  }
}
