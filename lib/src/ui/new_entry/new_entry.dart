import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medminder/src/models/medicine.dart';
import 'package:provider/provider.dart';
import 'package:medminder/src/models/medicine_type.dart';
import 'package:medminder/src/global_bloc.dart';
import 'package:medminder/src/ui/new_entry/new_entry_bloc.dart';
import 'package:medminder/src/common/convert_time.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medminder/src/ui/success_screen/success_screen.dart';
import 'package:medminder/src/ui/homepage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NewEntry extends StatefulWidget {
  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  TextEditingController nameController;
  TextEditingController dosageController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NewEntryBloc _newEntryBloc;

  List<Medicine> medicineList = [];
  String iconValue = "";
  MedicineTypeModel selectedMedicineType;

  GlobalKey<ScaffoldState> _scaffoldKey;

  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    _newEntryBloc = NewEntryBloc();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    this.selectedMedicineType = new MedicineTypeModel();

    getMedicines();
  }

  Future<Medicines> getMedicines() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String medicines = preferences.getString("medicines");
    var medicinesList = Medicines.fromJson(json.decode(medicines));

    this.medicineList = medicinesList.medicines;
    return medicinesList;
  }

  @override
  Widget build(BuildContext context) {
    //final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xFF3EB16F),
        ),
        centerTitle: true,
        title: Text(
          "Add New Mediminder",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Provider<NewEntryBloc>.value(
          value: _newEntryBloc,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            children: <Widget>[
              PanelTitle(
                title: "Medicine Name",
                isRequired: true,
              ),
              TextFormField(
                maxLength: 12,
                style: TextStyle(
                  fontSize: 16,
                ),
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              PanelTitle(
                title: "Dosage in mg",
                isRequired: false,
              ),
              TextFormField(
                controller: dosageController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 16,
                ),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              PanelTitle(
                title: "Medicine Type",
                isRequired: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: StreamBuilder<MedicineType>(
                  stream: _newEntryBloc.selectedMedicineType,
                  builder: (context, snapshot) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() => this.selectedMedicineType =
                                            MedicineTypeModel(
                                                type: MedicineType.Bottle,
                                                name: "Bottle",
                                                icon: FontAwesomeIcons
                                                    .prescriptionBottle,
                                                isSelected: snapshot.data ==
                                                        MedicineType.Bottle
                                                    ? true
                                                    : false)
                                        // print(this.selectedMedicineType.name);
                                        );
                                  },
                                  child: MedicineTypeColumn(
                                      type: MedicineType.Bottle,
                                      name: "Bottle",
                                      icon: FontAwesomeIcons.prescriptionBottle,
                                      isSelected:
                                          snapshot.data == MedicineType.Bottle
                                              ? true
                                              : false))),
                          Expanded(
                              child: MedicineTypeColumn(
                                  type: MedicineType.Pill,
                                  name: "Pill",
                                  icon: FontAwesomeIcons.pills,
                                  isSelected: snapshot.data == MedicineType.Pill
                                      ? true
                                      : false)),
                          Expanded(
                              child: MedicineTypeColumn(
                                  type: MedicineType.Syringe,
                                  name: "Syringe",
                                  icon: FontAwesomeIcons.syringe,
                                  isSelected:
                                      snapshot.data == MedicineType.Syringe
                                          ? true
                                          : false)),
                          Expanded(
                              child: MedicineTypeColumn(
                                  type: MedicineType.Tablet,
                                  name: "Tablet",
                                  icon: FontAwesomeIcons.tablets,
                                  isSelected:
                                      snapshot.data == MedicineType.Tablet
                                          ? true
                                          : false)),
                        ]);
                  },
                ),
              ),
              PanelTitle(
                title: "Interval Selection",
                isRequired: true,
              ),
              IntervalSelection(),
              PanelTitle(
                title: "Starting Time",
                isRequired: true,
              ),
              SelectTime(),
              SizedBox(
                height: 35,
              ),
              Row(children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(),
                  child: Container(
                    width: 220,
                    height: 50,
                    child: FlatButton(
                      color: Color(0xFF007bff),
                      shape: StadiumBorder(),
                      child: Center(
                          child: Text(
                        "Add new",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      )),
                      onPressed: () {
                        Medicine medicine = new Medicine(
                            medicineName: nameController.text,
                            dosage: int.parse(dosageController.text),
                            medicineType: this.selectedMedicineType,
                            interval: IntervalSelectionState()._selected,
                            startTime: SelectTimeState()
                                ._selectTime(context)
                                .toString());
                        medicineList.add(medicine);

//                      String medicineName;
//                      int dosage;
//                      String medicineType = _newEntryBloc
//                          .selectedMedicineType.value
//                          .toString()
//                          .substring(13);
//                      int interval = _newEntryBloc.selectedInterval$.value;
//                      String startTime = _newEntryBloc.selectedTimeOfDay$.value;
//
//                      List<int> intIDs =
//                      makeIDs(24/_newEntryBloc.selectedInterval$.value);
//                      List<String> notificationIDs = intIDs
//                          .map((i) => i.toString())
//                      .toList(); //for Shared preference
//
//
//                      Medicine newEntryMedicine = Medicine(
//                        notificationIDs: notificationIDs,
//                        medicineName: medicineName,
//                        dosage: dosage,
//                        medicineType: medicineType,
//                        interval: interval,
//                        startTime: startTime,
//                      );
                        //   _globalBloc.updateMedicineList(newEntryMedicine);
                      },
                    ),
                  ),
                )),
                SizedBox(width: 10.0),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(),
                  child: Container(
                    width: 220,
                    height: 50,
                    child: FlatButton(
                      color: Color(0xFF3EB16F),
                      shape: StadiumBorder(),
                      child: Center(
                          child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      )),
                      onPressed: () async {
                        Medicine medicine = new Medicine(
                            medicineName: nameController.text,
                            dosage: int.parse(dosageController.text),
                            medicineType: this.selectedMedicineType,
                            interval: IntervalSelectionState()._selected,
                            startTime: SelectTimeState()
                                ._selectTime(context)
                                .toString());
                        medicineList.add(medicine);
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        String medicinesList = json.encode(medicineList);
                        preferences.setString("medicines", medicinesList);
//                      String medicineName;
//                      int dosage;
//                      String medicineType = _newEntryBloc
//                          .selectedMedicineType.value
//                          .toString()
//                          .substring(13);
//                      int interval = _newEntryBloc.selectedInterval$.value;
//                      String startTime = _newEntryBloc.selectedTimeOfDay$.value;
//
//                      List<int> intIDs =
//                      makeIDs(24/_newEntryBloc.selectedInterval$.value);
//                      List<String> notificationIDs = intIDs
//                          .map((i) => i.toString())
//                      .toList(); //for Shared preference
//
//
//                      Medicine newEntryMedicine = Medicine(
//                        notificationIDs: notificationIDs,
//                        medicineName: medicineName,
//                        dosage: dosage,
//                        medicineType: medicineType,
//                        interval: interval,
//                        startTime: startTime,
//                      );
                        //   _globalBloc.updateMedicineList(newEntryMedicine);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HomePage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ))
              ]),
            ],
          ),
        ),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('mediminder_logo');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[2] + medicine.startTime[3]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      importance: Importance.Max,
      // sound: 'sound',
      ledColor: Color(0xFF3EB16F),
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          int.parse(medicine.notificationIDs[i]),
          'Mediminder: ${medicine.medicineName}',
          medicine.medicineType.toString() != MedicineType.None.toString()
              ? 'It is time to take your ${medicine.medicineType.name}, according to schedule'
              : 'It is time to take your medicine, according to schedule',
          Time(hour, minute, 0),
          platformChannelSpecifics);
      hour = ogValue;
    }
    //await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class IntervalSelection extends StatefulWidget {
  @override
  IntervalSelectionState createState() => IntervalSelectionState();
}

class IntervalSelectionState extends State<IntervalSelection> {
  var _intervals = [
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Remind Me every",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<int>(
              iconEnabledColor: Color(0xFF3EB16F),
              hint: _selected == 0
                  ? Text(
                      "Select an Interval",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    )
                  : null,
              elevation: 4,
              value: _selected == 0 ? null : _selected,
              items: _intervals.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _selected = newVal;
                  _newEntryBloc.updateInterval(newVal);
                });
              },
            ),
            Text(
              _selected == 1 ? " hour" : " hours",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectTime extends StatefulWidget {
  @override
  SelectTimeState createState() => SelectTimeState();
}

class SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    //final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        //  _newEntryBloc.updateTime("${convertTime(_time.hour.toString())}" +
        // "${convertTime(_time.minute.toString())}");
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 4),
        child: FlatButton(
          color: Color(0xFF3EB16F),
          shape: StadiumBorder(),
          onPressed: () {
            _selectTime(context);
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Pick Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  final MedicineType type;
  final String name;
  final IconData icon;
  final bool isSelected;

  MedicineTypeColumn(
      {Key key,
      @required this.type,
      @required this.name,
      @required this.icon,
      @required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
        onTap: () {
          _newEntryBloc.updateSelectedMedicine(type);
        },
        child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              width: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected ? Color(0xFF3EB16F) : Colors.white,
              ),
              child: Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 14.0),
                child: FaIcon(
                  icon,
                  size: 60,
                  color: isSelected ? Colors.white : Color(0xFF3EB16F),
                ),
              ))),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF3EB16F) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Color(0xFF3EB16F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  PanelTitle({
    Key key,
    @required this.title,
    @required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 12, bottom: 4),
        child: Text.rich(TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: isRequired ? "*" : "",
            style: TextStyle(fontSize: 14, color: Color(0xFF3EB16F)),
          )
        ])));
  }
}
