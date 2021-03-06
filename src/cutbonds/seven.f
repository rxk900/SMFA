      subroutine seven

      use fractdata
      implicit double precision(a-h,o-z)

c intended to identify 7 member rings and to
c amend the ma matrix to ensure that such rings cannot be
c broken in such a way as to lead to interacting caps

c arrays isix, ma, ilink are in common

c     dimension isix(natomm,natomm)
      dimension iseven(500,7),ifr(7)

      iseven=0
      nafrag=numat(nfrag)

      if(nafrag.lt.7)return

c     do n1=1,nafrag
c      do n2=1,nafrag
c       if(ilink(n1,n2).eq.1)write(6,*)n1,n2
c      enddo
c     enddo
c     stop


      nring=0
c nearbours in a 6 ring?
      do n1=1,nafrag
      do k1=1,itp(n1)+1
       n2=ibo(n1,k1)
       do k2=1,itp(n2)+1
        if(ibo(n2,k2).eq.n1)go to 91
       do k3=1,itp(n1)+1
        if(ibo(n1,k3).eq.n2)go to 92
        n3=ibo(n2,k2)
        n4=ibo(n1,k3)
         if(ilink(n3,n4).eq.1)go to 92
         if(ilink(n3,n1).eq.1)go to 92
         if(ilink(n2,n4).eq.1)go to 92
         do k4=1,itp(n3)+1
          n5=ibo(n3,k4)
          if(n5.eq.n2)go to 93
          if(n5.eq.n1)go to 93
          if(ilink(n5,n1).eq.1)go to 93
          if(ilink(n5,n4).eq.1)go to 93
         do k5=1,itp(n4)+1
          n6=ibo(n4,k5)
          if(n6.eq.n1)go to 94
          if(n6.eq.n2)go to 94
          if(n6.eq.n3)go to 94
          if(n6.eq.n5)go to 94
          if(ilink(n6,n1).eq.1)go to 94
          if(ilink(n6,n2).eq.1)go to 94
          if(ilink(n6,n3).eq.1)go to 94
          if(ilink(n6,n5).eq.1)go to 94
         do k6=1,itp(n5)+1
          n7=ibo(n5,k6)
          if(n7.eq.n1)go to 95
          if(n7.eq.n2)go to 95
          if(n7.eq.n3)go to 95
          if(n7.eq.n4)go to 95
          if(n7.eq.n6)go to 95
          if(ilink(n7,n1).eq.1)go to 95
          if(ilink(n7,n2).eq.1)go to 95
          if(ilink(n7,n3).eq.1)go to 95
          if(ilink(n7,n4).eq.1)go to 95
         if(ilink(n7,n6).eq.1)then

c we have a 7 ring
c     write(6,*)' we have a seven ring, fragment ',nfrag
           ifr(1)=n1
           ifr(2)=n2
           ifr(3)=n3
           ifr(4)=n4
           ifr(5)=n5
           ifr(6)=n6
           ifr(7)=n7
           call piksrt(7,ifr)
           if(nring.gt.0)then
            do k=1,nring
             idiff=0
             do j=1,7
              idiff=idiff+iabs(iseven(k,j)-ifr(j))
             enddo
            if(idiff.eq.0)go to 99
            enddo
c end the nring gt 0 if
           endif
           nring=nring+1
          do j=1,7
           iseven(nring,j)=ifr(j)
          enddo
c end the ibo match if
         endif
99    continue
c end the k6 loop
95        enddo
c end k5 loop
94        enddo
c end k4 loop
93        enddo
c end the k3 loop
92       enddo
c end the k2 loop
91       enddo
c end the k1 loop
      enddo
c end the n1 loop
      enddo

c     write(6,*)'nfrag = ',nfrag,nafrag
c      if(nring.gt.0)then
c        write(6,*)' 6 ring'
c        do k=1,nring
c        write(6,*)(isix(k,j),j=1,6)
c        enddo
c      endif

c     do n1=1,nafrag
c     do n2=1,nafrag
c      if(isix(n1,n2).eq.1)write(6,*)n1,n2
c     enddo
c     enddo

      if(nring.eq.0)return

c now amend the ma array

100   ncount=0
      do n=1,nafrag
       do i=1,nring
        isum=0
        do j=1,7
        isum=isum+ma(n,iseven(i,j))
        enddo
        if(isum.gt.4.and.isum.lt.7)then
         ncount=ncount+1
         do j=1,7
          ma(n,iseven(i,j))=1
          ma(iseven(i,j),n)=1
         enddo
        endif
       enddo
      enddo

c check if more needs to be done
      if(ncount.gt.0)go to 100

c      do n=1,nafrag
c
c       do 10 n1=1,nafrag
c        if(ma(n,n1).eq.0)go to 10
c
c        match=0
c        do 11 n2=1,nafrag
c         if(n2.eq.n1)go to 11
c         if(isix(n1,n2).eq.1.and.ma(n,n2).eq.1)match=1
c11      continue
c        if(match.eq.1)then
c         do n3=1,nafrag
c          if(isix(n1,n3).eq.1)ma(n,n3)=1
c         enddo
c        endif
c10     continue
c      enddo

      return
      end


