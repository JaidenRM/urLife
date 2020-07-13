import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/bloc/profile/profile_bloc.dart';
import 'package:urLife/widgets/generic_button.dart';

class ProfileFormPart2 extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String age;

  ProfileFormPart2({ Key key, this.firstName, this.lastName, this.age })
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileFormPart2State(firstName, lastName, age);

}

class _ProfileFormPart2State extends State<ProfileFormPart2> {
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  
  ProfileBloc _profileBloc;

  final String firstName;
  final String lastName;
  final String age;

  _ProfileFormPart2State(this.firstName, this.lastName, this.age);

  bool get isPopulated => true;
  bool isSubmitButtonedEnabled(ProfileState state) => state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _heightController.addListener(_onTextChanged);
    _weightController.addListener(_onTextChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if(state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: <Widget>[
                    Text('Update failed!'),
                    Icon(Icons.error)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                backgroundColor: Colors.red,
              )
            );
        }
        if(state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: <Widget>[
                    Text('Updating profile'),
                    CircularProgressIndicator()
                  ],
                ),
              )
            );
        }
        if(state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
          //to return to home screen
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _heightController,
                    autovalidate: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.rulerVertical),
                      labelText: 'Height (cm)'
                    ),
                    keyboardType: TextInputType.number,
                    validator: (_) => !state.isHeightValid ? 'Invalid height' : null,
                  ),
                  TextFormField(
                    controller: _weightController,
                    autovalidate: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.weight),
                      labelText: 'Weight (kg)'
                    ),
                    keyboardType: TextInputType.number,
                    validator: (_) => !state.isWeightValid ? 'Invalid weight' : null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: GenericButton(
                      buttonText: 'Update',
                      onPressed:
                        isSubmitButtonedEnabled(state)
                        ? _onFormSubmitted
                        : null,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
    
  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _profileBloc.add(
      ProfileUpdated(
        firstName: firstName,
        lastName: lastName,
        height: _heightController.text,
        weight: _weightController.text,
        age: age,
      )
    );
  }

  void _onTextChanged() {
    _profileBloc.add(
      ProfileTextChanged(
        height: _heightController.text,
        weight: _weightController.text,
      )
    );
  }
}
