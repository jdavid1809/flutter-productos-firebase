import 'package:flutter/material.dart';
import 'package:productosapp/providers/loginFormProvider.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/ui/inputDecorations.dart';
import 'package:productosapp/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
              ),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Login",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height:30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50,),
              Text("Crear una nueva cuenta")
            ],
          ),  
        )
      )
    );
  }
}

class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final loginForm = Provider.of<LoginFormProvider>(context);
    
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: "Correo",
                labelText: "Correo electronico",
                prefixIcon: Icons.alternate_email,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);
                return regExp.hasMatch(value ?? "")
                  ? null
                  :"El valor ingresado no es un correo";
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: "******",
                labelText: "Password",
                prefixIcon: Icons.security,
              ),
              onChanged: (value) => loginForm.passport = value,
              validator: (value) {
                return (value != null && value.length >=6)
                  ? null
                  : "La contraseña debe de ser de 6 caracteres";
              },
            ),
            SizedBox(height: 30,),
            MaterialButton(
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
               disabledColor: Colors.grey,
               elevation: 0,
               color: Colors.deepPurple,
               child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                    ? "Espere"
                    : "Ingresar",
                  style: TextStyle(color: Colors.white),
                ),
               ),
              onPressed: loginForm.isLoading ? null :  () async {
                FocusScope.of(context).unfocus();
                if(!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                await Future.delayed(Duration(seconds: 2));

                loginForm.isLoading = false;

                Navigator.pushNamed(context, "home");
              },
            ),
          ],
        )
      ),
    );
  }
}