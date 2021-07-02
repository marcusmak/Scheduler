import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

class RealTimeline extends AnimatedWidget{

  RealTimeline({
    Key? key,
    required AnimationController controller,
    required this.duration,
    required this.startTime,
    this.width,
    required this.height,
  }) : super(key: key, listenable: controller){
    initStackWidgets();
  }

  Animation<double> get _progress => listenable as Animation<double>;
  double? width;
  double? height;
  Duration? duration;
  TimeOfDay? startTime;
  int get startTimeeOffset => (startTime!.minute > 30)?60 - startTime!.minute:30-startTime!.minute;

  late Size screenSize;
  late List<Widget> stackWidgets = [];
  var add30 = (TimeOfDay time) => (time.minute + 30) >= 60? TimeOfDay(hour: time.hour +1 , minute: (time.minute-30)):time.replacing(minute:time.minute+30);
  void recGen (TimeOfDay start, Duration duration, {int level = 0}){
    
      if(duration.compareTo(Duration(minutes:30)) < 0)
        return;
      // if(start.minute > 30){
        // print((start.hour+1).toString() +":00  , pos: " + ((this.startTimeeOffset + level*30)/ this.duration!.inMinutes).toString() ) ;
      this.stackWidgets.add(
        Padding(
          padding: EdgeInsets.only(left: 15),
          child:
            Baseline(
              baseline:  (this.startTimeeOffset + level*30)/ this.duration!.inMinutes * this.height!,
              baselineType: TextBaseline.ideographic, 
              child:
                start.minute > 30?
                    Text((start.hour+1).toString() +":00",style: TextStyle(color: Colors.white),):
                    Text((start.hour).toString() +":30",style: TextStyle(color: Colors.white),)

            ),
        )
      );
      // }
      // else
      //   print((start.hour).toString() +":30" ) ;
      recGen(add30(start),duration - Duration(minutes: 30), level: level+1);

    
  }

  void initStackWidgets(){
    // this.startTime
    print("init");
    recGen(this.startTime!,this.duration!);
  }



  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    // return Transform.rotate(
    //   angle: _progress.value * 2.0 * pi,
    //   child: Container(width: 200.0, height: 200.0, color: Theme.of(context).primaryColor),
    // );
    // print(_progress.value);
    return SizedBox(
      height: this.height,
      child: Stack(
        children:[
          ...stackWidgets,
          Padding(
            padding: EdgeInsets.only(left:0.0),
          
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: 
                    Baseline(
                      baseline: 3+ this.height! * _progress.value,
                      baselineType: TextBaseline.ideographic, 
                      // child: Icon(Icons.play_arrow, color: Colors.white,)
                      child: SizedBox(
                        width:60,
                        height:30,
                        child: Stack(
                        children:[
                          Image.asset("assets/img/tag.png", width: 60, height: 30,),
                          Center(child:Padding(child:Text("NOW",style: TextStyle(fontWeight: FontWeight.w900),),padding: EdgeInsets.only(right:10),))
                        ]))
                    ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child:LinearProgressIndicator(
                      value: _progress.value,
                      valueColor: AlwaysStoppedAnimation(Colors.amber),
                      backgroundColor: Theme.of(context).primaryColor,
                  )
                )
              ],
            )
          ),
         
        ]
      )
    );
  }
}