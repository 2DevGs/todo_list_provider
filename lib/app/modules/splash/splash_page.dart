import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_page.dart';

class SplashPage extends StatelessWidget {

  const SplashPage({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           body: Center(
            child: TodoListLogo(),
           ),
       );
  }
}