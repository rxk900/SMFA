      program bigfract

c  this program reads in the coords and bonding of a big molecule
c  using subroutine readin.f as in the standard fragmentation program.
c This results in a "skeleton" of functional groups that are considered as
c single objects or "atoms"

c In this program, we set up a "tree" of skeletons. Call the original
c skeleton "skeleton(1)"
c The atoms in keleton(1) are grouped as disjoint pairs of
c neighbouring atoms. Each pair is now considered to be one object, connected to other
c such objects in skeleton(2).
c Again, the "atoms" in skeleton(2) are grouped as disjoint pairs of
c neighbouring atoms. Each pair is now considered to be one object, connected to other
c such objects in skeleton(3).
c As this process continues, the number of "atoms" reduces at each iteration, until the
c number is reduced below a specified limit, "natommin", say at iteration Nfinal.

c skeleton(Nfinal) is sent to the standard subroutines to be fragmented.
c Call the set of fragments {Frag(Nfinal)}.
c Each fragment in {Frag(Nfinal)} is "expanded" by replacing the "atoms" at iteration
c Nfinal by the pairs of atoms present in iteration Nfinal - 1. The set {Frag(Nfinal)} of
c  "expanded" fragments is sent back to the standard fragmentation subroutines to produce
c {Frag(Nfinal-1)}. The expansion and re-fragmentation are repected until the {F} contains 
c only the original atoms in the original skeleton.
c  The complete fragmentation of the original skeleton is now complete.



c THis version modifies writecom to be consistent with Matt's
c allfract_wrapper script


      use fractdata
      implicit double precision(a-h,o-z)

      write(6,*)' The maximum allowed compressions = ',ncomp
c read in some job control parameters

      call readINFRACT

c read in a parameter that allows or prevents caps
c       open(unit=1,file='IN_CAPS',status='old')
c c read in the control parameter that can stop calls
c c to three, four, five and six
c       read(1,*)
c       read(1,*)nocapsatall
c c if nocapsatall=1, there are no caps at all
c       close(unit=1)

      do i=1,10
       subtimes(i)=0.d0
      enddo

      write(6,*)' Level = ',Level
c  read in the molecule details, as generated by Spart2Mold etc
      call readin_big
      write(6,*)' after readin, nfragm = ',nfragm
c call the subroutine that generates the nested skeletons

      call compress

      write(6,*)'finished compression'

c The depth of the nest is given by "iterfinal"

c  transfer the final compressiojn results
      call setupfrags1

      write(6,*)'finished setupfrags1'

c Loop over the fragmentation and expansion

      itfinal=0

      if(iterfinal.eq.1)go to 100

      do i=iterfinal,2,-1

      write(6,*)' Iteration number = ',i
      write(6,*)
      write(6,*)' before fragsteps, nfragm = ',nfragm

      call fragsteps


      write(6,*)
        write(6,*)(n,n=1,natom)
        write(6,*)
        write(6,*)' = '
        write(6,*)
      do i1=1,nf
      if(nstop(i1).gt.1)go to 8591

      if(isign(i1).gt.0)then
        write(6,*)' + ',(natstore(i1,k),k=1,numat(i1))
        write(6,*)
      endif
8591  continue
      enddo

      do i1=1,nf
      if(nstop(i1).gt.1)go to 9691

      if(isign(i1).lt.0)then
        write(6,*)' - ',(natstore(i1,k),k=1,numat(i1))
        write(6,*)
      endif
9691    enddo


      call expand(i)

      enddo

100   continue
      write(6,*)' finished expansions'
      itfinal=1
      call fragsteps
      write(6,*)' calling finalcancel'
      call finalcancel
      write(6,*) 'finished finalcancel'


      if(nbondsextra.gt.0)call extrafrags
c write out the results


      write(6,*)'Finished after ',nf,' Iterations'
      write(6,*)
        write(6,*)(n,n=1,natom)
        write(6,*)
        write(6,*)' = '
        write(6,*)
      do i=1,nf
      if(nstop(i).gt.1)go to 3591

      if(isign(i).gt.0)then
        write(6,*)' + ',(natstore(i,k),k=1,numat(i))
        write(6,*)
      endif
3591  continue
      enddo

      do i=1,nf
      if(nstop(i).gt.1)go to 3691

      if(isign(i).lt.0)then
        write(6,*)' - ',(natstore(i,k),k=1,numat(i))
        write(6,*)
      endif
3691    enddo

      write(6,*)' Number of fragments = ',nf


      call writefrags
      call writecom
      call writerawdata

      stop
      end
