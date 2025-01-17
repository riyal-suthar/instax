import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../widgets/custom_widgets/custom_circulars_progress_indicators.dart';

class SmarterRefresh extends StatefulWidget {
  final Widget child;
  final List posts;
  final ValueNotifier<bool> isThatEndOfList;
  final AsyncValueSetter<int> onRefreshData;
  const SmarterRefresh(
      {super.key,
      required this.child,
      required this.posts,
      required this.isThatEndOfList,
      required this.onRefreshData});

  @override
  State<SmarterRefresh> createState() => _SmarterRefresherState();
}

class _SmarterRefresherState extends State<SmarterRefresh>
    with TickerProviderStateMixin {
  late AnimationController _animationController,
      _scaleController,
      _footerController;
  final ValueNotifier<RefreshController> _refreshController =
      ValueNotifier(RefreshController());
  ValueNotifier<int> lengthOfPosts = ValueNotifier(5);

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _scaleController =
        AnimationController(vsync: this, value: 0.0, upperBound: 1.0);
    _footerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _refreshController.value.headerMode?.addListener(() {
      if (_refreshController.value.headerStatus == RefreshStatus.idle) {
        _scaleController.value = 0.0;
        _animationController.reset();
      } else if (_refreshController.value.headerStatus ==
          RefreshStatus.refreshing) {
        _animationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scaleController.dispose();
    _footerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: ValueListenableBuilder(
        valueListenable: _refreshController,
        builder: (_, RefreshController value, __) {
          return smartRefresher(value);
        },
      ),
    );
  }

  SmartRefresher smartRefresher(RefreshController value) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: value,
      scrollDirection: Axis.vertical,
      onRefresh: onSmarterRefresh,
      onLoading: onSmarterLoading,
      footer: customFooter(),
      header: customHeader(),
      child: widget.child,
    );
  }

  onSmarterRefresh() {
    widget.onRefreshData(0).whenComplete(() {
      _refreshController.value.refreshCompleted();
      _refreshController.value.loadComplete();
      widget.isThatEndOfList.value = false;
      lengthOfPosts.value = 5;
    });
  }

  onSmarterLoading() {
    if (!widget.isThatEndOfList.value) {
      widget.onRefreshData(lengthOfPosts.value).whenComplete(() {
        _refreshController.value.loadComplete();
        if (lengthOfPosts.value >= widget.posts.length) {
          _refreshController.value.loadNoData();
          widget.isThatEndOfList.value = true;
        } else {
          lengthOfPosts.value += 5;
        }
      });
    } else {
      _refreshController.value.loadComplete();
      _refreshController.value.loadNoData();
    }
  }

  CustomFooter customFooter() {
    return CustomFooter(
      onModeChange: (mode) {
        if (mode == LoadStatus.loading) {
          _scaleController.value = 0.0;
          _footerController.repeat();
        } else {
          _footerController.reset();
        }
      },
      builder: (context, mode) {
        Widget child;
        switch (mode) {
          case LoadStatus.failed:
            child = Text(StringsManager.clickRetry.tr,
                style: Theme.of(context).textTheme.bodyLarge);
            break;
          case LoadStatus.noMore:
            child = Container();
            break;
          default:
            child = thineCircularProgress(context);
            break;
        }
        return SizedBox(
          height: 60,
          child: Center(
            child: child,
          ),
        );
      },
    );
  }

  Widget customHeader() {
    return CustomHeader(
      refreshStyle: RefreshStyle.Behind,
      onOffsetChange: (offset) {
        if (_refreshController.value.headerMode?.value !=
            RefreshStatus.refreshing) {
          _scaleController.value = offset / 150.0;
        }
      },
      builder: (context, mode) {
        return customCircleProgress(context);
      },
    );
  }

  Container customCircleProgress(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _scaleController,
        child: thineCircularProgress(context),
      ),
    );
  }

  ThineCircularProgress thineCircularProgress(BuildContext context) {
    return ThineCircularProgress(
      strokeWidth: 1.5,
      color: Theme.of(context).iconTheme.color,
      backgroundColor: Theme.of(context).dividerColor,
    );
  }
}
