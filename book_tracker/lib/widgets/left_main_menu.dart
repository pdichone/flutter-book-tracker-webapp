import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LeftMainMenu extends StatelessWidget {
  const LeftMainMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.04,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: HexColor('#f1f3f6'),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14), bottomLeft: Radius.circular(14))
          //borderRadius: BorderRadius.all(Radius.circular(14))
          ),
      //color: Colors.red,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 2,
              color: Colors.transparent,
              child: Icon(
                Icons.bookmark_border,
                size: 40,
                color: HexColor('#5d48b6'),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
