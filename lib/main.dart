import 'dart:async';
import 'dart:ui';

import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/components/filter_tracks.dart';
import 'package:finance_tracker/components/overlay_menu.dart';
import 'package:finance_tracker/components/searchbar.dart';
import 'package:finance_tracker/theme.dart';
import 'package:finance_tracker/utils/domain_layer/track_storage.dart';
import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:json_theme/json_theme.dart';
import 'dart:convert';
import 'dart:io';

import 'package:finance_tracker/views/modal_form.dart';
import 'package:finance_tracker/views/income_view.dart';
import 'package:finance_tracker/views/expense_view.dart';
import 'package:finance_tracker/views/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

Future<void> main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

  WidgetsFlutterBinding.ensureInitialized();
  // Initialinzing Local storage
  final localStorage = TrackStorage(await SharedPreferences.getInstance());

  // Initializing theme from JSON
  final darkThemeSrc = await rootBundle.loadString('assets/dark_theme.json');
  final themeSrc = await rootBundle.loadString('assets/light_theme.json');

  final darkThemeJson = jsonDecode(darkThemeSrc);
  final themeJson = jsonDecode(themeSrc);

  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
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
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(colorScheme: lightColorScheme, fontFamily: 'Poppins'),
      darkTheme: ThemeData(colorScheme: darkColorScheme, fontFamily: 'Poppins'),
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

  final List<String> categoriesNames = [
    'OverAll',
    'Personal',
    'Tuition',
    'Home',
    'Vacation',
    'Savings',
  ];
  String selectedCategory = '';
  late OverlayEntry overlayEntry;
  @override
  void initState() {
    super.initState();
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,
        left: 0,
        child: Material(
          child: AnimatedContainer(
            duration: Durations.medium2,
            curve: Curves.easeIn,
            width: MediaQuery.of(context).size.width,
            height:
                isSelectedCategoryMenuOpen ? 52.0 * categoriesNames.length : 0,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: const Border(
                    bottom: BorderSide(width: 2, color: Colors.black)),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
            child: AnimatedList(
                initialItemCount: categoriesNames.length,
                itemBuilder: (context, i, a) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ListTile(
                        style: ListTileStyle.list,
                        hoverColor: Color.alphaBlend(Colors.black12,
                            Theme.of(context).colorScheme.surface),
                        splashColor: Color.alphaBlend(Colors.black26,
                            Theme.of(context).colorScheme.surface),
                        dense: true,
                        title: Text(categoriesNames[i],
                            style: const TextStyle(
                                fontFamily: 'Quicksand', fontSize: 24)),
                        onTap: () => {
                              setState(() {
                                selectedCategory = categoriesNames[i];
                                overlayEntry.remove();
                              })
                            }),
                  );
                }),
          ),
        ),
      ),
    );
  }

  void showOverlay(BuildContext context) {
    Overlay.of(context).insert(overlayEntry);
  }

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
    const Icon(
      UniconsSolid.chart_pie,
      size: 32,
    ),
    Icon(
      MdiIcons.cog,
      size: 32,
    )
  ];
  List<String> navTitle = ['Queries', 'Accounts', 'Charts', 'Settings'];

  @override
  Widget build(BuildContext context) {
    const offset = Offset(0, 60);
    double navRowWidth = (MediaQuery.of(context).size.width - 90) / 2;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 145),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 85,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              MdiIcons.menu,
                              size: 36,
                              opticalSize: 32,
                            )),
                        Row(
                          children: [
                            const Text(''),
                            // DropdownMenu(
                            //     menuStyle: const MenuStyle()
                            //     ,
                            //
                            //     dropdownMenuEntries:
                            //         List.generate(categoriesNames.length, (i) {
                            //       return DropdownMenuEntry(
                            //           value: categoriesNames[i],
                            //           label: categoriesNames[i]);
                            //     })),
                            // DropdownButton(
                            //     value: 'OverAll',

                            //     items: List.generate(categoriesNames.length, (i) {
                            //       return DropdownMenuItem(
                            //           value: categoriesNames[i],
                            //           child: Text(categoriesNames[i]));
                            //     }),
                            //     onChanged: (i) {})
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  setState(() => isSelectedCategoryMenuOpen =
                                      !isSelectedCategoryMenuOpen);
                                  setState(() {
                                    Navigator.of(context).push(DialogRoute(
                                        context: context,
                                        anchorPoint: const Offset(0, 60),
                                        builder: (context) => Container(
                                              color: Colors.greenAccent,
                                              child: Material(
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                type: MaterialType.transparency,
                                                borderOnForeground: true,
                                                child: Container(
                                                    child: Text('Hello')),
                                              ),
                                            )));
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
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              MdiIcons.dotsVertical,
                              size: 32,
                              opticalSize: 32,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 60,
                  alignment: AlignmentDirectional.center,
                  constraints:
                      const BoxConstraints(minWidth: 120, maxWidth: 140),
                  decoration: BoxDecoration(
                      border: Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside, width: 2),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      )),
                  child: Container(
                    height: 60,
                    alignment: AlignmentDirectional.center,
                    constraints:
                        const BoxConstraints(minWidth: 120, maxWidth: 140),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: [
                              Theme.of(context).colorScheme.surface,
                              Theme.of(context).colorScheme.secondaryContainer,
                            ]),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).colorScheme.surface,
                              blurRadius: 0,
                              offset: const Offset(0, -2))
                        ]),
                    child: Text(
                      "\$99,999",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 116,
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 85,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border:
                      Border(top: BorderSide(color: Colors.black, width: 2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: navRowWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(2, (i) {
                            return Column(
                              children: [
                                IconButton(
                                  style: ButtonStyle(iconColor:
                                      WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer;
                                    }
                                    return Colors.black;
                                  })),
                                  isSelected: index == i,
                                  onPressed: () {
                                    setState(() {
                                      index = i;
                                    });
                                  },
                                  icon: navIcons[i],
                                ),
                                AnimatedSize(
                                    duration: Durations.medium2,
                                    child: Container(
                                      height: index == i ? 20 : 0,
                                      child: Text(navTitle[i]),
                                    ))
                              ],
                            );
                          }),
                        )),
                    SizedBox(
                        width: navRowWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(2, (i) {
                            return Column(
                              children: [
                                IconButton(
                                  style: ButtonStyle(iconColor:
                                      WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer;
                                    }
                                    return Colors.black;
                                  })),
                                  isSelected: index == i + 2,
                                  onPressed: () {
                                    setState(() {
                                      index = i + 2;
                                    });
                                  },
                                  icon: navIcons[i + 2],
                                ),
                                Text(navTitle[i + 2])
                              ],
                            );
                          }),
                        ))
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: (MediaQuery.of(context).size.width / 2) - 32,
                child: Transform.rotate(
                  angle: 0.785398,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(color: Colors.black, width: 2)),
                    child: IconButton(
                        style: ButtonStyle(
                          fixedSize: const WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                        ),
                        onPressed: () {},
                        icon: Transform.rotate(
                            angle: 0.785398, child: Icon(MdiIcons.plus))),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// class AppContainer extends StatefulWidget {
//   const AppContainer({super.key, required this.title});
//   final String title;
//
//   @override
//   State<AppContainer> createState() => _AppContainerState();
// }
//
// List<TrackState> incomeData = [];
// List<TrackState> expenseData = [];
//
// List<TrackState> getData(e) {
//   if (e == TrackType.income) {
//     return incomeData;
//   }
//   return expenseData;
// }
//
// class _AppContainerState extends State<AppContainer> {
//   var index = 0;
//   @override
//   void initState() {
//     super.initState();
//   }
//   // TODO: Add Tags to tracks
//   // By adding a checkbox for adding tags in "New Track Modal"
//   // - add an ability to add a tags and groups and collections
//   // - add an ability to add custom filters to user's prefrenced
//   // - add a comment for expense or income
//   // - add a level of importance (Importance Rate) in modal and add an ability to just ignore it
//   // - Monthly log & Weekly log for expenses and incomes
//   // - suggest what to expenses to avoid by "Importance Rate"
//
//   List<IconButton> items(BuildContext context) {
//     ButtonStyle buttonStyle = ButtonStyle(
//       padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
//           (Set<WidgetState> states) {
//         return const EdgeInsets.symmetric(vertical: 8, horizontal: 24);
//       }),
//     );
//     return [
//       IconButton(
//         isSelected: index == 0 ? true : false,
//         onPressed: () {
//           setState(() {
//             index = 0;
//             control.animateToPage(0,
//                 duration: Durations.medium2, curve: Curves.linearToEaseOut);
//           });
//         },
//         style: buttonStyle,
//         tooltip: 'Incomes',
//         enableFeedback: true,
//         iconSize: 28,
//         focusColor: Colors.red,
//         color: Theme.of(context).colorScheme.onSecondaryContainer,
//         selectedIcon: Icon(
//           MdiIcons.walletBifold,
//         ),
//         icon: Icon(
//           MdiIcons.walletBifoldOutline,
//         ),
//       ),
//       IconButton(
//         isSelected: index == 1 ? true : false,
//         onPressed: () {
//           setState(() {
//             index = 1;
//             control.animateToPage(1,
//                 duration: Durations.medium2, curve: Curves.linearToEaseOut);
//           });
//         },
//         tooltip: 'Expenses',
//         enableFeedback: true,
//         iconSize: 28,
//         focusColor: Colors.red,
//         color: Theme.of(context).colorScheme.onSecondaryContainer,
//         style: buttonStyle,
//         selectedIcon: Icon(
//           MdiIcons.creditCard,
//         ),
//         icon: Icon(
//           MdiIcons.creditCardOutline,
//         ),
//       ),
//     ];
//   }
//
//   PageController control =
//       PageController(keepPage: true, initialPage: 0, viewportFraction: 0.9999);
//   @override
//   Widget build(BuildContext context) {
//     Size screen = MediaQuery.sizeOf(context);
//     double navigationSideMargin = screen.width * 0.05;
//     double navigationBottomMargin = navigationSideMargin * 0.5;
//     return BlocProvider(
//       create: (context) => BlocProvider.of<TrackCollectionBloc>(context),
//       child: Scaffold(
//         appBar: PreferredSize(
//             preferredSize: Size(screen.width, 56 + 12 + 24 + 32),
//             child: const Column(
//               children: [
//                 SearchBarWidget(),
//                 FilterTracks(),
//               ],
//             )),
//         body: PageView(
//           controller: control,
//           pageSnapping: true,
//           onPageChanged: (i) {
//             setState(() {
//               index = i;
//             });
//           },
//           children: const [
//             ViewBootStrap(IncomeView()),
//             ViewBootStrap(ExpenseView())
//           ],
//         ),
//         bottomNavigationBar: SafeArea(
//             key: const Key('Navigation Safe Area'),
//             child: Container(
//                 margin: EdgeInsets.fromLTRB(navigationSideMargin, 0,
//                     navigationSideMargin, navigationBottomMargin),
//                 key: const Key('Navigation Container'),
//                 decoration: const BoxDecoration(
//                   color: Colors.transparent,
//                 ),
//                 transformAlignment: Alignment.center,
//                 width: screen.width,
//                 height: 64.0,
//                 child: SizedBox(
//                     key: const Key('Navigation Sized Box'),
//                     width: screen.width - (screen.width * 0.1),
//                     height: 64.0,
//                     child: DecoratedBox(
//                         key: const Key('Navigation Decorated Box'),
//                         decoration: BoxDecoration(
//                           color:
//                               Theme.of(context).colorScheme.secondaryContainer,
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(24)),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: items(context),
//                         ))))),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Theme.of(context).colorScheme.tertiary,
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => BlocProvider.value(
//                       value: BlocProvider.of<TrackCollectionBloc>(context),
//                       child: const ModalForm()),
//                   fullscreenDialog: true,
//                   allowSnapshotting: true,
//                   maintainState: true,
//                 ));
//           },
//           elevation: 5,
//           enableFeedback: true,
//           tooltip: 'Add Expense',
//           child:
//               Icon(Icons.add, color: Theme.of(context).colorScheme.onTertiary),
//         ),
//       ),
//     );
//   }
// }
