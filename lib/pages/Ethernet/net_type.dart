import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_box.dart';
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

