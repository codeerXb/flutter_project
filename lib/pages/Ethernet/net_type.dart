import 'package:flutter/material.dart';
import '../../core/widget/custom_app_bar.dart';

/// 以太网状态
class NetType extends StatefulWidget {
  const NetType({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetTypeState();
}

class _NetTypeState extends State<NetType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '以太网状态'),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //1系统信息
            const TitleWidger(title: '状态'),
            InfoBox(
              boxCotainer: Column(
                children: const [
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '连接模式',
                    righText: '动态 IP',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '链接状态',
                    righText: '已连接',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '连接状态',
                    righText: '已连接',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '在线时间',
                    righText: '00d 00h 00m',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: 'IP地址',
                    righText: '172.16.20.68',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '子网掩码',
                    righText: '255.255.255.0',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '默认网关',
                    righText: '172.16.20.253',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '主DNS',
                    righText: '172.16.100.253',
                  )),
                  RowContainer(
                    leftText: '辅DNS',
                    righText: '114.114.114.114',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
