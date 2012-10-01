# smoke

super simple harness for your smoke tests

![smoke screenshot](http://tonina.petalphile.com/stuff/smoke.png)

## running it

```
cd smoke
./smoke.sh
```

## add a test

just add your script into smoke/scripts!  Your test must

* be executable
* exit non-0 if it fails
* be prepended with a number if you'd like to run in a certain order.
  * for example, 010-script will run before 050-script
  * a_script will run before b_script
* and that's it!
