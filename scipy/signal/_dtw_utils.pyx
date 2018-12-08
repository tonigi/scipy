"""Utility functions for DTW alignments."""

import warnings

import numpy as np
cimport numpy as np

from cpython cimport array


# Not sure this file is even necessary.


__all__ = []



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
    TSS=TS*TS

    ts=np.array((TS, TS), dtype=np.int)
    cdef array.array ts_c = array.array('i', ts)

    twm = np.ones((TS, TS), dtype=np.int)
    cdef array.array twm_c = array.array('i', twm)

    tlm = np.zeros( (TS,TS), dtype=np.double)
    for i in range(TS):
        for j in range(TS):
            tlm[i,j]=(i+1)*(j+1)
    cdef array.array tlm_c = array.array('d', tlm)

    tnstepsp = [6]
    cdef array.array tnstepsp_c = array.array('i', tnstepsp)
    
    tdir = np.array( (1, 1, 2, 2, 3, 3, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0,-1, 1,-1, 1,-1, 1),
                     dtype=np.double)
    cdef array.array tdir_c = array.array('d', tdir)

    tcm = np.full_like(tlm, np.nan, dtype=np.double)
    tcm[0,0] = tlm[0,0]
    cdef array.array tcm_c = array.array('d', tcm)

    tsm = np.full_like(tlm, -1, dtype=np.int)
    cdef array.array tsm_c = array.array('i', tsm)

    computeCM(ts_c.data.as_ints,
              twm_c.data.as_ints,
              tlm_c.data.as_doubles,
              tnstepsp_c.data.as_ints,
              tdir_c.data.as_doubles,
              tcm_c.data.as_doubles,
              tsm_c.data.as_ints)
    
