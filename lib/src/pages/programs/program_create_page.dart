import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:tuple/tuple.dart';

class ProgramCreatePage extends StatefulWidget {
  @override
  _ProgramCreatePageState createState() => _ProgramCreatePageState();
}

class _ProgramCreatePageState extends State<ProgramCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ProgramModel _programModel = ProgramModel();
  ProgramsBloc _programsBloc;

  LanguagesBloc languagesBloc;
  UsersBloc usersBloc;

  int _inputNameCounter = 0;
  String _inputNameError;

  String _inputDescriptionError;

  List<LanguageModel> _languages;
  List<UserModel> _users;

  int _currentLanguageId;
  int _currentUserId;

  @override
  void initState() {
    languagesBloc = context.read<BlocProvider>().languagesBloc;
    languagesBloc.getLanguages(true);

    usersBloc = context.read<BlocProvider>().usersBloc;
    _users = usersBloc.lastValueUsersByProjectController?.item2;

    _currentUserId = _users[0].id;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _programsBloc = Provider.of<BlocProvider>(context).programsBloc;

    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;

    final int projectId = 1;

    // final int projectId = arguments[1];

    // if (arguments[0] != null) {
    //   _programModel = arguments[0];
    // }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).appBarTitlePrograms),
      ),
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
              _buildLanguageDropdownButton(),
              _buildUserDropdownButton(),
              _inputPlanningDate(),
              _inputStartDate(),
              SubmitButton(onPressed: () => _submit(projectId))
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
    return StreamBuilder<Tuple2<int, List<LanguageModel>>>(
      stream: languagesBloc.languageStream,
      initialData: Tuple2(200, [LanguageModel(id: -1, name: 'Cargando...')]),
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<LanguageModel>>> snapshot) {
        _languages = snapshot.data.item2;
        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        _currentLanguageId = _languages[0].id;

        return Row(
          children: [
            Text(S.of(context).labelLanguage),
            Expanded(
              child: Container(),
            ),
            DropdownButton(
              value: _currentLanguageId,
              items: getDropDownMenuItems(true),
              onChanged: (int selectedItem) =>
                  changedDropDownItem(selectedItem, true),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserDropdownButton() {
    return Row(
      children: [
        Text(S.of(context).labelUser),
        Expanded(
          child: Container(),
        ),
        DropdownButton(
          value: _currentUserId,
          items: getDropDownMenuItems(false),
          onChanged: (int selectedItem) =>
              changedDropDownItem(selectedItem, false),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int>> getDropDownMenuItems(bool isForLanguages) {
    var items = <DropdownMenuItem<int>>[];
    if (isForLanguages) {
      if (_languages != null && _languages.isNotEmpty) {
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

  void _submit(int projectId) async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    var statusCode = -1;

    _programModel.languagesId = _currentLanguageId;
    _programModel.usersId = _currentUserId;

    statusCode = await _programsBloc.insertProgram(_programModel);
    await progressDialog.hide();

    if (statusCode == 201) {
      Navigator.pop(context);
    } else {
      showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }
}
