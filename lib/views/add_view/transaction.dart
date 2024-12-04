import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/components/popup_transaction.dart';
import 'package:finance_tracker/components/snack_bar.dart';
import 'package:finance_tracker/layout/add_view/add_action_buttons.dart';
import 'package:finance_tracker/layout/add_view/add_category_button.dart';
import 'package:finance_tracker/utils/categories/bloc.dart';
import 'package:finance_tracker/utils/event_handling/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String whatTransaction = '';
  late Contact _contact;
  FlutterNativeContactPicker contactPicker = FlutterNativeContactPicker();
  final Set<String> _selectedCategories = {};
  void removeCategory(BuildContext context, String category) {
    showDialog(
        context: context,
        builder: (context) {
          Size screen = MediaQuery.sizeOf(context);
          return PopupDialog(
            constraints: BoxConstraints(
                maxWidth: screen.width * 0.7,
                minWidth: 0,
                maxHeight: screen.height * 0.25,
                minHeight: 0),
            title: 'Remove Category',
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Markdown(
                      data: 'You really want to remove **$category**?',
                      padding: const EdgeInsets.all(8),
                      styleSheet: MarkdownStyleSheet(
                          textAlign: WrapAlignment.start,
                          pPadding: const EdgeInsets.all(0),
                          p: const TextStyle(fontSize: 16),
                          strong: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < 2; i++)
                          ElevatedButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                fixedSize: Size(screen.width * 0.27, 40),
                                backgroundColor: i == 0
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary,
                                foregroundColor: i == 0
                                    ? Color.alphaBlend(Colors.white70,
                                        Theme.of(context).colorScheme.onError)
                                    : Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: i == 0
                                  ? () {
                                      Navigator.of(context).pop();
                                    }
                                  : () {
                                      final bloc =
                                          BlocProvider.of<CategoryBloc>(
                                              context);
                                      if (!bloc.isClosed) {
                                        bloc.add(DeleteCategoryEvent(category));
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar(context,
                                                title: '$category has removed',
                                                onPressed: () {
                                          bloc.add(const UndoCategoriesEvent());
                                        }));
                                      } else {
                                        print('BloC is closed');
                                      }
                                    },
                              child: Text(i == 0 ? 'No' : 'Yes',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void newCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => PopupInputTransaction(
              title: 'Add new category',
              onDone: (e) async {
                final bloc = BlocProvider.of<CategoryBloc>(context);
                if (!bloc.isClosed) {
                  bloc.add(AddCategoryEvent(e));
                  bloc.add(const UndoCategoriesEvent());
                  Navigator.of(context).pop();
                } else {
                  print('BloC is Closed');
                }
              },
            ));
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24)
              .add(const EdgeInsets.only(top: 48, bottom: 20)),
          child: Form(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "What Was That Transaction?",
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          onChanged: (a) {
                            setState(() => whatTransaction = a);
                          },
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2)),
                              hintText: ' Enter Transaction Title.',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w200, fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About This Transaction?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          maxLines: 3,
                          onChanged: (a) {},
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2)),
                              hintText:
                                  ' Enter What this Transaction was about.',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w200, fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "To Whom?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () async {
                            Contact? contact =
                                await contactPicker.selectContact();
                            if (contact!.phoneNumbers!.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar(context, title: 'Picked'));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar(context, title: 'Did not Pick'));
                            }
                          },
                          child: const Text('Choose'),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "To What Category?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Center(
                          child: BlocConsumer<CategoryBloc, CategoriesState>(
                              listener: (context, state) {
                                const errorStatus = CategoryStatus.error;
                                if (state.status == errorStatus ||
                                    state.event is BlocError) {
                                  BlocError errorEvent =
                                      state.event as BlocError;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar(context,
                                          title: errorEvent.message));
                                  if (errorEvent.err != null) {
                                    print("ERROR: ${errorEvent.err}");
                                    print("STACKTRACE: ${errorEvent.stack}");
                                  }
                                }
                                print(
                                    'In Listener ${state.event?.message}, data ${state.data}');
                              },
                              listenWhen: (p, n) =>
                                  p.data.length != n.data.length ||
                                  p.status != n.status ||
                                  n.event is BlocError ||
                                  p.event is BlocError,
                              builder: (context, CategoriesState state) {
                                if (state.data.isEmpty) {
                                  BlocProvider.of<CategoryBloc>(context)
                                      .add(const LoadCategoriesEvent());
                                }
                                var data = state.data;
                                return CategoryButton(
                                    key: UniqueKey(),
                                    lastButton: true,
                                    lastLabel: 'New',
                                    onLongPress: (String e) {
                                      setState(() {
                                        removeCategory(context, e);
                                      });
                                    },
                                    onLastButton: () {
                                      setState(() {
                                        newCategory(context);
                                      });
                                    },
                                    onChange: (e) {
                                      print(e);
                                    },
                                    segments: [
                                      for (var i in data)
                                        CategorySegment(
                                            label: Text(
                                              i,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            value: i)
                                    ],
                                    selected: _selectedCategories);
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Amount",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Center(
                          child: TextFormField(
                            style: const TextStyle(fontSize: 28),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: '\$\$\$',
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                counter: Container(),
                                isDense: true,
                                prefixText: "\$",
                                prefixStyle: TextStyle(
                                    fontSize: 28,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: AddActionButtons(
          onCancel: () {
            Navigator.of(context).pop();
          },
          onAdd: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(snack(
              context,
              content: 'Success Transaction',
              label: 'Undo',
              onPressed: () {},
            ));
          },
        ));
  }
}
