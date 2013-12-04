library tool.tasks;

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:html5lib/dom.dart' as dom;
import 'package:hop/hop_core.dart';
import 'package:hop/hop_tasks.dart';
import 'package:hop/src/hop_experimental.dart';
import 'package:path/path.dart' as pathos;

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
const _BUILD_PATH = 'build';
const _PAGE_PATH = '$_BUILD_PATH/index.html';
const _JS_PATH = 'script';

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

  var newUrl = new Uri(pathSegments: [_JS_PATH, name]);

  packageJsScriptElement.attributes['src'] = newUrl.toString();

  return _copyScriptFile(url);
}

Future _copyScriptFile(Uri sourcePath) {
  var sourceScript = new File(sourcePath.toFilePath());

  if(!sourceScript.existsSync()) {
    throw new ArgumentError('$sourcePath does not exist!');
  }

  var targetName = sourcePath.pathSegments.last;
  assert(targetName.endsWith('.js'));

  var targetPath = pathos.join(_BUILD_PATH, _JS_PATH, targetName);

  var targetFile = new File(targetPath);

  return targetFile.create(recursive: true)
      .then((_) =>
        targetFile.openWrite(mode: FileMode.WRITE)
            .addStream(sourceScript.openRead()));
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
