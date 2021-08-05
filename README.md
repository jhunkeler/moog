# Building

```
$ ./configure
$ make
```

# Installation

```
$ ./configure --prefix=$HOME/local/moog --with-sm=$HOME/local/sm/lib
$ make
$ make install
```

# Run

```
$ export PATH="$HOME/local/moog/bin:$PATH"
$ hash -r
$ MOOG [filename.par]
```
