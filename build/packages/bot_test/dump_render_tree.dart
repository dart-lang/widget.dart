library dump_render_tree;

import 'dart:async';
import 'dart:io';
import 'package:unittest/unittest.dart';

final _allPassedRegExp = new RegExp('All \\d+ tests passed');

void testDumpRenderTree(Iterable browserTests) {

  group('DumpRenderTree', () {
    for(var testFile in browserTests) {
      test(testFile, () {
        return _runDrt(testFile);
      });
    }
  });
}

Future _runDrt(String htmlFile) {
  var file = new File(htmlFile);
  return file.exists()
      .then((bool exists) {
        if(!exists) {
          fail('Could not find target test file: $htmlFile');
        }

        return Process.run('content_shell', ['--dump-render-tree', htmlFile]);
      })
      .then((ProcessResult pr) {
        expect(pr.exitCode, 0, reason: 'DumpRenderTree should return exit code 0 - success');

        if(!_allPassedRegExp.hasMatch(pr.stdout)) {
          logMessage(pr.stdout);
          fail('Could not find success value in stdout: ${_allPassedRegExp.pattern}');
        }
    });
}
