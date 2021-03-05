import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';

Handler detailsHandler = Handler(
  handlerFunc: (BuildContext _context,Map<String,dynamic> _params){
    String goodsId = _params['id'].first;
    print('index>details goodsId is ${goodsId}');
    return DetailsPage(goodsId);
  }
);