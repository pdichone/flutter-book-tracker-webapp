const String apiKey = '';
const String maxResult = "10";
const String apiUrl =
    'https://www.googleapis.com/books/v1/volumes?q=tarrega&key=';

String searchQuery(String searchTerms) {
  String urlLeft = 'https://www.googleapis.com/books/v1/volumes?q=$searchTerms';

  return urlLeft;
  // String urlLeft = 'https://www.googleapis.com/books/v1/volumes?q=';
  // String urlRight = '&maxResults=$maxResult&orderBy=newest&key=$apiKey';
  // return urlLeft + '$searchTerms' + urlRight;
}
