from __future__ import division, print_function, absolute_import

import numpy as np
from ._dtw_utils import *
from scipy.spatial.distance import cdist

__all__ = ['dtw']



# --------------------

class stepPattern:
    def __init__(self, mx, hint):
        self.mx = mx
        self.hint = hint

    def getN(self):
        return int(len(self.mx)/4)

    def getM(self):
        u=self.mx
        return u.reshape(int(len(u)/4),-1)

    def getP(self):
        return self.getM().T.reshape(-1)

    

# TODO: all step patterns and generation functions
symmetric2=stepPattern(np.array([  1,1,1,-1,
                                   1,0,0,2,
                                   2,0,1,-1,
                                   2,0,0,1,
                                   3,1,0,-1,
                                   3,0,0,1 ]),
                       "N+M")

symmetric1=stepPattern(np.array([  1,1,1,-1,
                                   1,0,0,1,
                                   2,0,1,-1,
                                   2,0,0,1,
                                   3,1,0,-1,
                                   3,0,0,1 ]),
                       "NA")

# --------------------

class DTW:
    def __init__(self, obj):
        self.__dict__.update(obj)

    def __repr__(self):
        s = "DTW alignment object of size (query x reference): {:d} x {:d}".format(self.N,self.M)
        return(s)




# --------------------


def dtw(x, y=None,
        dist_method="euclidean",
        step_pattern=symmetric2,
        window_type=None,
        keep_internals=False,
        distance_only=True,
        open_end=False,
        open_begin=False):
    """
    Compute Dynamic Time Warp and find optimal alignment between two time series.

    Under development. The syntax should mirror the one in R 'dtw' package. Please see 
     * https://cran.r-project.org/web/packages/dtw/index.html
     * http://dtw.r-forge.r-project.org
     * http://www.jstatsoft.org/v31/i07/
     * https://www.rdocumentation.org/packages/dtw/versions/1.20-1/topics/dtw

    Returns a dictionary with the same properties as the R implementation (q.v.).
    Note that dots in argument names are replaced by underscores.

    """

    if open_end or open_begin or not distance_only or window_type:
        raise Exception("Only the most basic DTW form is implemented in scipy. Please use the R version.")

    if y is None:
        x = np.array(x)
        if len(x.shape) != 2:
            raise Exception("A 2D local distance matrix was expected")
        lm = np.array(x)
    else:
        x = np.atleast_2d(x)
        y = np.atleast_2d(y)
        if x.shape[0] == 1:
            x=x.T
        if y.shape[0] == 1:
            y=y.T
        lm = cdist(x,y, metric=dist_method)


    n,m = lm.shape
    
    w = np.ones_like(lm, dtype=np.int32)

    sp = np.array(step_pattern.getP(), dtype=np.double)

    nsp = np.array([step_pattern.getN()], dtype=np.int32)

    cm = np.full_like(lm, np.nan, dtype=np.double)
    cm[0,0] = lm[0,0]
    
    ncm, sm = _computeCM(w,
                        lm,
                        nsp,
                        sp,
                        cm)

    out={
        'N': n,
        'M': m,
        'distance': ncm[n-1,m-1],
        'costMatrix': ncm,
        'directionMatrix': sm,
        'localCostMatrix': lm,
        'stepPattern': step_pattern,
        }

    return(DTW(out))
    
    
    
