import 'package:flutter/material.dart';
import '../../core/widget/custom_app_bar.dart';

/// 设备信息
class EquInfo extends StatefulWidget {
  const EquInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EquInfoState();
}

class _EquInfoState extends State<EquInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '设备信息'),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //1系统信息
                    const TitleWidger(title: '系统信息'),
                    const InfoBox(
                      boxCotainer: RowContainer(
                        leftText: '运行时长',
                        righText: '05d 20h 01m',
                      ),
                    ),

                    //2版本信息
                    const TitleWidger(title: '版本信息'),
                    InfoBox(
                      boxCotainer: Column(
                        children: const [
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: '产品型号',
                            righText: 'SRS621-a',
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: '硬件版本',
                            righText: 'V1.0',
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: '软件版本',
                            righText: 'SQXR60_V1.0.2',
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: 'UBOOT版本',
                            righText: 'V1.1.0',
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: '产品序列号',
                            righText: 'RS621A00211700113',
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: 'IMEI',
                            righText: '862165040976175',
                          )),
                          RowContainer(
                            leftText: 'IMSI',
                            righText: '— —',
                          )
                        ],
                      ),
                    ),

                    //3.0LAN口状态
                    const TitleWidger(title: 'LAN口状态'),
                    InfoBox(
                      boxCotainer: Column(
                        children: const [
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: 'MAC地址',
                            righText: '88:12:3D:03:6F:66',
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: 'IP地址',
                            righText: '192.168.1.1',
                          )),
                          RowContainer(
                            leftText: '子网掩码',
                            righText: '255.255.255.06',
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
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

            //标题1 系统信息
            // InfoItem(leftText: '运行时长', rigjtText: '05d 20h 01m'),


            //标题2 版本信息
            // InfoItem(leftText: '产品型号', rigjtText: 'SRS621-a'),
            // //硬件版本
            // InfoItem(leftText: '硬件版本', rigjtText: 'V1.0'),
            // //软件版本
            // InfoItem(leftText: '软件版本', rigjtText: 'SQXR60_V1.0.2'),
            // //UBOOT版本
            // InfoItem(leftText: 'UBOOT版本', rigjtText: 'V1.1.0'),
            // //产品序列号
            // InfoItem(leftText: '产品序列号', rigjtText: 'RS621A00211700113'),
            // //IMEI
            // InfoItem(leftText: 'IMEI', rigjtText: '862165040976175'),
            // //IMSI
            // Padding(
            //   padding: EdgeInsets.only(bottom: 10.0),
            //   child: InfoItem(leftText: 'IMSI', rigjtText: '— —'),
            // ),

            //标题3 LAN口状态
            // ItemInfo(
            //   title: 'LAN口状态',
            //   iteminfo:
            //       InfoItem(leftText: 'MAC地址', rigjtText: '88:12:3D:03:6F:66'),
            // ),
            // //IMSI
            // InfoItem(leftText: 'IP地址', rigjtText: '192.168.1.1'),
            // //IMSI
            // InfoItem(leftText: '子网掩码', rigjtText: '255.255.255.06')
