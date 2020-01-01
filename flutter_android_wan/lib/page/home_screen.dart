import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter_android_wan/common/base_widget.dart';
import 'package:flutter_android_wan/common/constants.dart';
import 'package:flutter_android_wan/model/article_model.dart';
import 'package:flutter_android_wan/model/banner_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends BaseWidgetState<HomeScreen> {
  ///首页轮播图数据
  List<BannerBean> _bannerList = new List();

  ///首页文章列表数据
  List<ArticleBean> _articles = new List();

  ///ListView的控制器
  ScrollController _scrollController = new ScrollController();

  ///是否显示悬浮按钮
  bool _isShowFAB = false;

  ///页码，从0开始
  int _page = 0;
  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _bannerList.add(null);

    showLoading().then((value) {
      getBannerList();
      getTopArticleList();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
      if (_scrollController.offset < 200 && _isShowFAB) {
        setState(() {
          _isShowFAB = false;
        });
      } else if (_scrollController.offset >= 200 && !_isShowFAB) {
        setState(() {
          _isShowFAB = true;
        });
      }
    });
  }

  ///获取轮播数据
  Future getBannerList() async {
    apiServie.getBannerList((BannerModel bannerModel) {
      if (bannerModel.data.lemgth > 0) {
        setState(() {
          _bannerList = bannerModel.data;
        });
      }
    });
  }

  ///获取置顶文章数据
  Future getTopArticleList() async {
    apiServie.getTopArticleList((TopArticleModel topArticleModel) {
      if (topArticleModel.errorCode == Constants.STATUS_SUCCESS) {
        topArticleModel.data.forEach((v) {
          v.top = 1;
        });
        _articles.clear();
        _articles.addAll(topArticleModel.data);
      }
      getArticleList();
    }, (DioError error) {
      showError();
    });
  }

  ///获取文章列表数据
  Future getArticleList() async {
    _page = 0;
    apiService.getArticleList((ArticleModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent().then((value) {
            _refreshController.refreshCompleted(resetFooterState: true);
            setState(() {
              _articles.addAll(model.data.datas);
            });
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      showError();
    }, _page);
  }

  ///获取更多的文章列表
  Future getMoreArticleList() async {
    _page++;
    apiService.getArticleList((ArticleModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _articles.addAll(model.data.datas);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      _refreshController.loadFailed();
    }, _page);
  }

  @override
  Widget build(BuildContext context) {}

  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(""),);
  }

  @override
  Widget attachContentWidget(BuildContext context) {
   return Scaffold(
     body:SmartRefresher (
       enablePullDown: true,
       enablePullUp: true,
       header: MaterialClassicHeader(),
       footer: RefreshFooter(),
       controller: _refreshController,
       onRefresh: getTopArticleList,
       onLoading: getMoreArticleList,
       child: ListView.builder(
           itemBuilder: itemView),

     ),
   );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
  }

  ///listView中每一行的视图
   Widget itemView (BuildContext context,int index){
    if(index==0){
      return Container(
        height: 200,
        color: Colors.transparent,
        child: _buildBannerWidget(),
      );
    }
    ArticleBean  item=_articles[index-1];
    return ItemArticleList(item:item);
   }
   ///构建轮播视图
  Widget _buildBannerWidget(){
    return Offstage(
      offstage: _bannerList.length==0,
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          if(index>=_bannerList.length||
          _bannerList[index]==null||
          _bannerList[index].imagePath==null){
            return new Container(height: 0,);
          }else{
            return InkWell(
              child: new Container(
                child:
                CustomCachedImage(imageUrl:_bannerList[index].imagePath),
              ),
              onTap: (){
                RouteUtil.toWebView(
                  context,_bannerList[index].title,_bannerList[index].url);
              },
            );

          }
        },
        itemCount: _bannerList.length,
        autoplay: true,
        pagination: new SwiperPagination(),

      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}


