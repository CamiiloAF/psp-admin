import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/languages_bloc.dart';
import 'package:psp_admin/src/blocs/programs_bloc.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/languages_model.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/spinner_widget.dart';
import 'package:tuple/tuple.dart';

class ProgramCreatePage extends StatefulWidget {
  @override
  _ProgramCreatePageState createState() => _ProgramCreatePageState();
}

class _ProgramCreatePageState extends State<ProgramCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ProgramModel _programModel = ProgramModel();
  ProgramsBloc _programsBloc;

  int moduleId;

  LanguagesBloc _languagesBloc;
  UsersBloc usersBloc;

  int _inputNameCounter = 0;
  String _inputNameError;

  String _inputDescriptionError;

  List<LanguageModel> _languages;
  List<UserModel> _users;

  int _currentLanguageId;
  int _currentUserId;

  bool isSubmitButtonEnabled = false;

  @override
  void initState() {
    _languagesBloc = context.read<BlocProvider>().languagesBloc;
    _languagesBloc.getLanguages(true);

    usersBloc = context.read<BlocProvider>().usersBloc;

    _users = [];

    final lastValueUsersByProject =
        usersBloc.lastValueUsersByProjectController?.item2;

    if (!isNullOrEmpty(lastValueUsersByProject)) {
      lastValueUsersByProject.forEach((user) {
        if (user.rol != 'ADMIN') _users.add(user);
      });
    }

    _currentUserId = _users.isNotEmpty ? _users[0].id : -1;

    super.initState();
  }

  @override
  void dispose() {
    _languagesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _programsBloc = Provider.of<BlocProvider>(context).programsBloc;
    moduleId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: S.of(context).appBarTitlePrograms),
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
              SizedBox(
                height: 10,
              ),
              _buildLanguageDropdownButton(),
              _buildUserDropdownButton(),
              _inputPlanningDate(),
              _inputStartDate(),
              SubmitButton(
                  onPressed: (!isSubmitButtonEnabled) ? null : () => _submit())
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputName() {
    return InputName(
        initialValue: _programModel.name,
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
        onSaved: (String value) => _programModel.name = value.trim());
  }

  Widget _inputDescription() {
    return InputDescription(
        initialValue: _programModel.description,
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
        onSaved: (String value) => _programModel.description = value.trim());
  }

  Widget _buildLanguageDropdownButton() {
    var haveVerifyIfHaveUsersAndLanguages = false;
    return StreamBuilder<Tuple2<int, List<LanguageModel>>>(
      stream: _languagesBloc.languagesStream,
      initialData: Tuple2(200, [LanguageModel(id: -1, name: 'Cargando...')]),
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<LanguageModel>>> snapshot) {
        _languages = snapshot?.data?.item2 ??
            [LanguageModel(id: -1, name: 'Cargando...')];

        final statusCode = snapshot?.data?.item1 ?? 200;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (_currentLanguageId == null || _currentLanguageId == -1) {
          _currentLanguageId =
              (!isNullOrEmpty(_languages)) ? _languages[0].id : -2;
        }

        if (_currentLanguageId != -1 && !haveVerifyIfHaveUsersAndLanguages) {
          haveVerifyIfHaveUsersAndLanguages = true;
          _verifyIfHaveUsersAndLanguages();
        }

        return Spinner(
          label: S.of(context).labelLanguage,
          value: _currentLanguageId,
          items: getDropDownMenuItems(true),
          onChanged: (selectedItem) => changedDropDownItem(selectedItem, true),
        );
      },
    );
  }

  Widget _buildUserDropdownButton() {
    return Spinner(
      label: S.of(context).labelUser,
      value: _currentUserId,
      items: getDropDownMenuItems(false),
      onChanged: (selectedItem) => changedDropDownItem(selectedItem, false),
    );
  }

  List<DropdownMenuItem<int>> getDropDownMenuItems(bool isForLanguages) {
    var items = <DropdownMenuItem<int>>[];
    if (isForLanguages) {
      if (!isNullOrEmpty(_languages)) {
        _languages.forEach((language) {
          items.add(
              DropdownMenuItem(value: language.id, child: Text(language.name)));
        });
      }
    } else {
      if (_users != null && _users.isNotEmpty) {
        _users.forEach((user) {
          final userFullName = '${user.firstName} ${user.lastName}';
          items.add(DropdownMenuItem(
              value: user.id,
              child: Text(
                userFullName,
                overflow: TextOverflow.ellipsis,
              )));
        });
      }
    }
    return items;
  }

  void changedDropDownItem(int selectedItem, bool isForLanguages) {
    setState(() {
      if (isForLanguages) {
        _currentLanguageId = selectedItem;
      } else {
        _currentUserId = selectedItem;
      }
    });
  }

  Widget _inputPlanningDate() {
    return InputDate(
        initialValue: (_programModel.planningDate != null)
            ? DateTime.fromMillisecondsSinceEpoch(_programModel.planningDate)
            : null,
        isRequired: true,
        labelAndHint: S.of(context).labelPlanningDate,
        onSaved: (DateTime value) =>
            _programModel.planningDate = value.millisecondsSinceEpoch);
  }

  Widget _inputStartDate() {
    return InputDate(
        initialValue: (_programModel.startDate != null)
            ? DateTime.fromMillisecondsSinceEpoch(_programModel.startDate)
            : null,
        isRequired: true,
        labelAndHint: S.of(context).labelStartDate,
        onSaved: (DateTime value) =>
            _programModel.startDate = value?.millisecondsSinceEpoch);
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    var statusCode = -1;

    _programModel.languagesId = _currentLanguageId;
    _programModel.usersId = _currentUserId;
    _programModel.modulesId = moduleId;

    statusCode = await _programsBloc.insertProgram(_programModel);
    await progressDialog.hide();

    if (statusCode == 201) {
      Navigator.pop(context);
    } else {
      await showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }

  void _verifyIfHaveUsersAndLanguages() async {
    if (_users.isEmpty || _languages.isEmpty) {
      _showSnackBarUsersAndLanguagesAreRequired();
    } else {
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          isSubmitButtonEnabled = true;
        });
      }
    }
  }

  void _showSnackBarUsersAndLanguagesAreRequired() async {
    final s = S.of(context);
    var message;

    if (_users.isEmpty && _languages.isEmpty) {
      message = s.messageAtLeastOneUserAndLanguageIsRequiered;
    } else {
      message = (_users.isEmpty)
          ? s.messageAtLeastOneUserIsRequiered
          : s.messageAtLeastOneLanguageIsRequiered;
    }
    await Future.delayed(Duration(milliseconds: 500));
    await _scaffoldKey.currentState?.showSnackBar(buildSnackbar(Text(message)));
  }
}
