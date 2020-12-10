import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> navigatorPush(context, navigationClass) => Navigator.of(context)
    .push(MaterialPageRoute(builder: ((context) => navigationClass)));

Widget horizontalSpace(double width) => SizedBox(
      width: width,
    );

Widget verticalSpace(double height) => SizedBox(
      height: height,
    );

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

TextTheme trackerTheme(BuildContext context) => Theme.of(context).textTheme;

EdgeInsets all4px() => EdgeInsets.all(4);

EdgeInsets all8px() => EdgeInsets.all(8);

EdgeInsets all12px() => EdgeInsets.all(12);

EdgeInsets all16px() => EdgeInsets.all(16);

EdgeInsets allCustompx(value) => EdgeInsets.all(value);

EdgeInsets symHorizontalpx(value) => EdgeInsets.symmetric(horizontal: value);

EdgeInsets symVerticalpx(value) => EdgeInsets.symmetric(vertical: value);

EdgeInsets allSymmetric(vertical, horizontal) =>
    EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
