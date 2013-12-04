import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

import '../test/harness_console.dart' as test;

void main(List<String> args) {
  addTask('build', createProcessTask('dart', args: ['build.dart'],
      description: "execute the project's build.dart file"));

  final paths = ['web/out/index.html_bootstrap.dart'];
  addTask('dart2js', createDartCompilerTask(paths,
      minify: true, liveTypeAnalysis: true));

  addTask('test_dart2js',
      createDartCompilerTask(['test/browser_test_harness.dart']));

  addTask('test', createUnitTestTask(test.testCore));

  //
  // gh_pages
  //
  addTask('pages', (ctx) =>
      branchForDir(ctx, 'master', 'build', 'gh-pages'));

  addTask('update_js', createCopyJSTask('build',
      browserDart: true,
      browserInterop: true));

  runHop(args);
}
