import 'package:flutter/material.dart';
import 'package:medminder/src/ui/new_entry/new_entry.dart';
//import 'package:provider/provider.dart';
//import 'package:medminder/src/global_bloc.dart';
import 'package:medminder/src/models/medicine.dart';
//import 'package:medminder/src/ui/medicine_details/medicine_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Medicines medicines= new Medicines();
  void initState() {
    super.initState();
    print(medicines.medicines.length);
  }

  @override
  Widget build(BuildContext context) {
  //  final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3EB16F),
          elevation: 0.0,
        ),
        body: Container(
          color: Color(0xFFF6F8FC),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: TopContainer(),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                  flex: 7,
                 // child: Provider<GlobalBloc>.value(
                    child: BottomContainer(),
                  //  value: _globalBloc,
                  ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 4,
            backgroundColor: Color(0xFF3EB16F),
            child: Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewEntry(),
                  ));
            }));
  }
}

class TopContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(50, 27),
          bottomRight: Radius.elliptical(50, 27),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey[400],
            offset: Offset(0, 3.5),
          )
        ],
        color: Color(0xFF3EB16F),
      ),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              "Medminder",
              style: TextStyle(
                fontFamily: "Angel",
                fontSize: 64,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            color: Color(0xFFB0F3CB),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Center(
              child: Text(
                "Number of Medminders",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Container(
      color: Color(0xFFF6F8FC),
      child: Center(
        child: Text(
          "Press + to add a Medminder",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              color: Color(0xFFC9C9C9),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
