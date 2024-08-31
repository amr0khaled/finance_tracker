import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

TrackType intToType(int value) {
  switch (value) {
    case 1:
      {
        return TrackType.expense;
      }
    default:
      {
        return TrackType.income;
      }
  }
}

TrackCategory intToCategory(int value, TrackCategories cats) {
  return cats.values[value];
}

class ModalForm extends StatefulWidget {
  const ModalForm({super.key});

  @override
  State<ModalForm> createState() => _ModalForm();
}

class _ModalForm extends State<ModalForm> {
  InputBorder border([Color? color]) {
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12));
    if (color != null) {
      return OutlineInputBorder(
          borderRadius: borderRadius, borderSide: BorderSide(color: color));
    }
    return OutlineInputBorder(borderRadius: borderRadius);
  }

  String title = '';
  int formValue = 0;
  String des = '';
  bool isIncome = true;
  List<String> radios = ['Income', 'Expense'];
  late List<String> catRadios = [];
  int radioValue = 0;
  int catRadioValue = 0;
  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  final _formKey = GlobalKey<FormState>();
  late TrackCategories _cats = TrackCategories();
  FocusNode newCatFocus = FocusNode();
  String newCategory = "";

  void addNewCategory(TrackCollectionBloc bloc) {
    bloc.add(TrackAllNewCategory(newCategory));
    setState(() {
      _cats = bloc.state.getCategories();
      newCategory = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<TrackCollectionBloc>(context);
    setState(() {
      if (_cats.names.isEmpty) {
        _cats = bloc.state.getCategories();
      }
      catRadios = List.generate(_cats.names.length, (i) {
        var arr = _cats.names[i].split('');
        arr[0] = arr[0].toUpperCase();
        return arr.join();
      }).reversed.toList();
    });
    Size screen = MediaQuery.of(context).size;
    var state = bloc.state;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar.preferredHeightFor(
            context, const Size(double.infinity, 70))),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('Add'),
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.4),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: IconButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              TrackState newTrack = TrackState(
                  title: title.trim(),
                  value: formValue,
                  description: des.trim(),
                  type: intToType(radioValue),
                  category: intToCategory(catRadioValue, state.categories));
              context
                  .read<TrackCollectionBloc>()
                  .add(TrackCollectionAddTrackEvent(newTrack));
              Navigator.of(context).pop();
            }
          },
          constraints: const BoxConstraints(maxWidth: 383),
          style: ButtonStyle(
              enableFeedback: true,
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              fixedSize: WidgetStatePropertyAll<Size>(Size(screen.width, 56)),
              elevation: const WidgetStatePropertyAll<double>(6),
              backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimaryContainer)),
          icon: Text('Add',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primaryContainer)),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          padding: MediaQuery.viewInsetsOf(context) +
              const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
                child: Text(
                  'Add New Transcition',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.start,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      onFieldSubmitted: (e) {
                        FocusScope.of(context).requestFocus(focusNodes[1]);
                      },
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) {
                        title = value;
                      },
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Transcition Title';
                        }
                        return null;
                      },
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        border: border(),
                        errorBorder:
                            border(Theme.of(context).colorScheme.onError),
                        label: const Text('Track title'),
                      ),
                      focusNode: focusNodes[0],
                      onTapOutside: (e) {
                        focusNodes[0].unfocus();
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 0),
                        child: TextFormField(
                          onFieldSubmitted: (e) {
                            FocusScope.of(context).requestFocus(focusNodes[2]);
                          },
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            formValue = int.parse(value);
                          },
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Transcition Value';
                            }
                            return null;
                          },
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            border: border(),
                            errorBorder:
                                border(Theme.of(context).colorScheme.onError),
                            label: const Text('Value'),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          focusNode: focusNodes[1],
                          onTapOutside: (e) {
                            if (e.down) {
                              focusNodes[1].unfocus();
                            }
                          },
                        )),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        setState(() {
                          des = value;
                        });
                      },
                      maxLines: 4,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        border: border(),
                        errorBorder:
                            border(Theme.of(context).colorScheme.onError),
                        label: const Text('Description'),
                      ),
                      focusNode: focusNodes[2],
                      onTapOutside: (event) {
                        focusNodes[2].unfocus();
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, left: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Type", style: TextStyle(fontSize: 22))
                          ]),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 0),
                        child: Column(
                          children: [
                            for (int i = 0; i < 2; i++)
                              ListTile(
                                  title: Text(radios[i]),
                                  leading: Radio(
                                    value: i,
                                    groupValue: radioValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        if (value != null) {
                                          radioValue = value;
                                        }
                                      });
                                    },
                                  ))
                          ],
                        )),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, left: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Category", style: TextStyle(fontSize: 22))
                          ]),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 0),
                        child: Column(
                          children: [
                            for (int i = 0; i < _cats.names.length; i++)
                              ListTile(
                                  title: Text(catRadios[i]),
                                  trailing: IconButton(
                                      onPressed: () {
                                        bloc.add(TrackAllRemoveCategory(
                                            catRadios[i]));
                                        setState(() {
                                          _cats = bloc.state.getCategories();
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar(context,
                                                title:
                                                    "Removed ${catRadios[i]}",
                                                onPressed: () {
                                          bloc.add(TrackAllUndoCategory());
                                          setState(() {
                                            _cats = bloc.state.getCategories();
                                          });
                                        }));
                                      },
                                      focusColor:
                                          Colors.redAccent.withOpacity(0.4),
                                      hoverColor:
                                          Colors.redAccent.withOpacity(0.3),
                                      highlightColor: Colors.red,
                                      icon: Icon(
                                        MdiIcons.delete,
                                        color: Colors.white70,
                                      )),
                                  leading: Radio(
                                    value: i,
                                    groupValue: catRadioValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        if (value != null) {
                                          catRadioValue = value;
                                        }
                                      });
                                    },
                                  )),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
                              child: ListTileTheme(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  tileColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  child: ExpansionTile(
                                    leading: Icon(MdiIcons.plus),
                                    onExpansionChanged: (e) {
                                      if (e) {
                                        newCatFocus.attach(context);
                                      }
                                    },
                                    title: const Text('Add Category'),
                                    children: [
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        trailing: IconButton(
                                            onPressed: () =>
                                                addNewCategory(bloc),
                                            icon: Icon(MdiIcons.plus)),
                                        title: TextFormField(
                                          focusNode: newCatFocus,
                                          textInputAction: TextInputAction.send,
                                          onFieldSubmitted: (e) =>
                                              addNewCategory(bloc),
                                          initialValue: "",
                                          onChanged: (e) =>
                                              setState(() => newCategory = e),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  'e.g. Expremental Category'),
                                        ),
                                      )
                                    ],
                                    // splashColor: Colors.deepOrange,
                                  )),
                            )
                          ],
                        )),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
