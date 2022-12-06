import 'package:flutter/material.dart';
import 'package:flutter_template/config/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/widget/custom_app_bar.dart';

/// 用户协议
class UserAgreement extends StatelessWidget {
  const UserAgreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: "用户协议"),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.w),
          width: Constant.defaultWidth,
          child: Column(
            children: <Widget>[
              const Text(
                '''    尊敬的客户，在您下载XXX程序( 下称“APP")使用我们的服务前，请仔细阅读本用户协议。

    本协议是您与A有限公司(以下简称“A”)签署的《用户协议》。您下载本APP并成功注册后，即被视为已阅读、理解、接受本协议条款。本协议可由我们不时作出修订，且构成您与我们之间达成的有关APP使用、具有约束力的协议。您在修订发布后继续使用APP，即视为您已接受了相关修订。如果您不同意本协议或相关修订，则应立即卸载本APP。

    1.用户许可
        1.1.我们允许您在本协议范围内享有个人的、非排他性的、不可转让的使用本APP的权利。但是您不得有以下行为:
            1.1.1.以任何方式出售、转让、分发、修改或传播APP或与APP有关的文字、图片、音乐、条形码、视频、数据、超链接、展示及其他内容(“内容") ;
            1.1.4.利用服务或APP程序进行违法犯罪活动;
            1.1.5.利用服务或APP程序侵犯他人合法权益;
            1.1.6.利用服务或APP程序影响网络的正常运行;
            1.1.7.损害APP程序数据的完整性或性能。本用户许可同样适用于本APP的任何更新、补充或替代产品，但相关更新、补充或替代产品中有相反规定的除外。
        1.2.如果我们认为您存在任何违反本协议的行为或存在其他损害APP的行为，我们保留在不另行通知的情况下随时禁止您继续使用APP和相关服务的权利。
    2.注册帐号、密码及安全性
        2.1.注册资格您承诺:您具有完全民事权利能力和行为能力或虽不具有完全民事权利能力和行为能力但经您的法定代理人同意并由其代理注册APP服务。
        2.2.注册流程:您同意根据APP注册页面的要求提供手机号码并通过认证程序注册账号，或者通过微信授权快速注册账号。您将对账户安全负全部责任。另外，每个用户都要对以其用户名进行的所有活动和事件负全责。
        2.3.您成功注册后，您同意接收我们发送的与APP管理、运营相关的微信订阅号和/或客户端消息和/或电子邮件和/或短消息。
    6.合约期限及变更、终止
        6.1我们和您订立的这份协议是无固定期限协议。
        6.2您有权在结清全部应付费用后，随时通过永久性删除移动设备上安装的APP程序来终止协议。
        6.3我们保留随时修改或替换本协议，或者更改、暂停服务及APP程序(包括但不限于任何功能、数据库或内容)的权利。
    7.其他
        7.1本用户协议部分条款或附件无效或终止的，我们有权根据具体情况选择是否继续履行其他条款。
        7.2本协议适用中国法律。本协议履行中发生的任何争议，由A公司所在地人民法院管辖。''',
                style: TextStyle(
                    color: Color.fromRGBO(56, 56, 56, 1),
                    fontSize: 14,
                    height: 1.4),
              ),
              Container(
                padding: EdgeInsets.only(right: 20.w),
                child: Row(
                  children: const <Widget>[
                    Expanded(
                      child: Text(
                        'A有限公司',
                        style: TextStyle(
                            fontSize: 14, color: Color.fromRGBO(56, 56, 56, 1)),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
