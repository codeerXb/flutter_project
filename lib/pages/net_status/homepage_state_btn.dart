import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageStateBtn extends StatelessWidget {
  const HomePageStateBtn(
      {super.key,
      required this.imageUrl,
      required this.offImageUrl,
      this.routeName,
      required this.status});
  final String imageUrl;
  final String offImageUrl;
  final String? routeName;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12.sp),
      child: GestureDetector(
        child: Image(image: AssetImage(status == '1' ? imageUrl : offImageUrl)),
        onTap: () => {
          routeName != null ? Navigator.pushNamed(context, routeName!) : null
        },
      ),
    );
  }
}
