import 'package:flutter/material.dart';
import 'package:medminder/src/ui/new_entry/new_entry.dart';
//import 'package:provider/provider.dart';
//import 'package:medminder/src/global_bloc.dart';
import 'package:medminder/src/models/medicine.dart';
//import 'package:medminder/src/ui/medicine_details/medicine_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Medicines medicines = new Medicines();
  Medicine medicine = new Medicine();
  List medicinesList = [];
  void initState() {
    super.initState();
  }

  Future<Medicines> getMedicines() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String medicines = preferences.getString("medicines");
    var medicinesList = Medicines.fromJson(json.decode(medicines));
    return medicinesList;
  }

  @override
  Widget build(BuildContext context) {
    //  final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3EB16F),
          elevation: 0.0,
        ),
        body: FutureBuilder(
            future: getMedicines(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loading"),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: CircularProgressIndicator(),
                    )
                  ],
                ));
              } else {
                if (snapshot.hasError) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${snapshot.error}"),
                      Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: RaisedButton(
                          child: Text("Try again"),
                          onPressed: () {
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ));
                }
                return Container(
                  color: Color(0xFFF6F8FC),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: TopContainer(
                          number: snapshot.data.medicines.length,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        flex: 7,
                        // child: Provider<GlobalBloc>.value(
                        child: snapshot.data.medicines.length == 0
                            ? BottomContainer()
                            : ListView.builder(
                                itemCount: snapshot.data.medicines.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: ClipOval(
                                        child: Icon(snapshot
                                            .data
                                            .medicines[index]
                                            .medicineType
                                            .icon),
                                      ),
                                    ),
                                    title: Text(
                                      "${snapshot.data.medicines[index].getName}",
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        snapshot.data.medicines.remove(index);
                                      },
                                    ),
                                  );
                                }),
                        //  value: _globalBloc,
                      ),
                    ],
                  ),
                );
              }
            }),
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
  int number;

  TopContainer({this.number});
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
                "Number of Medminders: ${this.number}",
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

class MedicinesList extends StatelessWidget {
  Medicine medicine;
  int index;
  List<Medicine> medicines;

  MedicinesList({this.medicine, this.index, this.medicines});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: ClipOval(
          child: Icon(medicine.medicineType.icon),
        ),
      ),
      title: Text(
        "${this.medicine.getName}",
      ),
      trailing: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {
          // setState(() {
          //   this.medicines.;
          // });
        },
      ),
    );
  }
}
