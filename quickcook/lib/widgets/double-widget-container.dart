import 'package:flutter/material.dart';

class DoubleWidgetContainer extends StatelessWidget {
  final Widget? widget1;
  final Widget? widget2;
  final List<String?>? labels;
  const DoubleWidgetContainer(
      {Key? key, this.widget1, this.widget2, this.labels})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: screenSize.width * 0.04),
      // height: screenSize.height * 0.18,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(Colors.grey[300]!.value),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(2, 4),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                top: 0,
                child: Text(
                  labels!.isNotEmpty ? labels![0]! : "",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              widget1!,
            ],
          ),
          Divider(
            thickness: 1,
            height: 20,
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                top: 0,
                child: Text(
                  labels!.isNotEmpty ? labels![1]! : "",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              widget2!,
            ],
          ),
        ],
      ),
    );
  }
}
