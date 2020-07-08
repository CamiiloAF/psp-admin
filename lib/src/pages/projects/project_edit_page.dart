import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/utils/utils.dart' as utils;
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class ProjectEditPage extends StatefulWidget {
  @override
  _ProjectEditPageState createState() => _ProjectEditPageState();
}

class _ProjectEditPageState extends State<ProjectEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ProjectsBloc _projectsBloc;
  ProjectModel _projectModel = ProjectModel();

  int _inputNameCounter = 0;
  String _inputNameError;

  String _inputDescriptionError;

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAutorizedScreen();

    _projectsBloc = Provider.of<BlocProvider>(context).projectsBloc;

    final ProjectModel projectFromArgument =
        ModalRoute.of(context).settings.arguments;

    if (projectFromArgument != null) {
      _projectModel = projectFromArgument;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: S.of(context).appBarTitleProjects),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _inputName(),
              _inputDescription(),
              _inputPlanningDate(),
              _inputStartDate(),
              _inputFinishDate(),
              SubmitButton(onPressed: _submit)
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputName() {
    return InputName(
        initialValue: _projectModel.name,
        errorText: _inputNameError,
        counter: _inputNameCounter.toString(),
        onChange: (value) {
          setState(() {});
          _inputNameCounter = value.length;
          if (value.trim().length < 3) {
            _inputNameError = S.of(context).inputNameError;
            return S.of(context).inputNameError;
          } else {
            _inputNameError = null;
            return null;
          }
        },
        onSaved: (String value) => _projectModel.name = value.trim());
  }

  Widget _inputDescription() {
    return InputDescription(
        initialValue: _projectModel.description,
        errorText: _inputDescriptionError,
        onChange: (value) {
          setState(() {});
          if (value.trim().isEmpty) {
            _inputDescriptionError = S.of(context).inputRequiredError;
            return S.of(context).inputRequiredError;
          } else {
            _inputDescriptionError = null;
            return null;
          }
        },
        onSaved: (String value) => _projectModel.description = value.trim());
  }

  Widget _inputPlanningDate() {
    return InputDate(
        initialValue: (_projectModel.planningDate != null)
            ? DateTime.fromMillisecondsSinceEpoch(_projectModel.planningDate)
            : null,
        isRequired: true,
        labelAndHint: S.of(context).labelPlanningDate,
        onSaved: (DateTime value) =>
            _projectModel.planningDate = value.millisecondsSinceEpoch);
  }

  Widget _inputStartDate() {
    return InputDate(
        initialValue: (_projectModel.startDate != null)
            ? DateTime.fromMillisecondsSinceEpoch(_projectModel.startDate)
            : null,
        labelAndHint: S.of(context).labelStartDate,
        onSaved: (DateTime value) =>
            _projectModel.startDate = value?.millisecondsSinceEpoch);
  }

  Widget _inputFinishDate() {
    return InputDate(
        initialValue: (_projectModel.finishDate != null)
            ? DateTime.fromMillisecondsSinceEpoch(_projectModel.finishDate)
            : null,
        labelAndHint: S.of(context).labelFinishDate,
        onSaved: (DateTime value) =>
            _projectModel.finishDate = value?.millisecondsSinceEpoch);
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    if (!_isValidDates()) return;

    final progressDialog =
        utils.getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    var statusCode = -1;

    if (_projectModel.id == null) {
      statusCode = await _projectsBloc.insertProject(_projectModel);
      await progressDialog.hide();
    } else {
      statusCode = await _projectsBloc.updateProject(_projectModel);
      await progressDialog.hide();
    }

    if (statusCode == 201) {
      Navigator.pop(context);
    } else {
      await utils.showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }

  bool _isValidDates() {
    if (_projectsBloc.isValidDifferenceBetweenThreeDates(
        _projectModel.planningDate,
        _projectModel.startDate,
        _projectModel.finishDate)) {
      return true;
    } else {
      utils.showSnackBarIncorrectDates(context, _scaffoldKey.currentState);
      return false;
    }
  }
}
