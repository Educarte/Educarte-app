String? nome;
int? profile;
bool firstAccess = false;

String? emailEsqueciSenha;
String? code;

int checkUserType({required String profileType}) {
  return switch (profileType) {
    "Employee" || "Teacher" || "Admin" => profile = 2,
    _ => profile = 1
  };
}

String routerPath({required bool firstAccess}) {
  if (firstAccess) {
    return "/redefinirSenha";
  } else {
    if (profile == 1) {
      return "/home";
    } else {
      return "/timeControl";
    }
  }
}
