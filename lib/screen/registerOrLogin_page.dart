import 'package:flutter/material.dart';
import 'package:getapi/screen/log_in_page.dart';
import 'package:getapi/screen/register_page.dart';

class RegisterOrLoginPage extends StatefulWidget {
  const RegisterOrLoginPage({ Key? key }) : super(key: key);

  @override
  _RegisterOrLoginPageState createState() => _RegisterOrLoginPageState();
}

class _RegisterOrLoginPageState extends State<RegisterOrLoginPage> {
bool showLoginPage = true;
void togglePages(){
  setState(() {
    showLoginPage = !showLoginPage;
  });
}


  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
  return LogInPage(
      onTap: togglePages,
    );
    }else{
       return RegisterPage(onTap: togglePages);
    }
  
  }
}