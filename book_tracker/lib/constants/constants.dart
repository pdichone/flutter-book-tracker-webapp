const String apiKey = 'Your_API_KEY';
const String maxResult = "30";
const String apiUrl =
    'https://www.googleapis.com/books/v1/volumes?q=tarrega&key=YOUR_API_KEY';

String searchQuery(String searchTerms) {
  String urlLeft = 'https://www.googleapis.com/books/v1/volumes?q=';
  String urlRight =
      '&maxResults=$maxResult&orderBy=newest&langRestrict=en&key=$apiKey';
  return urlLeft + '$searchTerms' + urlRight;
}
