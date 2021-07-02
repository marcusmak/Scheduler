import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scheduler/Components/RealTimeline.dart';
import 'package:scheduler/Components/EventsView.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, //required
     required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State{

  late void Function() onPressedListView;
  late void Function() onPressedDownload;
  late void Function() onPressedLock;
  late void Function() onPressedPlay;
  late void Function() onPressedAdd;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onPressedListView = ()=>{print("onPressedListView")};
    onPressedDownload = ()=>{print("onPressedDownload")};
    onPressedLock     = ()=>{print("onPressedLock")};
    onPressedPlay     = ()=>{print("onPressedPlay")};
    onPressedAdd      = ()=>{print("onPressedAdd")};
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        shape: Border(bottom: BorderSide(color: primaryColor)),
        shadowColor: primaryColor,
        leading: IconButton(icon: Icon(Icons.reorder_rounded,color: primaryColor ,size: 40.0,), onPressed: onPressedListView ),
        title: TimeDisplayer(),
        centerTitle: true,
        actions: [
          Center(child:Text(getTimeZone(),style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900),)),

        ],
      ),
      body: Column(
        children:[
          Expanded(child: TimeLineComponent(duration: Duration(hours: 3),),),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
            height: MediaQuery.of(context).size.height * 0.085,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: onPressedDownload, icon: Icon(Icons.download_rounded, color: Colors.black ,size: 40.0,),),
                IconButton(onPressed: onPressedLock, icon: Icon(Icons.lock_rounded,   color: Colors.black ,size: 40.0,),),
                IconButton(onPressed: onPressedPlay, icon: Icon(Icons.play_arrow_rounded, color: Colors.black ,size: 40.0,),),
                IconButton(onPressed: onPressedAdd, icon: Icon(Icons.add_rounded, color: Colors.white ,size: 40.0,),),
            ],),
          )
          
        ]
      ),
    );
  }
  


  String getTimeZone(){
    DateTime current = DateTime.now();
    Duration offset = current.timeZoneOffset;
    String name = current.timeZoneName;
    return name + "\nGMT+" + offset.inHours.toString();

  }

}

class TimeLineComponent extends StatefulWidget {
  Duration duration;
  TimeLineComponent({Key? key, required this.duration}) : super(key: key);

  @override
  _TimeLineComponentState createState() => _TimeLineComponentState();
}

class _TimeLineComponentState extends State<TimeLineComponent> with TickerProviderStateMixin {
  
  late final AnimationController _controller = AnimationController(
    // duration: const Duration(seconds: 10),
    duration: this.widget.duration,
    vsync: this,
  )..repeat();
  
  @override
  Widget build(BuildContext context) {
    print("build realtimeline");
    return SingleChildScrollView(
      
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 3.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(color: Colors.red),
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RealTimeline(
                controller: _controller,
                startTime: TimeOfDay.now(),
                duration: this.widget.duration,
                height: MediaQuery.of(context).size.height
              ),
              EventsView()
            ],
          )
        )
        
       
      )
    );
  }
}
class TimeDisplayer extends StatefulWidget {
  TimeDisplayer({Key? key}) : super(key: key);

  @override
  _TimeDisplayerState createState() => _TimeDisplayerState();
}

class _TimeDisplayerState extends State<TimeDisplayer> {
  late DateTime _now;
  late Timer _timer;

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  void initState() { 
    super.initState();
    _updateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text(getCurrentTime(),style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w900),)
    );
  }

  String getCurrentTime(){
    // Clock
    DateTime current = _now;
    return (current.hour.toString() + ":" + ((current.minute<10)?"0":"") + current.minute.toString() + ":" +((current.second<10)?"0":"") + current.second.toString());
     
  }
}