# Building

```
$ make SMLIB=/path/to/sm/lib
```

If you have GCC v10 or greater, do:

```
$ make MODERN_GCC=1 SMLIB=/path/to/sm/lib
```

# Executing

```
$ export MOOG_DATA=`pwd`
$ ./MOOG [filename.par]
```
