












CBOP
C !ROUTINE: GAD_OPTIONS.h

C !INTERFACE:
C #include "GAD_OPTIONS.h"

C !DESCRIPTION:
C Contains CPP macros/flags for controlling optional features of package.
CEOP

C CPP options file for GAD (Generic Advection Diffusion) package
C Use this file for selecting options within the GAD package







C $Header: /u/gcmpack/MITgcm/verification/tutorial_plume_on_slope/code/CPP_OPTIONS.h,v 1.1 2006/04/20 16:45:12 jmc Exp $
C $Name: checkpoint65t $


C CPP flags controlling particular source code features

C o Shortwave heating as extra term in external_forcing.F
C Note: this should be a run-time option

C o Include/exclude phi_hyd calculation code

C o Include/exclude call to S/R CONVECT

C o Include/exclude call to S/R CALC_DIFFUSIVITY

C o Include/exclude Implicit vertical advection code

C o Include/exclude nonHydrostatic code

C o Include pressure loading code

C o Use "Exact Convervation" of fluid in Free-Surface formulation
C   so that d/dt(eta) is exactly equal to - Div.Transport

C o Allow the use of Non-Linear Free-Surface formulation
C   this implies that surface thickness (hFactors) vary with time

C o Use "OLD" UV discretisation near boundaries (*not* recommended)
C   Note - only works with  #undef NO_SLIP_LATERAL  in calc_mom_rhs.F
C          because the old code did not have no-slip BCs

C o Execution environment support options
CBOP
C     !ROUTINE: CPP_EEOPTIONS.h
C     !INTERFACE:
C     include "CPP_EEOPTIONS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP\_EEOPTIONS.h                                         |
C     *==========================================================*
C     | C preprocessor "execution environment" supporting        |
C     | flags. Use this file to set flags controlling the        |
C     | execution environment in which a model runs - as opposed |
C     | to the dynamical problem the model solves.               |
C     | Note: Many options are implemented with both compile time|
C     |       and run-time switches. This allows options to be   |
C     |       removed altogether, made optional at run-time or   |
C     |       to be permanently enabled. This convention helps   |
C     |       with the data-dependence analysis performed by the |
C     |       adjoint model compiler. This data dependency       |
C     |       analysis can be upset by runtime switches that it  |
C     |       is unable to recoginise as being fixed for the     |
C     |       duration of an integration.                        |
C     |       A reasonable way to use these flags is to          |
C     |       set all options as selectable at runtime but then  |
C     |       once an experimental configuration has been        |
C     |       identified, rebuild the code with the appropriate  |
C     |       options set at compile time.                       |
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C=== Macro related options ===
C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working set size.
C     However, on vector CRAY systems this degrades performance.
C     Enable to switch REAL4_IS_SLOW from genmake2 (with LET_RS_BE_REAL4):

C--   Control use of "double" precision constants.
C     Use D0 where it means REAL*8 but not where it means REAL*16

C--   Enable some old macro conventions for backward compatibility

C=== IO related options ===
C--   Flag used to indicate whether Fortran formatted write
C     and read are threadsafe. On SGI the routines can be thread
C     safe, on Sun it is not possible - if you are unsure then
C     undef this option.

C--   Flag used to indicate whether Binary write to Local file (i.e.,
C     a different file for each tile) and read are thread-safe.

C--   Flag to turn off the writing of error message to ioUnit zero

C--   Alternative formulation of BYTESWAP, faster than
C     compiler flag -byteswapio on the Altix.

C--   Flag to turn on old default of opening scratch files with the
C     STATUS='SCRATCH' option. This method, while perfectly FORTRAN-standard,
C     caused filename conflicts on some multi-node/multi-processor platforms
C     in the past and has been replace by something (hopefully) more robust.

C--   Flag defined for eeboot_minimal.F, eeset_parms.F and open_copy_data_file.F
C     to write STDOUT, STDERR and scratch files from process 0 only.
C WARNING: to use only when absolutely confident that the setup is working
C     since any message (error/warning/print) from any proc <> 0 will be lost.

C=== MPI, EXCH and GLOBAL_SUM related options ===
C--   Flag turns off MPI_SEND ready_to_receive polling in the
C     gather_* subroutines to speed up integrations.

C--   Control MPI based parallel processing
CXXX We no longer select the use of MPI via this file (CPP_EEOPTIONS.h)
CXXX To use MPI, use an appropriate genmake2 options file or use
CXXX genmake2 -mpi .
CXXX #undef  1

C--   Control use of communication that might overlap computation.
C     Under MPI selects/deselects "non-blocking" sends and receives.
C--   Control use of communication that is atomic to computation.
C     Under MPI selects/deselects "blocking" sends and receives.

C--   Control XY periodicity in processor to grid mappings
C     Note: Model code does not need to know whether a domain is
C           periodic because it has overlap regions for every box.
C           Model assume that these values have been
C           filled in some way.

C--   disconnect tiles (no exchange between tiles, just fill-in edges
C     assuming locally periodic subdomain)

C--   Always cumulate tile local-sum in the same order by applying MPI allreduce
C     to array of tiles ; can get slower with large number of tiles (big set-up)

C--   Alternative way of doing global sum without MPI allreduce call
C     but instead, explicit MPI send & recv calls. Expected to be slower.

C--   Alternative way of doing global sum on a single CPU
C     to eliminate tiling-dependent roundoff errors. Note: This is slow.

C=== Other options (to add/remove pieces of code) ===
C--   Flag to turn on checking for errors from all threads and procs
C     (calling S/R STOP_IF_ERROR) before stopping.

C--   Control use of communication with other component:
C     allow to import and export from/to Coupler interface.

C--   Activate some pieces of code for coupling to GEOS AGCM


CBOP
C     !ROUTINE: CPP_EEMACROS.h
C     !INTERFACE:
C     include "CPP_EEMACROS.h"
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP_EEMACROS.h
C     *==========================================================*
C     | C preprocessor "execution environment" supporting
C     | macros. Use this file to define macros for  simplifying
C     | execution environment in which a model runs - as opposed
C     | to the dynamical problem the model solves.
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C     Flag used to indicate which flavour of multi-threading
C     compiler directives to use. Only set one of these.
C     USE_SOLARIS_THREADING  - Takes directives for SUN Workshop
C                              compiler.
C     USE_KAP_THREADING      - Takes directives for Kuck and
C                              Associates multi-threading compiler
C                              ( used on Digital platforms ).
C     USE_IRIX_THREADING     - Takes directives for SGI MIPS
C                              Pro Fortran compiler.
C     USE_EXEMPLAR_THREADING - Takes directives for HP SPP series
C                              compiler.
C     USE_C90_THREADING      - Takes directives for CRAY/SGI C90
C                              system F90 compiler.






C--   Define the mapping for the _BARRIER macro
C     On some systems low-level hardware support can be accessed through
C     compiler directives here.

C--   Define the mapping for the BEGIN_CRIT() and  END_CRIT() macros.
C     On some systems we simply execute this section only using the
C     master thread i.e. its not really a critical section. We can
C     do this because we do not use critical sections in any critical
C     sections of our code!

C--   Define the mapping for the BEGIN_MASTER_SECTION() and
C     END_MASTER_SECTION() macros. These are generally implemented by
C     simply choosing a particular thread to be "the master" and have
C     it alone execute the BEGIN_MASTER..., END_MASTER.. sections.

CcnhDebugStarts
C      Alternate form to the above macros that increments (decrements) a counter each
C      time a MASTER section is entered (exited). This counter can then be checked in barrier
C      to try and detect calls to BARRIER within single threaded sections.
C      Using these macros requires two changes to Makefile - these changes are written
C      below.
C      1 - add a filter to the CPP command to kill off commented _MASTER lines
C      2 - add a filter to the CPP output the converts the string N EWLINE to an actual newline.
C      The N EWLINE needs to be changes to have no space when this macro and Makefile changes
C      are used. Its in here with a space to stop it getting parsed by the CPP stage in these
C      comments.
C      #define IF ( a .EQ. 1 ) THEN  IF ( a .EQ. 1 ) THEN  N EWLINE      CALL BARRIER_MS(a)
C      #define ENDIF    CALL BARRIER_MU(a) N EWLINE        ENDIF
C      'CPP = cat $< | $(TOOLSDIR)/set64bitConst.sh |  grep -v '^[cC].*_MASTER' | cpp  -traditional -P'
C      .F.f:
C      $(CPP) $(DEFINES) $(INCLUDES) |  sed 's/N EWLINE/\n/' > $@
CcnhDebugEnds

C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working
C     set size. However, on vector CRAY systems this degrades
C     performance.
C- Note: global_sum/max macros were used to switch to  JAM routines (obsolete);
C  in addition, since only the R4 & R8 S/R are coded, GLOBAL RS & RL macros
C  enable to call the corresponding R4 or R8 S/R.



C- Note: a) exch macros were used to switch to  JAM routines (obsolete)
C        b) exch R4 & R8 macros are not practically used ; if needed,
C           will directly call the corrresponding S/R.

C--   Control use of JAM routines for Artic network (no longer supported)
C     These invoke optimized versions of "exchange" and "sum" that
C     utilize the programmable aspect of Artic cards.
CXXX No longer supported ; started to remove JAM routines.
CXXX #ifdef LETS_MAKE_JAM
CXXX #define CALL GLOBAL_SUM_R8 ( a, b) CALL GLOBAL_SUM_R8_JAM ( a, b)
CXXX #define CALL GLOBAL_SUM_R8 ( a, b ) CALL GLOBAL_SUM_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RS ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RL ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RS ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RL ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #endif

C--   Control use of "double" precision constants.
C     Use d0 where it means REAL*8 but not where it means REAL*16

C--   Substitue for 1.D variables
C     Sun compilers do not use 8-byte precision for literals
C     unless .Dnn is specified. CRAY vector machines use 16-byte
C     precision when they see .Dnn which runs very slowly!

C--   Set the format for writing processor IDs, e.g. in S/R eeset_parms
C     and S/R open_copy_data_file. The default of I9.9 should work for
C     a long time (until we will use 10e10 processors and more)



C o Include/exclude code specific to the ECCO/SEALION version.
C   AUTODIFF or EXF package.
C   Currently controled by a single header file
C   For this to work, PACKAGES_CONFIG.h needs to be included!
cph#if (defined (ALLOW_AUTODIFF) || cph     defined (ALLOW_ECCO) || cph     defined (ALLOW_EXF))
cph# include "ECCO_CPPOPTIONS.h"
cph#endif



C     Package-specific Options & Macros go here

C This flag selects the form of COSINE(lat) scaling of bi-harmonic term.
C *only for use on a lat-lon grid*
C Setting this flag here only affects the bi-harmonic tracer terms; to
C use COSINEMETH_III in the momentum equations set it CPP_OPTIONS.h

C This selects isotropic scaling of harmonic and bi-harmonic term when
C using the COSINE(lat) scaling.
C Setting this flag here only affects the tracer diffusion terms; to
C use ISOTROPIC_COS_SCALING of the horizontal viscosity terms in the
C momentum equations set it CPP_OPTIONS.h; the following line
C even overrides setting the flag in CPP_OPTIONS.h

C As of checkpoint41, the inclusion of multi-dimensional advection
C introduces excessive recomputation/storage for the adjoint.
C We can disable it here using CPP because run-time flags are insufficient.

C Use compressible flow method for multi-dim advection instead of old, less
C accurate jmc method. Note: option has no effect on SOM advection which
C always use compressible flow method.

C This enable the use of 2nd-Order Moment advection scheme (Prather, 1986) for
C Temperature and Salinity ; due to large memory space (10 times more / tracer)
C requirement, by default, this part of the code is not compiled.

C Hack to get rid of negatives caused by Redi.  Works by restricting the
C outgoing flux (only contributions computed in gad_calc_rhs) for each cell
C to be no more than the amount of tracer in the cell (see Smolarkiewicz
C MWR 1989 and Bott MWR 1989).
C The flux contributions computed in gad_calc_rhs which are affected by
C this hack are:
C - explicit diffusion, Redi and the non-local part of KPP
C - advection is affected only if multiDimAdvection=.FALSE.
C - vertical diffusion (including the diagonal contribution from GMRedi)
C   only if implicitDiffusion=.FALSE.
C - GM is affected only if GMREDI_AdvForm=.FALSE.
C
C The parameter SmolarkiewiczMaxFrac (defined in gad_init_fixed.F)
C specifies the maximal fraction of tracer that can leave a cell.
C By default it is 1.  This will prevent the tracer from going negative
C due to contributions from gad_calc_rhs alone.  In the presence of other
C contributions (or roundoff errors), it may be necessary to reduce this
C value to achieve strict positivity.
C
C This hack applies to all tracers except temperature and salinity!
C Do not use with Adams-Bashforth (for ptracers)!
C Do not use with OBCS!


C--  File gad_pqm_fun.F: Routines to form PQM grid-cell polynomial.
C--   Contents
C--   o QUADROOT
C--   o GAD_PPM_FUN_NULL
C--   o GAD_PPM_FUN_MONO

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

      LOGICAL FUNCTION QUADROOT(aa,bb,cc,xx)
C     |================================================================|
C     | QUADROOT: find roots of quadratic ax**2 + bx + c = 0.          |
C     |================================================================|

          implicit none

C     ====================================================== arguments
          Real*8 aa,bb,cc
          Real*8 xx(1:2)

C     ====================================================== variables
          Real*8 sq,a0,b0

          a0 = abs(aa)
          b0 = abs(bb)

          sq = bb * bb - 4.D0 * aa * cc

          if (a0 .gt. 0.D0) then

          if (sq .ge. 0.D0) then

              QUADROOT =  .TRUE.

              sq = sqrt(sq)

              xx(1) =  - bb + sq
              xx(2) =  - bb - sq

              aa = 0.5D0 / aa

              xx(1) = xx(1) * aa
              xx(2) = xx(2) * aa

          else

              QUADROOT = .FALSE.

          end if

          else

          if (b0 .gt. 0.D0) then

              QUADROOT =  .TRUE.

              xx(1) =  - cc / bb
              xx(2) =  - cc / bb

          else

              QUADROOT = .FALSE.

          end if

          end if

          return

c     end function QUADROOT
      end

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

      SUBROUTINE GAD_PQM_FUN_NULL(
     I           ff00,
     I           fell,ferr,
     I           dell,derr,
     O           fhat,mono)
C     |================================================================|
C     | PQM_FUN_NULL: form PQM grid-cell polynomial.                   |
C     | Piecewise Quartic Method (PQM) - unlimited variant.            |
C     |================================================================|

          implicit none

C     ====================================================== arguments
          Real*8 ff00
          Real*8 fell,ferr
          Real*8 dell,derr
          Real*8 fhat(+1:+5)
          integer mono

          mono = +0

C     ============================================== unlimited profile
          fhat(1) =
     & + (30.D0 / 16.D0) * ff00
     & - ( 7.D0 / 16.D0) *(ferr+fell)
     & + ( 1.D0 / 16.D0) *(derr-dell)
          fhat(2) =
     & + ( 3.D0 /  4.D0) *(ferr-fell)
     & - ( 1.D0 /  4.D0) *(derr+dell)
          fhat(3) =
     & - (30.D0 /  8.D0) * ff00
     & + (15.D0 /  8.D0) *(ferr+fell)
     & - ( 3.D0 /  8.D0) *(derr-dell)
          fhat(4) =
     & - ( 1.D0 /  4.D0) *(ferr-fell-derr-dell)
          fhat(5) =
     & + (30.D0 / 16.D0) * ff00
     & - (15.D0 / 16.D0) *(ferr+fell)
     & + ( 5.D0 / 16.D0) *(derr-dell)

          return

c     end subroutine GAD_PQM_FUN_NULL
      end

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

      SUBROUTINE GAD_PQM_FUN_MONO(
     I           ff00,
     I           ffll,ffrr,
     I           fell,ferr,
     I           dell,derr,
     I           dfds,
     O           fhat,mono)
C     |================================================================|
C     | PQM_FUN_MONO: form PQM grid-cell polynomial.                   |
C     | Piecewise Quartic Method (PQM) - monotonic variant.            |
C     |================================================================|

          implicit none

C     ====================================================== arguments
          Real*8 ff00,ffll,ffrr
          Real*8 fell,ferr
          Real*8 dell,derr
          Real*8 dfds(-1:+1)
          Real*8 fhat(+1:+5)
          integer mono

C     ====================================================== functions
          logical QUADROOT

C     ====================================================== variables
          integer bind
          Real*8 aval,bval,cval
          Real*8 iflx(+1:+2)
          Real*8 dflx(+1:+2)

          mono = +0

C     ============================================== "flatten" extrema
          if((ffrr-ff00) *
     &       (ff00-ffll) .le. 0.D0) then

              mono = +1

              fhat(1) = ff00

              fhat(2) = 0.D0
              fhat(3) = 0.D0
              fhat(4) = 0.D0
              fhat(5) = 0.D0

              return

          end if

C     ============================================== limit edge values
          if((ffll - fell) *
     &       (fell - ff00) .le. 0.D0) then

              mono = +1

              fell = ff00 - dfds(0)

          end if

          if((ffrr - ferr) *
     &       (ferr - ff00) .le. 0.D0) then

              mono = +1

              ferr = ff00 + dfds(0)

          end if

C     ============================================== limit edge slopes
          if((dell * dfds(-1)) .lt. 0.D0) then

              mono = +1

              dell = dfds(-1)

          end if

          if((derr * dfds(+1)) .lt. 0.D0) then

              mono = +1

              derr = dfds(+1)

          end if

C     ============================================== limit cell values
          fhat(1) =
     & + (30.D0 / 16.D0) * ff00
     & - ( 7.D0 / 16.D0) *(ferr+fell)
     & + ( 1.D0 / 16.D0) *(derr-dell)
          fhat(2) =
     & + ( 3.D0 /  4.D0) *(ferr-fell)
     & - ( 1.D0 /  4.D0) *(derr+dell)
          fhat(3) =
     & - (30.D0 /  8.D0) * ff00
     & + (15.D0 /  8.D0) *(ferr+fell)
     & - ( 3.D0 /  8.D0) *(derr-dell)
          fhat(4) =
     & - ( 1.D0 /  4.D0) *(ferr-fell-derr-dell)
          fhat(5) =
     & + (30.D0 / 16.D0) * ff00
     & - (15.D0 / 16.D0) *(ferr+fell)
     & + ( 5.D0 / 16.D0) *(derr-dell)

C     ============================= calc. inflexion via 2nd-derivative
          aval = 12.D0 * fhat(5)
          bval =  6.D0 * fhat(4)
          cval =  2.D0 * fhat(3)

          if ( QUADROOT(aval,bval,cval,iflx) ) then

              bind = +0

              if ( ( iflx(1) .gt. -1.D0 )
     &       .and. ( iflx(1) .lt. +1.D0 ) ) then

C     ============================= check for non-monotonic inflection
              dflx(1) =       fhat(2)
     &      + iflx(1)       * fhat(3) * 2.D0
     &      +(iflx(1) ** 2) * fhat(4) * 3.D0
     &      +(iflx(1) ** 3) * fhat(5) * 4.D0

              if (dflx(1)*dfds(+0) .lt. 0.D0) then

                  if (abs(dell)
     &           .lt. abs(derr) ) then

                      bind = -1

                  else

                      bind = +1

                  end if

              end if

              end if

              if ( ( iflx(2) .gt. -1.D0 )
     &       .and. ( iflx(2) .lt. +1.D0 ) ) then

C     ============================= check for non-monotonic inflection
              dflx(2) =       fhat(2)
     &      + iflx(2)       * fhat(3) * 2.D0
     &      +(iflx(2) ** 2) * fhat(4) * 3.D0
     &      +(iflx(2) ** 3) * fhat(5) * 4.D0

              if (dflx(2)*dfds(+0) .lt. 0.D0) then

                  if (abs(dell)
     &           .lt. abs(derr) ) then

                      bind = -1

                  else

                      bind = +1

                  end if

              end if

              end if

C     ============================= pop non-monotone inflexion to edge

              if (bind .eq. -1) then

C     ============================= pop inflection points onto -1 edge
                  mono = +2

                  derr =
     &          -( 5.D0 / 1.D0) * ff00
     &          +( 3.D0 / 1.D0) * ferr
     &          +( 2.D0 / 1.D0) * fell
                  dell =
     &          +( 5.D0 / 3.D0) * ff00
     &          -( 1.D0 / 3.D0) * ferr
     &          -( 4.D0 / 3.D0) * fell

                  if (dell*dfds(-1) .lt. 0.D0) then

                      dell = 0.D0

                      ferr =
     &              +( 5.D0 / 1.D0) * ff00
     &              -( 4.D0 / 1.D0) * fell
                      derr =
     &              +(10.D0 / 1.D0) * ff00
     &              -(10.D0 / 1.D0) * fell

                  end if

                  if (derr*dfds(+1) .lt. 0.D0) then

                      derr = 0.D0

                      fell =
     &              +( 5.D0 / 2.D0) * ff00
     &              -( 3.D0 / 2.D0) * ferr
                      dell =
     &              -( 5.D0 / 3.D0) * ff00
     &              +( 5.D0 / 3.D0) * ferr

                  end if

              end if

              if (bind .eq. +1) then

C     ============================= pop inflection points onto +1 edge
                  mono = +2

                  derr =
     &          -( 5.D0 / 3.D0) * ff00
     &          +( 4.D0 / 3.D0) * ferr
     &          +( 1.D0 / 3.D0) * fell
                  dell =
     &          +( 5.D0 / 1.D0) * ff00
     &          -( 2.D0 / 1.D0) * ferr
     &          -( 3.D0 / 1.D0) * fell

                  if (dell*dfds(-1) .lt. 0.D0) then

                      dell = 0.D0

                      ferr =
     &              +( 5.D0 / 2.D0) * ff00
     &              -( 3.D0 / 2.D0) * fell
                      derr =
     &              +( 5.D0 / 3.D0) * ff00
     &              -( 5.D0 / 3.D0) * fell

                  end if

                  if (derr*dfds(+1) .lt. 0.D0) then

                      derr = 0.D0

                      fell =
     &              +( 5.D0 / 1.D0) * ff00
     &              -( 4.D0 / 1.D0) * ferr
                      dell =
     &              -(10.D0 / 1.D0) * ff00
     &              +(10.D0 / 1.D0) * ferr

                  end if

              end if

          end if

C     ============================= re-assemble coefficients on demand
          if (mono .eq. +2) then

          fhat(1) =
     & + (30.D0 / 16.D0) * ff00
     & - ( 7.D0 / 16.D0) *(ferr+fell)
     & + ( 1.D0 / 16.D0) *(derr-dell)
          fhat(2) =
     & + ( 3.D0 /  4.D0) *(ferr-fell)
     & - ( 1.D0 /  4.D0) *(derr+dell)
          fhat(3) =
     & - (30.D0 /  8.D0) * ff00
     & + (15.D0 /  8.D0) *(ferr+fell)
     & - ( 3.D0 /  8.D0) *(derr-dell)
          fhat(4) =
     & - ( 1.D0 /  4.D0) *(ferr-fell-derr-dell)
          fhat(5) =
     & + (30.D0 / 16.D0) * ff00
     & - (15.D0 / 16.D0) *(ferr+fell)
     & + ( 5.D0 / 16.D0) *(derr-dell)

          end if

          return

c     end subroutine GAD_PQM_FUN_MONO
      end
