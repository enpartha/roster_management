import 'package:provider/provider.dart';
import '../providers/group_members.dart';
import '../providers/my_duty.dart';
import '../providers/my_groups.dart';

Future<void> fetchData(context) async {
  await Provider.of<MyDuty>(context, listen: false).fetch();
  await Provider.of<Members>(context, listen: false).fetch();
  await Provider.of<Groups>(context, listen: false).fetch();
}
