import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

import 'tasks.dart' as tasks;
import '../test/harness_console.dart' as test;

void main(List<String> args) {
  addTask('build', tasks.getBuildTask());

  addTask('clean', tasks.cleanHtml);

  addTask('test_dart2js',
      createDartCompilerTask(['test/browser_test_harness.dart']));

  addTask('test', createUnitTestTask(test.testCore));

  addTask('pages', (ctx) => branchForDir(ctx, 'master', 'build', 'gh-pages'));

  addTask('update_js', createCopyJSTask('build',
      browserDart: true,
      browserInterop: true));

  runHop(args);
}
