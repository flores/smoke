# smoke

super simple harness for your smoke tests

![smoke screenshot](http://tonina.petalphile.com/stuff/smoke.png)

## why

We found most test harnesses too hard.  We found running shell loops not repeatable.
We like easy.

## running it

```
cd smoke
./smoke.sh
```
## options and defaults

```
./smoke.sh -h
smoke.sh runs smoke tests on your box
 usage: smoke.sh <option>
 
 where option can be:
 	-l <file> :silently write logs to <file>. default: /var/log/smoke.log
 	-f :only output failures. default: not set
 	-d <directory> :runs tests in <directory>. default: tests/
 	-h :prints this message
```

## writing tests

just add your script into smoke/tests (or any directory called by the `-d` option above)!  Your test must:

* be executable
* exit 0 for a passed test and exit non-0 for a failed test
* use init-style naming if you'd like to run in a certain order.  For example:
  * `010-script` will run before `050-script`
  * `050-script` will run before `a_script`
  * `a_script` will run before `b_script`

that's it!
