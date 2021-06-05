import 'package:book_tracker/mobile/screens/mobile_main_screen.dart';
import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/screens/getting_started_page.dart';
import 'package:book_tracker/screens/login_page.dart';
import 'package:book_tracker/screens/not_found_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(MobileApp());
  runApp(MyApp());
}

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
      ],
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // if (snapshot.hasError) {
          //   return Material(child: Text('Firebase not working!'));
          // }
          if (snapshot.connectionState == ConnectionState.done) {
            var user = Provider.of<User>(context);
            //print('loggedin user ==> ${user.email}');
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: '',

              home: user == null ? LoginPage() : MobileMainScreen(),
              //home: MobileMainScreen(),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

/* 

--->>> Better strategy: add html rendered in runtime: https://flutter.dev/docs/development/tools/web-renderers
Deployment: use flutter build web --web-renderer html to render html for images to work!
 To see images
        or... run in: flutter run -d chrome --web-renderer html
        or.. change launcher.json:https://github.com/LunaGao/flag_flutter/issues/49#issuecomment-803008314
        to render images run web-renderer: https://stackoverflow.com/questions/66060984/flutter-web-image-loading-in-mobile-view-but-not-in-full-view */

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final linkCollection = FirebaseFirestore.instance.collection('books');
    final userBookDataStream = linkCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((book) {
        return Book.fromDocument(book);
      }).toList();
    });

    return MultiProvider(
        providers: [
          StreamProvider<User?>(
              create: (context) => FirebaseAuth.instance.authStateChanges(),
              initialData: null),
          Provider<CollectionReference>(
            create: (context) => linkCollection,
          ),
          StreamProvider<List<Book>>(
            initialData: [],
            catchError: (context, error) {
              return [];
            },
            create: (context) => userBookDataStream,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'A.Reader',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          initialRoute: '/',
          //initialRoute: '/',
          // routes: {
          //   '/': (context) => GettingStartedPage(),
          //   '/main': (context) => MainPage(),
          //   '/login': (context) => LoginPage()
          // },
          //
          /* advanced routing */
          onGenerateRoute: (settings) {
            print(settings.name);
            return MaterialPageRoute(
              builder: (context) {
                return RouteController(settingsName: settings.name);
              },
            );
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (context) {
              return PageNotFound();
            });
          },
          //home: MainPage(),
        ));
  }
}

class RouteController extends StatelessWidget {
  final String? settingsName;
  const RouteController({
    Key? key,
    required this.settingsName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User>(context) != null;
    print(userSignedIn);
    final signedInGotoMain =
        userSignedIn && settingsName == '/main'; // they are good to go!
    final notSignedInGotoMain = !userSignedIn &&
        settingsName == '/main'; //not signed in user trying to go to mainPage
    if (settingsName == '/') {
      return GettingStartedPage();
    } else if (settingsName == '/login' || notSignedInGotoMain) {
      return LoginPage();
    } else if (signedInGotoMain) {
      return MobileMainScreen();
    } else {
      return PageNotFound();
    }
  }
}

/*
 class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userStream = FirebaseAuth.instance.authStateChanges();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookTracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User>(
        stream: userStream,
        builder: (context, snapshot) {
          final userSignedIn = snapshot.data != null;

          return userSignedIn ? MainScreenPage() : LoginPage();
        },
        //child: GetStartedPage()
      ),
    );
  }
}
*/

/*
  Deployment:

flutter run -d chrome --release (will run in release mode [for testing])
flutter build web

Firebase init - start the deployment process
Flutter build web
For public directory use build/web (this is where the assets are)
For overriding say “n”
… single page app… say “y”
Then firebase deploy

iOS running on device - if you want to see apps installed on iOS devices, 
must run “flutter run --release”.  Otherwise, the app will always crash when you try to tap the app icon and launch it on device.


*/
