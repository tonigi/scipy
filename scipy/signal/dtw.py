from __future__ import division, print_function, absolute_import

import numpy as np
from ._dtw_utils import *

__all__ = ['dtw']


class stepPattern:
    def __init__(self, mx, hint):
        self.mx = mx
        self.hint = hint

# TODO: all step patterns and generation functions
symmetric2=stepPattern(np.array([  1,1,1,-1,
                                   1,0,0,2,
                                   2,0,1,-1,
                                   2,0,0,1,
                                   3,1,0,-1,
                                   3,0,0,1 ]),
                       "N+M")



def dtw(x, y=None,
        dist_method="Euclidean",
        step_pattern=symmetric2,
        window_type=None,
        keep_internals=False,
        distance_only=False,
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

    if open_end or open_begin or not distance_only or window_type or dist_method != "Euclidean":
        raise "Unsupported yet"

    
    
    
