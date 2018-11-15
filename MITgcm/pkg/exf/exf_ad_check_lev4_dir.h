C $Header: /u/gcmpack/MITgcm/pkg/exf/exf_ad_check_lev4_dir.h,v 1.11 2012/04/19 16:06:43 heimbach Exp $
C $Name: checkpoint63n $

#ifdef ALLOW_EXF

CADJ STORE StoreEXF1        = tapelev4, key = ilev_4
CADJ STORE StoreEXF2        = tapelev4, key = ilev_4
CADJ STORE StoreCTRLS1      = tapelev4, key = ilev_4

# ifdef EXF_ALLOW_SEAICE_RELAX
CADJ STORE areamask0    = tapelev4, key = ilev_4
CADJ STORE areamask1    = tapelev4, key = ilev_4
# endif

# ifdef ALLOW_HFLUX_CONTROL
CADJ STORE xx_hflux0     = tapelev4, key = ilev_4
CADJ STORE xx_hflux1     = tapelev4, key = ilev_4
# endif
# ifdef ALLOW_SFLUX_CONTROL
CADJ STORE xx_sflux0     = tapelev4, key = ilev_4
CADJ STORE xx_sflux1     = tapelev4, key = ilev_4
# endif
# ifdef ALLOW_USTRESS_CONTROL
CADJ STORE xx_tauu0      = tapelev4, key = ilev_4
CADJ STORE xx_tauu1      = tapelev4, key = ilev_4
# endif
# ifdef ALLOW_VSTRESS_CONTROL
CADJ STORE xx_tauv0      = tapelev4, key = ilev_4
CADJ STORE xx_tauv1      = tapelev4, key = ilev_4
# endif
# ifdef ALLOW_SST_CONTROL
CADJ STORE xx_sst0      = tapelev4, key = ilev_4
CADJ STORE xx_sst1      = tapelev4, key = ilev_4
# endif
# ifdef ALLOW_SSS_CONTROL
CADJ STORE xx_sss0      = tapelev4, key = ilev_4
CADJ STORE xx_sss1      = tapelev4, key = ilev_4
# endif


#endif /* ALLOW_EXF */
