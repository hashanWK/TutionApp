import 'package:tutor/Models/DB/User.dart';
import 'package:tutor/Views/Contents/Admin/Institute/institute_management.dart';
import 'package:tutor/Views/Contents/Admin/class/class_management.dart';
import 'package:flutter/material.dart';
import 'package:tutor/Controllers/AuthController.dart';
import 'package:tutor/Models/Utils/Colors.dart';
import 'package:tutor/Models/Utils/Common.dart';
import 'package:tutor/Models/Utils/Images.dart';
import 'package:tutor/Models/Utils/Routes.dart';
import 'package:tutor/Models/Utils/Utils.dart';
import 'package:tutor/Views/Contents/Admin/tutor/tutor_management.dart';
import 'package:tutor/Views/Contents/History/payment_history.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  final AuthController _authController = AuthController();

  List<Widget> userMenus = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displaySize.width * 0.8,
      decoration: BoxDecoration(color: color6),
      child: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: displaySize.height * 0.15,
            child: Container(
                decoration: BoxDecoration(color: colorPrimary),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 12.0, left: 15.0, right: 15.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: ClipOval(
                            child: Image.asset(
                              user,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CustomUtils.loggedInUser!.name,
                                  style: TextStyle(
                                      color: color6,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  CustomUtils.loggedInUser!.email,
                                  style: TextStyle(
                                      color: color6,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                )),
          ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.ADMIN)
            ListTile(
              onTap: () => Routes(context: context)
                  .navigate(const InstituteManagement()),
              tileColor: color6,
              leading: Icon(
                Icons.work_history_outlined,
                color: color15,
              ),
              title: Text(
                'Institutes',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.ADMIN)
            ListTile(
              onTap: () =>
                  Routes(context: context).navigate(const TutorManagement()),
              tileColor: color6,
              leading: Icon(
                Icons.person_4_outlined,
                color: color15,
              ),
              title: Text(
                'Tutors',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.INSTITUDE_MANAGER ||
              CustomUtils.loggedInUser!.type == LoggedUser.TUTOR)
            ListTile(
              onTap: () =>
                  Routes(context: context).navigate(const ClassManagement()),
              tileColor: color6,
              leading: Icon(
                Icons.class_outlined,
                color: color15,
              ),
              title: Text(
                'Class Management',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.STUDENT ||
              CustomUtils.loggedInUser!.type == LoggedUser.TUTOR)
            ListTile(
              onTap: () =>
                  Routes(context: context).navigate(const PaymentHistory()),
              tileColor: color6,
              leading: Icon(
                Icons.payment,
                color: color15,
              ),
              title: Text(
                'Payment History',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          ListTile(
            onTap: () => _authController.logout(context),
            tileColor: color6,
            leading: Icon(
              Icons.logout_outlined,
              color: color15,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                  color: color15, fontWeight: FontWeight.w400, fontSize: 15.0),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color15,
              size: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}
