import 'package:flutter/material.dart';
import '../../core/widget/custom_app_bar.dart';

/// WLAN状态
class WlanType extends StatefulWidget {
  const WlanType({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WlanTypeState();
}

class _WlanTypeState extends State<WlanType> {
  bool isCheck = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'WLAN状态'),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //12.4GHZ
                const TitleWidger(title: '2.4GHZ'),
                InfoBox(
                  boxCotainer: Column(
                    children: const [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'WLAN',
                        righText: '启用',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '模式',
                        righText: '802.11axg',
                      )),
                      RowContainer(
                        leftText: '信道',
                        righText: '1',
                      ),
                    ],
                  ),
                ),

                //5GHZ
                const TitleWidger(title: '5GHZ'),
                InfoBox(
                  boxCotainer: Column(
                    children: const [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'WLAN',
                        righText: '启用',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '模式',
                        righText: '802.11axg',
                      )),
                      RowContainer(
                        leftText: '信道',
                        righText: '116',
                      ),
                    ],
                  ),
                ),

                //设备列表
                const TitleWidger(title: '设备列表'),
              ],
            ),
          ),
        ));
  }
}

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
