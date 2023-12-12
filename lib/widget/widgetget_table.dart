import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartwater/models/datatable_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DatadetailsDataSourcePage1 extends DataGridSource {
  DatadetailsDataSourcePage1(this.alldata) {
    buildDataGridRow();
  }
  List<DATATABLE> alldata = [];
  List<DataGridRow> _DataGridRows = [];

  void buildDataGridRow() {
    _DataGridRows = alldata
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(
                  columnName: 'id', value: e.productDetailsMonthId),
              DataGridCell<dynamic>(
                  columnName: 'statusai', value: e.productDetailsResultAi),
              DataGridCell<dynamic>(
                  columnName: 'statussolenoid',
                  value: e.productDetailsResultSolenoid),
              DataGridCell<dynamic>(
                  columnName: 'flowrate', value: e.productDetailsMonthFlowrate),
              DataGridCell<dynamic>(
                  columnName: 'Pressure', value: e.productDetailsMonthPressure),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _DataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Color.fromARGB(255, 255, 255, 255), //พื้นหลัง
        cells: row.getCells().map<Widget>((e) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x53FFFFFF)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                color: Color.fromARGB(255, 225, 229, 123),
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          e.value.toString(),
                          style: GoogleFonts.kanit(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        )))),
          );
        }).toList());
  }

  void updateDataGrid(List<DATATABLE> data_update) {
    _DataGridRows = data_update
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(
                  columnName: 'id', value: e.productDetailsMonthId),
              DataGridCell<dynamic>(
                  columnName: 'statusai', value: e.productDetailsResultAi),
              DataGridCell<dynamic>(
                  columnName: 'statussolenoid',
                  value: e.productDetailsResultSolenoid),
              DataGridCell<dynamic>(
                  columnName: 'flowrate', value: e.productDetailsMonthFlowrate),
              DataGridCell<dynamic>(
                  columnName: 'Pressure', value: e.productDetailsMonthPressure),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
    notifyListeners();
  }
}

class DatadetailsDataSourcePage2 extends DataGridSource {
  DatadetailsDataSourcePage2(this.alldata) {
    buildDataGridRow();
  }
  List<DATATABLE> alldata = [];
  List<DataGridRow> _DataGridRows = [];

  void buildDataGridRow() {
    _DataGridRows = alldata
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(
                  columnName: 'id', value: e.productDetailsMonthId),
              DataGridCell<dynamic>(
                  columnName: 'timecontrol', value: e.productDetailsResultTime),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _DataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Color.fromARGB(255, 255, 255, 255), //พื้นหลัง
        cells: row.getCells().map<Widget>((e) {
          return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0x53FFFFFF)),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Color.fromARGB(255, 225, 229, 123),
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        e.value.toString(),
                        style: GoogleFonts.kanit(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ))));
        }).toList());
  }

  void updateDataGrid(List<DATATABLE> data_update) {
    _DataGridRows = data_update
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(
                  columnName: 'id', value: e.productDetailsMonthId),
              DataGridCell<dynamic>(
                  columnName: 'timecontrol', value: e.productDetailsResultTime),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
    notifyListeners();
  }
}

class DatadetailsDataSourcePage3 extends DataGridSource {
  DatadetailsDataSourcePage3(this.alldata) {
    buildDataGridRow();
  }
  List<DATATABLE> alldata = [];
  List<DataGridRow> _DataGridRows = [];

  void buildDataGridRow() {
    _DataGridRows = alldata
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(
                  columnName: 'id', value: e.productDetailsMonthId),
              DataGridCell<dynamic>(
                  columnName: 'wateruse', value: e.productDetailsMonthWaterUse),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _DataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Color.fromARGB(255, 255, 255, 255), //พื้นหลัง
        cells: row.getCells().map<Widget>((e) {
          return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0x53FFFFFF)),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Color.fromARGB(255, 225, 229, 123),
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        e.value.toString(),
                        style: GoogleFonts.kanit(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ))));
        }).toList());
  }

  void updateDataGrid(List<DATATABLE> data_update) {
    _DataGridRows = data_update
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(
                  columnName: 'id', value: e.productDetailsMonthId),
              DataGridCell<dynamic>(
                  columnName: 'wateruseD', value: e.productDetailsDayWaterUse),
              DataGridCell<dynamic>(
                  columnName: 'wateruseM',
                  value: e.productDetailsMonthWaterUse),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
    notifyListeners();
  }
}
