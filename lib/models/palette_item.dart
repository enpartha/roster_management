import 'dart:ui';

// import 'package:cytoapp1/models/duty.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PaletteItem extends StatelessWidget {
  final Color? paletteColor;
  final String? paletteText;
  void Function()? paletteAction;
  bool selectedItem = false;

  PaletteItem({
    Key? key,
    this.paletteColor,
    this.paletteText,
    this.paletteAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.17 * 0.5,
        // width: MediaQuery.of(context).size.width * 0.2,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: paletteColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black26,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: paletteAction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width > 400
                        ? MediaQuery.of(context).size.width * 0.17
                        : 70,
                    height: 50,
                    child: Center(
                      child: Text(
                        '$paletteText',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            ),
                          ],
                          fontSize: MediaQuery.of(context).size.width < 400
                              ? MediaQuery.of(context).size.height * 0.16 * 0.12
                              : 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
