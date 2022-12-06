import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// 带刷新的列表
SmartRefresher listRefresh(RefreshController refreshController, int itemCount, Function item,{bool enablePullUp = true,  Function? onRefresh, Function? onLoading}){
  return SmartRefresher(
    ///可在此通过header:和footer:指定个性效果
    header: const ClassicHeader(
        idleText: "下拉刷新",
        releaseText: "开始刷新",
        refreshingText: "刷新中......",
        failedText: "刷新失败",
        completeText: "刷新完成"
    ),
    footer: const ClassicFooter(
        idleText: "上拉刷新",
        failedText: "加载失败",
        loadingText: "加载中......",
        noDataText: "--暂无数据--",
        canLoadingText: "释放加载"
    ),
    //允许下拉
    enablePullDown: true,
    //允许上拉加载
    enablePullUp: enablePullUp,
    //控制器
    controller: refreshController,
    //刷新回调方法 - 上拉
    onRefresh: () => {
      onRefresh == null ? print("没有传递回调函数") : onRefresh()
    },
    //加载下一页回调 - 下拉
    onLoading: () => {
      onLoading == null ? print("没有传递回调函数") : onLoading()
    },
    child: ListView.builder(
      itemBuilder: (c, i) => item(i),
      itemCount: itemCount,
    ),
  );
}

