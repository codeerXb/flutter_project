import 'package:flutter/material.dart';
import '../../core/widget/custom_app_bar.dart';

/// 以太网设置
class NetSet extends StatefulWidget {
  const NetSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetSetState();
}

class _NetSetState extends State<NetSet> {
  bool isCheck = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '以太网设置'),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TitleWidger(title: '设置'),

                //连接模式
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('连接模式',
                          style: TextStyle(
                              color: Color.fromARGB(255, 5, 0, 0),
                              fontSize: 14)),
                      SizedBox(
                        height: 25,
                        width: 150,
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                        ),
                      ),
                    ],
                  ),
                ),

                //仅以太网
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('仅以太网',
                          style: TextStyle(
                              color: Color.fromARGB(255, 5, 0, 0),
                              fontSize: 14)),
                      Row(
                        children: [
                          Switch(
                            value: isCheck,
                            onChanged: (newVal) {
                              setState(() {
                                isCheck = newVal;
                              });
                            },
                          ),
                          const Text('启用')
                        ],
                      )
                    ],
                  ),
                ),

                //MTU
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('MTU',
                          style: TextStyle(
                              color: Color.fromARGB(255, 5, 0, 0),
                              fontSize: 14)),
                      SizedBox(
                        height: 25,
                        width: 150,
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                        ),
                      ),
                    ],
                  ),
                ),

                //检测服务器
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('检测服务器',
                          style: TextStyle(
                              color: Color.fromARGB(255, 5, 0, 0),
                              fontSize: 14)),
                      SizedBox(
                        height: 25,
                        width: 150,
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin:const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('提交'),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        onPressed: () {},
                        child: const Text('取消'),
                      ),
                    ])
              ],
            ),
          ),
        ));
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
