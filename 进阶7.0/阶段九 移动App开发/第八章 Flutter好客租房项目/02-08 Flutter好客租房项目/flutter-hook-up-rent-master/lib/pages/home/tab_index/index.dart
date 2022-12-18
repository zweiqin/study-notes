import 'package:flutter/material.dart';
import 'package:hook_up_rent/pages/home/info/index.dart';
import 'package:hook_up_rent/utils/common_toast.dart';
import 'package:hook_up_rent/widgets/common_swiper.dart';
import 'package:hook_up_rent/widgets/search_bar/index.dart';

import 'index_navigator.dart';
import 'index_recommond.dart';

class TabIndex extends StatelessWidget {
  const TabIndex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SearchBar(
          showLoaction: true,
          showMap: true,
          onSearch: () {
            CommonToast.showToast('该功能暂未实现，敬请期待！');
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          CommonSwiper(),
          IndexNavigator(),
          IndexRecommond(),
          Info(
            showTitle: true,
          ),
          // Text('这里是内容区域'),
        ],
      ),
    );
  }
}
