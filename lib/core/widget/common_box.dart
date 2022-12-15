import 'package:flutter/material.dart';

//底部线
class BottomLine extends StatelessWidget {
  final Widget rowtem;

  const BottomLine({super.key, required this.rowtem});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(bottom: 6),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: rowtem,
    );
  }
}

//信息每行
class RowContainer extends StatelessWidget {
  final String leftText;
  final String righText;

  const RowContainer(
      {super.key, required this.leftText, required this.righText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(leftText,
            style: const TextStyle(
                color: Color.fromARGB(255, 5, 0, 0), fontSize: 14)),
        Text(
          righText,
          style: const TextStyle(
              color: Color.fromARGB(255, 37, 37, 36), fontSize: 13),
        ),
      ],
    );
  }
}

//标题
class TitleWidger extends StatelessWidget {
  final String title;

  const TitleWidger({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }
}

//信息盒子
class InfoBox extends StatelessWidget {
  final Widget boxCotainer;

  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(14.0),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: boxCotainer);
  }
}
