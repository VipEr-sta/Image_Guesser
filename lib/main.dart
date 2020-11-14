import 'dart:ui';

import 'package:flutter/material.dart';
import 'image_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEGO Universe IG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lego Universe Image Guesser'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<String> characterNames = [
    'Bob',
    'Wisp Lee',
    'Stromling',
    'Baron Typhonus',
    'Spiderling',
    'Nexus Jay'
  ];

  String currentCharacterName = '';

  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  @override
  initState() {
    super.initState();

    finishScrollController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    )
    ..addListener(() {
      setState(() {
        scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd,
            finishScrollController.value);

      });

    });
  }

  @override
  dispose() {
    finishScrollController.dispose();
    super.dispose();
  }


  List<Widget> buildCards() {
    List<Widget> cardsList = [];

    for (int i = 0; i < characterNames.length; i++) {
      cardsList.add(buildCard(i, scrollPercent));
    }
    return cardsList;
  }

  Widget buildCard(int cardIndex, double scrollPercent) {
    final cardScrollPercent = scrollPercent / characterNames.length;
    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ImageCard(
          imageName: characterNames[cardIndex],
        ),
      ),
    );
  }

  onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  onHorizontalDragUpdate(DragUpdateDetails details) {
    final currentDrag = details.globalPosition;
    // dx = distance of x
    final dragDistance = currentDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    setState(() {
      scrollPercent = (startDragPercentScroll +
          (-singleCardDragPercent / characterNames.length))
          .clamp(0.0, 1.0 - (1 / characterNames.length));
    });
  }

  onHorizontalDragEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent;
    finishScrollEnd =
        (scrollPercent * characterNames.length).round() / characterNames.length;
    finishScrollController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
      currentCharacterName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onHorizontalDragStart: onHorizontalDragStart,
                onHorizontalDragUpdate: onHorizontalDragUpdate,
                onHorizontalDragEnd: onHorizontalDragEnd,
                // makes sure in front and behind have same functionality
                behavior: HitTestBehavior.translucent,
                child: Stack(
                  children: buildCards(),
                ),
              ),
              OutlineButton(
                padding: EdgeInsets.all(10.0),
                onPressed: ()  {
                  setState(() {
                    this.currentCharacterName = characterNames[(scrollPercent * 10).round()];

                });
                },
                child: Text('Show Answer',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 4.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                highlightedBorderColor: Colors.cyan,
                highlightColor: Colors.blueAccent,
              ),
              Text(
                currentCharacterName,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 2,
                ),
              ),
            ]),
      ),
    );
  }
}
