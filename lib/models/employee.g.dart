// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 0;

  @override
  Employee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Employee(
      empName: fields[0] as String,
      empSalary: fields[1] as dynamic,
      empAge: fields[2] as String,
      dalidata: fields[4] as String,
      daliaddr: fields[5] as String,
      screpeat: fields[6] as String,
      scdestaddr: fields[7] as String,
      scstat: fields[8] as String,
      empId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.empName)
      ..writeByte(1)
      ..write(obj.empSalary)
      ..writeByte(2)
      ..write(obj.empAge)
      ..writeByte(3)
      ..write(obj.empId)
      ..writeByte(4)
      ..write(obj.dalidata)
      ..writeByte(5)
      ..write(obj.daliaddr)
      ..writeByte(6)
      ..write(obj.screpeat)
      ..writeByte(7)
      ..write(obj.scdestaddr)
      ..writeByte(8)
      ..write(obj.scstat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
