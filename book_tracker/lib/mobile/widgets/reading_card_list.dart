import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/mobile/widgets/book_rating.dart';
import 'package:book_tracker/mobile/widgets/two_sided_rounded_button.dart';
import 'package:book_tracker/model/book.dart';
import 'package:flutter/material.dart';

class ReadingListCard extends StatelessWidget {
  final String? image;
  final String? title;
  final String? auth;
  final double? rating;
  final String? buttonText;
  final Book? book;
  final bool? isBookRead;
  final Function? pressDetails;
  final Function? pressRead;

  const ReadingListCard({
    Key? key,
    this.image,
    this.isBookRead,
    this.title,
    this.auth,
    this.book,
    this.buttonText,
    this.rating,
    this.pressDetails,
    this.pressRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      margin: EdgeInsets.only(left: 24, bottom: 0),
      width: 202,
      // width: MediaQuery.of(context).size.width * 0.48 - 4,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              height: 244,
              //height: MediaQuery.of(context).size.height * 0.25 + 13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 33,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              image!,
              width: 100,
            ),
          ),
          Positioned(
            top: 35,
            right: 10,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  onPressed: () {},
                ),
                BookRating(score: (rating)),
              ],
            ),
          ),
          Positioned(
            top: 160,
            child: Container(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: TextStyle(color: kBlackColor),
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: auth,
                            style: TextStyle(
                              color: kLightBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: pressDetails as void Function()?,
                        child: Container(
                          width: 101,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: Text("Details"),
                        ),
                      ),
                      Expanded(
                        child: TwoSideRoundedButton(
                          text: buttonText,
                          press: pressRead,
                          color: kLightPurple,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
