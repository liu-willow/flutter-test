
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wallet_test/controller/Home.dart' as home_controller;

class Home extends GetView<home_controller.Home> {

  @override
  Widget build(context) {
    final home_controller.Home c = Get.put(home_controller.Home());

    final width = Get.width / Get.pixelRatio;
    final height = Get.height / Get.pixelRatio;

    return Scaffold(
      body: EasyRefresh(
          controller: c.refreshController,
          resetAfterRefresh: true,
          header: const ClassicHeader(
              dragText: '下拉刷新',
              messageText: '最后更新于 %T',
              processedText: '更新成功',
              armedText: '释放开始',
              readyText: '刷新中'
          ),
          footer: const ClassicFooter(
            dragText: '上拉加载',
            armedText: '松开加载',
            readyText: '加载中',
            processedText: '已加载',
            noMoreText: '没有更多数据了',
            failedText: '再试一次',
            messageText: '最后更新于 %T',
          ),
          onRefresh: () async {
            c.refreshList();
            c.refreshController.finishRefresh();
            c.refreshController.resetHeader();
          },
          onLoad: () async {
            c.getNftList();
            c.refreshController.finishLoad(IndicatorResult.success);
            c.refreshController.resetFooter();
          },
          child: Obx(() {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, idx) => GFListTile(
                    avatar: GFAvatar(
                        backgroundColor: GFColors.WHITE,
                        child: GFImageOverlay(
                          height: 500,
                          width: 500,
                          shape: BoxShape.circle,
                          image: NetworkImage(c.nftData[idx].image()),
                          boxFit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.lighten),
                        )),
                    titleText: c.nftData[idx].name.toString(),
                    subTitleText: c.nftData[idx].description,
                    color: GFColors.WHITE,
                    onTap: () => {
                      print(c.nftData.length),
                    } ,
                  ),
                    childCount: c.nftData.length,
                  ),
                ),
              ],
            );
          })
      ),
    );
  }
}