import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urLife/bloc/profile/profile_bloc.dart';
import 'package:urLife/forms/profile_pt2_form.dart';
import 'package:urLife/widgets/generic_button.dart';

class ProfileFormPart1 extends StatefulWidget {

  ProfileFormPart1({ Key key })
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileFormPart1State();

}

class _ProfileFormPart1State extends State<ProfileFormPart1> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  ProfileBloc _profileBloc;

  bool get isPopulated => _firstNameController.text.isNotEmpty 
    && _lastNameController.text.isNotEmpty && _ageController.text.isNotEmpty;
  bool isSubmitButtonedEnabled(ProfileState state) => state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _firstNameController.addListener(_onTextChanged);
    _lastNameController.addListener(_onTextChanged);
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
                    Text('Save failed!'),
                    Icon(Icons.error)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                backgroundColor: Colors.red,
              )
            );
        }
        if(state.isSaved) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                BlocProvider<ProfileBloc>(
                  create: (context) => _profileBloc,
                  child: Scaffold(
                    body: ProfileFormPart2(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      age: _ageController.text,
                    ),
                  )
                )
            )
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                  child: SingleChildScrollView(
                    child: Column(
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
                      ],
                    ),
                  ),
                
              ),
            ),
            floatingActionButton: 
              GenericButton(
                buttonText: Text('Next'),
                onPressed:
                  isSubmitButtonedEnabled(state)
                  ? _onFormSubmitted
                  : null,
              ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }
    
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() => _profileBloc.add(ProfileSaved());

  void _onTextChanged() {
    _profileBloc.add(
      ProfileTextChanged(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        age: _ageController.text
      )
    );
  }
}
