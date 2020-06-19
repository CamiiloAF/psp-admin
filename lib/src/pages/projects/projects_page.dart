import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/fab_model.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/searchs/search_projects.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:tuple/tuple.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController controller = ScrollController();
  double lastScroll = 0;

  @override
  void initState() {
    controller.addListener(() {
      if (controller.offset > lastScroll && controller.offset > 150) {
        Provider.of<FabModel>(context, listen: false).isShowing = false;
      } else {
        Provider.of<FabModel>(context, listen: false).isShowing = true;
      }

      lastScroll = controller.offset;
    });

    super.initState();

    context.read<BlocProvider>().projectsBloc.getProjects(false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShowing = Provider.of<FabModel>(context).isShowing;
    final projectsBloc = Provider.of<BlocProvider>(context).projectsBloc;

    Constants.token = Preferences().token;

    if (!isValidToken()) return NotAutorizedScreen();

    return ChangeNotifierProvider(
      create: (_) => FabModel(),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
              title: S.of(context).appBarTitleProjects,
              searchDelegate: SearchProjects(projectsBloc)),
          body: _body(projectsBloc),
          floatingActionButton: FAB(
            isShowing: isShowing,
            routeName: 'editProject',
          ),
          drawer: CustomDrawerMenu(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat),
    );
  }

  Widget _body(ProjectsBloc projectsBloc) {
    return StreamBuilder(
      stream: projectsBloc.projectStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<ProjectModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final projects = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (projects.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshProjects(context, projectsBloc),
            child: ListView(
              children: [
                Center(
                  child: Text(S.of(context).thereIsNoInformation),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshProjects(context, projectsBloc),
          child: _buildListView(projects),
        );
      },
    );
  }

  ListView _buildListView(List<ProjectModel> projects) {
    return ListView.separated(
        controller: controller,
        itemCount: projects.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(projects, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<ProjectModel> projects, int i, BuildContext context) {
    return CustomListTile(
      title: projects[i].name,
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, 'editProject', arguments: projects[i]);
          }),
      onTap: () => Navigator.pushNamed(context, 'projectItems',
          arguments: projects[i].id),
      subtitle: projects[i].description,
    );
  }

  Future<void> _refreshProjects(
      BuildContext context, ProjectsBloc projectsBloc) async {
    await projectsBloc.getProjects(true);
  }
}

class CustomDrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Container(
                width: double.infinity,
                height: 200,
                child: CircleAvatar(
                  child: Text(
                    'FH',
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ),
            ),
            CustomListTile(title: 'Proyectos', onTap: () {}),
            CustomListTile(title: 'Lenguajes', onTap: () {}),
            CustomListTile(title: 'Usuarios libres', onTap: () {}),
            Divider(),
            ListTile(
              leading: Icon(Icons.lightbulb_outline),
              title: Text('Modo oscuro'),
              trailing: Switch.adaptive(
                  value: appTheme.isDarkTheme,
                  activeColor: appTheme.currentTheme.accentColor,
                  onChanged: (value) => appTheme.isDarkTheme = value),
            ),
          ],
        ),
      ),
    );
  }
}
