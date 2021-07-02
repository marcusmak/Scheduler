import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {
  EventsView({Key? key}) : super(key: key);

  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Baseline(
          baseline: 100,
          baselineType: TextBaseline.ideographic,
          child:Container(
              padding: EdgeInsets.zero,
              width: MediaQuery.of(context).size.width * 0.8,
              // decoration: BoxDecoration(color: Colors.white),
              child: EventView(height: 60)
            )
          )
    );
  }
}

class EventView extends StatelessWidget {
  const EventView({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RotatedBox(
            quarterTurns: -2,
            child: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor,)
          ),
          Expanded(
            flex: 3, 
            child: Padding(
              padding: EdgeInsets.only(right:5.0),
              child:Container(
                height: this.height,
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
               child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text("over ",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                            Text("57 S", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          ]
                        ),
                        Text("OPENING", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                      ],
                    ),

                  
                  
              ),
            )
          ),
          Expanded(
            flex: 5, 
            child: Container(
              height: this.height,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topRight:Radius.circular(5.0), bottomRight: Radius.circular(5.0))
              ),
              child: Stack(
                children:[
                Row(
                // mainAxisAlignment:MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children:[
                  Expanded(
                    child: Text("123")
                  ),
                  Icon(Icons.reorder_rounded, size: 30,),
                  Icon(Icons.check, size: 30,),


                ]
              ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    alignment:Alignment.bottomLeft, 
                    child:Text("Fixed start", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                  )
              ],
                    
              )
            ),
          )
        ],
      )
    );
  }
}
