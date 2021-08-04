
      program moog
c******************************************************************************
c     This is the main driver for MOOG.  It reads the parameter
c     file and sends MOOG to various controlling subroutines.
c     This is the normal interactive version of the code; for batch
c     processing without user decisions, run MOOGSILENT instead.
c******************************************************************************

      include 'Atmos.com'
      include 'Pstuff.com'
      character yesno*1


c$$$$$$$$$$$$$$$$$$$$$$$$ USER SETUP AREA $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
c*****in compiling MOOG, here the various machine-specific things are 
c     declared.  First, define the directory where MOOG lives, in order to 
c     be able to pull in auxiliary data files; executing 'make' will 
c     generate a reminder of this necessity
      write (moogpath,1001)
      call get_environment_variable("MOOG_DATA", moogpath)


c*****What kind of machine are you using?  Possible ones are:
c     OBSOLETE
c     "mac" = Intel-based Apple Mac 
c     "pcl" = a PC or desktop running some standard linux like Redhat
c     "uni" = a machine running Unix, specifically Sun Solaris
      machine = ""


c*****for x11 terminal types, define the parameters of plotting windows;
c     set up an x11 screen geometry and placement that is good for spectrum
c     syntheses (long, but not tall); the user should play with the format
c     statements for particular machines.
      write (smt1,1018)
c     now do the same for line abundance trend plots (short but tall).
      write (smt2,1017)
c$$$$$$$$$$$$$$$$$$$$$$$ END OF USER SETUP $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


c*****declare this to be the normal interactive version; variable "silent"
c     will be queried on all occasions that might call for user input;
c     DON'T CHANGE THIS VARIABLE; 
c     if silent = 'n', the normal interactive MOOG is run;
c     if silent = 'y', the non-interactive MOOG is run
      silent = 'n'


c*****invoke the overall starting routine
1     control = '       '
      call begin


c*****use one of the standard driver routines
      if     (control == 'synplot') then
         call plotit
      elseif (control == 'synth  ') then
         call synth
      elseif (control == 'cogsyn ') then
         call cogsyn  
      elseif (control == 'blends ') then
         call blends  
      elseif (control == 'abfind ') then
         call abfind
      elseif (control == 'ewfind ') then
         call ewfind
      elseif (control == 'cog    ') then
         call cog
      elseif (control == 'calmod ') then
         call calmod
      elseif (control == 'doflux ') then
         call doflux   
      elseif (control == 'weedout') then
         call weedout  
      elseif (control == 'gridsyn') then
         call gridsyn  
      elseif (control == 'gridplo') then
         call gridplo  
      elseif (control == 'binary ') then
         call binary
      elseif (control == 'abpop  ') then
         call abpop
      elseif (control == 'synpop ') then
         call synpop


c*****or, put in your own drivers in the form below....
      elseif (control == 'mine  ') then
         call  mydriver 


c*****or else you are out of luck!
      else
         array = 'THIS IS NOT ONE OF THE DRIVERS.  TRY AGAIN (y/n)?'
         istat = ivwrite (4,3,array,49)
         istat = ivmove (3,1)
         read (*,*) yesno
         if (yesno == 'y') then
            go to 1
         else
            call finish (0)
         endif
      endif


c*****format statements
1001  format (60(' '))
1003  format (22x,'MOOG IS CONTROLLED BY DRIVER ',a7)
1017  format ('x11 -bg black -title MOOGplot -geom 700x800+650+000')
1018  format ('x11 -bg black -title MOOGplot -geom 1200x350+20+450')


      end


      
