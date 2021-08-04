
      subroutine finish (number)
c******************************************************************************
c     This routine simply wraps up MOOG
c******************************************************************************

      implicit real*8 (a-h,o-z)
      include 'Atmos.com'
      include 'Pstuff.com'


c  close the files
      if (nfmodel /= 0)      close (unit=nfmodel)
      if (nflines /= 0)      close (unit=nflines)
      if (nfslines /= 0)     close (unit=nfslines)
      if (nftable /= 0)      close (unit=nftable)
      if (nfobs /= 0)        close (unit=nfobs)
      if (nf1out /= 0)       close (unit=nf1out)
      if (nf2out /= 0)       close (unit=nf2out)
      if (nf3out /= 0)       close (unit=nf3out)
      if (nf4out /= 0)       close (unit=nf4out)
      if (nf5out /= 0)       close (unit=nf5out)
      if (control /= 'gridsyn' .and. control /= 'gridplo') then
         if (nf6out /= 0)    close (unit=nf6out)
         if (nf7out /= 0)    close (unit=nf7out)
         if (nf8out /= 0)    close (unit=nf8out)
         if (nf9out /= 0)    close (unit=nf9out)
         if (nf10out /= 0)   close (unit=nf10out)
      endif

c  write the closing message
      if (number == 0) then
         istat = ivcleof (4,1)
         write (array,1001) 
         istat = ivwrite (5,1,array,79)
      endif
      return


c*****format statements
1001  format (22('<'),10x,'MOOG HAS ENDED!',10x,22('>'))


      end
      

