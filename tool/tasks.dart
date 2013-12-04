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
          ctx.info('Things changed!');
        } else {
          ctx.info('Nothing changed...');
        }
      });

}

Future<dom.Document> _process(dom.Document doc) {

  // replace *.dart references with the corresponding .dart.js refs

  // find all package imports and put them somewhere else

  var elements = _getPackageJSScriptElements(doc);

  return Future.forEach(elements, _fixPackageScriptTag)
      .then((_) => doc);
}

Future _fixPackageScriptTag(dom.Element packageJsScriptElement) {
  String src = packageJsScriptElement.attributes['src'];

  var url = new Uri(path: src);

  print(url.pathSegments);
  assert(url.pathSegments.first == 'packages');

  var name = url.pathSegments.last;
  assert(name.endsWith('.js'));

  packageJsScriptElement.attributes['src'] = name;
}

List<dom.Element> _getPackageJSScriptElements(dom.Document doc) {
  return doc.queryAll('script')
      .where((dom.Element e) {
        assert(e.tagName == 'script');
        String src = e.attributes['src'];

        if(src == null) return false;

        return src.startsWith('packages/') && src.endsWith('.js');
      })
      .toList();
}
