import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/app_module.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/theme_extension.dart';
import 'package:todo_list_provider/app/core/validators/validators.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_field.dart';
// import 'package:todo_list_provider/app/core/widget/todo_list_field.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {


  RegisterPage({Key? key }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();
  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
  //   context.read<RegisterController>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final defaultListener = DefaultListenerNotifier(changeNotifier: context.read<RegisterController>());
    defaultListener.listener(
      context: context, 
      successCallBack: (notifier, listenerInstance) {
        listenerInstance.dispose();
        // Removemos esse pop devido a alteração do AuthProvider
        // Navigator.of(context).pop();
      },

      // esse atributo é opcional
      // errorCallback: (notifier, listenerInstance) {
      //   print('Deu RUIM!!!!');
      // },
    );
    // context.read<RegisterController>().addListener(() {
    //   final controller = context.read<RegisterController>();
    //   var success = controller.success;
    //   var error = controller.error;
    //   if(success) {
    //     Navigator.of(context).pop();
    //   } else if(error != null && error.isNotEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(error),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // });
  }

   @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Todo List',
                  style: TextStyle(
                    fontSize: 10,
                    color: context.primaryColor
                  ),
                  ),
                Text(
                  'Cadastro',
                  style: TextStyle(
                    fontSize: 15,
                    color: context.primaryColor
                  ),
                  ),
              ],
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: ClipOval(
                child: Container(
                  color: context.primaryColor.withAlpha(20),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios_outlined, 
                    size: 20, 
                    color: context.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          body: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * .5,
                child: FittedBox(
                  child: TodoListLogo(),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                    TodoListField(
                      label: 'E-mail',
                      controller: _emailEC,
                      validator: Validatorless.multiple([
                        Validatorless.required('E-mail obrigatório'),
                        Validatorless.email('E-mail Inválido'),
                      ]),
                    ),
                    SizedBox(height: 20,),
                    TodoListField(
                      label: 'Senha',
                      obscureText: true,
                      controller: _passwordEC,
                      validator: Validatorless.multiple([
                        Validatorless.required('Senha obrigatória'),
                        Validatorless.min(6, 'Senha deve ter pelo menos 6 caracteres'),
                      ]),
                      ),
                    SizedBox(height: 20,),
                    TodoListField(
                      label: 'Confirmar Senha',
                      obscureText: true,
                      controller: _confirmPasswordEC,
                      validator: Validatorless.multiple([
                        Validatorless.required('Confirma Senha obrigatória'),
                        Validators.compare(_passwordEC, 'Senha diferente de Confirma Senha'),
                      ]),
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: (){
                          final formValid = _formKey.currentState?.validate() ?? false;
                          if(formValid) {
                            final email = _emailEC.text;
                            final password = _passwordEC.text;
                            context.read<RegisterController>().registerUser(email, password);
                          }
                        }, 
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Salvar',style: TextStyle(color: Colors.white),),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      );
  }
}