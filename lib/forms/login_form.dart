import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/bloc/login/login_bloc.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/widgets/auth/create_account_button.dart';
import 'package:urLife/widgets/auth/google_login_button.dart';
import 'package:urLife/widgets/auth/login_button.dart';

//login form is stateful so it can manage its own 'TextEditingControllers'
class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({ Key key, @required UserRepository userRepository })
    : assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isLoginButtonEnabled(LoginState state) => state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onLoginEmailChanged);
    _passwordController.addListener(_onLoginPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    //BlocLISTENER used for DOING THINGS in response to state change
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if(state.isFailure) {
          Scaffold.of(context)
            //SNACKBAR: Similar to TOASTS. 1-time message at bottom of screen
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: <Widget>[
                    Text('Login Failure'),
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
                    Text('Logging in...'),
                    CircularProgressIndicator()
                  ],
                ),
              )
            );
        }
        if(state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
        }
      },
      //BlocBUILDER used to RENDER WIDGETS in response to state change
      //Should just be used to call a PURE FUNCTION as it can be called MANY times by Flutter Framework
      //PURE FUNCTION = Given x arguments you will ALWAYS get y output and has NO side effects when EVALUATING
      child: BlocBuilder<LoginBloc, LoginState>(
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
                        LoginButton(
                          onPressed: isLoginButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                        ),
                        GoogleLoginButton(),
                        CreateAccountButton(userRepository: _userRepository),
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

  void _onLoginEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text)
    );
  }

  void _onLoginPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text)
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text, 
        password: _passwordController.text
      )
    );
  }
}