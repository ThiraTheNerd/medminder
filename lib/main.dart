import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medminder/src/ui/homepage.dart';

void main() {
  runApp(MedicineReminder());
}
class MedicineReminder extends StatefulWidget{
  @override
  _MedicineReminderState createState() => _MedicineReminderState();
}
class _MedicineReminderState extends State<MedicineReminder> {
  @override
  Widget build(BuildContext context) {
    return Container(
    //return Provider<GlobalBloc>. value (
      //value: GlobalBloc,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),

    );
  }
}
