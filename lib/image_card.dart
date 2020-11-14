import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {

  final String imageName;

  ImageCard({this.imageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.black,
          width: 10.0,
        )
      ),
      child: Image.asset('Assets/Images/$imageName.jpg',
          height: 300,
          width: 500,
          fit: BoxFit.fitHeight,
      ),
    );


  }
  
}