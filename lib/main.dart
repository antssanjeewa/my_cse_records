import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/service_locator.dart';
import 'core/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://koevusjggapfimievpld.supabase.co',
    anonKey: 'sb_publishable_KENbWDLkCcVVtsDr7MuZAg_ojvqONUk',
    // db pass= 3WWQg/Atg/z%i@+
  );

  setupLocator();
  runApp(const MyApp());
}
