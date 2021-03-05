import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieBar extends StatelessWidget {
  List<Map> msg;
  final int index;
  MovieBar(this.msg,this.index);

  @override
  Widget build(BuildContext context) {
    // print("============单个组合");
    // print(msg);
    return Container(
        width: ScreenUtil().setWidth(150),
        margin: EdgeInsets.only(right: 20,top: 10),
        child: Column(
          children: [
            picW(msg[index]['image']),
            _title(msg[index]['title']),
            _scroe(msg[index]['score']),
            _button(index)
          ],
        ),
    );
  }
  Widget picW(src){
    return InkWell(
        child: Container(
          width: ScreenUtil().setWidth(280),
          height: ScreenUtil().setHeight(200),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(src),
                fit: BoxFit.cover,
              )
          ),
        ),
      onTap: (){
      },
    );
  }
  Widget _title(String title){
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.black,
        fontSize: ScreenUtil().setSp(20),
      ),
    );
  }
  //分数
  Widget _scroe(String scroe){
    return Text(
      "评分：${scroe}",
      style: TextStyle(
        color: Colors.black26,
        fontSize: ScreenUtil().setSp(15),
      ),
    );
  }
  // 购片按钮
  Widget _button(index){
    return SizedBox(
      width: ScreenUtil().setWidth(100),
      child:  FlatButton (
        child: Text(
          '购票',
        ),
        color: Colors.red,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        onPressed: (){

        },
      ),
    );

  }
}


