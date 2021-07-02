import 'package:flutter/material.dart'  hide ReorderableList;

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'LocalDataManager.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key,
    required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class EventData {
  EventData(this.title, this.key);
  String title;
  // Each item in reorderable list needs stable and unique key
  Key key;

  EventData.fromMap(Map<String,dynamic> element):
    this.title = element.containsKey('title')?element['title']:"",
    this.key = element.containsKey('id')?ValueKey(element['id']):Key(""),
    assert(!element.containsKey('id'),"Json object has to contain id as key")
  {
    
  }
}

enum DraggingMode {
  iOS,
  Android,
}

class _MyHomePageState extends State<MyHomePage> {

  void updateList(){
    LocalDataManager.FetchEvents().then((value) =>
        setState(
                ()=>{
              _events = value!
            }
        )
      // print(value.length.toString())
    );
  }
  //late
  List<EventData> _events = [];
  _MyHomePageState() {
    updateList();
    // // _events = [];
    // for (int i = 0; i < 20; ++i) {
    //   String label = "List event $i";
    //   if (i == 5) {
    //     label += ". This event has a long label and will be wrapped.";
    //   }
    //   _events.add(EventData(label, ValueKey(i)));
    // }
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _events.indexWhere((EventData d) => d.key == key);
  }

  bool _reorderCallback(Key event, Key newPosition) {
    int draggingIndex = _indexOfKey(event);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedEvent = _events[draggingIndex];
    setState(() {
      debugPrint("Reordering $event -> $newPosition");
      _events.removeAt(draggingIndex);
      _events.insert(newPositionIndex, draggedEvent);
    });
    return true;
  }

  void _reorderDone(Key event) {
    final draggedEvent = _events[_indexOfKey(event)];
    debugPrint("Reordering finished for ${draggedEvent.title}}");
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(45, 45, 45, 1),
      body: ReorderableList(
        onReorder: this._reorderCallback,
        onReorderDone: this._reorderDone,
        child: CustomScrollView(
          // cacheExtent: 3000,
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                PopupMenuButton<DraggingMode>(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text("Options"),
                  ),
                  initialValue: _draggingMode,
                  onSelected: (DraggingMode mode) {
                    setState(() {
                      _draggingMode = mode;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<DraggingMode>>[
                    const PopupMenuItem<DraggingMode>(
                        value: DraggingMode.iOS,
                        child: Text('iOS-like dragging')),
                    const PopupMenuItem<DraggingMode>(
                        value: DraggingMode.Android,
                        child: Text('Android-like dragging')),
                  ],
                ),
                IconButton(icon: Icon(Icons.add), onPressed: (){
                  print("add");
                  showDialog(
                    context: context,
                    builder:
                      (BuildContext context){
                        TextEditingController _controller = TextEditingController();
                        String title;
                        double period;
                        int start_date;
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          // titleTextStyle: TextStyle(color:Colors.white),
                          title: Text('Add an event'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children:[
                                  Text("Event name"),
                                  Container(
                                    width: 100.0,
                                    child:
                                    TextField(
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            height: 2.0,
                                            color: Colors.black
                                        ),
                                      decoration: InputDecoration(
                                        // border: OutlineInputBorder(),
                                        // labelText: 'Password',
                                      ),
                                        controller: _controller,
                                    //     onSubmitted: (String value){
                                    //         print(value);
                                    //       }
                                    )
                                  ),
                                ]
                              ),
                            ],
                          ),
                          actions: [
                            FlatButton(
                              textColor: Color(0xFF6200EE),
                              onPressed: () {Navigator.pop(context);},
                              child: Text('CANCEL'),
                            ),
                            FlatButton(
                              textColor: Color(0xFF6200EE),
                              onPressed: () {
                                LocalDataManager.AddEvent(_controller.text, updateList);
                                Navigator.pop(context);
                              },
                              child: Text('ACCEPT'),
                            ),
                          ],
                        );
                    }
                  );
                })
              ],
              pinned: true,
              expandedHeight: 150.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: const Text('Scheduler'),
              ),

            ),
            SliverPadding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Item(
                        data: _events[index],
                        // first and last attributes affect border drawn during dragging
                        isFirst: index == 0,
                        isLast: index == _events.length - 1,
                        draggingMode: _draggingMode,
                      );
                    },
                    childCount: _events.length,
                  ),
                )),

            
          ],
          
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item({
    required 
    this.data,
    required 
    this.isFirst,
    required 
    this.isLast,
    required 
    this.draggingMode,
  });

  final EventData data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Color.fromRGBO(45, 45, 45, 1),);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: EdgeInsets.only(right: 18.0, left: 18.0),
              color: Color(0x08000000),
              child: Center(
                child: Icon(Icons.reorder, color: Color(0xFF888888)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                    child: Text(data.title,
                        // style: Theme.of(context).textTheme.subtitle1),

                        style:
                        (state == ReorderableItemState.dragProxy ||
                            state == ReorderableItemState.dragProxyFinished)?
                        TextStyle(color:Colors.black):
                        TextStyle(color:Colors.white)
                    ),
                  )),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}