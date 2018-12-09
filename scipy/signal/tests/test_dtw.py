from __future__ import division, print_function, absolute_import

import numpy as np
from numpy.testing import (assert_, assert_approx_equal,
                           assert_allclose, assert_array_equal, assert_equal,
                           assert_array_almost_equal_nulp)
import pytest
from pytest import raises as assert_raises

from scipy.signal import dtw


        
"""
# As in the JSS paper

ref <- window(aami3a, start = 0, end = 2)
test <- window(aami3a, start = 2.7, end = 5)
write.table(ref,"ref.dat",row.names=F,col.names=F)
write.table(test,"test.dat",row.names=F,col.names=F)
alignment <- dtw(test, ref, keep=T)
alignment$distance
"""        

"""
ref=np.genfromtxt("ref.dat")
test=np.genfromtxt("test.dat")
alignment=dtw(test,ref)
alignment.distance

"""        


class TestDTW(object):
    def test_matrix(self):
        dm = 10*np.ones((4,4)) + np.eye(4)
        al = dtw(dm)
        assert_array_equal(al.costMatrix,
                           np.array([[11., 21., 31., 41.],
                                     [21., 32., 41., 51.],
                                     [31., 41., 52., 61.],
                                     [41., 51., 61., 72.]]))

    def test_rectangular(self):
        # Hand-checked
        x = np.array([1,2,3])
        y = np.array([2,3,4,5,6])
        al = dtw(x,y)
        assert_array_equal(al.costMatrix,
                           np.array([[ 1.,  3.,  6., 10., 15.],
                                     [ 1.,  2.,  4.,  7., 11.],
                                     [ 2.,  1.,  2.,  4.,  7.]]))
        

    def test_vectors(self):
        x = np.array([1,2,3])
        y = np.array([2,3,4])
        al = dtw(x,y)
        assert_approx_equal(al.distance, 2.0)

