import 'dart:ui';

const String apiKey = 'AIzaSyDSZ_I5i3mQytndsISR7nacelTltWSWN_s';
const String maxResult = "40"; // max is 40, default is 10
const String apiUrl =
    'https://www.googleapis.com/books/v1/volumes?q=tarrega&key=AIzaSyDSZ_I5i3mQytndsISR7nacelTltWSWN_s';

String searchQuery(String searchTerms) {
  String urlLeft = 'https://www.googleapis.com/books/v1/volumes?q=';
  String urlRight =
      '&maxResults=$maxResult&orderBy=relevance&langRestrict=en&key=$apiKey'; //newest or relevance for orderBy
  return urlLeft + '$searchTerms' + urlRight;
}

double parseDouble(dynamic value) {
  try {
    if (value is int) {
      return double.parse(value.toString());
    } else if (value is double) {
      return value;
    } else {
      return 0.0;
    }
  } catch (e) {
    // return null if double.parse fails
    return 0.0;
  }
}

const kBlackColor = Color(0xFF393939);
const kLightBlackColor = Color(0xFF8F8F8F);
const kIconColor = Color(0xFFF48A37);
const kProgressIndicator = Color(0xFFBE7066);
const kButtonColor = Color(0xFFBE7066);

const kLightPurple = Color(0xBA68C8d4);

final kShadowColor = Color(0xFFD3D3D3).withOpacity(.84);
