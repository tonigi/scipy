"""Utility functions for DTW alignments."""

import warnings

import numpy as np
cimport numpy as np

from cpython cimport array


# Not sure this file is even necessary.


__all__ = ["test_computeCM"]



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


  
def test_computeCM(TS=5):

    DTYPE = np.int32

    # Size
    cdef int [:] ts=np.array((TS, TS), dtype=DTYPE)

    # Window
    cdef int [:,:] twm = np.ones((TS, TS), dtype=DTYPE)

    # Local distance matrix
    cdef double [:,:] tlm = np.zeros( (TS,TS), dtype=np.double)
    for i in range(TS):
        for j in range(TS):
            tlm[i,j]=(i+1)*(j+1)

    # Step pattern size
    cdef int [:] tnstepsp = np.array([6], dtype=DTYPE)

    # Step pattern
    cdef double [:] tdir = np.array( (1, 1, 2, 2, 3, 3, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0,-1, 1,-1, 1,-1, 1),
                                     dtype=np.double)

    # Computed cumulative cost matrix
    cdef double [:,:] tcm = np.full_like(tlm, np.nan, dtype=np.double)
    tcm[0,0] = tlm[0,0]

    # Direction matrix
    cdef int [:,:] tsm = np.full_like(tlm, -1, dtype=DTYPE)

    computeCM(&ts[0],
              &twm[0,0],
              &tlm[0,0],
              &tnstepsp[0],
              &tdir[0],
              &tcm[0,0],
              &tsm[0,0])

    return (tcm, tsm)
    
    
