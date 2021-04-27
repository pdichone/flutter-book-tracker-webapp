import 'dart:ui';

const String apiKey = 'AIzaSyDSZ_I5i3mQytndsISR7nacelTltWSWN_s';
const String maxResult = "30";
const String apiUrl =
    'https://www.googleapis.com/books/v1/volumes?q=tarrega&key=AIzaSyDSZ_I5i3mQytndsISR7nacelTltWSWN_s';

String searchQuery(String searchTerms) {
  String urlLeft = 'https://www.googleapis.com/books/v1/volumes?q=';
  String urlRight =
      '&maxResults=$maxResult&orderBy=newest&langRestrict=en&key=$apiKey';
  return urlLeft + '$searchTerms' + urlRight;
}

const kBlackColor = Color(0xFF393939);
const kLightBlackColor = Color(0xFF8F8F8F);
const kIconColor = Color(0xFFF48A37);
const kProgressIndicator = Color(0xFFBE7066);

final kShadowColor = Color(0xFFD3D3D3).withOpacity(.84);
