"""Utility functions for DTW alignments."""

import warnings

import numpy as np
cimport numpy as np

from cpython cimport array


# Not sure this file is even necessary.


__all__ = ["dtw","_computeCM","_test_computeCM"]



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



  


  
def _computeCM(np.int[::1] s not None,
               np.int[:,::1] wm not None,
               np.float64_t[:,::1] lm not None,
               np.int[:] nsteps not None,
               np.float64_t[::1] dir not None,
               np.float64_t[:,::1] cm not None,
               np.int[:,::1] sm not None  ):

    # Size
    cdef int [:] ts=s

    # Window
    cdef int [:,:] twm = wm

    # Local distance matrix
    cdef double [:,:] tlm = lm

    # Step pattern size
    cdef int [:] tnstepsp = nsteps

    # Step pattern
    cdef double [:] tdir = dir

    # Computed cumulative cost matrix
    cdef double [:,:] tcm = cm

    # Direction matrix
    cdef int [:,:] tsm = sm

    computeCM(&ts[0],
              &twm[0,0],
              &tlm[0,0],
              &tnstepsp[0],
              &tdir[0],
              &tcm[0,0],
              &tsm[0,0])

    return (tcm, tsm)



  
  
def _test_computeCM(TS=5):

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
    
    
