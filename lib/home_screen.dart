
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'employee_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeController controller = Get.find<EmployeeController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Text('Employee Directory'),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.error.value.isNotEmpty
            ? Center(child: Text('Error: ${controller.error.value}'))
            : controller.employees.isEmpty
            ? const Center(child: Text('No employees found'))
            : ListView.builder(
          itemCount: controller.employees.length,
          itemBuilder: (context, index) {
            final employee = controller.employees[index];
            final isEligible = controller.isEligibleForFlag(employee);

            return Card(
              color: isEligible ? Colors.green[100] : null,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: Text("${index+1}"),
                title: Text(employee.name,style: const TextStyle(fontWeight: FontWeight.w600),),
                subtitle: Text(
                  'Joined: ${DateFormat('MMM dd, yyyy').format(employee.joiningDate)}\n'
                      'Status: ${employee.isActive ? 'Active' : 'Inactive'}',
                ),
                trailing: isEligible
                    ? const Icon(Icons.star, color: Colors.green)
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}