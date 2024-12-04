import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog(
      {super.key,
      required this.title,
      required this.child,
      this.constraints,
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
      this.crossAxisAlignment = CrossAxisAlignment.start});
  final Widget child;
  final String title;
  final BoxConstraints? constraints;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  //
  //
  //BoxConstraints(
  //            minWidth: screen.width * 0.6,
  //            maxWidth: screen.width * 0.8,
  //            minHeight: screen.height * 0.15,
  //            maxHeight: screen.height * 0.2,
  //          )
  //
  //
  //

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        constraints: constraints ??
            BoxConstraints(
              minWidth: screen.width * 0.6,
              maxWidth: screen.width * 0.8,
              minHeight: screen.height * 0.15,
              maxHeight: screen.height * 0.2,
            ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    CloseButton(
                      color: Colors.black,
                      style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
                const Divider(),
              ],
            ),
            child
          ],
        ),
      )),
    );
  }
}

class PopupTransaction extends StatelessWidget {
  const PopupTransaction(
      {super.key, required this.title, required this.description});
  final String title;
  final String description;
  // BoxConstraints(
  //         minWidth: screen.width * 0.6,
  //         maxWidth: screen.width * 0.8,
  //         minHeight: screen.height * 0.15,
  //         maxHeight: screen.height * 0.2,
  //       )

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return PopupDialog(
      title: title,
      mainAxisAlignment: MainAxisAlignment.start,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}

class PopupInputTransaction extends StatefulWidget {
  PopupInputTransaction({super.key, required this.title, required this.onDone});
  final String title;
  void Function(String) onDone;

  @override
  State<PopupInputTransaction> createState() => _PopupInputTransactionState();
}

class _PopupInputTransactionState extends State<PopupInputTransaction> {
  late String _value;
  // BoxConstraints(
  //       minWidth: screen.width * 0.6,
  //       maxWidth: screen.width * 0.8,
  //       minHeight: screen.height * 0.15,
  //       maxHeight: screen.height * 0.3,
  //     )

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return PopupDialog(
      title: 'Add New Category',
      constraints: BoxConstraints(
        minWidth: screen.width * 0.6,
        maxWidth: screen.width * 0.8,
        minHeight: screen.height * 0.15,
        maxHeight: screen.height * 0.3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onFieldSubmitted: (e) {
                widget.onDone(e);
              },
              textInputAction: TextInputAction.done,
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 16),
              keyboardType: TextInputType.text,
              onChanged: (e) => setState(() => _value = e),
              maxLines: 1,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.allow(RegExp(r'[A-z]'))
              ],
              decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.error)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.primary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black)),
                  hintText: 'Type here',
                  hintStyle: const TextStyle(color: Colors.black87)),
            ),
          ),
          LayoutBuilder(builder: (context, box) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < 2; i++)
                    ElevatedButton(
                      onPressed: i == 0
                          ? () {
                              Navigator.pop(context);
                            }
                          : () {
                              widget.onDone(_value);
                            },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size((box.maxWidth / 2) - 20, 50),
                          backgroundColor: i == 0
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text(
                        i == 0 ? 'Cancel' : 'Add',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: i == 0
                                ? Color.alphaBlend(Colors.white60,
                                    Theme.of(context).colorScheme.onError)
                                : Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                      ),
                    ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
