#     makefile for MOOG with all of the common block assignments;
#     this is for my Mac laptop

#     here are the object files
OBJECTS = Abfind.o Abpop.o Abunplot.o Batom.o Begin.o Binary.o \
	Binplot.o Binplotprep.o Blankstring.o Blends.o Bmolec.o Boxit.o \
	Calmod.o Cdcalc.o Chabund.o Cog.o Cogplot.o Cogsyn.o \
	Correl.o Crosscorr.o Curve.o Damping.o Defcolor.o Discov.o \
	Doflux.o Drawcurs.o Eqlib.o Ewfind.o \
	Ewweighted.o Fakeline.o Findtic.o Finish.o \
	Fluxplot.o Gammabark.o Getasci.o Getcount.o Getnum.o Getsyns.o \
	Gridplo.o Gridsyn.o Infile.o Inlines.o Inmodel.o Invert.o \
	Jexpint.o Lineinfo.o Lineabund.o Linlimit.o \
	Makeplot.o Molquery.o Mydriver.o \
	Nansi.o Nearly.o Number.o Obshead.o \
	Oneline.o Opaccouls.o OpacHelium.o OpacHydrogen.o \
	Opacit.o Opacmetals.o Opacscat.o Params.o Partfn.o \
	Partnew.o Plotit.o Plotremember.o Pltabun.o Pltcog.o \
	Pltflux.o Pltspec.o Pointcurs.o Prinfo.o Putasci.o Readobs.o \
	Rinteg.o Setmols.o Smooth.o Specplot.o Stats.o Sunder.o Synpop.o \
	Synspec.o Synth.o Tablepop.o Taukap.o Total.o Trudamp.o Ucalc.o \
	Vargauss.o Vmacro.o Voigt.o Wavecalc.o Weedout.o Writenumber.o

MOOG_ENTRY = Moog.o
MOOGSILENT_ENTRY = Moogsilent.o

#     here are the common files
COMMON =  Atmos.com Dummy.com Equivs.com Factor.com Kappa.com Linex.com \
	Mol.com Multistar.com Obspars.com Pstuff.com \
	Quants.com Multimod.com Dampdat.com

# the following lines point to some needed libraries
X11LIB = /usr/X11/lib
SMLIB = /usr/local/lib

FC = gfortran
FFLAGS = -std=legacy -w -ff2c
LDFLAGS = -L$(X11LIB) -lX11 -ltcl -ltk -L$(SMLIB) -lplotsub -ldevices -lutils

#        here are the compilation and linking commands
all: MOOG MOOGSILENT
	@echo -----------------------------------------------------------------
	@echo
	@echo Set MOOG_DATA environment variable to path containing file\(s\):
	@for x in *.dat; \
		do echo $$x; \
	done
	@echo
	@echo -----------------------------------------------------------------

MOOG:  $(OBJECTS);
	$(FC) -o MOOG $(MOOG_ENTRY) $(OBJECTS) $(FFLAGS) $(LDFLAGS)

MOOGSILENT:  $(OBJECTS) $(MOOGSILENT_ENTRY);
	$(FC) -o MOOGSILENT $(MOOGSILENT_ENTRY) $(OBJECTS) $(FFLAGS) $(LDFLAGS)

$(OBJECTS): $(COMMON) $(MOOG_ENTRY) $(MOOGSILENT_ENTRY)

clean:
	-rm -f *.o MOOG MOOGSILENT
