"""Utility functions for DTW alignments."""

import warnings

import numpy as np
cimport numpy as np

from cpython cimport array


# Not sure this file is even necessary.


__all__ = ["_computeCM","_test_computeCM"]



cdef extern from "dtw_computeCM.h":
  void computeCM(			
	       const int *s,		
	       const int *wm,		
	       const double *lm,	
	       const int *nstepsp,	
	       const double *dir,	
	       double *cm,      # IN+OUT
	       int *sm          # OUT
  ) 




  
def _computeCM(int [:] s not None,
               int [:,::1] wm not None,
               double [:,::1] lm not None,
               int [:] nstepsp not None,
               double [::1] dir not None,
               double [:,::1] cm not None,
               int [:,::1] sm = None  ):

    computeCM(&s[0],
              &wm[0,0],
              &lm[0,0],
              &nstepsp[0],
              &dir[0],
              &cm[0,0],
              &sm[0,0])

    return (cm.base, sm.base)



  
  
def _test_computeCM(TS=5):

    DTYPE = np.int32
    
    ts=np.array((TS, TS), dtype=DTYPE)

    twm = np.ones((TS, TS), dtype=DTYPE)

    tlm = np.zeros( (TS,TS), dtype=np.double)
    for i in range(TS):
        for j in range(TS):
            tlm[i,j]=(i+1)*(j+1)

    tnstepsp = np.array([6], dtype=DTYPE)

    tdir = np.array( (1, 1, 2, 2, 3, 3, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0,-1, 1,-1, 1,-1, 1),
                                     dtype=np.double)

    tcm = np.full_like(tlm, np.nan, dtype=np.double)
    tcm[0,0] = tlm[0,0]

    tsm = np.full_like(tlm, -1, dtype=DTYPE)

    a, b = _computeCM(ts,
                      twm,
                      tlm,
                      tnstepsp,
                      tdir,
                      tcm,
                      tsm)
    return (a,b)
    
    
