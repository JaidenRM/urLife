import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/bloc/register/register_bloc.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/widgets/auth/register_button.dart';

class RegisterForm extends StatefulWidget {
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isRegisterButtonEnabled(RegisterState state) => state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onRegisterEmailChanged);
    _passwordController.addListener(_onRegisterPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    //BlocLISTENER used for DOING THINGS in response to state change
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if(state.isFailure) {
          Scaffold.of(context)
            //SNACKBAR: Similar to TOASTS. 1-time message at bottom of screen
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: <Widget>[
                    Text('Register Failure'),
                    Icon(Icons.error)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if(state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: <Widget>[
                    Text('Registering...'),
                    CircularProgressIndicator()
                  ],
                ),
              )
            );
        }
        if(state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
          //to instantly log the user in
          Navigator.of(context).pop();
        }
      },
      //BlocBUILDER used to RENDER WIDGETS in response to state change
      //Should just be used to call a PURE FUNCTION as it can be called MANY times by Flutter Framework
      //PURE FUNCTION = Given x arguments you will ALWAYS get y output and has NO side effects when EVALUATING
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Image.asset('assets/placeholder.jpg', height: 200),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) => !state.isEmailValid ? 'Invalid Email' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) => !state.isPasswordValid ? 'Invalid Password' : null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RegisterButton(
                          onPressed: isRegisterButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text)
    );
  }

  void _onRegisterPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text)
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text, 
        password: _passwordController.text
      )
    );
  }
}