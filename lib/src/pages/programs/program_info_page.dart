import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/languages_bloc.dart';
import 'package:psp_admin/src/models/languages_model.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/utils/utils.dart' as utils;
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';
import 'package:psp_admin/src/widgets/spinner_widget.dart';
import 'package:tuple/tuple.dart';

class ProgramInfoPage extends StatefulWidget {
  static const ROUTE_NAME = 'program-info';

  @override
  _ProgramInfoPageState createState() => _ProgramInfoPageState();
}

class _ProgramInfoPageState extends State<ProgramInfoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ProgramModel _programModel;

  LanguagesBloc _languagesBloc;

  @override
  void initState() {
    _languagesBloc = context.read<BlocProvider>().languagesBloc;
    _languagesBloc.getLanguages(true);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _programModel =
        ModalRoute.of(context).settings?.arguments ?? ProgramModel();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _languagesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: S.of(context).appBarTitlePrograms),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    final s = S.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            children: <Widget>[
              _buildReadOnlyInput(s.labelName, _programModel.name),
              _buildReadOnlyInput(
                  s.labelDescription, _programModel.description),
              SizedBox(
                height: 10,
              ),
              _buildLanguageDropdownButton(),
              _buildUserDropdownButton(),
              _buildInputDateDisable(
                  _programModel.planningDate, s.labelPlanningDate),
              _buildInputDateDisable(_programModel.startDate, s.labelStartDate),
              _buildInputDateDisable(
                  _programModel.deliveryDate, s.labelDeliveryDate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyInput(String label, String initialValue) {
    return InputForm(
      initialValue: initialValue,
      label: label,
      isReadOnly: true,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _buildLanguageDropdownButton() {
    return StreamBuilder<Tuple2<int, List<LanguageModel>>>(
      stream: _languagesBloc.languagesStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<LanguageModel>>> snapshot) {
        final statusCode = snapshot?.data?.item1 ?? 200;

        if (statusCode != 200) {
          utils.showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        final languageName = (snapshot.hasData)
            ? _languagesBloc.getLanguageNameById(_programModel.languagesId)
            : S.of(context).labelLoading;

        return Spinner(
          label: '${S.of(context).labelLanguage}:',
          value: languageName,
          items: [
            DropdownMenuItem(value: languageName, child: Text(languageName))
          ],
          onChanged: (value) {},
        );
      },
    );
  }

  Widget _buildUserDropdownButton() {
    final projectUsers = Provider.of<BlocProvider>(context)
        .usersBloc
        .lastValueUsersByProjectController
        ?.item2;

    final user = (!utils.isNullOrEmpty(projectUsers))
        ? projectUsers
            .firstWhere((element) => element.id == _programModel.usersId)
        : null;

    final userFullName = (user != null)
        ? '${user.firstName} ${user.lastName}'
        : S.of(context).labelNotAvailable;

    return Spinner(
      label: S.of(context).labelUser,
      value: userFullName,
      items: [DropdownMenuItem(value: userFullName, child: Text(userFullName))],
      onChanged: (value) {},
    );
  }

  Widget _buildInputDateDisable(int initialValueInMilliseconds, String label) {
    return InputDate(
      initialValue: (initialValueInMilliseconds != null)
          ? DateTime.fromMillisecondsSinceEpoch(initialValueInMilliseconds)
          : null,
      isEnabled: false,
      labelAndHint: label,
    );
  }
}
