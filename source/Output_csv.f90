!----------------------------------------------------------------------------
! MODULE NAME:
!       Output_csv
!
!----------------------------------------------------------------------------
! PURPOSE:
!       interface of csv file wrote in Snow Algae Model.
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
  integer,parameter :: num_out = 12

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

    character(len=20) :: h1, h2, h3, h4, h5, h6, &
                       & h7, h8, h9, h10, h11, h12
    character linebuf*512

    ! header information
    h1 = 'gt-mal[hour-1]'
    h2 = 'cl-mal[cells*m-2]'
    h3 = 'bio-mal[uL*m-2]'
    h4 = 'gt-XM[hour-1]'
    h5 = 'cl-XM[cells*m-2]'
    h6 = 'bio-XM[uL*m-2]'
    h7 = 'gt-XMD[hour-1]'
    h8 = 'cl-XMD[cells*m-2]'
    h9 = 'bio-XMD[uL*m-2]'
    h10 = 'gt-XMDF[hour-1]'
    h11 = 'cl-XMDF[cells*m-2]'
    h12 = 'bio-XMDF[uL*m-2]'

    ! write header to csv file (snow).
    !write(linebuf,*) 'ymd',',','doy',',','time',',', &
    write(linebuf,*) 'ymd',',','time',',', &
                   & h1,',',h2,',',h3,',', &
                   & h4,',',h5,',',h6,',', &
                   & h7,',',h8,',',h9,',', &
                   & h10,',',h11,',',h12
    call Output_csv__delspace(linebuf)
    write(36,'(a)') trim(linebuf)

  end subroutine Output_csv__header

!--------------------------------------------------------------------------
  subroutine Output_csv__write(istep)
    
    implicit none
    integer :: istep
    character linebuf*512

    rout(istep,1) = grtime_mal 
    rout(istep,2) = cell_mal
    rout(istep,3) = biomass_mal 
    rout(istep,4) = grtime_XM 
    rout(istep,5) = cell_XM
    rout(istep,6) = biomass_XM 
    rout(istep,7) = grtime_XMD 
    rout(istep,8) = cell_XMD
    rout(istep,9) = biomass_XMD
    rout(istep,10) = grtime_XMDF 
    rout(istep,11) = cell_XMDF
    rout(istep,12) = biomass_XMDF

    ! write model results to csv file (snow).
    !write(linebuf,*) ymd,',', doy,',', time,',', &
    write(linebuf,*) ymd,',',time,',', &
                   & rout(istep,1),',',rout(istep,2),',',rout(istep,3),',', &
                   & rout(istep,4),',',rout(istep,5),',',rout(istep,6),',', &
                   & rout(istep,7),',',rout(istep,8),',',rout(istep,9),',', &
                   & rout(istep,10),',',rout(istep,11),',',rout(istep,12)
    call Output_csv__delspace(linebuf)
    write(36,'(a)') trim(linebuf)

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
