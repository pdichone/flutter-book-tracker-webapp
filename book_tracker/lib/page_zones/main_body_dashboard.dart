import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MainBodyDashboard extends StatelessWidget {
  const MainBodyDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> readingList = [
      'Think Again',
      'Be again,',
      'Show Your Work',
      'Psychology of Money',
      'The History of Humankind',
      'Everyday Millionaires'
    ];
    return Expanded(
        flex: 5,
        child: Container(
          margin: const EdgeInsets.all(49),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Add a book'))
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                height: 2,
                child: Container(
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: 90,
              ),
              SizedBox(
                child: Text(
                  'Currently Reading',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0),
                height: 200,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: createBookCards(readingList)),
              )
            ],
          ),
        ));
  }

  List<Widget> createBookCards(List<String> books) {
    List<Widget> children = [];

    for (var book in books) {
      children.add(
        new Container(
          width: 160,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
              //color: HexColor('#5d48b6'),
              //border: Border.all(width: 5),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Card(
            elevation: 5,
            color: HexColor('#f6f4ff'),
            child: Wrap(
              children: [
                Image.network(
                    'https://images.unsplash.com/photo-1553729784-e91953dec042?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1050&q=80'),
                ListTile(
                  title: Text(
                    '$book',
                    style: TextStyle(color: HexColor('#5d48b6')),
                  ),
                  subtitle: Text('Be yourself!'),
                )
              ],
            ),
          ),
        ),
      );
    }
    return children;
  }
}
