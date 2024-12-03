import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopupTransaction extends StatelessWidget {
  const PopupTransaction(
      {super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        constraints: BoxConstraints(
          minWidth: screen.width * 0.6,
          maxWidth: screen.width * 0.8,
          minHeight: screen.height * 0.15,
          maxHeight: screen.height * 0.2,
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BackButton(
                  color: Colors.black,
                  style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(title, style: const TextStyle(fontSize: 20)),
                )
              ],
            ),
            const Divider(),
            Padding(
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
            )
          ],
        ),
      )),
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
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Material(
      shadowColor: Colors.black,
      color: Colors.transparent,
      type: MaterialType.card,
      child: Center(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        constraints: BoxConstraints(
          minWidth: screen.width * 0.6,
          maxWidth: screen.width * 0.8,
          minHeight: screen.height * 0.15,
          maxHeight: screen.height * 0.3,
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Text(widget.title,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.black,
                style: const TextStyle(fontSize: 16),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                : Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
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
      )),
    );
  }
}
