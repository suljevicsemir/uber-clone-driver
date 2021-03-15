

import 'package:uber_clone_driver/screens/get_started/sign_in.dart';

enum SignInResults {
  UserDisabled,
  UserNotFound,
  WrongPassword,
  Success,
  Timeout
}


extension SignInResultsExtension on SignInResults {
  String parseMessage() {

   if(this == SignInResults.WrongPassword ) {
     return 'Invalid password!';
   }
   if(this == SignInResults.UserDisabled) {
     return 'Account disabled!';
   }
    return 'Email does not exist!';
  }

  SignInResults parseErrorCode(String code) {
    if(code == 'user-disabled')
      return SignInResults.UserDisabled;
    if(code == 'user-not-found')
      return SignInResults.UserNotFound;
    return SignInResults.WrongPassword;
  }
}



class SignInResult {
  late SignInResults result;

  SignInResult.fromErrorCode(String code) {
    print(code);

    if(code == 'user-disabled')
      result =  SignInResults.UserDisabled;
    else if(code == 'user-not-found')
      result = SignInResults.UserNotFound;
    else result = SignInResults.WrongPassword;
  }

  SignInResult(SignInResults result) : result = result;


  factory SignInResult.success() {
    return SignInResult(SignInResults.Success);
  }
  factory SignInResult.timeout() {
    return SignInResult(SignInResults.Timeout);
  }

}







