
      subroutine binplot
c******************************************************************************
c     This routine produces MONGO plots of the syntheses.
c******************************************************************************

      implicit real*8 (a-h,o-z)
      include 'Quants.com'
      include 'Factor.com'
      include 'Atmos.com'
      include 'Linex.com'
      include 'Pstuff.com'
      include 'Equivs.com'
      include 'Multistar.com'
      real*8 style(1)
      real*8 yup,ydown
      integer iflip


c*****for grid syntheses, dump out relevant information to a file
      if (choice == 'g') then
         write (nf6out,3001) syncount
         write (nf6out,3002) obsitle, moditle, smitle
      endif
 

c*****begin with a default window
      call sm_location (3500,31000,4000,30000)
      call sm_window (1,1,1,1,1,1)
      call sm_limits (0.0,1.0,0.0,1.0)
      call defcolor (1)


c*****write smoothing information at the top of the plot
      call sm_lweight (2.2)
      call sm_expand (0.7)
      call sm_relocate (-0.080,1.015)
      call sm_label (smitle)
      write (chinfo(1:34),3004) deltaradvel, lumratio
      call sm_relocate (0.500,1.015)
      call sm_label (chinfo(1:30))


c*****write the non-varying isotopic information at the top of the plot
      do i=1,120
         if (isoitle(i:i) /= ' ') go to 112
      enddo
      isoitle(1:16) = 'no isotopic data'
112   call sm_relocate (-0.080,1.065)
      call sm_label (isoitle(1:120))
 

c*****define the real plot limits
      if (xlo < xhi) then
         call sm_limits (xlo,xhi,ylo,yhi)
         iflip = 0
      else
         call sm_limits (xhi,xlo,ylo,yhi)
         iflip = 1
      endif
      call findtic (xlo,xhi,bigxtic,smlxtic)
      call findtic (ylo,yhi,bigytic,smlytic)
      call sm_ticksize (smlxtic,bigxtic,smlytic,bigytic)


c*****draw and label the box for the spectra
      call defcolor (1)
      if (whichwin == '1of1') then
         idev = 1
         call sm_window (1,1,1,1,1,1)
      else
         idev = 2
         call sm_defvar ('y_gutter','0.0')
         call sm_window (1,2,1,1,1,1)
      endif
      call sm_lweight (4.0)
      call sm_expand (1.2)
      call sm_box (0,0,0,0)
      call sm_lweight (2.0)
      call sm_expand (0.8)
      call sm_box (1,2,4,4)
      if (iflip == 1) then
         array = 'Wavenumber'
      else
         array = 'Wavelength'
      endif
      call sm_xlabel (array)
      array = 'Rel  Flux'
      call sm_ylabel (array)


c*****plot the synthetic spectra
      call sm_lweight (2.2)
      call sm_expand (0.7)
      do i=1,100
         if (pec(i) /= 0) go to 111
      enddo            
111   do j=1,nsyn
         if (choice=='h' .or. choice=='f' .or.
     .       choice=='g') then
            call defcolor (8)
            call sm_ltype (j-1)
         else
            if (smterm(1:3) == 'x11') then
               call defcolor (j+1)
               call sm_ltype (0)
            else
               call defcolor (1)
               call sm_ltype (j-1)
            endif
         endif
         call sm_connect (xsyn,chunk(1,j),kount) 
         if (iflip == 1) then
            call sm_relocate (xhi+0.045*(xlo-xhi),
     .                     ylo+(0.12+0.06*j)*(yhi-ylo))
            call sm_draw (xhi+0.005*(xlo-xhi),
     .                 ylo+(0.12+0.06*j)*(yhi-ylo))
            call sm_relocate (xhi+0.05*(xlo-xhi),
     .                     ylo+(0.12+0.06*j)*(yhi-ylo))
         else
            call sm_relocate (xlo+0.045*(xhi-xlo),
     .                     ylo+(0.12+0.06*j)*(yhi-ylo))
            call sm_draw (xlo+0.005*(xlo-xhi),
     .                 ylo+(0.12+0.06*j)*(yhi-ylo))
            call sm_relocate (xlo+0.05*(xhi-xlo),
     .                     ylo+(0.12+0.06*j)*(yhi-ylo))
         endif
         noff = 80*(j-1)
         call sm_lweight (2.2)
         call sm_label (abitle(noff+1:noff+80))
      enddo
      call defcolor (1)
      call sm_ltype (0)

   
c*****plot the observed spectrum
      if (plotopt == 2) then
         call defcolor (1)
         if (choice=='h' .or. choice=='f') then
            call sm_lweight (4.0)
         else 
            call sm_lweight (2.2)
         endif
         call sm_ltype (0)
         call sm_expand (3.0)
         style(1) = 43.5
         call sm_ptype (style,1)
         mount = lim2obs - lim1obs + 1
         if (mount < 500) then
            call sm_points (xobs(lim1obs),yobs(lim1obs),mount)
         else
            if (histoyes == 1) then
               call sm_histogram (xobs(lim1obs),yobs(lim1obs),mount)
            else
               call sm_connect (xobs(lim1obs),yobs(lim1obs),mount)
            endif
         endif
         call sm_lweight (2.2)
         call sm_expand (0.7)
         if (iflip == 1) then
            call sm_relocate (xhi+0.05*(xlo-xhi),ylo+0.12*(yhi-ylo))
         else
            call sm_relocate (xlo+0.05*(xhi-xlo),ylo+0.12*(yhi-ylo))
         endif
         call sm_label (obsitle)
      endif
      do i=1,2
         if (iflip == 1) then
            call sm_relocate (xhi+0.05*(xlo-xhi),
     .                        ylo+0.01+0.06*(2-i)*(yhi-ylo))
         else
            call sm_relocate (xlo+0.05*(xhi-xlo),
     .                        ylo+0.01+0.06*(2-i)*(yhi-ylo))
         endif
         call sm_label (modbin(i))
      enddo
      if (whichwin=='1of1' .or. plotopt/=2) then
         return
      endif


c*****this section of code is executed only if a deviations plot is desired;
c     find the starting and stopping points in the arrays for the deviations
      if (xsyn(kount) <= xobs(lim1obs)) go to 1000
      if (xsyn(1) > xobs(lim2obs)) go to 1000
      if (xsyn(1) > xobs(lim1obs)) go to 150
      lim3obs = lim1obs
      do k=2,kount
         if (xsyn(k) > xobs(lim3obs)) then
            lim1syn = k - 1
            go to 155
         endif
      enddo
150   lim1syn = 1
      do l=lim1obs,lim2obs
         if (xsyn(lim1syn) <= xobs(l)) then
            lim3obs = l 
            go to 155
         endif
      enddo
155   if (xsyn(kount) < xobs(lim2obs)) go to 160
      lim4obs = lim2obs
      do k=lim1syn,kount
         if (xsyn(k) > xobs(lim4obs)) then
            lim2syn = k
            go to 165
         endif
      enddo
160   lim2syn = kount
      do l=lim3obs,lim2obs
         if (xsyn(lim2syn) < xobs(l)) then
            lim4obs = l - 1
            go to 165
         endif
      enddo


c  compute the deviations; linear interpolation in the wavelength array
c  of the synthetic spectra is considered sufficient
165   do j=1,nsyn
         lpoint = lim1syn
         devsigma = 0.
         do i=lim3obs,lim4obs
170         if (xsyn(lpoint+1) < xobs(i)) then
               lpoint = lpoint + 1
               go to 170
            endif
            syninterp = (chunk(lpoint+1,j)-chunk(lpoint,j))*
     .         (xobs(i)-xsyn(lpoint))/(xsyn(lpoint+1)-xsyn(lpoint)) +
     .         chunk(lpoint,j)
            dev(i) = yobs(i) - syninterp
            devsigma = devsigma + dev(i)**2
         enddo
         devsigma = dsqrt(devsigma/(lim4obs-lim3obs-1))
         
      
c  from first set of deviations, define the plot limits, draw and label box
         if (j == 1) then
            yup = -1000.
            ydown = +1000.
            do i=lim3obs,lim4obs
               yup = amax1(yup,dev(i))
               ydown = amin1(ydown,dev(i))
            enddo
            ydelta = amin1(0.3,amax1(0.05,1.5*(yup-ydown)/2.))
            ydown = -ydelta
            yup = ydelta
            call sm_defvar ('y_gutter','0.0')
            call sm_window (1,2,1,2,1,2)
            call sm_limits (xlo,xhi,ydown,yup)
            call findtic (ydown,yup,bigytic,smlytic)
            call sm_ticksize (smlxtic,bigxtic,smlytic,bigytic)
            call sm_lweight (4.0)
            call sm_expand (1.2)
            call defcolor (1)
            call sm_box (0,0,0,0)
            call sm_lweight (2.0)
            call sm_expand (0.8)
            call sm_box (4,2,4,4)
            array = 'Obs - Comp'
            call sm_ylabel (array)
            call sm_relocate (xlo,0.0)
            call sm_draw (xhi,0.0)
         endif


c  plot the array of deviations
         if (choice=='h' .or. choice=='f' .or.
     .       choice=='g') then
            call defcolor (8)
            call sm_ltype (j-1)
         else
            if (smterm(1:3) == 'x11') then
               call defcolor (j+1)
               call sm_ltype (0)
            else
               call defcolor (1)
               call sm_ltype (j-1)
            endif
         endif
         call defcolor (j+1)
         call sm_lweight (2.2)
         call sm_connect (xobs(lim1obs),dev(lim1obs),mount)
         write (array,3005) devsigma
         call sm_relocate(xhi-0.2*(xhi-xlo),
     .                 ydown+(0.10+0.06*j)*(yup-ydown))
         call sm_relocate(xhi-0.24*(xhi-xlo),
     .                 ydown+(0.10+0.06*j)*(yup-ydown))
         call sm_draw(xhi-0.215*(xhi-xlo),
     .                 ydown+(0.10+0.06*j)*(yup-ydown))
         call sm_label (array)
         if (choice == 'g') then
            noff = 80*(j-1)
            write (nf6out,3002) abitle(noff+1:noff+80)
            write (nf6out,3003) devsigma, velsh
         endif
      enddo


c  reset the spectrum plot boundaries before exiting
      if(xlo < xhi) then
         call sm_limits (xlo,xhi,ylo,yhi)
         iflip = 0
      else
         call sm_limits (xhi,xlo,ylo,yhi)
         iflip = 1
      endif
1000  return


c*****format statements
3001  format (/'RUN NUMBER:', i4, 65('-'))
3002  format (a80)
3003  format ('sigma =', f8.4, '   lambda shift =', f7.3, ' km/s')
3004  format ('del(Vr)=', f8.3, 5x, 'L1/L2=', f7.3)
3005  format ('sigma =',f8.4)


      end



