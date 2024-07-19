import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:tutor/Models/Utils/Colors.dart';
import 'package:tutor/Models/Utils/Common.dart';
import 'package:tutor/Models/Utils/FirebaseStructure.dart';
import 'package:tutor/Models/Utils/Utils.dart';
import 'package:tutor/Views/Widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutor/Views/Widgets/custom_text_form_field.dart';
import 'package:uuid/uuid.dart';

class UploadPDF extends StatefulWidget {
  final String classUid;

  const UploadPDF({Key? key, required this.classUid}) : super(key: key);

  @override
  _UploadPDFState createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDF> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  final TextEditingController _name = TextEditingController();

  FilePickerResult? _filePicker;
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: colorWhite,
      body: SizedBox(
          width: displaySize.width,
          height: displaySize.height,
          child: Column(
            children: [
              Expanded(
                  flex: 0,
                  child: Container(
                    decoration: BoxDecoration(color: colorPrimary),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: colorWhite,
                            ),
                          ),
                          Text(
                            "Upload Materials",
                            style: TextStyle(fontSize: 18.0, color: colorWhite),
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedFile = null;
                                _name.text = '';
                              });
                            },
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0)
                            .copyWith(top: 50.0),
                        child: CustomTextFormField(
                            height: 5.0,
                            controller: _name,
                            backgroundColor: color7,
                            iconColor: colorPrimary,
                            isIconAvailable: true,
                            hint: 'Name for a material',
                            icon: Icons.file_download_done_sharp,
                            textInputType: TextInputType.text,
                            validation: (value) {
                              final validator = Validator(
                                validators: [const RequiredValidator()],
                              );
                              return validator.validate(
                                label: 'Please insert the name for a material',
                                value: value,
                              );
                            },
                            obscureText: false),
                      ),
                      (selectedFile != null)
                          ? GestureDetector(
                              onTap: () => showChooserType(),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: displaySize.width * 0.8,
                                      child: Icon(
                                        Icons.picture_as_pdf_outlined,
                                        color: colorGreen,
                                        size: 200.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      "Your file has been selected to upload",
                                      style: TextStyle(
                                          fontSize: 14.0, color: colorBlack),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () => showChooserType(),
                              child: Align(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  width: displaySize.width * 0.9,
                                  height: displaySize.width * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        color: colorBlack,
                                        style: BorderStyle.solid,
                                      )),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 10.0),
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        direction: Axis.vertical,
                                        children: [
                                          Icon(Icons.file_copy_outlined,
                                              color: colorBlack,
                                              size: displaySize.width * 0.4),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(
                                              "Click to choose".toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: colorBlack),
                                            ),
                                          ),
                                          Text(
                                            "Upload Material PDF".toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: colorBlack),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  )),
              Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: CustomButton(
                      buttonText: "Upload Material",
                      textColor: color6,
                      backgroundColor: colorPrimary,
                      isBorder: false,
                      borderColor: color6,
                      onclickFunction: () async {
                        if (selectedFile != null) {
                          uploadFile();
                        }
                      },
                    ),
                  )),
            ],
          )),
    ));
  }

  uploadFile() async {
    if (_name.text.isEmpty) return;

    CustomUtils.showLoader(context);
    final firebaseStorage = FirebaseStorage.instance;
    if (selectedFile != null) {
      var snapshot = await firebaseStorage
          .ref()
          .child("${DateTime.now().millisecondsSinceEpoch}.pdf")
          .putData(await selectedFile!.readAsBytes());
      var downloadUrl = await snapshot.ref.getDownloadURL();
      await _databaseReference
          .child(FirebaseStructure.CLASS)
          .child(widget.classUid)
          .child(FirebaseStructure.MATERIALS)
          .push()
          .set({
        'name': _name.text,
        'file': downloadUrl,
        'user': CustomUtils.loggedInUser!.uid,
      });
      CustomUtils.hideLoader(context);
      CustomUtils.showToast('Upload successfully.');
      setState(() {
        selectedFile = null;
        _name.text = '';
      });
    }
  }

  Future<void> showChooserType() async {
    _filePicker = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf']);
    setState(() {
      if (_filePicker != null) {
        selectedFile = File(_filePicker!.files.single.path!);
      } else {
        selectedFile = null;
      }
    });
  }
}
