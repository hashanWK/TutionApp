import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutor/Models/Utils/Colors.dart';
import 'package:tutor/Models/Utils/Common.dart';
import 'package:tutor/Models/Utils/FirebaseStructure.dart';
import 'package:tutor/Models/Utils/Routes.dart';
import 'package:tutor/Models/Utils/Utils.dart';
import 'package:intl/intl.dart';
import 'package:tutor/Views/Widgets/custom_text_date_chooser.dart';
import '../../Widgets/custom_text_datetime_chooser.dart';

class AttendanceHistory extends StatefulWidget {
  final String classUid;

  const AttendanceHistory({Key? key, required this.classUid}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  TextEditingController start = TextEditingController();
  bool useFilters = false;
  bool showFilters = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
        body: SafeArea(
          child: SizedBox(
              width: displaySize.width,
              height: displaySize.height,
              child: Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Routes(context: context).back();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: colorWhite,
                                ),
                              ),
                              Text(
                                "Attendance History",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    showFilters = !showFilters;
                                  });
                                },
                                child: Icon(
                                  (showFilters) ? Icons.menu_open : Icons.menu,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  (showFilters)
                      ? AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontSize: 16.0, color: colorBlack),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CustomTextDateChooser(
                                        height: 5.0,
                                        controller: start,
                                        backgroundColor: color7,
                                        iconColor: colorPrimary,
                                        isIconAvailable: true,
                                        hint: 'Start',
                                        icon: Icons.calendar_month,
                                        textInputType: TextInputType.text,
                                        validation: (value) {
                                          return null;
                                        },
                                        obscureText: false),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50.0,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  colorWhite),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  colorPrimary),
                                        ),
                                        onPressed: () async {
                                          useFilters = true;
                                          getData();
                                        },
                                        child: const Text(
                                          "Filter Records",
                                          style: TextStyle(),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: colorWhite,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5.0, left: 5.0, right: 5.0),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (var rec in list)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.payment_outlined,
                                              color: colorPrimary,
                                              size: 35.0,
                                            ),
                                            title: Wrap(
                                              direction: Axis.vertical,
                                              children: [
                                                Text(
                                                  "${rec['value']['name']}",
                                                  style: TextStyle(
                                                      color: colorPrimary,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15.0),
                                                ),
                                                Text(
                                                  "${rec['value']['email']}",
                                                  style: TextStyle(
                                                      color: colorGreen,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12.0),
                                                )
                                              ],
                                            ),
                                            subtitle: Text(
                                              rec['value']['date'],
                                              style: TextStyle(
                                                  color: colorGrey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.0),
                                            ),
                                          )),
                                    )
                                ]),
                          ),
                        ),
                      ))
                ],
              )),
        ));
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  String getDate(int mills) {
    return DateFormat('yyyy/MM/dd')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.CLASS)
        .child(widget.classUid)
        .child('attendance')
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        dynamic obj = element.value;

        if (useFilters == true && start.text.isNotEmpty) {
          DateTime currentDateTime =
              DateFormat("yyyy/MM/dd").parse(obj['date']);
          if (DateFormat("yyyy/MM/dd").parse(start.text).toString() ==
              currentDateTime.toString()) {
            list.add({'key': element.key, 'value': element.value});
          }
        } else {
          list.add({'key': element.key, 'value': element.value});
        }
      }
      setState(() {
        useFilters = false;
      });
    });
  }
}
