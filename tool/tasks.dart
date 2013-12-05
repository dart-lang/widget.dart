library tool.tasks;

import 'package:args/args.dart';
import 'package:hop/hop_core.dart';
import 'package:hop/hop_tasks.dart';

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
