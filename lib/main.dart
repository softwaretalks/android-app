
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:softwaretalks_app/utils/duration.dart';
import 'package:softwaretalks_app/utils/internet/handleResponse.dart';
import 'package:softwaretalks_app/web_page.dart';
import 'package:flutter/foundation.dart';

import 'helper/pagewise/flutter_pagewise.dart';

void _setTargetPlatformForDesktop() {
  // No need to handle macOS, as it has now been added to TargetPlatform.
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}


void main() {
  _setTargetPlatformForDesktop();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoListPage(),
    );
  }
}





class VideoListPage extends StatefulWidget{
  VideoListPage();

  @override
  State<StatefulWidget> createState() {
    return VideoListPageState();
  }

}

class VideoListPageState extends State<VideoListPage>{

  final _scaffoldKey = GlobalKey<ScaffoldState>(); // in this time use to show snackbar



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child:  Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purple,Colors.pink])//Colors.purple
          ),
          child: Column(
//        padding: EdgeInsets.zero,
            children: <Widget>[
            createTitle(context,"Software Talks",[Colors.purple,Colors.pink],),
//                Semantics(button: true,), // for testing
              Expanded(
                child: PagewiseListView<Video>(
                  pageSize: 100,
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  shrinkWrap: false,
                  pageFuture: (pageIndex) {
                    return getList(100,pageIndex);
                  },
                  padding: EdgeInsets.all(16.0),
//                      shrinkWrap: true,
                  itemBuilder: (context, item, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: FlatButton(
//                          color: Colors.white,
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=>VideoPlay(item.frame,item.title)
                            ));
                          },
                          child:                             Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Image.network(item.small_poster,height: 140,),
                                SizedBox(height: 8,),
                                Text(
                                  item.title,
                                  style: TextStyle(color: Colors.black87,fontFamily: "BYekan",fontSize: 20),
                                  softWrap: true,
                                ),
                                SizedBox(height: 8,),
                                Text(
                                  "مدت زمان :    " + getDurationOfSecond(item.duration),
                                  style: TextStyle(color: Colors.green,fontFamily: "BYekan",fontSize: 18),
//                                    overflow: TextOverflow.ellipsis,
//                                    softWrap: true,
//                                    maxLines: 5,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  retryBuilder: (context, callback,error) {
                    return returnErrorWidgetWithTryAgain(getErrorMessage(error), (){
                      callback();
                    });

                  },

                ),
              )

            ],
          ),
        ),
      ),
    );

  }













  Future<List<Video>> getList(int pageSize,int pageCurrent) async {

    List<Video> list = List();


    try {

//      http.Response response = await http.post(baseClubOfoqAddress + "General/GetTableItems",body: qb.toMap()); //can thrown network error

      Response dioResponse = await Dio().get(
        "https://www.aparat.com/etc/api/videoByUser/username/softwaretalks/perpage/200",
//        data: qb.toMap(),
      );
      var list2 = ((jsonDecode(dioResponse.data) as Map)["videobyuser"] as List);
      for(int i=0;i<list2.length;i++)
        list.add(Video.fromMap(list2[i]));
      return list;
    } on DioError catch (e) {// show network error
      rethrow;// throw exception to show retry button on pagewise [ go to catch on pagewise ]
//      return list; // not need , just show empty list
    }catch(e){
      rethrow;
    }



  }































}


class Video{


  static const String keyTitle='title';
  static const String keySmallPoster='small_poster';
  static const String keyFrame='frame';
  static const String keyDuration='duration';


  String title='';
  String small_poster='';
  String frame='';
  int duration=0;



  Video.fromMap(Map o) {
    if (o==null) {return;}

    title=o[keyTitle] ;
    small_poster=o[keySmallPoster] ;
    frame=o[keyFrame] ;
    duration=o[keyDuration] ;

  }


}


Widget createTitle(BuildContext context,String title,List<Color> colors){
  return Directionality(
    textDirection: TextDirection.ltr,// for static icon side to left
    child: Container(
      height: 80,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors)//Colors.purple
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30,),
          Stack(//put into column for max size and center true work
            children: <Widget>[


              Align(
                alignment: Alignment.center,
                child: FlatButton(// text not true worked in aligen

                    onPressed: null,
                    child: Text(title,
                        style:TextStyle(color: Colors.white,fontFamily: "BYekan",fontSize: 24)
                    )
                ),

              ),


            ],
          ),


        ],
      ),
    ),
  );

}
