//首页

import 'dart:async';
import 'dart:developer';
// import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';
import '../pages/publicWidget/movie_bar.dart';
import '../service/service_method.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//混入状态保持
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];
  GlobalKey _globalKey = GlobalKey();
  //混入状态保持需要重写
  @override
  bool get wantKeepAlive => true;

  String homePageContent = '正在获取数据';
  @override
  void initState() {
    // TODO: implement initState初始化状态 不初始化的原因是因为futureBuilder
    //加载首页数据
    // _getHotGoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(top: 2,bottom: 2,left: 16),
              child: Container(
                height: 35,
                width:  MediaQuery.of(context).size.width-64,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(230,230,230,1.0),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 10,right: 10),
                              child: Icon(Icons.search,color: Colors.teal)),
                          Text("点我进行搜索",style: TextStyle(color: Colors.grey,fontSize: 15),)
                        ],
                      ),
                      onTap: (){
                        //这里是跳转搜索界面的关键
                        showSearch(context: context,delegate: SearchBarDelegate());
                      },
                    ),
                  ],
                )

              ),
            )
        ),
        body: FutureBuilder(
          future: myRequest('floor'),
          builder: (context, snapshot) {
            // 判断是否存在值
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              // print("============>>>>>>>>.请求成功");
              // 将map解析为list
              List<Map> swiper = (data['data']['ImgData'] as List).cast();
              List<Map> hotMovieList1 = (data['data']['floor1'] as List).cast();
              List<Map> hotMovieList2 = (data['data']['floor2'] as List).cast();
              List<Map> hotMovieList3 = (data['data']['floor3'] as List).cast();
              List<Map> hotMovieList4 = (data['data']['floor4'] as List).cast();

              // List<Map> navigator = (data['data']['category'] as List).cast();
              // String adPicture =
              //     data['data']['advertesPicture']['PICTURE_ADDRESS'];
              // String leaderImage = data['data']['shopInfo']['leaderImage'];
              // String leaderPhone = data['data']['shopInfo']['leaderPhone'];
              // List<Map> recommendList =
              //     (data['data']['recommend'] as List).cast();
              // String floot1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
              // String floot2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
              // String floot3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
              // List<Map> floor1 = (data['data']['floor1'] as List).cast();
              // List<Map> floor2 = (data['data']['floor2'] as List).cast();
              // List<Map> floor3 = (data['data']['floor3'] as List).cast();

              return EasyRefresh(
                  footer: ClassicalFooter(
                    key: _globalKey,
                    bgColor: Colors.white,
                    textColor: Colors.deepOrange,
                    noMoreText: 'dsa',
                    loadText: '加载中',
                  ),
                  child: ListView(
                    children: <Widget>[
                      SwiperDiy(swperDateList: swiper),
                      Image.asset("assets/images/firstBar.png"),
                      hotPalyer(movieList:hotMovieList1,title:'正在热映'),
                      hotPalyer(movieList:hotMovieList2,title:'即将上映'),
                      hotPalyer(movieList:hotMovieList3,title:'异域风情'),
                      hotPalyer(movieList:hotMovieList4,title:'国产好片'),

                    ],
                  ),
                  onLoad: (){

                  });
            } else {
              return Center(
                child: Text('加载中'),
              );
            }
          },
        ));
  }

  // void _getHotGoods() {
  //   var formData = {'page': page};
  //   request('homePageBelowConten', formData: formData).then((value) {
  //     var data = json.decode(value.toString());
  //     List<Map> newGoodsList = (data['data'] as List).cast();
  //     setState(() {
  //       print(newGoodsList);
  //       hotGoodsList.addAll(newGoodsList);
  //       print(newGoodsList);
  //       page++;
  //     });
  //   });
  // }
/**/
  //TODO 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    alignment: Alignment.center,
    color: Colors.transparent,
    padding: EdgeInsets.all(5),
    child: Text('火爆专区'),
  );

  //TODO 火爆专区主体
  Widget _wrapList() {
    if (hotGoodsList.length != null) {
      List<Widget> listWidget = hotGoodsList.map((e) {
        return InkWell(
          onTap: () {
            Application.router
                .navigateTo(context, '/detail?id=${e['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(370),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: [
                Image.network(e['image'], width: ScreenUtil().setWidth(368)),
                Text(
                  e['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: [
                    Text(
                      '￥${e['mallPrice']}',
                    ),
                    Text(
                      '￥${e['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        //流式布局
        spacing: 2, //每一行两列
        children: listWidget,
      );
    } else {
      return Text('暂无数据');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: [hotTitle, _wrapList()],
      ),
    );
  }
}
//TODO 搜索结果页面
class TextScreen extends StatelessWidget {

  final String s;
  TextScreen({Key key, @required this.s}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return new Scaffold(
      appBar:  AppBar(
        title: Text("搜索结果内容"),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(s),
          )
      ),
    );
  }
}

var nameList = [
  "绿皮南瓜","番茄", "白菜", "胡萝卜","土豆","甜菜","白甜"
];
var data;
void getSearchList(query) async{

  print(query);
  await myGetRequest('http://49.234.103.109:18080/selectMovie'+'?para='+query).then((value){
     data = json.decode(value.toString());
  });
  return data;
}


//TODO 搜索栏
class SearchBarDelegate extends SearchDelegate<String>{


  bool flag;//判断搜索框内输入的内容是否存在于数据列表里
  //返回值为我们搜索框右侧的一个控件
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear,color: Colors.black,),
        onPressed: () {
          query = "";
          showSuggestions(context);
        }, //搜索值为空
      )
    ];
  }

  //返回值为我们搜索框左侧的一个控件
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation
        ),
        onPressed: () => close(context, null)  //点击时关闭整个搜索页面
    );
  }

  //返回值为我们搜到内容后的展现
  @override
  Widget buildResults(BuildContext context) {

    getSearchList(query);
    Timer(Duration(seconds: 2), (){
      // Do something
      print('====查询到结果');
      List<Map> resultList = (data['data'] as List).cast();
      print(data);
    });


    if (data['data'].length!=0) {
      flag = true;
    }else{
      flag =false;
    }
    // for(int i=0;i<data.length;i++){
    //
    //   if(query==data[i]){
    //     flag = true;
    //     break;
    //   }
    //   else{
    //     flag = false;
    //   }
    // }
    Widget searchItem (data){
      return ListView.builder(
        itemCount: data['data'].length,
        itemBuilder: (context,index){
          return InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Image.network(data['data'][index]['image'],height: ScreenUtil().setHeight(130),width: ScreenUtil().setWidth(100),),
                  Column(
                    children: [
                      Text(data['data'][index]['title']),
                      Text(data['data'][index]['actor'])
                    ],
                  )
                ],
              ),
            ),
            onTap: (){
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) =>  TextScreen(s: query),
                  //TextScreen()用于展示我们想要通过搜索到达的页面，
                  //这里用到了构造函数传值。
                ),
              );
            },
          );
        },
      );
    }

    return flag == true ? Padding(
        padding: EdgeInsets.all(16),
        child: searchItem(data)
    )
        :
    Center(
      child: Text("没有找到这个结果！！！"),
    );
  }

  //设置推荐
  @override
  Widget buildSuggestions(BuildContext context) {
    final recentSuggest = [];
    final searchList = [];
    final suggestionsList= query.isEmpty ? recentSuggest
        :
    searchList.where((input)=> input.startsWith(query)).toList();
//判断集合中的字符串是否以搜索框内输入的字符串开头，
//是则返回true，并将筛选出来的结果以list的方式储存在searchList里
    return ListView.builder(
        itemCount:suggestionsList.length,
        itemBuilder: (context,index) {
          return InkWell(
            child: ListTile(
              title: RichText( //富文本
                text: TextSpan(
                    text: suggestionsList[index].substring(0,query.length),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionsList[index].substring(query.length),
                          style: TextStyle(color: Colors.grey)
                      )
                    ]
                ),
              ),
            ),
            onTap: (){
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new TextScreen(s: suggestionsList[index]),
                ),
              );
            },
          );
        }
    );
  }

  //返回一个主题，也就是可以自定义搜索界面的主题样式
  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context);
  }
}

//TODO 正在热映
class hotPalyer extends StatelessWidget {
  final List movieList;
  final String title;
  hotPalyer({this.movieList,this.title,});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(440),
      margin: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          hotTitle(title),
          hotList()
        ],
      ),
    );
  }
  //电影列表
  Widget hotList(){
    return Container(
      height: ScreenUtil().setHeight(380),
      child:ListView.builder(

          scrollDirection: Axis.horizontal,
          itemCount: movieList.length,

          itemBuilder:(context,index){
            return   MovieBar(movieList,index);
          }
      ),
    );
  }
  //标题
  Widget hotTitle(text){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          hotLeftTitle(text),
          hotRightTitle()
        ],
      ),
    );
  }
  //标题左
  Widget hotLeftTitle(text){
    return Container(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(30),
              fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  //标题右
  Widget hotRightTitle(){
    return InkWell(
      child: Text(
        '查看更多>>',
        style: TextStyle(
            color: Colors.black38
        ),
      ),
      onTap: (){
          print('查看更多');
      },
    );


    //   Container(
    //   margin: EdgeInsets.only(right: 10),
    //   child: Text(
    //     '查看更多>>',
    //     style: TextStyle(
    //       color: Colors.black38
    //     ),
    //   ),
    // );
  }



}


//TODO 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swperDateList;
  //构造函数
  SwiperDiy({this.swperDateList});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        //swiper构造器
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swperDateList[index]['image']}",
            fit: BoxFit.cover,
          );
        },
        itemCount: 4,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}



// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController typeController = TextEditingController();
//   String showText = '欢迎您的到来';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('美好人间'),
//       ),
//       body:
//       SingleChildScrollView(
//         child:Container(
//           child: Column(
//             children: <Widget>[
//               TextField(
//                 controller: typeController,
//                 decoration: InputDecoration(
//                     contentPadding: EdgeInsets.all(10.0),
//                     labelText: '美女类型',
//                     helperText: '请输入你喜欢的类型'),
//                 autofocus: false,
//               ),
//               RaisedButton(
//                 onPressed: () {
//                   _choiceAction();
//                 },
//                 child: Text('选择完毕'),
//               ),
//               Text(
//                 showText,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//               )
//             ],
//           ),
//         ),
//       )

//     );
//   }

//   void _choiceAction() {
//     print('开始选择你喜欢的类型');
//     if (typeController.text.toString() == "") {
//       showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//                 title: Text('类型不能为空'),
//               ));
//     } else {
//       getHttp(typeController.text.toString()).then((value) => {
//             setState(() {
//               showText = value['data']['name'].toString();
//             })
//           });
//     }
//   }

//   Future getHttp(String typeText) async {
//     try {
//       Response response;
//       var data = {"name": typeText};
//       response = await Dio().get(
//           "http://www.myhost.com:7300/mock/5ee72f8c240df931e03ec5a2/tipsList",
//           queryParameters: data);
//       return response.data;
//     } catch (e) {
//       return print(e);
//     }
//   }
// }

//TODO 伪造请求头
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   String showText  ='暂无数据';
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('请求远程数据'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               RaisedButton(
//                 child: Text('请求数据'),
//                 onPressed: _jike,
//               ),
//               Text(showText)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _jike(){
//     print('开始请求');
//     getHttp().then((value) => {
//       setState((){
//         showText = value.toString();
//       })
//     });
//   }
//
//
//   Future getHttp() async {
//     try{
//       Response response ;
//       Dio dio  = new Dio();
//       dio.options.headers = httpHeader;
//       response = await dio.post('https://time.geekbang.org/serv/v1/column/labels');
//       print(2);print(response);
//       return response.data;
//     }catch(e){
//       print(1);
//       return print(e);
//     }
//   }
// }
