import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  String empName;

  @HiveField(1)
  var empSalary;

  @HiveField(2)
  String empAge;

  @HiveField(3)
  String empId;

  @HiveField(4)
  String dalidata;
  @HiveField(5)
  String daliaddr;

  @HiveField(6)
  String screpeat;

  @HiveField(7)
  String scdestaddr;

  @HiveField(8)
  String scstat;

  Employee(
      {this.empName,
      this.empSalary,
      this.empAge,
      this.dalidata,
      this.daliaddr,
      this.screpeat,
      this.scdestaddr,
      this.scstat,
      @required this.empId});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        empName: json['sc_name'],
        empSalary: json['dev_status'],
        empAge: "${json['sc_hour']}:${json['sc_min']}",
        empId: json['sc_id'],
        dalidata: json['dali_data'],
        daliaddr: json['dali_addr'],
        scdestaddr: json['sc_destination_addr'],
        scstat: json['sc_status'],
        screpeat: json['sc_repeat']);
  }
}
