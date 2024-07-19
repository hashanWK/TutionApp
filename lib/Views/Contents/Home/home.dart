import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tutor/Models/DB/User.dart';
import 'package:tutor/Models/Utils/Routes.dart';
import 'package:tutor/Models/Utils/Utils.dart';
import 'package:tutor/Models/Utils/FirebaseStructure.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutor/Models/Strings/app.dart';
import 'package:tutor/Models/Utils/Colors.dart';
import 'package:tutor/Models/Utils/Common.dart';
import 'package:tutor/Models/Utils/Images.dart';
import 'package:tutor/Views/Contents/Attendance/attendance.dart';
import 'package:tutor/Views/Contents/Home/drawer.dart';
import 'package:cron/cron.dart';
import 'package:tutor/Views/Contents/Payment/payment.dart';
import 'package:tutor/Views/Upload/materials.dart';
import 'package:tutor/Views/Widgets/custom_text_form_field.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];
  List<String> paidCources = [];

  var cron = new Cron();

  bool showQR = false;
  String qr = '';

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  final TextEditingController _search = TextEditingController();

  @override
  void reassemble() {
    super.reassemble();
    if (CustomUtils.loggedInUser!.type == LoggedUser.INSTITUDE_MANAGER) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: colorWhite,
        drawer: HomeDrawer(),
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
                            color: colorBlack,
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
                                onTap: () => (_scaffoldKey
                                        .currentState!.isDrawerOpen)
                                    ? _scaffoldKey.currentState!.openEndDrawer()
                                    : _scaffoldKey.currentState!.openDrawer(),
                                child: Icon(
                                  Icons.menu_rounded,
                                  color: colorWhite,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: displaySize.width * 0.08,
                                    child: Image.asset(logo),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      app_name,
                                      style: TextStyle(
                                          fontSize: 16.0, color: color7),
                                    ),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  switch (CustomUtils.loggedInUser!.type) {
                                    case LoggedUser.INSTITUDE_MANAGER:
                                      setState(() {
                                        showQR = !showQR;
                                      });
                                      break;
                                    default:
                                      getData();
                                  }
                                },
                                child: Icon(
                                  CustomUtils.loggedInUser!.type ==
                                          LoggedUser.INSTITUDE_MANAGER
                                      ? (showQR
                                          ? Icons.close_outlined
                                          : Icons.qr_code_2_outlined)
                                      : Icons.refresh_outlined,
                                  color: colorWhite,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: CustomTextFormField(
                                    height: 5.0,
                                    controller: _search,
                                    backgroundColor: color7,
                                    iconColor: colorPrimary,
                                    isIconAvailable: true,
                                    hint: 'Search By Subject Name',
                                    icon: Icons.search,
                                    textInputType: TextInputType.text,
                                    validation: (value) {
                                      return null;
                                    },
                                    obscureText: false)),
                            Expanded(
                                flex: 0,
                                child: IconButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      getData();
                                    },
                                    icon: Icon(
                                      Icons.search,
                                      color: colorPrimary,
                                    )))
                          ],
                        ),
                      )),
                  if (showQR)
                    Expanded(
                        flex: 0,
                        child: Container(
                          color: colorWhite,
                          width: double.infinity,
                          height: displaySize.height * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Stack(
                              children: [
                                QRView(
                                  key: qrKey,
                                  onQRViewCreated: _onQRViewCreated,
                                  cameraFacing: CameraFacing.back,
                                ),
                                Center(
                                  child: Text(
                                    'Please scan student QR'.toString(),
                                    style: TextStyle(
                                        color: colorWhite,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: colorWhite,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5.0, left: 5.0, right: 5.0),
                          child: getContent(),
                        ),
                      ))
                ],
              )),
        ));
  }

  String splitKey = 'x-x';

  bool firstDetection = true;

  void _onQRViewCreated(QRViewController controller) {
    firstDetection = true;
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      if (result != null && firstDetection) {
        firstDetection = false;
        String? code = result!.code;
        setState(() {
          showQR = !showQR;
        });
        if (!showQR && code != null) {
          if (code.contains(splitKey)) {
            markAttendance(code);
            CustomUtils.showSnackBarMessage(
                context, 'Scan succeed - $code', CustomUtils.SUCCESS_SNACKBAR);
          } else {
            CustomUtils.showSnackBarMessage(
                context, 'Invalid Scan - $code', CustomUtils.SUCCESS_SNACKBAR);
          }
        }
        sleep(const Duration(seconds: 2));
      }
    });
  }

  Future<void> markAttendance(String code) async {
    String currentKey = CustomUtils.formatDateForKey(DateTime.now());

    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(code.split(splitKey)[0])
        .child('courses')
        .child(code.split(splitKey)[1])
        .child('attendance')
        .child(currentKey)
        .once()
        .then((coursesSnap) async {
      bool addAtt = true;

      Map<String, dynamic> dd = {
        'in': CustomUtils.formatDateForKey(DateTime.now())
      };

      if (coursesSnap.snapshot.exists) {
        Map<dynamic, dynamic> profileUserData =
            coursesSnap.snapshot.value as Map;
        dd['in'] = profileUserData['in'];
        dd['out'] = CustomUtils.formatDateForKey(DateTime.now());
        dd.remove('in');
        addAtt = false;
      }

      await _databaseReference
          .child(FirebaseStructure.USERS)
          .child(code.split(splitKey)[0])
          .child('courses')
          .child(code.split(splitKey)[1])
          .child('attendance')
          .child(currentKey)
          .update(dd);

      await _databaseReference
          .child(FirebaseStructure.USERS)
          .child(code.split(splitKey)[0])
          .once()
          .then((DatabaseEvent event) async {
        Map<dynamic, dynamic> profileUserData = event.snapshot.value as Map;
        if (event.snapshot.value != null && addAtt) {
          await _databaseReference
              .child(FirebaseStructure.CLASS)
              .child(code.split(splitKey)[1])
              .child('attendance')
              .push()
              .set({
            'name': profileUserData['name'],
            'email': profileUserData['email'],
            'date': CustomUtils.formatDateTime(DateTime.now())
          });
        }
      });
      CustomUtils.showToast('Attendance Marked');
    });
  }

  Widget getContent() {
    switch (CustomUtils.loggedInUser!.type) {
      case LoggedUser.TUTOR:
      case LoggedUser.INSTITUDE_MANAGER:
      case LoggedUser.STUDENT:
        return SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            for (var record in list)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: GestureDetector(
                  onTap: () => clickClass(record),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    color: colorWhite,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: SizedBox(
                          width: double.infinity,
                          height: displaySize.height * 0.3,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  imageClass,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  color: colorBlack.withOpacity(0.6),
                                  colorBlendMode: BlendMode.darken,
                                ),
                              ),
                              Positioned(
                                  bottom: 20.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      children: [
                                        Text(
                                          record['value']['subject'].toString(),
                                          style: TextStyle(
                                              color: colorWhite,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.0),
                                        ),
                                        if (CustomUtils.loggedInUser!.type ==
                                            LoggedUser.STUDENT)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                              'LKR ${double.parse(record['value']['price'].toString()).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: SizedBox(
                                            width: displaySize.width * 0.9,
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              record['value']['description']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: SizedBox(
                                            width: displaySize.width * 0.9,
                                            child: Text(
                                              'Day of week : ${record['value']['day']}',
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: SizedBox(
                                            width: displaySize.width * 0.9,
                                            child: Text(
                                              'From : ${record['value']['start']}',
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: SizedBox(
                                            width: displaySize.width * 0.9,
                                            child: Text(
                                              'End : ${record['value']['end']}',
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: SizedBox(
                                            width: displaySize.width * 0.9,
                                            child: Text(
                                              '${record['value']['institute']} - ${record['value']['location']}',
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              if (paidCources.contains(record['key']))
                                Positioned(
                                    top: 10.0,
                                    right: 10.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: colorWhite),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: Text(
                                          'Paid',
                                          style: TextStyle(color: colorRed),
                                        ),
                                      ),
                                    )),
                              if (paidCources.contains(record['key']) &&
                                  CustomUtils.loggedInUser!.type ==
                                      LoggedUser.STUDENT)
                                Positioned(
                                  bottom: 10.0,
                                  right: 10.0,
                                  child: SizedBox(
                                    width: displaySize.width * 0.2,
                                    height: displaySize.width * 0.2,
                                    child: (qr == record['key'])
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: QrImageView(
                                              data:
                                                  '${CustomUtils.loggedInUser!.uid}x-x${record['key']}',
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                qr = record['key'];
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: Center(
                                                child: Text(
                                                  'Show QR',
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: colorPrimary),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                )
                            ],
                          ),
                        )),
                  ),
                ),
              )
          ]),
        );
      default:
        return Center(
          child: SizedBox(
            width: displaySize.width * 0.4,
            child: Image.asset(logo),
          ),
        );
    }
  }

  Future<void> getData() async {
    if (CustomUtils.loggedInUser!.type == LoggedUser.STUDENT) {
      await _databaseReference
          .child(FirebaseStructure.USERS)
          .child(CustomUtils.loggedInUser!.uid)
          .child('courses')
          .once()
          .then((coursesSnap) {
        paidCources.clear();
        for (DataSnapshot element in coursesSnap.snapshot.children) {
          paidCources.add(element.key!);
        }
      });
    }

    dynamic dbRef = _databaseReference.child(FirebaseStructure.CLASS);

    if (CustomUtils.loggedInUser!.type == LoggedUser.INSTITUDE_MANAGER) {
      dbRef = dbRef.orderByChild('im').equalTo(CustomUtils.loggedInUser!.uid);
    } else if (CustomUtils.loggedInUser!.type == LoggedUser.TUTOR) {
      dbRef =
          dbRef.orderByChild('tutor').equalTo(CustomUtils.loggedInUser!.uid);
    }

    dbRef.once().then((DatabaseEvent value) {
      list.clear();
      if (value.snapshot.exists) {
        setState(() {
          for (DataSnapshot element in value.snapshot.children) {
            dynamic ddRec = element.value;
            if (_search.text.isNotEmpty) {
              if (ddRec['subject']
                  .toString()
                  .toLowerCase()
                  .contains(_search.text)) {
                list.add({'key': element.key, 'value': element.value});
              }
            } else {
              list.add({'key': element.key, 'value': element.value});
            }
          }
          list = list.reversed.toList();

          // if (CustomUtils.loggedInUser!.type == LoggedUser.STUDENT) {
          //   list.sort((a, b) {
          //     return a['value']
          //         .toLowerCase()
          //         .compareTo(b['name'].toLowerCase());
          //   });
          // }
        });
      }
    });
  }

  clickClass(record) {
    if (CustomUtils.loggedInUser!.type == LoggedUser.STUDENT) {
      if (paidCources.contains(record['key'])) {
        Routes(context: context).navigate(MaterialsPage(
          classUid: record['key'],
        ));
        return;
      }

      Routes(context: context).navigate(Payment(
        classUid: record['key'],
        classTutor: record['value']['tutor'],
        className: record['value']['subject'],
        price: double.parse(record['value']['price'].toString()),
      ));
    } else {
      Routes(context: context).navigate(AttendanceHistory(
        classUid: record['key'],
      ));
    }
  }
}
