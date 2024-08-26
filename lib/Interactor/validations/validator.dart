

class ValidatorDataSent {

  static String validatePassword({required String password}){
    if(password.trim().isEmpty){
      return 'Senha não pode estar vazia';
    }else if(!containsUpperCaseLetter(password.trim())){
      return 'Senha deve ter pelo menos uma letra maiúscula';
    }else if(!containsLowerCaseLetter(password.trim())){
      return 'Senha deve ter pelo menos uma letra minúscula';
    }else if(!containsNumber(password.trim())){
      return 'Senha deve ter pelo menos 1 número';
    }else if(password.trim().length < 8){
      return 'Senha deve ter mais que 8 caracteres';
    }else{
      return "";
    }
  }

  static String validateConfirmPassword({required String password, required String confirmPassword}){
    if(confirmPassword.trim().isEmpty){
      return 'Confirmação de senha não pode estar vazia';
    }else if(confirmPassword.trim().length < 8){
      return 'Confirmação de senha deve ter mais que 8 caracteres';
    }else if(confirmPassword.trim() != password.trim()){
      return 'Confirmação de senha deve ser igual a senha informada';
    }else if(!containsUpperCaseLetter(confirmPassword.trim())){
      return 'Confirmação de senha deve ter pelo menos uma letra maiúscula';
    }else if(!containsLowerCaseLetter(confirmPassword.trim())){
      return 'Confirmação de senha deve ter pelo menos uma letra minúscula';
    }else if(!containsNumber(confirmPassword.trim())){
      return 'Confirmação de senha deve ter pelo menos 1 número';
    }else{
      return "";
    }
  }

  static bool containsUpperCaseLetter(String text) {
    RegExp regex = RegExp(r'[A-Z]');
    return regex.hasMatch(text);
  }

  static bool containsLowerCaseLetter(String text) {
    RegExp regex = RegExp(r'[a-z]');
    return regex.hasMatch(text);
  }

  static bool containsNumber(String text) {
    RegExp regex = RegExp(r'\d');
    return regex.hasMatch(text);
  }
}