import 'package:intl/intl.dart';
import 'package:tutor/Models/DB/User.dart';
import 'package:tutor/Models/Utils/Utils.dart';
import 'package:tutor/Views/Upload/upload.dart';
import 'package:tutor/Views/Widgets/cuatom_text_time_picker.dart';
import 'package:tutor/Views/Widgets/custom_button.dart';
import 'package:tutor/Views/Widgets/custom_dropdown.dart';
import 'package:tutor/Views/Widgets/custom_text_datetime_chooser.dart';
import 'package:tutor/Views/Widgets/custom_text_form_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutor/Models/Utils/Colors.dart';
import 'package:tutor/Models/Utils/Common.dart';
import 'package:tutor/Models/Utils/FirebaseStructure.dart';
import 'package:tutor/Models/Utils/Routes.dart';
import 'package:form_validation/form_validation.dart';

class ClassManagement extends StatefulWidget {
  const ClassManagement({Key? key}) : super(key: key);

  @override
  State<ClassManagement> createState() => _ClassManagementState();
}

class _ClassManagementState extends State<ClassManagement> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];
  List<DropdownMenuItem<String>> tutors = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
      getTutors();
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
                                "Class Management",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () => CustomUtils.loggedInUser!.type ==
                                        LoggedUser.TUTOR
                                    ? getData()
                                    : openEnrollment(null),
                                child: Icon(
                                  CustomUtils.loggedInUser!.type ==
                                          LoggedUser.TUTOR
                                      ? Icons.refresh_outlined
                                      : Icons.add,
                                  color: colorWhite,
                                ),
                              ),
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
                          child: (list.isNotEmpty)
                              ? SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        for (var rec in list)
                                          GestureDetector(
                                            onTap: () => (CustomUtils
                                                        .loggedInUser!.type ==
                                                    LoggedUser.TUTOR)
                                                ? Routes(context: context)
                                                    .navigateReplace(UploadPDF(
                                                    classUid: rec['key'],
                                                  ))
                                                : null,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1.0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Card(
                                                  color: colorWhite,
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10.0),
                                                      child: ListTile(
                                                        title: Text(
                                                          rec['value']
                                                              ['subject'],
                                                          style: TextStyle(
                                                              color: colorBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15.0),
                                                        ),
                                                        subtitle: Wrap(
                                                          direction:
                                                              Axis.vertical,
                                                          children: [
                                                            Text(
                                                              'Day of Week : ${rec['value']['day']}',
                                                              style: TextStyle(
                                                                  color:
                                                                      colorGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      13.0),
                                                            ),
                                                            Text(
                                                              'Start : ${rec['value']['start']}',
                                                              style: TextStyle(
                                                                  color:
                                                                      colorGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      13.0),
                                                            ),
                                                            Text(
                                                              'End : ${rec['value']['end']}',
                                                              style: TextStyle(
                                                                  color:
                                                                      colorGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      13.0),
                                                            ),
                                                            Text(
                                                              'LKR ${double.parse(rec['value']['price'].toString()).toStringAsFixed(2)}',
                                                              style: TextStyle(
                                                                  color:
                                                                      colorPrimary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      16.0),
                                                            )
                                                          ],
                                                        ),
                                                        trailing: CustomUtils
                                                                    .loggedInUser!
                                                                    .type ==
                                                                LoggedUser
                                                                    .INSTITUDE_MANAGER
                                                            ? IconButton(
                                                                onPressed: () => _databaseReference
                                                                    .child(FirebaseStructure
                                                                        .CLASS)
                                                                    .child(rec[
                                                                        'key'])
                                                                    .remove()
                                                                    .then((value) =>
                                                                        getData()),
                                                                icon: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        colorRed))
                                                            : null,
                                                      )),
                                                ),
                                              ),
                                            ),
                                          )
                                      ]),
                                )
                              : Center(
                                  child: Text(
                                    "No Data Found".toString().toUpperCase(),
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0),
                                  ),
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

  void openEnrollment(data) {
    if (tutors.isEmpty) {
      CustomUtils.showSnackBarMessage(
          context, 'No tutors found', CustomUtils.ERROR_SNACKBAR);
      return;
    }

    final _formKey = GlobalKey<FormState>();

    final TextEditingController _subject = TextEditingController();
    final TextEditingController _start = TextEditingController();
    final TextEditingController _end = TextEditingController();
    final TextEditingController _description = TextEditingController();
    final TextEditingController _price = TextEditingController();

    String? tutor;
    String day = 'Monday';

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          tutor = tutor ?? tutors.first.value!;

          return SizedBox(
            width: double.infinity,
            height: displaySize.height * 0.8,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Add Class",
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0),
                                  )),
                              Expanded(
                                  flex: 0,
                                  child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Icon(
                                        Icons.close,
                                        color: colorRed,
                                      )))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(
                              color: colorGrey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return CustomDropDown(
                                  dropdown_value: tutor!,
                                  action_icon_color: colorPrimary,
                                  text_color: colorBlack,
                                  background_color: colorWhite,
                                  underline_color: colorWhite,
                                  function: (selectedKey) {
                                    setState(() {
                                      tutor = selectedKey;
                                    });
                                  },
                                  items: tutors);
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: CustomTextFormField(
                                height: 5.0,
                                controller: _subject,
                                backgroundColor: color7,
                                iconColor: colorPrimary,
                                isIconAvailable: true,
                                hint: 'Subject',
                                icon: Icons.subject_outlined,
                                textInputType: TextInputType.text,
                                validation: (value) {
                                  final validator = Validator(
                                    validators: [const RequiredValidator()],
                                  );
                                  return validator.validate(
                                    label: "Please fill this field",
                                    value: value,
                                  );
                                },
                                obscureText: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: CustomTextFormField(
                                height: 5.0,
                                controller: _description,
                                backgroundColor: color7,
                                iconColor: colorPrimary,
                                isIconAvailable: true,
                                hint: 'Description',
                                icon: Icons.description_outlined,
                                textInputType: TextInputType.multiline,
                                maxLines: 5,
                                validation: (value) {
                                  final validator = Validator(
                                    validators: [const RequiredValidator()],
                                  );
                                  return validator.validate(
                                    label: "Please fill this field",
                                    value: value,
                                  );
                                },
                                obscureText: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: CustomTextFormField(
                                height: 5.0,
                                controller: _price,
                                backgroundColor: color7,
                                iconColor: colorPrimary,
                                isIconAvailable: true,
                                hint: 'Price',
                                icon: Icons.price_change_outlined,
                                textInputType: TextInputType.text,
                                validation: (value) {
                                  final validator = Validator(
                                    validators: [const RequiredValidator()],
                                  );
                                  return validator.validate(
                                    label: "Please fill this field",
                                    value: value,
                                  );
                                },
                                obscureText: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return CustomDropDown(
                                  dropdown_value: day,
                                  action_icon_color: colorPrimary,
                                  text_color: colorBlack,
                                  background_color: colorWhite,
                                  underline_color: colorWhite,
                                  function: (selectedKey) {
                                    setState(() {
                                      day = selectedKey;
                                    });
                                  },
                                  items: [
                                    for (String element in [
                                      'Monday',
                                      'Tuesday',
                                      'Wednesday',
                                      'Thursday',
                                      'Friday',
                                      'Saturday',
                                      'Subday'
                                    ])
                                      DropdownMenuItem(
                                          value: element,
                                          child: Text(
                                            element,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: colorBlack),
                                          ))
                                  ]);
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: CustomTextTimeChooser(
                                height: 5.0,
                                controller: _start,
                                backgroundColor: color7,
                                iconColor: colorPrimary,
                                isIconAvailable: true,
                                hint: 'Start Time',
                                icon: Icons.calendar_month,
                                textInputType: TextInputType.text,
                                validation: (value) {
                                  final validator = Validator(
                                    validators: [const RequiredValidator()],
                                  );
                                  return validator.validate(
                                    label: "Please fill this field",
                                    value: value,
                                  );
                                },
                                obscureText: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: CustomTextTimeChooser(
                                height: 5.0,
                                controller: _end,
                                backgroundColor: color7,
                                iconColor: colorPrimary,
                                isIconAvailable: true,
                                hint: 'End Time',
                                icon: Icons.calendar_month,
                                textInputType: TextInputType.text,
                                validation: (value) {
                                  final validator = Validator(
                                    validators: [const RequiredValidator()],
                                  );
                                  return validator.validate(
                                    label: "Please fill this field",
                                    value: value,
                                  );
                                },
                                obscureText: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            child: CustomButton(
                                buttonText: "Submit",
                                textColor: color6,
                                backgroundColor: colorPrimary,
                                isBorder: false,
                                borderColor: color6,
                                onclickFunction: () async {
                                  FocusScope.of(context).unfocus();
                                  CustomUtils.showLoader(context);

                                  await _databaseReference
                                      .child(FirebaseStructure.INSTITUTES)
                                      .child(CustomUtils.loggedInUser!.uid)
                                      .once()
                                      .then((event) {
                                    Map<dynamic, dynamic> instituteData =
                                        event.snapshot.value as Map;

                                    Map<String, dynamic> dataNew = {
                                      'subject': _subject.text,
                                      'description': _description.text,
                                      'price': _price.text,
                                      'day': day,
                                      'start': _start.text,
                                      'end': _end.text,
                                      'tutor': tutor,
                                      'institute': instituteData['name'],
                                      'location': instituteData['location'],
                                      'im': CustomUtils.loggedInUser!.uid,
                                    };

                                    if (data != null) {
                                      _databaseReference
                                          .child(FirebaseStructure.CLASS)
                                          .child(data['key'])
                                          .update(dataNew)
                                          .then((value) {
                                        CustomUtils.hideLoader(context);
                                        Navigator.pop(context);
                                        getData();
                                      });
                                    } else {
                                      _databaseReference
                                          .child(FirebaseStructure.CLASS)
                                          .push()
                                          .update(dataNew)
                                          .then((value) {
                                        CustomUtils.hideLoader(context);
                                        Navigator.pop(context);
                                        getData();
                                      });
                                    }
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          );
        });
  }

  Future<void> getData() async {
    dynamic ref = _databaseReference.child(FirebaseStructure.CLASS);

    if (CustomUtils.loggedInUser!.type == LoggedUser.INSTITUDE_MANAGER) {
      ref = ref.orderByChild('im').equalTo(CustomUtils.loggedInUser!.uid);
    } else {
      ref = ref.orderByChild('tutor').equalTo(CustomUtils.loggedInUser!.uid);
    }

    ref.once().then((DatabaseEvent data) {
      list.clear();
      setState(() {
        for (DataSnapshot element in data.snapshot.children) {
          list.add({'key': element.key, 'value': element.value});
        }
        list = list.reversed.toList();
      });
    });
  }

  Future<void> getTutors() async {
    _databaseReference
        .child(FirebaseStructure.USERS)
        .orderByChild("type")
        .equalTo(LoggedUser.TUTOR)
        .once()
        .then((DatabaseEvent data) {
      tutors.clear();
      setState(() {
        for (DataSnapshot element in data.snapshot.children) {
          dynamic value = element.value;
          tutors.add(DropdownMenuItem(
              value: element.key!,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Text(
                    value['name'],
                    style: TextStyle(fontSize: 13.0, color: colorBlack),
                  ),
                  Text(
                    value['email'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.0, color: colorGrey),
                  )
                ],
              )));
        }
        tutors = tutors.reversed.toList();
      });
    });
  }
}
