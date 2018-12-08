"""Utility functions for DTW alignments."""

import warnings

import numpy as np
cimport numpy as np


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


  

