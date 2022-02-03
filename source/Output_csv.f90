!----------------------------------------------------------------------------
! MODULE NAME:
!       Output_csv
!
!----------------------------------------------------------------------------
! PURPOSE:
!       Interface of csv file wrote in Snow Algae Model.
!       This code was written while referencing
!       SMAP.v4.12a (Niwano et al., 2012).
!
!----------------------------------------------------------------------------
! CATEGORY:
!       SnowAlgae
!
!----------------------------------------------------------------------------
! LANGUAGE:
!       fortran 90
!
!----------------------------------------------------------------------------
! CONTAINS:
!       ---------------------------------------------------------------------
!       [PUBLIC]
!       - Output_csv_ini: 
!            initialize 1-D output data (CSV format).
!
!       - Output_csv_header: 
!            write out header fir 1-D output data (CSV format).
!
!       - Output_csv_write: 
!            write out 1-D output data in CSV format.
!
!       ---------------------------------------------------------------------
!       [PRIVATE]
!       - Output_csv_delspace: 
!            delete space 1-D output data for CSV file.
!
!----------------------------------------------------------------------------
! CREATION HISTORY:
!
!       Written by:     Yukihiko Onuma (IIS, UTokyo), 24-Jan-2022
!                                       onuma@iis.u-tokyo.ac.jp
!
!----------------------------------------------------------------------------
! Copyright (C) 2022 Yukihiko Onuma
!
!----------------------------------------------------------------------------
module Output_csv
  use SnowAlgae_Global
  use SnowAlgae_Read_nml

  !===============================================
  ! write data from output.
  !===============================================
  implicit none
  integer,parameter :: num_out = 24

  private
  public :: Output_csv__ini, Output_csv__header, Output_csv__write

contains
!--------------------------------------------------------------------------
  subroutine Output_csv__ini()

    implicit none
    
    !------------------------------------------
    ! 1-D snow & ice surface parameters
    !------------------------------------------
    allocate(rout(ttime,num_out))

  end subroutine Output_csv__ini
!--------------------------------------------------------------------------
  subroutine Output_csv__header()

    implicit none

    character(len=20) :: h1, h2, h3, h4, h5, h6
    character(len=20) :: u1, u2, u3, u4, u5, u6
    character linebuf*512

    ! header information
    h1 = 'gp'
    h2 = 'cellA'
    h3 = 'bioA'
    h4 = 'cellV'
    h5 = 'bioV'
    h6 = 'ocV'

    u1 = 'hour'
    u2 = 'cells*m-2'
    u3 = 'uL*m-2'
    u4 = 'cells*L-1'
    u5 = 'uL*L-1'
    u6 = 'mg*L-1'

    ! write header to csv file (snow).
    !write(linebuf,*) 'ymd',',','doy',',','time',',', &
    write(linebuf,*) 'ymd',',','time',',', &
                   & h1,',',h2,',',h3,',',h4,',',h5,',',h6
    call Output_csv__delspace(linebuf)
    write(36,'(a)') trim(linebuf)
    write(46,'(a)') trim(linebuf)
    write(56,'(a)') trim(linebuf)
    write(66,'(a)') trim(linebuf)
    write(linebuf,*) 'YYYYMMDD',',','HHMMSS',',', &
                   & u1,',',u2,',',u3,',',u4,',',u5,',',u6
    call Output_csv__delspace(linebuf)
    write(36,'(a)') trim(linebuf)
    write(46,'(a)') trim(linebuf)
    write(56,'(a)') trim(linebuf)
    write(66,'(a)') trim(linebuf)

  end subroutine Output_csv__header

!--------------------------------------------------------------------------
  subroutine Output_csv__write(istep, model, &
             & gp, cellA, bioA, cellV, bioV, ocV)
    
    implicit none
    integer :: istep
    character linebuf*512
    character model*4

     ! out
     real(8) :: gp       ! growth period of snow algal cell [hour]
     real(8) :: cellA    ! snow algal cell concentration per area [cells m-2]
     real(8) :: bioA     ! snow algal bio-volume per area [uL m-2]
     real(8) :: cellV    ! snow algal cell concentration per volume [cells L-1]
     real(8) :: bioV     ! snow algal bio-volume per volume [uL L-1]
     real(8) :: ocV      ! organic carbon of snow algae per volume [mg L-1]

    rout(istep,1) = gp 
    rout(istep,2) = cellA
    rout(istep,3) = bioA 
    rout(istep,4) = cellV
    rout(istep,5) = bioV 
    rout(istep,6) = ocV 

    ! write model results to csv file (snow).
    !write(linebuf,*) ymd,',', doy,',', time,',', &
    write(linebuf,*) ymd,',',time,',', &
                   & rout(istep,1),',',rout(istep,2),',',rout(istep,3),',', &
                   & rout(istep,4),',',rout(istep,5),',',rout(istep,6)
    call Output_csv__delspace(linebuf)

    if (model .eq. 'mal ') then
       write(36,'(a)') trim(linebuf)
    else if (model .eq. 'xm ') then
       write(46,'(a)') trim(linebuf)
    else if (model .eq. 'xmd ') then
       write(56,'(a)') trim(linebuf)
    else if (model .eq. 'xmdf') then
       write(66,'(a)') trim(linebuf)
    end if

  end subroutine Output_csv__write

!--------------------------------------------------------------------------
  subroutine Output_csv__delspace(s)
    
    implicit none
    character (*), intent (inout) :: s
    character (len=len(s)) tmp
    integer i, j

    j = 1
    do i = 1, len(s)
       if (s(i:i)==' ') cycle
       tmp(j:j) = s(i:i)
       j = j + 1
    end do
   
    s = tmp(1:j-1)

   end subroutine Output_csv__delspace

end module Output_csv
