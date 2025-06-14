
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'employee_model.dart';

class EmployeeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Employee> employees = <Employee>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSampleData();
    fetchEmployees();
  }

  Future<void> initializeSampleData() async {
    final snapshot = await _firestore.collection('employees').get();
    if (snapshot.docs.isNotEmpty) return;

    // Add sample employees
    final sampleEmployees = [
      Employee(
        id: '1',
        name: 'Aarav',
        joiningDate: DateTime(2017, 4, 10),
        isActive: true,
      ),
      Employee(
        id: '2',
        name: 'Priya',
        joiningDate: DateTime(2023, 6, 15),
        isActive: true,
      ),
      Employee(
        id: '3',
        name: 'Vikram',
        joiningDate: DateTime(2015, 9, 20),
        isActive: false,
      ),
      Employee(
        id: '4',
        name: 'Ananya',
        joiningDate: DateTime(2019, 2, 25),
        isActive: true,
      ),
      Employee(
        id: '5',
        name: 'Rohan',
        joiningDate: DateTime(2016, 11, 5),
        isActive: true,
      ),
      Employee(
        id: '6',
        name: 'Sneha',
        joiningDate: DateTime(2021, 8, 30),
        isActive: false,
      ),
      Employee(
        id: '7',
        name: 'Arjun',
        joiningDate: DateTime(2018, 3, 12),
        isActive: true,
      ),
      Employee(
        id: '8',
        name: 'Kavya',
        joiningDate: DateTime(2022, 1, 10),
        isActive: true,
      ),
      Employee(
        id: '9',
        name: 'Sanjay',
        joiningDate: DateTime(2014, 7, 18),
        isActive: true,
      ),
      Employee(
        id: '10',
        name: 'Meera',
        joiningDate: DateTime(2020, 5, 22),
        isActive: false,
      ),
    ];

    for (var employee in sampleEmployees) {
      await _firestore
          .collection('employees')
          .doc(employee.id)
          .set(employee.toFirestore());
    }
  }

  void fetchEmployees() {
    isLoading.value = true;
    error.value = '';

    _firestore.collection('employees').snapshots().listen(
          (snapshot) {
        employees.value = snapshot.docs
            .map((doc) => Employee.fromFirestore(doc))
            .toList();
        isLoading.value = false;
      },
      onError: (e) {
        error.value = e.toString();
        isLoading.value = false;
      },
    );
  }

  bool isEligibleForFlag(Employee employee) {
    final fiveYearsAgo = DateTime.now().subtract(const Duration(days: 5 * 365));
    return employee.isActive && employee.joiningDate.isBefore(fiveYearsAgo);
  }
}