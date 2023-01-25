import 'package:flutter/material.dart';

class TextFieldInputDialog extends StatefulWidget {
  const TextFieldInputDialog({
    super.key,
    required this.label,
    required this.result,
    required this.error,
    required this.hint,
    required this.items,
    required this.itemLabel,
    required this.itemValue,
    required this.darkmode,
    required this.model,
    required this.readOnly,
  });

  final String label;
  final TextEditingController result;
  final TextEditingController model;
  final bool error;
  final String hint;
  final List items;
  final String itemLabel;
  final String itemValue;
  final bool darkmode;
  final bool readOnly;

  @override
  State<TextFieldInputDialog> createState() => _TextFieldInputDialogState();
}

class _TextFieldInputDialogState extends State<TextFieldInputDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            spreadRadius: 2,
            blurRadius: 14,
            offset: const Offset(3, 4), // changes x,y position of shadow
          ),
        ],
      ),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 14.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
            ),
            child: const Text(''),
          ),
          SizedBox(
            height: 45.0,
            child: TextField(
              onTap: () {
                if (widget.readOnly) {
                  dialog(context);
                }
              },
              readOnly: true,
              // cursorHeight: 16.0,
              controller: widget.result,
              autofocus: false,
              style: const TextStyle(
                fontFamily: 'Spartan',
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFFA2A4A3),
              ),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: const TextStyle(
                  fontFamily: 'Spartan',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFA2A4A3),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  fontFamily: 'Spartan',
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD6D6D6),
                ),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 13.0, top: 2.0),
                  child: Image(
                    image: AssetImage('assets/images/calendar.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 13.0, top: 2.0),
                  child: Image(
                    image: AssetImage('assets/images/down.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                contentPadding: const EdgeInsets.only(bottom: 0.0),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor:
                widget.darkmode == true ? Color(0xff343A40) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            ),
            contentPadding: const EdgeInsets.all(0.0),
            insetPadding: EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            content: widget.items.length >= 4
                ? SizedBox(
                    height: 68.0 * 4,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: Builder(builder: (BuildContext context) {
                            return Column(
                              children: [
                                for (var i = 0; i < widget.items.length; i++)
                                  ListTile(
                                    onTap: () {
                                      widget.result.text = widget.items[i]
                                              [widget.itemLabel]
                                          .toString();
                                      widget.model.text = widget.items[i]
                                              [widget.itemValue]
                                          .toString();
                                      Navigator.pop(context);
                                    },
                                    title: Container(
                                      height: 60.0,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Text(
                                              widget.items[i][widget.itemLabel],
                                              style: TextStyle(
                                                color: !widget.darkmode
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 15.0,
                                                fontFamily: 'Spartan',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: Builder(builder: (BuildContext context) {
                            return Column(
                              children: [
                                for (var i = 0; i < widget.items.length; i++)
                                  ListTile(
                                    onTap: () {
                                      widget.result.text = widget.items[i]
                                              [widget.itemLabel]
                                          .toString();
                                      widget.model.text = widget.items[i]
                                              [widget.itemValue]
                                          .toString();
                                      Navigator.pop(context);
                                    },
                                    title: Container(
                                      height: 60.0,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Text(
                                              widget.items[i][widget.itemLabel],
                                              style: TextStyle(
                                                color: !widget.darkmode
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 15.0,
                                                fontFamily: 'Spartan',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}
