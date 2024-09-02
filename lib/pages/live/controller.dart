import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:PiliMini/http/live.dart';
import 'package:PiliMini/models/live/item.dart';
import 'package:PiliMini/utils/storage.dart';

class LiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int count = 12;
  int _currentPage = 1;
  RxInt crossAxisCount = 2.obs;
  RxList<LiveItemModel> liveList = <LiveItemModel>[].obs;
  bool flag = false;
  OverlayEntry? popupDialog;
  Box setting = GStorage.setting;

  @override
  void onInit() {
    super.onInit();
  }

  // 获取推荐
  Future queryLiveList(type) async {
    // if (type == 'init') {
    //   _currentPage = 1;
    // }
    var res = await LiveHttp.liveList(
      pn: _currentPage,
    );
    if (res['status']) {
      if (type == 'init') {
        liveList.value = res['data'];
      } else if (type == 'onLoad') {
        liveList.addAll(res['data']);
      }
      _currentPage += 1;
    }
    return res;
  }

  // 下拉刷新
  Future onRefresh() async {
    queryLiveList('init');
  }

  // 上拉加载
  Future onLoad() async {
    queryLiveList('onLoad');
  }

  // 返回顶部并刷新
  void animateToTop() async {
    if (scrollController.offset >=
        MediaQuery.of(Get.context!).size.height * 5) {
      scrollController.jumpTo(0);
    } else {
      await scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
