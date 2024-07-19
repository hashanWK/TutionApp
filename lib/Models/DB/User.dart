class LoggedUser {
  static const int ADMIN = 1;
  static const int INSTITUDE_MANAGER = 2;
  static const int TUTOR = 3;
  static const int STUDENT = 4;

  var uid, name, gmobile, email, type, user;

  LoggedUser(
      {this.uid, this.name, this.email, this.type, this.user, this.gmobile});
}
