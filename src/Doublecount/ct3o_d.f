      subroutine ct3o_d(c1,o2,t4,dect4o)

      implicit double precision(a-h,o-z)

      dimension o2(3,3,3),t4(3,3,3,3),dect4o(3)

c  this subroutine evaluates the quadrupole-quadrupole
c  electrostatic interaction

      dimension a(3,10)

      a(1,1)=o2(1,1,1)*t4(1,1,1,1)
      a(1,2)=o2(1,1,2)*t4(1,1,1,2)*3.d0
      a(1,3)=o2(1,1,3)*t4(1,1,1,3)*3.d0
      a(1,4)=o2(1,2,2)*t4(1,1,2,2)*3.d0
      a(1,5)=o2(1,2,3)*t4(1,1,2,3)*6.d0
      a(1,6)=o2(1,3,3)*t4(1,1,3,3)*3.d0
      a(1,7)=o2(2,2,2)*t4(1,2,2,2)
      a(1,8)=o2(2,2,3)*t4(1,2,2,3)*3.d0
      a(1,9)=o2(2,3,3)*t4(1,2,3,3)*3.d0
      a(1,10)=o2(3,3,3)*t4(1,3,3,3)

      a(2,1)=o2(1,1,1)*t4(1,1,1,2)
      a(2,2)=o2(1,1,2)*t4(1,1,2,2)*3.d0
      a(2,3)=o2(1,1,3)*t4(1,1,2,3)*3.d0
      a(2,4)=o2(1,2,2)*t4(1,2,2,2)*3.d0
      a(2,5)=o2(1,2,3)*t4(1,2,2,3)*6.d0
      a(2,6)=o2(1,3,3)*t4(1,2,3,3)*3.d0
      a(2,7)=o2(2,2,2)*t4(2,2,2,2)
      a(2,8)=o2(2,2,3)*t4(2,2,2,3)*3.d0
      a(2,9)=o2(2,3,3)*t4(2,2,3,3)*3.d0
      a(2,10)=o2(3,3,3)*t4(2,3,3,3)

      a(3,1)=o2(1,1,1)*t4(1,1,1,3)
      a(3,2)=o2(1,1,2)*t4(1,1,2,3)*3.d0
      a(3,3)=o2(1,1,3)*t4(1,1,3,3)*3.d0
      a(3,4)=o2(1,2,2)*t4(1,2,2,3)*3.d0
      a(3,5)=o2(1,2,3)*t4(1,2,3,3)*6.d0
      a(3,6)=o2(1,3,3)*t4(1,3,3,3)*3.d0
      a(3,7)=o2(2,2,2)*t4(2,2,2,3)
      a(3,8)=o2(2,2,3)*t4(2,2,3,3)*3.d0
      a(3,9)=o2(2,3,3)*t4(2,3,3,3)*3.d0
      a(3,10)=o2(3,3,3)*t4(3,3,3,3)

      dect4o(1)=c1*(a(1,1)+a(1,2)+a(1,3)+a(1,4)+a(1,5)+a(1,6)+
     .          a(1,7)+a(1,8)+a(1,9)+a(1,10))

      dect4o(2)=c1*(a(2,1)+a(2,2)+a(2,3)+a(2,4)+a(2,5)+a(2,6)+
     .          a(2,7)+a(2,8)+a(2,9)+a(2,10))

      dect4o(3)=c1*(a(3,1)+a(3,2)+a(3,3)+a(3,4)+a(3,5)+a(3,6)+
     .          a(3,7)+a(3,8)+a(3,9)+a(3,10))

      return
      end

