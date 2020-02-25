import 'dart:async';
import 'dart:io';
import 'dart:convert';


import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:softwaretalks_app/utils/internet/response.dart';
import 'package:softwaretalks_app/utils/system/debug_release.dart';


/*

enum network_errors{

}
*/



///use for FutureBuilder [ inside builder ]
///            if (snapshot.hasData==false){
///              return handleLoading(snapshot);
///            }
///
///            if(isErrorOccurred(snapshot)){
///              return returnErrorWidget(getErrorMessage(snapshot),messageColor: Colors.red);
///            }else{
///             return view
///            }
Widget handleLoading(){

//  if (snapshot.connectionState=ConnectionState.waiting) can used
    return Padding(//SizedBox.expand not true work in listview in category page
      padding: EdgeInsets.all(16),
      child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator()
      ),
    );

}


///Support Types Now :
///http.Response -
///AsyncSnapshot<http.Response> -
///DioError -
/*
bool isErrorOccurred(dynamic object){

  bool result=false;

  if(object==null) {
    result = true;
    debugPrint("object is null isErrorOccurred");
  }


  if(object is AsyncSnapshot){// AsyncSnapshot used in FutureBuilder      have http.Response or DioError
    if(object.error!=null) {// network exception
      result= true;
    }else if(object.data is http.Response){
      result= !isServerResponseCorrect(object.data);
    }else if(object.data is DioError){
      result= true;
    }

  }


  if(object is http.Response){// http.Response  that
    result= !isServerResponseCorrect(object);
  }

  if(object.data is DioError){ //have dio.response in dioError that have httpStatus and like http.response
    result= true;
  }


  if (object is ResponseError) {
    result= true;//object.code;
  }

  return result;



}
*/



///Support Types Now :
///http.Response -
/*
bool isServerResponseCorrect(http.Response object){
  if(object.statusCode==HttpStatus.ok ){
    var response = BaseResponse(json.decode(object.body));
    if(response.success)
      return true;
    else
      return false;
  }else{
    return false;
  }
}

*/







///Support Types Now :
///http.Response |
///FutureBuilder AsyncSnapshot<http.Response> |
///DioError |
///dio.Response
String getErrorMessage(dynamic object) {


  String message="";
  //we have 3 type of error :
  // network error in mobile
  // http error in server
  // backend error


  if (object is AsyncSnapshot) {// for futureBuilder
    if (object.error != null) {
      if(object.error is BaseResponse){
        message = getServerErrorMessage(object.error);
      }else{// network error
        message = getNetworkExceptionMessage(object.error);
      }
    } else if (object.data is http.Response) {// for package http response
      message =  getServerErrorMessage(BaseResponse(json.decode(object.data.body)));
    }
  }else if (object is dio.Response){// like http.Response have httpStatus
    message =  getServerErrorMessage(BaseResponse(json.decode(object.data.body)));
  }else if(object is http.Response){//happend in http package request time
    message =  getHttpErrorMessage(object.statusCode);
  }else if(object is dio.DioError){// happend in dio package request time
    message =  getNetworkExceptionMessage(object);
  }else if (object is ResponseError) {
    message =  object.message;
  }else if (object is BaseResponse) {
    message =  getServerErrorMessage(object);
  }else if (object is EmptyReponseException) {
    message =  object.message;
  }


  if(message.length==0){
    message=getNetworkExceptionMessage(object);// for time that netword exception sent straight to func [ sent with http package ]
  }



  if (object is NoSuchMethodError) {// occurd in sending request time
    message =  "عملیات روی داده ی خالی";
  }



  if (object is FormatException) {// occurd in sending request time
    message =  "خطای نوع داده ، لطفا مقادیر عددی را عددی و رشته ای را رشته ای وارد نمایید";
  }

  if (object is TypeError) {// occurd in sending request time
    message =  "خطای عدم همخوانی نوع داده ها";
  }

  if (object is CastError) {// occurd in sending request time
    message =  "خطای عدم همخوانی نوع داده ها";
  }

  if(message.length==0)
    return "خطای نا معلوم";
  else
    return message;

}



String getServerErrorMessage(BaseResponse baseResponse){
    if(baseResponse.error!=null){
      if(DeviceUtils.currentBuildMode()==BuildMode.DEBUG && baseResponse.error.technical_message!=null )
        return baseResponse.error.technical_message;
      else
        return baseResponse.error.message;

    }else{
      return "خطا در سرور ، نوع خطا از سمت سرور ارسال نشد";
    }

}



enum Type {
  ResponseNullException,ResponseEmptyException,ResponseBadFormatException,// my defined classes
  SocketException,SocketTimeout,ConnectToNetwork,UnknownHost,MalformedJson, UnknownException,
  IOException,// this line for soap exception
}



String getNetworkExceptionMessage(dynamic t) {// request that not send to server because network eror

  String message = '';
  Type e;
  if(t is DioError){
    e = getNetworkExceptionType(t.error);
  }else{
    e = getNetworkExceptionType(t);
  }

  switch (e){
    case Type.SocketException:
      message = "خطای اتصال به اینترنت";
      break;
    case Type.SocketTimeout:
      message = "در زمان مناسب پاسخی دریافت نشد";
      break;
    case Type.ConnectToNetwork:
      message = "لطفا دسترسی به اینترنت را فعال نمایید";
      break;
    case Type.UnknownHost:
      message = "هاست شناسایی نشد";
      break;
    case Type.MalformedJson://in gson
      message = "نوع داده ی دریافت شده صحیح نمی باشد";
      break;
    case Type.ResponseNullException://my definedClass that extends Throwable
      message = "پاسخی دریافت نشد ، دوباره تلاش کنید";
      break;
    case Type.ResponseEmptyException://my definedClass that extends Throwable
      message = "پاسخ خالی است";
      break;
    case Type.ResponseBadFormatException://my definedClass that extends Throwable
      message = "فرمت جواب از سرور نامعلوم است";
      break;
    case Type.IOException:
      message = "خطای اتصال به ورودی";
      break;
    case Type.UnknownException:
      message = "";//"خطای ناشناخته";
      break;
  }

  if(message.length==0){
    if(t is http.Response) {
      message = getHttpErrorMessage(t.statusCode);
    }else if (t is dio.DioError){
      message = getHttpErrorMessage(t.response.statusCode);
    }
  }

  return message;

}



Type getNetworkExceptionType(dynamic t) {


  if(t is SocketException){
    return Type.SocketException;
  }else if(t is IOException){
    return Type.IOException;
  }else if(t is TimeoutException){ // not tested
    return Type.SocketTimeout;
  }



  return Type.UnknownException;




/* for java

///
///    used of simplename to avoid of importing foreign class to this module [ like MalformedJsonException in Gson ]



    String className = t.getClass().getSimpleName();
    if (className.contains("SocketTimeoutException")){//t instanceof SocketTimeoutException
    }else if (className.contains("ConnectException")){//t instanceof ConnectException
        return Type.ConnectToNetwork;
    }else if (className.contains("UnknownHostException")){//t instanceof UnknownHostException
        return Type.UnknownHost;
    }else if (className.contains("MalformedJsonException")){//t instanceof MalformedJsonException
        return Type.MalformedJson;
    }else if (className.contains("ResponseNullException")){//in my define //t instanceof ResponseNullException
        return Type.ResponseNullException;
    }else if (className.contains("ResponseEmptyException")){//in my define //t instanceof ResponseNullException
        return Type.ResponseEmptyException;
    }else if (className.contains("ResponseEmptyException")){//in my define //t instanceof ResponseNullException
        return Type.ResponseEmptyException;
    }else if (className.contains("IOException")) { //t instanceof ResponseNullException
        return Type.IOException;
    }

*/


}




String getHttpErrorMessage(int statusCode ){// request that sent to server and receive http error of server
  if(statusCode==HttpStatus.ok ){
//    return _getServerErrorMessage(object);
  }else if(statusCode==HttpStatus.notFound){//404
    return "این وب سرویس موجود نیست";
  }else if(statusCode==HttpStatus.forbidden){//403
    return "این درخواست بلاک شده است";
  }else if(statusCode==HttpStatus.methodNotAllowed){//405
    return "این متد اجازه ی فراخوانی ندارد";
  }else if(statusCode==HttpStatus.requestTimeout){//408
    return "در زمان مناسب پاسخی دریافت نشد";
  }else if(statusCode==HttpStatus.requestEntityTooLarge){//413
    return "حجم این درخواست بیش از حد مجاز است";
  }else if(statusCode==HttpStatus.requestUriTooLong){//414
    return "آدرس وب سرویس خیلی طولانی است";
  }else if(statusCode==HttpStatus.unsupportedMediaType){//415
    return "این نوع داده ساپورت نمی شود";
  }else if(statusCode==HttpStatus.networkAuthenticationRequired){//511
    return "اتصال به اینترنت نیاز به اعتبار سنجی دارد";
  }else if(statusCode==HttpStatus.networkConnectTimeoutError){//599
    return "در زمان مناسب اتصال به اینترنت انجام نشد";
  }else if(statusCode==500){//Internal Server Error
    return "خطا داخلی سمت سرور ، کد خط : " + statusCode.toString();
  }else if(statusCode==504){//Internal Server Error
    return "در زمان مناسب پاسخی از سمت سرور دریافت نشد";
  }else{
    //future send error code to server
    return "در درخواست خطایی رخ داده ، کد خطا : " + statusCode.toString();
  }
}





//region view
Widget returnErrorWidget(String message,{Color messageColor=Colors.red}){

  return Container(
    child: Center(
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                message,
                style:TextStyle(color: messageColor,fontFamily: 'BYekan',fontSize: 18),
              ),
            ),
          )
      ),
    ),
  );

}

Widget returnErrorWidgetWithTryAgain(String message,Function tryAgain,{double fontSize= 18,Color messageColor=Colors.red}){

  return Padding(
    padding: EdgeInsets.all(16),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: <Widget>[
          Text(
            message,
            style:TextStyle(color: messageColor,fontFamily: 'BYekan',fontSize: fontSize),
          ),
          const SizedBox(height: 12,),
          FlatButton(
            padding: EdgeInsets.all(2),
            child: Text("تلاش دوباره",style: TextStyle(color: Colors.white,fontFamily: 'BYekan'),),
            onPressed: (){
              tryAgain();// reload page
            },
            color: Colors.green,
          ),
        ],
      ),
    ),
  );

}




void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey,String message,{Color messageColor=Colors.red}){

/*
 not work easly all time
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(message,style:TextStyle(color: messageColor,fontFamily: 'BYekan',fontSize: 24),
        )
    ),
  ));
*/

  //or
  scaffoldKey.currentState.showSnackBar(
      SnackBar(
//        duration: Duration(seconds: 10),
        content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(message,style:TextStyle(color: messageColor,fontFamily: 'BYekan',fontSize: 20),
            )
        ),
      ));

}
//endregion





class EmptyReponseException with Exception{
  String message;

  EmptyReponseException(this.message);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }

}