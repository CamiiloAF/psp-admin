import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/experiences_bloc.dart';
import 'package:psp_admin/src/models/experience_model.dart';
import 'package:psp_admin/src/pages/projects/projects_page.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_popup_menu.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class ExperiencesPage extends StatefulWidget {
  static const ROUTE_NAME = 'experiences';
  @override
  _ExperiencesPageState createState() => _ExperiencesPageState();
}

class _ExperiencesPageState extends State<ExperiencesPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final preferences = Preferences();

  ExperienceModel _experienceModel;
  ExperiencesBloc _experiencesBloc;

  String _retainedToken = '';

  int _userId;
  int _currentUserId;

  @override
  void initState() {
    _experiencesBloc = context.read<BlocProvider>().experiencesBloc;
    _experienceModel = ExperienceModel();

    _currentUserId = json.decode(preferences.curentUser)['id'];

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userId = ModalRoute.of(context).settings.arguments;
    if (_userId != null &&
        _experiencesBloc.lastValueTestReportsController == null) {
      _experiencesBloc.getExperience(false, _userId);
    }

    _retainToken();

    super.didChangeDependencies();
  }

  // ! Para evitar que cierre la app y vuelva a ingresar con un token,
  // ! lo que ocasionaría que lo llevara a proyectos sin haber creado una experiencia
  void _retainToken() {
    if (_userId == null) {
      _retainedToken = preferences.token;
      preferences.token = '';
    }
  }

  @override
  void dispose() {
    _experiencesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken() && _retainedToken.isEmpty) {
      return NotAutorizedScreen();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: (_userId != null)
          ? CustomAppBar(title: S.of(context).appBarTitleExperiences)
          : AppBar(
              title: Text(S.of(context).appBarTitleExperiences),
              actions: [
                IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => CustomPopupMenu.doLogout(context))
              ],
            ),
      body: (_userId == null) ? _buildForm() : _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder(
      stream: _experiencesBloc.experienceStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, ExperienceModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        _experienceModel = snapshot.data?.item2 ?? ExperienceModel();

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        return RefreshIndicator(
          onRefresh: () => (_userId == null) ? null : _refreshExperience(),
          child: _buildForm(),
        );
      },
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildInputPositions(),
              _buildNumericInput(
                  S.of(context).labelYearsGenerals,
                  '${_experienceModel.yearsGenerals ?? ''}',
                  (value) => _experienceModel.yearsGenerals = int.parse(value)),
              _buildNumericInput(
                  S.of(context).labelYearsConfiguration,
                  '${_experienceModel.yearsConfiguration ?? ''}',
                  (value) =>
                      _experienceModel.yearsConfiguration = int.parse(value)),
              _buildNumericInput(
                  S.of(context).labelYearsIntegration,
                  '${_experienceModel.yearsIntegration ?? ''}',
                  (value) =>
                      _experienceModel.yearsIntegration = int.parse(value)),
              _buildNumericInput(
                  S.of(context).labelYearsRequirements,
                  '${_experienceModel.yearsRequirements ?? ''}',
                  (value) =>
                      _experienceModel.yearsRequirements = int.parse(value)),
              _buildNumericInput(
                  S.of(context).labelYearsDesign,
                  '${_experienceModel.yearsDesign ?? ''}',
                  (value) => _experienceModel.yearsDesign = int.parse(value)),
              _buildNumericInput(
                  S.of(context).labelYearsTests,
                  '${_experienceModel.yearsTests ?? ''}',
                  (value) => _experienceModel.yearsTests = int.parse(value)),
              _buildNumericInput(
                  S.of(context).labelYearsSupport,
                  '${_experienceModel.yearsSupport ?? ''}',
                  (value) => _experienceModel.yearsSupport = int.parse(value)),
              (_userId == null || _userId == _currentUserId)
                  ? SubmitButton(onPressed: () => _submit())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputPositions() {
    final inputRequiredError = S.of(context).inputRequiredError;
    final isReadOnly = (_userId != null && _userId != _currentUserId);
    return CustomInput(
      label: S.of(context).labelPositions,
      initialValue: _experienceModel.positions,
      isReadOnly: isReadOnly,
      errorText: inputRequiredError,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      minLines: 1,
      onSaved: (value) => _experienceModel.positions = value,
      onChanged: (value) => value.isEmpty,
      validator: (value) => (value.isEmpty) ? inputRequiredError : null,
    );
  }

  Widget _buildNumericInput(
      String label, String initialValue, Function(String value) onSaved) {
    final isReadOnly = (_userId != null && _userId != _currentUserId);

    return CustomInput(
      label: label,
      initialValue: initialValue,
      isReadOnly: isReadOnly,
      errorText: S.of(context).invalidNumber,
      keyboardType: TextInputType.number,
      onSaved: onSaved,
      onChanged: _onChangeNumericInput,
      validator: _inputNumericValidator,
    );
  }

  bool _onChangeNumericInput(String value) =>
      !_experiencesBloc.isValidNumber(value);

  String _inputNumericValidator(String value) =>
      (_experiencesBloc.isValidNumber(value))
          ? null
          : S.of(context).invalidNumber;

  void _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    _restoreToken();

    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    final statusCode = (_experienceModel.id != null)
        ? await _experiencesBloc.updateExperience(_experienceModel)
        : await _experiencesBloc.insertExperience(_experienceModel);

    await progressDialog.hide();

    if (statusCode == 201) {
      _restoreToken();
      await Navigator.pushReplacementNamed(context, ProjectsPage.ROUTE_NAME);
    } else {
      _retainToken();
      await showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }

  void _restoreToken() =>
      (_userId == null) ? preferences.token = _retainedToken : null;

  Future<void> _refreshExperience() async =>
      await _experiencesBloc.getExperience(true, _userId);
}
