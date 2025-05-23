import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/ui/todo_list_icons.dart';
import 'package:todo_list_provider/app/core/ui/theme_extension.dart';


class TodoListField extends StatelessWidget {
  
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  TodoListField({
    Key? key,
    required this.label,
    this.suffixIconButton,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.focusNode,
  }) : assert(obscureText == true ? suffixIconButton == null : true, 
            'ObscureText Não pode ser enviado em conjunto com suffixIconButton'),
        obscureTextVN = ValueNotifier(obscureText),
        super(key: key);

   @override
  Widget build(BuildContext context) {
      return ValueListenableBuilder<bool>(
          valueListenable: obscureTextVN,
          builder: (_, obscureTextValue, child) {
              return TextFormField(
                controller: controller,
                validator: validator,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.red),
                ),
                isDense: true,
                suffixIcon: this.suffixIconButton ??
                  (obscureText == true 
                    ? IconButton(
                      onPressed: (){
                      obscureTextVN.value = !obscureTextValue;
                      }, 
                      icon: Icon(
                        !obscureTextValue 
                        ? TodoListIcons.eye_slash
                        : TodoListIcons.eye,
                      ),
                    ) 
                    : null),
                ),
              obscureText: obscureTextValue,
            );
          },
      );
  }
}
