import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/bloc/profile/profile_bloc.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/widgets/generic_button.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({ Key key, @required UserRepository userRepository })
    : assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileFormState();

}

class _ProfileFormState extends State<ProfileForm> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  ProfileBloc _profileBloc;
  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated => _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;
  bool isSubmitButtonedEnabled(ProfileState state) => state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _firstNameController.addListener(_onTextChanged);
    _lastNameController.addListener(_onTextChanged);
    _heightController.addListener(_onTextChanged);
    _weightController.addListener(_onTextChanged);
    _ageController.addListener(_onTextChanged);
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
                    controller: _firstNameController,
                    autovalidate: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      labelText: 'First Name'
                    ),
                    validator: (_) => !state.isFirstNameValid ? 'Invalid first name' : null,
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    autovalidate: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      labelText: 'Last Name'
                    ),
                    validator: (_) => !state.isLastNameValid ? 'Invalid last name' : null,
                  ),
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
                  TextFormField(
                    controller: _ageController,
                    autovalidate: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.stethoscope),
                      labelText: 'Age'
                    ),
                    keyboardType: TextInputType.number,
                    validator: (_) => !state.isAgeValid ? 'Invalid age' : null,
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _profileBloc.add(
      ProfileUpdated(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        height: _heightController.text,
        weight: _weightController.text,
        age: _ageController.text
      )
    );
  }

  void _onTextChanged() {
    _profileBloc.add(
      ProfileTextChanged(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        height: _heightController.text,
        weight: _weightController.text,
        age: _ageController.text
      )
    );
  }
}
