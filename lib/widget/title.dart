import 'package:flutter/material.dart';



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
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  onPressed: (){
                    Navigator.pop(context,);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),

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
