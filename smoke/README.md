# smoke

super simple/weak shell harness for tests

## add a test

just add your script into smoke/scripts!  Your test must

* be executable
* exit non-0 if it fails
* be prepended with a number if you'd like to run in a certain order.
** for example, 010-script will run before 050-script
** a_script will run before b_script
* and that's it!
