const String apiKey = 'AIzaSyDSZ_I5i3mQytndsISR7nacelTltWSWN_s';
const String maxResult = "10";
const String apiUrl =
    'https://www.googleapis.com/books/v1/volumes?q=tarrega&key=AIzaSyDSZ_I5i3mQytndsISR7nacelTltWSWN_s';

String searchQuery(String searchTerms) {
  String urlLeft = 'https://www.googleapis.com/books/v1/volumes?q=';
  String urlRight = '&maxResults=$maxResult&orderBy=newest&key=$apiKey';
  return urlLeft + '$searchTerms' + urlRight;
}
