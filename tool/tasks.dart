library tool.tasks;

import 'dart:async';
import 'package:args/args.dart';
import 'package:html5lib/dom.dart' as dom;
import 'package:hop/hop_core.dart';
import 'package:hop/hop_tasks.dart';
import 'package:hop/src/hop_experimental.dart';

const _MODE = 'mode';
const _VERBOSE = 'verbose';

Task getBuildTask() =>
    new Task((TaskContext ctx) {
      var args = ['build', '--mode', ctx.arguments[_MODE]];

      if(ctx.arguments[_VERBOSE]) {
        args.add('--verbose');
      }

      return startProcess(ctx, 'pub', args);
    }, config: (ArgParser parser) {
      parser.addOption(_MODE, abbr: 'm', allowed: ['release', 'debug'], defaultsTo: 'debug');
      parser.addFlag(_VERBOSE, abbr: 'v', defaultsTo: false);
    });

// NOTE: assuming we're in build/index.html
const _PAGE_PATH = 'build/index.html';

Future cleanHtml(TaskContext ctx) {

  return transformHtml(_PAGE_PATH, _process)
      .then((bool changes) {
        if(changes) {
          ctx.info('Thing changed!');
        } else {
          ctx.info('Nothing changed...');
        }
      });

}

Future<dom.Document> _process(dom.Document doc) {

  // replace *.dart references with the corresponding .dart.js refs

  // find all package imports and put them somewhere else

  print(doc.hashCode);

  return new Future.value(doc);
}
