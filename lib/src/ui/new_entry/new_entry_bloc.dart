//import 'package:medminder/src/models/medicine.dart';
import 'package:medminder/src/models/medicine_type.dart';
import 'package:rxdart/rxdart.dart';

class NewEntryBloc {
  BehaviorSubject<MedicineType> _selectedMedicineType$;
  BehaviorSubject<MedicineType> get selectedMedicineType =>
      _selectedMedicineType$.stream;

  BehaviorSubject<int> _selectedInterval$;
  BehaviorSubject<int> get selectedInterval$ => _selectedInterval$;


  BehaviorSubject<String> _selectedTimeOfDay$;
  BehaviorSubject<String> get selectedTimeOfDay$ => _selectedTimeOfDay$;


  NewEntryBloc() {
    _selectedMedicineType$ =
    BehaviorSubject<MedicineType>.seeded(MedicineType.None);
    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded("None");
    _selectedInterval$ = BehaviorSubject<int>.seeded(0);
    //_errorState$ = BehaviorSubject<EntryError>();
  }
  void dispose() {
    _selectedMedicineType$.close();
    _selectedTimeOfDay$.close();
    _selectedInterval$.close();
  }
  void updateInterval(int interval) {
    _selectedInterval$.add(interval);
  }
  void updateSelectedMedicine(MedicineType type) {
    MedicineType _tempType = _selectedMedicineType$.value;
    if (type == _tempType) {
      _selectedMedicineType$.add(MedicineType.None);
    } else {
      _selectedMedicineType$.add(type);
    }
  }
}
