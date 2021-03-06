C $Header: /u/gcmpack/MITgcm/pkg/obcs/obcs_sponge.F,v 1.9 2011/05/24 14:31:14 jmc Exp $
C $Name: checkpoint63n $

#include "OBCS_OPTIONS.h"
#include "AD_CONFIG.h"

C--   File obcs_sponge.F:
C--    Contents:
C--    o OBCS_SPONGE_U
C--    o OBCS_SPONGE_V
C--    o OBCS_SPONGE_T
C--    o OBCS_SPONGE_S

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CStartOfInterface
      SUBROUTINE OBCS_SPONGE_U(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myTime, myThid )
C     *==========================================================*
C     | S/R OBCS_SPONGE_U
C     | o Contains problem specific forcing for zonal velocity.
C     *==========================================================*
C     | Adds a relaxation term to gU near Open-Boundaries
C     *==========================================================*
      IMPLICIT NONE

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "OBCS_PARAMS.h"
#include "OBCS_GRID.h"
#include "OBCS_FIELDS.h"

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      _RL myTime
      INTEGER myThid
CEndOfInterface

#if (defined (ALLOW_OBCS) && defined (ALLOW_OBCS_SPONGE))
C     == Local variables ==
C     Loop counters
      INTEGER i, j, isl, jsl
      _RL urelax, lambda_obcs_u

      IF (useOBCSsponge) THEN

C Northern Open Boundary
#ifdef ALLOW_OBCS_NORTH
      DO i=iMin,iMax
       IF ((OB_Jn(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Jn(i,bi,bj)-jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN
          urelax=(
     &      float(spongeThickness-jsl)*OBNu(i,kLev,bi,bj)
     &    + float(jsl)*uVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_u = (
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl)*Vrelaxobcsinner)
     &    / float(spongeThickness)

          IF (lambda_obcs_u.ne.0.) THEN
           lambda_obcs_u = 1. _d 0 / lambda_obcs_u
          ELSE
           lambda_obcs_u = 0. _d 0
          ENDIF

          gU(i,j,kLev,bi,bj) =  gU(i,j,kLev,bi,bj)
     &    - _maskW(i,j,kLev,bi,bj) * lambda_obcs_u
     &    * ( uVel(i,j,kLev,bi,bj) - urelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Southern Open Boundary
#ifdef ALLOW_OBCS_SOUTH
      DO i=iMin,iMax
       IF ((OB_Js(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Js(i,bi,bj)+jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN
          urelax=(
     &      float(spongeThickness-jsl)*OBSu(i,kLev,bi,bj)
     &    + float(jsl)*uVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_u = (
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl)*Vrelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_u.ne.0.) then
            lambda_obcs_u = 1. _d 0 / lambda_obcs_u
          else
            lambda_obcs_u = 0. _d 0
          endif

         gU(i,j,kLev,bi,bj) = gU(i,j,kLev,bi,bj)
     &   - _maskW(i,j,kLev,bi,bj) * lambda_obcs_u
     &   * ( uVel(i,j,kLev,bi,bj) - urelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Eastern Open Boundary
#ifdef ALLOW_OBCS_EAST
      DO j=jMin,jMax
       IF ((OB_Ie(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Ie(j,bi,bj)-isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN
          urelax=(
     &      float(spongeThickness-isl)*OBEu(j,kLev,bi,bj)
     &    + float(isl)*uVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_u = (
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl)*Urelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_u.ne.0.) then
            lambda_obcs_u = 1. _d 0 / lambda_obcs_u
          else
            lambda_obcs_u = 0. _d 0
          endif

          gU(i,j,kLev,bi,bj) = gU(i,j,kLev,bi,bj)
     &    - _maskW(i,j,kLev,bi,bj) * lambda_obcs_u
     &    * ( uVel(i,j,kLev,bi,bj) - urelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Western Open Boundary
#ifdef ALLOW_OBCS_WEST
      DO j=jMin,jMax
       IF ((OB_Iw(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Iw(j,bi,bj)+isl+1

         IF ((i.ge.imin).and.(i.le.imax)) THEN
          urelax=(
     &      float(spongeThickness-isl)*OBWu(j,kLev,bi,bj)
     &    + float(isl)*uVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_u= (
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl)*Urelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_u.ne.0.) then
            lambda_obcs_u = 1. _d 0 / lambda_obcs_u
          else
            lambda_obcs_u = 0. _d 0
          endif

          gU(i,j,kLev,bi,bj) =  gU(i,j,kLev,bi,bj)
     &    - _maskW(i,j,kLev,bi,bj) * lambda_obcs_u
     &    * ( uVel(i,j,kLev,bi,bj) - urelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

      ENDIF

#endif /* ALLOW_OBCS & ALLOW_OBCS_SPONGE */

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CStartOfInterface
      SUBROUTINE OBCS_SPONGE_V(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myTime, myThid )
C     *==========================================================*
C     | S/R OBCS_SPONGE_V
C     | o Contains problem specific forcing for merid velocity.
C     *==========================================================*
C     | Adds a relaxation term to gV near Open-Boundaries
C     *==========================================================*
      IMPLICIT NONE

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "OBCS_PARAMS.h"
#include "OBCS_GRID.h"
#include "OBCS_FIELDS.h"

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      _RL myTime
      INTEGER myThid
CEndOfInterface

#if (defined (ALLOW_OBCS) && defined (ALLOW_OBCS_SPONGE))
C     == Local variables ==
C     Loop counters
      INTEGER i, j, isl, jsl
      _RL vrelax,lambda_obcs_v

      IF (useOBCSsponge) THEN

C Northern Open Boundary
#ifdef ALLOW_OBCS_NORTH
      DO i=iMin,iMax
       IF ((OB_Jn(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Jn(i,bi,bj)-jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN
          vrelax=(
     &      float(spongeThickness-jsl)*OBNv(i,kLev,bi,bj)
     &    + float(jsl)*vVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_v = (
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl)*Vrelaxobcsinner)
     &    / float(spongeThickness)

          IF (lambda_obcs_v.ne.0.) THEN
            lambda_obcs_v = 1. _d 0 / lambda_obcs_v
          ELSE
            lambda_obcs_v = 0. _d 0
          ENDIF

          gV(i,j,kLev,bi,bj) = gV(i,j,kLev,bi,bj)
     &    - _maskS(i,j,kLev,bi,bj) * lambda_obcs_v
     &    * ( vVel(i,j,kLev,bi,bj) - vrelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Southern Open Boundary
#ifdef ALLOW_OBCS_SOUTH
      DO i=iMin,iMax
       IF ((OB_Js(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Js(i,bi,bj)+jsl+1

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN
          vrelax=(
     &      float(spongeThickness-jsl)*OBSv(i,kLev,bi,bj)
     &    + float(jsl)*vVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_v = (
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl)*Vrelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_v.ne.0.) then
            lambda_obcs_v = 1. _d 0 / lambda_obcs_v
          else
            lambda_obcs_v = 0. _d 0
          endif

          gV(i,j,kLev,bi,bj) = gV(i,j,kLev,bi,bj)
     &    - _maskS(i,j,kLev,bi,bj) * lambda_obcs_v
     &    * ( vVel(i,j,kLev,bi,bj) - vrelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Eastern Open Boundary
#ifdef ALLOW_OBCS_EAST
      DO j=jMin,jMax
       IF ((OB_Ie(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Ie(j,bi,bj)-isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN
          vrelax=(
     &      float(spongeThickness-isl)*OBEv(j,kLev,bi,bj)
     &    + float(isl)*vVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_v = (
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl)*Urelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_v.ne.0.) then
            lambda_obcs_v = 1. _d 0 / lambda_obcs_v
          else
            lambda_obcs_v = 0. _d 0
          endif

          gV(i,j,kLev,bi,bj) = gV(i,j,kLev,bi,bj)
     &    - _maskS(i,j,kLev,bi,bj) * lambda_obcs_v
     &    * ( vVel(i,j,kLev,bi,bj) - vrelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Western Open Boundary
#ifdef ALLOW_OBCS_WEST
      DO j=jMin,jMax
       IF ((OB_Iw(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Iw(j,bi,bj)+isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN

          vrelax=(
     &      float(spongeThickness-isl)*OBWv(j,kLev,bi,bj)
     &    + float(isl)*vVel(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_v = (
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl)*Urelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_v.ne.0.) then
            lambda_obcs_v = 1. _d 0 / lambda_obcs_v
          else
            lambda_obcs_v = 0. _d 0
          endif

         gV(i,j,kLev,bi,bj) = gV(i,j,kLev,bi,bj)
     &   - _maskS(i,j,kLev,bi,bj) * lambda_obcs_v
     &   * ( vVel(i,j,kLev,bi,bj) - vrelax )
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

      ENDIF

#endif /* ALLOW_OBCS & ALLOW_OBCS_SPONGE */

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CStartOfInterface
      SUBROUTINE OBCS_SPONGE_T(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myTime, myThid )
C     *==========================================================*
C     | S/R OBCS_SPONGE_T
C     | o Contains problem specific forcing for temperature.
C     *==========================================================*
C     | Adds a relaxation term to gT near Open-Boundaries
C     *==========================================================*
      IMPLICIT NONE

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "OBCS_PARAMS.h"
#include "OBCS_GRID.h"
#include "OBCS_FIELDS.h"
#ifdef ALLOW_AUTODIFF_TAMC
# include "tamc.h"
# include "tamc_keys.h"
#endif

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      _RL myTime
      INTEGER myThid
CEndOfInterface

#if (defined (ALLOW_OBCS) && defined (ALLOW_OBCS_SPONGE))
C     == Local variables ==
C     Loop counters
      INTEGER i, j, isl, jsl
      _RL trelax, lambda_obcs_t

      IF (useOBCSsponge) THEN

#ifdef ALLOW_AUTODIFF_TAMC
          act1 = bi - myBxLo(myThid)
          max1 = myBxHi(myThid) - myBxLo(myThid) + 1
          act2 = bj - myByLo(myThid)
          max2 = myByHi(myThid) - myByLo(myThid) + 1
          act3 = myThid - 1
          max3 = nTx*nTy
          act4 = ikey_dynamics - 1
          ikey = (act1 + 1) + act2*max1
     &                      + act3*max1*max2
     &                      + act4*max1*max2*max3
          kkey = (ikey-1)*Nr + klev
#endif /* ALLOW_AUTODIFF_TAMC */

C Northern Open Boundary
#ifdef ALLOW_OBCS_NORTH

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE OBNt(:,klev,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
#endif

      DO i=iMin,iMax
       IF ((OB_Jn(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Jn(i,bi,bj)-jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN
           IF  (OBNt(i,klev,bi,bj).ne. 0.d0) then
          trelax=(
     &      float(spongeThickness-jsl)*OBNt(i,kLev,bi,bj)
     &    + float(jsl)*theta(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)
          lambda_obcs_t = (
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl)*Vrelaxobcsinner)
     &    / float(spongeThickness)

          IF (lambda_obcs_t.ne.0.) THEN
           lambda_obcs_t = 1. _d 0 / lambda_obcs_t
          ELSE
           lambda_obcs_t = 0. _d 0
          ENDIF

          gT(i,j,kLev,bi,bj) =  gT(i,j,kLev,bi,bj)
     &    -  maskC(i,j,kLev,bi,bj) * lambda_obcs_t
     &    * ( theta(i,j,kLev,bi,bj) - trelax )
           endif
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Southern Open Boundary
#ifdef ALLOW_OBCS_SOUTH

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE OBSt(:,klev,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
#endif

      DO i=iMin,iMax
       IF ((OB_Js(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Js(i,bi,bj)+jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN
           IF  (OBSt(i,klev,bi,bj).ne. 0.d0) then
          trelax=(
     &      float(spongeThickness-jsl)*OBSt(i,kLev,bi,bj)
     &    + float(jsl)*theta(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_t = (
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl)*Vrelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_t.ne.0.) then
            lambda_obcs_t = 1. _d 0 / lambda_obcs_t
          else
            lambda_obcs_t = 0. _d 0
          endif

         gT(i,j,kLev,bi,bj) = gT(i,j,kLev,bi,bj)
     &   - maskC(i,j,kLev,bi,bj) * lambda_obcs_t
     &   * ( theta(i,j,kLev,bi,bj) - trelax )
           endif
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Eastern Open Boundary
#ifdef ALLOW_OBCS_EAST

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE OBEt(:,klev,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
#endif

      DO j=jMin,jMax
       IF ((OB_Ie(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Ie(j,bi,bj)-isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN
           IF  (OBEt(j,klev,bi,bj).ne. 0.d0) then
          trelax=(
     &      float(spongeThickness-isl)*OBEt(j,kLev,bi,bj)
     &    + float(isl)*theta(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_t = (
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl)*Urelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_t.ne.0.) then
            lambda_obcs_t = 1. _d 0 / lambda_obcs_t
          else
            lambda_obcs_t = 0. _d 0
          endif

          gT(i,j,kLev,bi,bj) = gT(i,j,kLev,bi,bj)
     &    - maskC(i,j,kLev,bi,bj) * lambda_obcs_t
     &    * ( theta(i,j,kLev,bi,bj) - trelax )
           endif
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Western Open Boundary
#ifdef ALLOW_OBCS_WEST

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE OBWt(:,klev,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
#endif

      DO j=jMin,jMax
       IF ((OB_Iw(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
cgg         i=OB_Iw(j,bi,bj)+isl+1
cgg  Needed to fix the coordinate of the tracer open boundary. This is the classic "cut-and-paste" bug.
         i=OB_Iw(j,bi,bj)+isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN
           IF  (OBWt(j,klev,bi,bj).ne. 0.d0) then
          trelax=(
     &      float(spongeThickness-isl)*OBWt(j,kLev,bi,bj)
     &    + float(isl)*theta(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_t= (
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl)*Urelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_t .ne. 0.) then
            lambda_obcs_t = 1. _d 0 / lambda_obcs_t
          else
            lambda_obcs_t = 0. _d 0
          endif

          gT(i,j,kLev,bi,bj) =  gT(i,j,kLev,bi,bj)
     &    - maskC(i,j,kLev,bi,bj) * lambda_obcs_t
     &    * ( theta(i,j,kLev,bi,bj) - trelax )
           endif
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

      ENDIF

#endif /* ALLOW_OBCS & ALLOW_OBCS_SPONGE */

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CStartOfInterface
      SUBROUTINE OBCS_SPONGE_S(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myTime, myThid )
C     *==========================================================*
C     | S/R OBCS_SPONGE_S
C     | o Contains problem specific forcing for salinity.
C     *==========================================================*
C     | Adds a relaxation term to gS near Open-Boundaries
C     *==========================================================*
      IMPLICIT NONE

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "OBCS_PARAMS.h"
#include "OBCS_GRID.h"
#include "OBCS_FIELDS.h"
#ifdef ALLOW_AUTODIFF_TAMC
# include "tamc.h"
# include "tamc_keys.h"
#endif

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      _RL myTime
      INTEGER myThid
CEndOfInterface

#if (defined (ALLOW_OBCS) && defined (ALLOW_OBCS_SPONGE))
C     == Local variables ==
C     Loop counters
      INTEGER i, j, isl, jsl
      _RL srelax, lambda_obcs_s

      IF (useOBCSsponge) THEN

#ifdef ALLOW_AUTODIFF_TAMC
          act1 = bi - myBxLo(myThid)
          max1 = myBxHi(myThid) - myBxLo(myThid) + 1
          act2 = bj - myByLo(myThid)
          max2 = myByHi(myThid) - myByLo(myThid) + 1
          act3 = myThid - 1
          max3 = nTx*nTy
          act4 = ikey_dynamics - 1
          ikey = (act1 + 1) + act2*max1
     &                      + act3*max1*max2
     &                      + act4*max1*max2*max3
          kkey = (ikey-1)*Nr + klev
#endif /* ALLOW_AUTODIFF_TAMC */

C Northern Open Boundary
#ifdef ALLOW_OBCS_NORTH

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE OBNs(:,klev,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
#endif

      DO i=iMin,iMax
       IF ((OB_Jn(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Jn(i,bi,bj)-jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN
           IF  (OBNs(i,klev,bi,bj).ne. 0.d0) then
          srelax=(
     &      float(spongeThickness-jsl)*OBNs(i,kLev,bi,bj)
     &    + float(jsl)*salt(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_s = (
     &      float(spongeThickness-jsl)*Vrelaxobcsbound
     &    + float(jsl)*Vrelaxobcsinner)
     &    / float(spongeThickness)

          IF (lambda_obcs_s.ne.0.) THEN
           lambda_obcs_s = 1. _d 0 / lambda_obcs_s
          ELSE
           lambda_obcs_s = 0. _d 0
          ENDIF

          gS(i,j,kLev,bi,bj) =  gS(i,j,kLev,bi,bj)
     &    - maskC(i,j,kLev,bi,bj) * lambda_obcs_s
     &    * ( salt(i,j,kLev,bi,bj) - srelax )
           endif
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Southern Open Boundary
#ifdef ALLOW_OBCS_SOUTH

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE OBSs(:,klev,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
#endif

      DO i=iMin,iMax
       IF ((OB_Js(i,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO jsl= 1,spongeThickness
         j=OB_Js(i,bi,bj)+jsl

         IF ((j.ge.jmin).and.(j.le.jmax)) THEN
           IF  (OBSs(i,klev,bi,bj).ne. 0.d0) then
          srelax=(
     &      float(spongeThickness-jsl)*OBSs(i,kLev,bi,bj)
     &    + float(jsl)*salt(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_s = (
     &      float(spongeThickness)*Vrelaxobcsbound
     &    + float(jsl)*Vrelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_s.ne.0.) then
            lambda_obcs_s = 1. _d 0 / lambda_obcs_s
          else
            lambda_obcs_s = 0. _d 0
          endif

         gS(i,j,kLev,bi,bj) = gS(i,j,kLev,bi,bj)
     &   - maskC(i,j,kLev,bi,bj) * lambda_obcs_s
     &   * ( salt(i,j,kLev,bi,bj) - srelax )
           endif
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Eastern Open Boundary
#ifdef ALLOW_OBCS_EAST

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE OBEs(:,klev,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
#endif

      DO j=jMin,jMax
       IF ((OB_Ie(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness
         i=OB_Ie(j,bi,bj)-isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN
           IF  (OBEs(j,klev,bi,bj).ne. 0.d0) then
          srelax=(
     &      float(spongeThickness-isl)*OBEs(j,kLev,bi,bj)
     &    + float(isl)*salt(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_s = (
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl)*Urelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_s.ne.0.) then
            lambda_obcs_s = 1. _d 0 / lambda_obcs_s
          else
            lambda_obcs_s = 0. _d 0
          endif

          gS(i,j,kLev,bi,bj) = gS(i,j,kLev,bi,bj)
     &    - maskC(i,j,kLev,bi,bj) * lambda_obcs_s
     &    * ( salt(i,j,kLev,bi,bj) - srelax )
           endif
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

C Western Open Boundary
#ifdef ALLOW_OBCS_WEST

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE OBWs(:,klev,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
#endif

      DO j=jMin,jMax
       IF ((OB_Iw(j,bi,bj).ne.0).and.(spongeThickness.ne.0)) THEN
        DO isl= 1,spongeThickness

cgg         i=OB_Iw(j,bi,bj)+isl+1
cgg  Fix the tracer o.b. coordinate.
         i=OB_Iw(j,bi,bj)+isl

         IF ((i.ge.imin).and.(i.le.imax)) THEN
           IF  (OBWs(j,klev,bi,bj).ne. 0.d0) then
          srelax=(
     &      float(spongeThickness-isl)*OBWs(j,kLev,bi,bj)
     &    + float(isl)*salt(i,j,kLev,bi,bj) )
     &    / float(spongeThickness)

          lambda_obcs_s= (
     &      float(spongeThickness-isl)*Urelaxobcsbound
     &    + float(isl)*Urelaxobcsinner)
     &    / float(spongeThickness)

          if (lambda_obcs_s.ne.0.) then
            lambda_obcs_s = 1. _d 0 / lambda_obcs_s
          else
            lambda_obcs_s = 0. _d 0
          endif

          gS(i,j,kLev,bi,bj) =  gS(i,j,kLev,bi,bj)
     &    - maskC(i,j,kLev,bi,bj) * lambda_obcs_s
     &    * ( salt(i,j,kLev,bi,bj) - srelax )
           endif
         ENDIF

        ENDDO
       ENDIF
      ENDDO
#endif

      ENDIF

#endif /* ALLOW_OBCS & ALLOW_OBCS_SPONGE */

      RETURN
      END
