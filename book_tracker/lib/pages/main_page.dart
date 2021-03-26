import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: HexColor('#B9C2D1'),
      child: Card(
        margin: const EdgeInsets.all(120),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.transparent, width: 1)),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  color: HexColor('#F5F6F8'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: IconButton(
                          color: HexColor('#69639F'),
                          icon: Icon(Icons.dashboard),
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: IconButton(
                          color: HexColor('#69639F'),
                          icon: Icon(Icons.person),
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: IconButton(
                          color: HexColor('#69639F'),
                          icon: Icon(Icons.stacked_line_chart_sharp),
                          onPressed: () {},
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                )),
            Expanded(flex: 4, child: Text('Main side')),
            Expanded(
                flex: 2,
                child: Container(
                  color: HexColor('#F5F6F8'),
                  child: Column(children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            'https://media.istockphoto.com/photos/ethnic-profile-picture-id185249635?k=6&m=185249635&s=612x612&w=0&h=8U5SlsY9iGJcHqBSxd_r6PLbgGFylccForDTK8drYcg='),
                        radius: 50,
                      ),
                    ),
                    Text(
                      'Danny Devoe',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Business Analyst & Reader',
                        style: Theme.of(context).textTheme.overline,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 2,
                      child: Container(
                        color: Colors.red,
                      ),
                    )
                  ]),
                ))
          ],
        ),
      ),
    );
  }
}
