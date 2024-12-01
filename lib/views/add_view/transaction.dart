import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/components/popup_transaction.dart';
import 'package:finance_tracker/components/snack_bar.dart';
import 'package:finance_tracker/layout/add_view/add_action_buttons.dart';
import 'package:finance_tracker/layout/add_view/add_category_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late List<String> categories = [
    'Home',
    'Personal',
    'Vacation',
    'Tuition',
    'Photography',
    'Study',
    'Work',
    'Programming',
    'Health',
    'Clothes',
    'Pet',
  ];
  Set<String> _selectedCategories = {};
  String getNewCategory() {
    showDialog(
      context: context,
      builder: (context) => PopupInputTransaction(title: 'Add new category'),
    );
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              CategoryButton(
                                  lastButton: true,
                                  lastLabel: 'New',
                                  onLastButton: () async {
                                    getNewCategory();
                                  },
                                  onChange: (e) {
                                    print(e);
                                  },
                                  segments: [
                                    for (var i in categories)
                                      CategorySegment(
                                          label: Text(
                                            i,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          value: i)
                                  ],
                                  selected: _selectedCategories)
                            ],
                          ),
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
