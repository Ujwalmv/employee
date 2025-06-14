
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
        backgroundColor: Colors.white,
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
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.blue[50],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Employees active with over 5 years of tenure are flagged in green with a star icon.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Employee list
            Expanded(
              child: ListView.builder(
                itemCount: controller.employees.length,
                itemBuilder: (context, index) {
                  final employee = controller.employees[index];
                  final isEligible = controller.isEligibleForFlag(employee);

                  return Card(
                    color: isEligible ? Colors.green[100] : Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Text("${index+1}"),
                      title: Text(employee.name),
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
          ],
        ),
      ),

    );
  }
}