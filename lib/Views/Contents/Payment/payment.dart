import 'package:form_validation/form_validation.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutor/Models/Utils/Colors.dart';
import 'package:tutor/Models/Utils/Common.dart';
import 'package:tutor/Models/Utils/FirebaseStructure.dart';
import 'package:tutor/Models/Utils/Images.dart';
import 'package:tutor/Models/Utils/Routes.dart';
import 'package:tutor/Models/Utils/Utils.dart';
import 'package:tutor/Views/Contents/Home/home.dart';
import 'package:tutor/Views/Widgets/custom_button.dart';
import 'package:tutor/Views/Widgets/custom_text_form_field.dart';

class Payment extends StatefulWidget {
  final String classTutor;
  final String classUid;
  final String className;
  final double price;

  const Payment(
      {Key? key,
      required this.classTutor,
      required this.classUid,
      required this.price,
      required this.className})
      : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

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
                                "Complete Payment",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.refresh,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 60.0),
                                child: Image.asset(paymentTypes),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: TextEditingController(),
                                    backgroundColor: color7,
                                    iconColor: colorPrimary,
                                    isIconAvailable: true,
                                    hint: 'Your Card Number',
                                    icon: Icons.card_membership_outlined,
                                    textInputType: TextInputType.text,
                                    validation: (value) {
                                      final validator = Validator(
                                        validators: [const RequiredValidator()],
                                      );
                                      return validator.validate(
                                        label: 'Please fill this field',
                                        value: value,
                                      );
                                    },
                                    obscureText: false),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: TextEditingController(),
                                    backgroundColor: color7,
                                    iconColor: colorPrimary,
                                    isIconAvailable: true,
                                    hint: 'Name of Card Holder',
                                    icon: Icons.person_2_outlined,
                                    textInputType: TextInputType.text,
                                    validation: (value) {
                                      final validator = Validator(
                                        validators: [const RequiredValidator()],
                                      );
                                      return validator.validate(
                                        label: 'Please fill this field',
                                        value: value,
                                      );
                                    },
                                    obscureText: false),
                              ),
                              Row(
                                children: [
                                  // Expanded(
                                  //     flex: 1,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           horizontal: 20.0, vertical: 5.0),
                                  //       child: CustomDateSelectorWithImage(
                                  //         height: 5.0,
                                  //         backgroundColor: color7,
                                  //         isIconAvailable: true,
                                  //         hint: reservation_card_expire_date_month
                                  //             .toUpperCase(),
                                  //         icon_img: Icons.calendar_month,
                                  //         onConfirm: () {},
                                  //         type: CustomDateSelectorWithImage
                                  //             .DATE_SELECTOR,
                                  //       ),
                                  //     )),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 5.0),
                                        child: CustomTextFormField(
                                            readOnly: false,
                                            height: 5.0,
                                            controller: TextEditingController(),
                                            backgroundColor: color7,
                                            iconColor: colorPrimary,
                                            isIconAvailable: true,
                                            hint: 'CVV',
                                            icon: Icons.code_rounded,
                                            textInputType: TextInputType.text,
                                            validation: (value) {
                                              final validator = Validator(
                                                validators: [
                                                  const RequiredValidator()
                                                ],
                                              );
                                              return validator.validate(
                                                label: 'Please fill this field',
                                                value: value,
                                              );
                                            },
                                            obscureText: false),
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 5.0),
                                child: CustomButton(
                                    buttonText:
                                        "Make Payment (LKR ${double.parse(widget.price.toString()).toStringAsFixed(2)})",
                                    textColor: color6,
                                    backgroundColor: colorPrimary,
                                    isBorder: false,
                                    borderColor: color6,
                                    onclickFunction: () async {
                                      FocusScope.of(context).unfocus();
                                      CustomUtils.showLoader(context);

                                      Map<String, dynamic> map = {
                                        'name': widget.className,
                                        'price': widget.price,
                                        'datetime': DateTime.now()
                                            .millisecondsSinceEpoch
                                      };

                                      await _databaseReference
                                          .child(FirebaseStructure.USERS)
                                          .child(CustomUtils.loggedInUser!.uid)
                                          .child('courses')
                                          .child(widget.classUid)
                                          .set(map)
                                          .then((value) async {
                                        map['user'] =
                                            CustomUtils.loggedInUser!.name;

                                        await _databaseReference
                                            .child(FirebaseStructure.USERS)
                                            .child(widget.classTutor)
                                            .child('courses')
                                            .child(widget.classUid)
                                            .set(map)
                                            .then((value) {
                                          CustomUtils.hideLoader(context);
                                          Routes(context: context)
                                              .navigateReplace(const Home());
                                        });
                                      });
                                    }),
                              )
                            ],
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
}
