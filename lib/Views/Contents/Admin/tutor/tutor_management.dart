import 'package:tutor/Controllers/AuthController.dart';
import 'package:tutor/Models/DB/User.dart';
import 'package:tutor/Models/Utils/Utils.dart';
import 'package:tutor/Views/Widgets/custom_button.dart';
import 'package:tutor/Views/Widgets/custom_text_form_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutor/Models/Utils/Colors.dart';
import 'package:tutor/Models/Utils/Common.dart';
import 'package:tutor/Models/Utils/FirebaseStructure.dart';
import 'package:tutor/Models/Utils/Routes.dart';
import 'package:form_validation/form_validation.dart';

class TutorManagement extends StatefulWidget {
  const TutorManagement({Key? key}) : super(key: key);

  @override
  State<TutorManagement> createState() => _TutorManagementState();
}

class _TutorManagementState extends State<TutorManagement> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final AuthController _authController = AuthController();

  List<dynamic> list = [];

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
                                "Tutor Management",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () => openEnrollment(null),
                                child: Icon(
                                  Icons.add,
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
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
                                                          rec['value']['name']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: colorBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16.0),
                                                        ),
                                                        subtitle: Text(
                                                          rec['value']
                                                                  ['email'] ??
                                                              '',
                                                          style: TextStyle(
                                                              color:
                                                                  colorPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14.0),
                                                        ),
                                                        trailing: Wrap(
                                                          direction:
                                                              Axis.horizontal,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () =>
                                                                    openEnrollment(
                                                                        rec),
                                                                icon: Icon(
                                                                    Icons.edit,
                                                                    color:
                                                                        color12)),
                                                            IconButton(
                                                                onPressed: () => _databaseReference
                                                                    .child(FirebaseStructure
                                                                        .INSTITUTES)
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
                                                          ],
                                                        ))),
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

  void openEnrollment(data) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController address = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    String? imUid;

    if (data != null) {
      name.text = data['value']['name'];
      phone.text = data['value']['phone'] ?? '';
      address.text = data['value']['address'] ?? '';
      email.text = data['value']['email'];
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: SizedBox(
                      height: displaySize.height * 0.8,
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
                                      "Tutor Management",
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Divider(
                                color: colorGrey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: CustomTextFormField(
                                  height: 5.0,
                                  controller: name,
                                  backgroundColor: color7,
                                  iconColor: colorPrimary,
                                  isIconAvailable: true,
                                  hint: 'Name',
                                  icon: Icons.title,
                                  textInputType: TextInputType.multiline,
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
                                  controller: phone,
                                  backgroundColor: color7,
                                  iconColor: colorPrimary,
                                  isIconAvailable: true,
                                  hint: 'Phone Number',
                                  icon: Icons.phone_android_outlined,
                                  textInputType: TextInputType.phone,
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
                                  controller: address,
                                  backgroundColor: color7,
                                  iconColor: colorPrimary,
                                  isIconAvailable: true,
                                  hint: 'Address',
                                  icon: Icons.map_outlined,
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
                                  readOnly: data != null,
                                  height: 5.0,
                                  controller: email,
                                  backgroundColor: color7,
                                  iconColor: colorPrimary,
                                  isIconAvailable: true,
                                  hint: 'Username',
                                  icon: Icons.email_outlined,
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
                                  readOnly: data != null,
                                  height: 5.0,
                                  controller: password,
                                  backgroundColor: color7,
                                  iconColor: colorPrimary,
                                  isIconAvailable: true,
                                  hint: 'Password',
                                  icon: Icons.password_outlined,
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
                                  obscureText: true),
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
                                    if (_formKey.currentState!.validate()) {
                                      CustomUtils.showLoader(context);

                                      Map<String, dynamic> dataNew = {
                                        'name': name.text.toString(),
                                        'mobile': phone.text.toString(),
                                        'email': email.text.toString(),
                                        'type': LoggedUser.TUTOR,
                                        'password': password.text.toString()
                                      };

                                      if (data == null) {
                                        await _authController
                                            .userRegistration(dataNew)
                                            .then((onValue) async {
                                          CustomUtils.hideLoader(context);
                                          Navigator.pop(context);
                                          getData();
                                        });
                                      } else {
                                        await _databaseReference
                                            .child(FirebaseStructure.USERS)
                                            .child(data['key'])
                                            .update(dataNew)
                                            .then((value) {
                                          CustomUtils.hideLoader(context);
                                          Navigator.pop(context);
                                          getData();
                                        });
                                      }
                                    } else {
                                      CustomUtils.showSnackBar(
                                          context,
                                          "Please fill above data",
                                          CustomUtils.ERROR_SNACKBAR);
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            );
          });
        });
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.USERS)
        .orderByChild("type")
        .equalTo(LoggedUser.TUTOR)
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      setState(() {
        for (DataSnapshot element in data.snapshot.children) {
          dynamic value = element.value;
          list.add({'key': element.key, 'value': value});
        }
        list = list.reversed.toList();
      });
    });
  }
}
