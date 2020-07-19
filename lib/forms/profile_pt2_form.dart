import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/bloc/profile/profile_bloc.dart';
import 'package:urLife/models/Profile.dart';
import 'package:urLife/widgets/animated/anim_left_center_icon_button.dart';
import 'package:urLife/widgets/bmi.dart';
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

  bool _showHeight;
  bool _showWeight;
  
  ProfileBloc _profileBloc;

  final String firstName;
  final String lastName;
  final String age;

  _ProfileFormPart2State(this.firstName, this.lastName, this.age);

  bool get isPopulated => _heightController.text.isNotEmpty && _weightController.text.isNotEmpty;
  bool isSubmitButtonedEnabled(ProfileState state) => state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _heightController.addListener(_onTextChanged);
    _weightController.addListener(_onTextChanged);
    _showHeight = true;
    _showWeight = false;
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
          setState(() {
            _showHeight = false;
            _showWeight = false;
          });
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _showHeight 
                        ?
                          TextFormField(
                            controller: _heightController,
                            autofocus: true,
                            autovalidate: true,
                            autocorrect: true,
                            decoration: InputDecoration(
                              icon: Icon(FontAwesomeIcons.rulerVertical),
                              labelText: 'Height (cm)'
                            ),
                            keyboardType: TextInputType.number,
                            validator: (_) => !state.isHeightValid ? 'Invalid height' : null,
                          ) 
                        :
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: <Widget>[
                                Text(_heightController.text, style: TextStyle(fontSize: 48,)),
                                AnimatedIconButtonLeftCenter(
                                  iconSize: 78,
                                  icon: Icon(FontAwesomeIcons.rulerVertical),
                                  onPressed: state.isSuccess
                                  ?
                                    null
                                  :
                                    () => setState(() { 
                                      _showWeight = !_showWeight; 
                                      _showHeight = !_showHeight;
                                    })
                                  ,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ),
                        _showWeight
                        ?
                          TextFormField(
                            controller: _weightController,
                            autofocus: true,
                            autovalidate: true,
                            autocorrect: true,
                            decoration: InputDecoration(
                              icon: Icon(FontAwesomeIcons.weight),
                              labelText: 'Weight (kg)'
                            ),
                            keyboardType: TextInputType.number,
                            validator: (_) => !state.isWeightValid ? 'Invalid weight' : null,
                          )
                        :
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: <Widget>[
                                Text(_weightController.text, style: TextStyle(fontSize: 48,)),
                                AnimatedIconButtonLeftCenter(
                                  iconSize: 78,
                                  icon: Icon(FontAwesomeIcons.weight),
                                  onPressed: state.isSuccess
                                  ?
                                    null
                                  :
                                    () => setState(() { 
                                      _showWeight = !_showWeight; 
                                      _showHeight = !_showHeight;
                                    })
                                  ,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          )
                        ,
                        state.isSuccess
                        ?
                          BMI(profile: Profile(
                            firstName: this.firstName,
                            lastName: this.lastName,
                            age: num.parse(this.age),
                            height: num.parse(_heightController.text),
                            weight: num.parse(_weightController.text)
                          ),)
                        :
                          Container()
                        ,
                      ],
                    )
                  )
                ),
              ),
            ),
            floatingActionButton: 
              !state.isSuccess
              ?
                GenericButton(
                  buttonText: Text('Update'),
                  onPressed:
                    isSubmitButtonedEnabled(state)
                    ? _onFormSubmitted
                    : null,
                )
              :
                GenericButton(
                  buttonText: Text('Continue'),
                  onPressed: _goHome,
                ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  void _goHome() {
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
    //to return to home screen
    Navigator.of(context).popUntil(ModalRoute.withName(Navigator.defaultRouteName));
  }

  void _onTextChanged() {
    _profileBloc.add(
      ProfileTextChanged(
        firstName: firstName,
        lastName: lastName,
        height: _heightController.text,
        weight: _weightController.text,
        age: age
      )
    );
  }
}
