      if(mata(1,2).eq.0.and.mata(2,2).eq.0)then
       mg=natstore(k2,1)
      call match_mg(2*nffinal1,mg,numat,natstore,nffinal,nbextra,match)
c fill in the fragments
cc       if(ic.ge.10*nffinal0)then
cc        write(6,*)' ic too big'
cc      call cancelL1L1(10*nffinal0,ic,matstore,nsign)
cc       endif
       ic=ic+1
c record the fragment numbers and the net sign
       matstore(ic,1)=k1
       matstore(ic,2)=match
       nsign(ic)=ksign(k1)*ksign(k2)
c     do ip=1,ic
c     if(matstore(ip,1).eq.0.or.matstore(ip,2).eq.0)write(6,*)'case11'
c     enddo
       go to 111
      endif

