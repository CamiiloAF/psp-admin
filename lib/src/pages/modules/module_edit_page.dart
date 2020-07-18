import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/modules_bloc.dart';
import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/utils/utils.dart' as utils;
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';

class ModuleEditPage extends StatefulWidget {
  static const ROUTE_NAME = 'edit-module';

  @override
  _ModuleEditPageState createState() => _ModuleEditPageState();
}

class _ModuleEditPageState extends State<ModuleEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ModulesBloc _modulesBloc;
  ModuleModel _moduleModel = ModuleModel();

  int _inputNameCounter = 0;
  String _inputNameError;

  String _inputDescriptionError;

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    _modulesBloc = Provider.of<BlocProvider>(context).modulesBloc;

    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;

    final int projectId = arguments[1];

    if (arguments[0] != null) {
      _moduleModel = arguments[0];
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: S.of(context).appBarTitleModules),
      body: _createBody(projectId),
    );
  }

  Widget _createBody(int projectId) {
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
              SubmitButton(onPressed: () => _submit(projectId))
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputName() {
    return InputName(
        initialValue: _moduleModel.name,
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
        onSaved: (String value) => _moduleModel.name = value.trim());
  }

  Widget _inputDescription() {
    return InputDescription(
        initialValue: _moduleModel.description,
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
        onSaved: (String value) => _moduleModel.description = value.trim());
  }

  Widget _inputPlanningDate() {
    return InputDate(
        initialValue: (_moduleModel.planningDate != null)
            ? DateTime.fromMillisecondsSinceEpoch(_moduleModel.planningDate)
            : null,
        isRequired: true,
        labelAndHint: S.of(context).labelPlanningDate,
        onSaved: (DateTime value) =>
            _moduleModel.planningDate = value.millisecondsSinceEpoch);
  }

  Widget _inputStartDate() {
    return InputDate(
        initialValue: (_moduleModel.startDate != null)
            ? DateTime.fromMillisecondsSinceEpoch(_moduleModel.startDate)
            : null,
        labelAndHint: S.of(context).labelStartDate,
        onSaved: (DateTime value) =>
            _moduleModel.startDate = value?.millisecondsSinceEpoch);
  }

  Widget _inputFinishDate() {
    return InputDate(
        initialValue: (_moduleModel.finishDate != null)
            ? DateTime.fromMillisecondsSinceEpoch(_moduleModel.finishDate)
            : null,
        labelAndHint: S.of(context).labelFinishDate,
        onSaved: (DateTime value) =>
            _moduleModel.finishDate = value?.millisecondsSinceEpoch);
  }

  void _submit(int projectId) async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    if (!_isValidDates()) return;

    final progressDialog =
        utils.getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    var statusCode = -1;

    if (_moduleModel.id == null) {
      _moduleModel.projectsId = projectId;
      statusCode = await _modulesBloc.insertModule(_moduleModel);
      await progressDialog.hide();
    } else {
      statusCode = await _modulesBloc.updateModule(_moduleModel);
      await progressDialog.hide();
    }

    if (statusCode == 201) {
      Navigator.pop(context);
    } else {
      await utils.showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }

  bool _isValidDates() {
    if (_modulesBloc.isValidDifferenceBetweenThreeDates(
        _moduleModel.planningDate,
        _moduleModel.startDate,
        _moduleModel.finishDate)) {
      return true;
    } else {
      utils.showSnackBarIncorrectDates(context, _scaffoldKey.currentState);
      return false;
    }
  }
}
