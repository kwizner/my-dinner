import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:my_dinner/core/services/injection.dart';
import 'package:my_dinner/features/my_diet/presentation/pages/my_diet_page.dart';
import 'package:my_dinner/features/profile/domain/usecases/get_profile.dart';
import 'package:my_dinner/features/profile/domain/usecases/update_profile.dart';
import 'package:my_dinner/features/profile/presentation/mobx/profile_store.dart';
import 'package:my_dinner/features/profile/presentation/widgets/profile_form.dart';
import 'package:my_dinner/widgets/navigation_drawer.dart';

class ProfilePage extends StatefulWidget {
  static ModalRoute<dynamic> get route {
    return MaterialPageRoute(
      builder: (_) => ProfilePage(),
    );
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProfileStore _profileStore;
  List<ReactionDisposer> _disposers = [];

  @override
  void initState() {
    super.initState();
    _profileStore = ProfileStore(
      locator.get<GetProfile>(),
      locator.get<UpdateProfile>(),
    );
    _disposers.addAll([
      autorun((_) {
        if (_profileStore.updateSuccess) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Dane zostały zaktualizowane'),
          ));
        }
      }),
      when((_) => _profileStore.error, () {
        showDialog(
          context: _scaffoldKey.currentContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Błąd serwera'),
              content: Text('Coś poszło nie tak...'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }),
    ]);
    _profileStore.getProfile();
  }

  @override
  void dispose() {
    _disposers.forEach((d) => d());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MyDietPage.routeWithParams());
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Moje dane'),
        ),
        body: Column(
          children: <Widget>[
            Observer(
              builder: (_) => AnimatedOpacity(
                child: const LinearProgressIndicator(),
                duration: const Duration(milliseconds: 200),
                opacity: _profileStore.loading ? 1.0 : 0.0,
              ),
            ),
            Expanded(
              child: Observer(
                builder: (_) => ProfileForm(
                  key: GlobalKey(),
                  profile: _profileStore.profile,
                  onUpdate: (profile) => _profileStore.updateProfile(profile),
                ),
              ),
            ),
          ],
        ),
        drawer: NavigationDrawer(),
      ),
    );
  }
}
