# -*- coding: utf-8 -*-
#
# Copyright (C) 2020 Max-Planck-Gesellschaft zur Förderung der Wissenschaften e.V. (MPG),
# acting on behalf of its Max Planck Institute for Intelligent Systems and the
# Max Planck Institute for Biological Cybernetics. All rights reserved.
#
# Max-Planck-Gesellschaft zur Förderung der Wissenschaften e.V. (MPG) is holder of all proprietary rights
# on this computer program. You can only use this computer program if you have closed a license agreement
# with MPG or you get the right to use the computer program from someone who is authorized to grant you that right.
# Any use of the computer program without a valid license is prohibited and liable to prosecution.
# Contact: ps-license@tuebingen.mpg.de
#
#
# If you use this code in a research publication please consider citing the following:
#
# STAR: Sparse Trained  Articulated Human Body Regressor <https://arxiv.org/pdf/2008.08535.pdf>
#
#
# Code Developed by:
# Ahmed A. A. Osman

from star.pytorch.star import STAR
import numpy as np
from numpy import newaxis
import pickle
import os
import torch
import trimesh
import math

def render(gender, data, len):
  p = [None] * 24
  p9_1 = None
  p9_2 = None

  # Joint coordinates of Restpose as reference
  restpose = np.array([
         [-2.8556e-03, -2.4251e-01,  2.8134e-02],
         [ 5.6633e-02, -3.4741e-01,  1.3533e-02],
         [-6.0310e-02, -3.4778e-01,  1.2419e-02],
         [-5.3794e-03, -1.1676e-01,  8.6785e-03],
         [ 1.0775e-01, -7.2241e-01,  1.4424e-02],
         [-1.1239e-01, -7.2386e-01,  1.2741e-02],
         [ 1.2233e-03,  2.3377e-02,  8.8773e-03],
         [ 8.9704e-02, -1.1313e+00, -2.7132e-02],
         [-9.0236e-02, -1.1329e+00, -2.7772e-02],
         [-3.1243e-04,  8.4470e-02,  2.2479e-02],
         [ 1.1011e-01, -1.1837e+00,  1.0910e-01],
         [-1.1203e-01, -1.1841e+00,  1.0802e-01],
         [-5.5198e-03,  2.8195e-01, -1.0894e-02],
         [ 8.9990e-02,  1.9922e-01, -1.1218e-02],
         [-9.2949e-02,  1.9712e-01, -1.4635e-02],
         [ 9.0825e-03,  3.8191e-01,  2.9127e-02],
         [ 1.9972e-01,  2.2863e-01, -1.1933e-02],
         [-1.9787e-01,  2.2662e-01, -1.4848e-02],
         [ 4.5190e-01,  2.2527e-01, -4.0916e-02],
         [-4.5197e-01,  2.2441e-01, -3.9767e-02],
         [ 7.1905e-01,  2.3020e-01, -4.2044e-02],
         [-7.1880e-01,  2.2573e-01, -3.9575e-02],
         [ 8.1542e-01,  2.2426e-01, -5.4773e-02],
         [-8.1996e-01,  2.1984e-01, -5.6233e-02]])
  
  # search for joints in data
  for i in range(len): 
    if(data[i]['point_id'] == 3235):
      p[0] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 3085):
      p[1] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 2353):
      p[2] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 3505):
      p[3] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 3601):
      p[4] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 2604):
      p[5] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 3371):
      p[6] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 3873):
      p9_1 = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 3846):
      p9_2 = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 3249):
      p[13] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 3717):
    # if(data[i]['point_id'] == 3750):
      p[14] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 2569):
      p[16] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 2500):
    # if(data[i]['point_id'] == 2578):
      p[17] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 2572):
      p[18] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
    if(data[i]['point_id'] == 2589):
      p[19] = np.array([data[i]["position"][0], -data[i]["position"][1], data[i]['distance']])
  
  if(p9_1 is not None and p9_2 is not None):
    p[9]=p9_1+(p9_2-p9_1)/2
    
  # for i in range(24):
  #   print("Point:" + str(i) + " :" + str(p[i]))

  star = STAR(gender=gender)
  num_betas=10
  batch_size=1
  m = STAR(gender=gender,num_betas=num_betas)

  poses = torch.FloatTensor(np.zeros((batch_size,72)))
  betas = torch.FloatTensor(np.zeros((batch_size,10)))
  
  # Calculate rotation from restpose to actual pose 
  poses[0].reshape(24,3)[1]  = axis_angle(p[0] , p[1] ,  restpose[1]  - restpose[0] )
  poses[0].reshape(24,3)[2]  = axis_angle(p[0] , p[2] ,  restpose[2]  - restpose[0] )
  poses[0].reshape(24,3)[3]  = axis_angle(p[0] , p[3] ,  restpose[3]  - restpose[0] )
  poses[0].reshape(24,3)[4]  = axis_angle(p[1] , p[4] ,  restpose[4]  - restpose[1] )
  poses[0].reshape(24,3)[5]  = axis_angle(p[2] , p[5] ,  restpose[5]  - restpose[2] )
  poses[0].reshape(24,3)[6]  = axis_angle(p[3] , p[6] ,  restpose[6]  - restpose[3] )
  poses[0].reshape(24,3)[7]  = axis_angle(p[4] , p[7] ,  restpose[7]  - restpose[4] )
  poses[0].reshape(24,3)[8]  = axis_angle(p[5] , p[8] ,  restpose[8]  - restpose[5] )
  poses[0].reshape(24,3)[9]  = axis_angle(p[6] , p[9] ,  restpose[9]  - restpose[6] )
  poses[0].reshape(24,3)[10] = axis_angle(p[7] , p[10],  restpose[10] - restpose[7] )
  poses[0].reshape(24,3)[11] = axis_angle(p[8] , p[11],  restpose[11] - restpose[8] )
  poses[0].reshape(24,3)[12] = axis_angle(p[9] , p[12],  restpose[12] - restpose[9] )
  poses[0].reshape(24,3)[13] = axis_angle(p[9] , p[13],  restpose[13] - restpose[9] )
  poses[0].reshape(24,3)[14] = axis_angle(p[9] , p[14],  restpose[14] - restpose[9] )
  poses[0].reshape(24,3)[15] = axis_angle(p[12], p[15],  restpose[15] - restpose[12])
  poses[0].reshape(24,3)[16] = axis_angle(p[13], p[16],  restpose[16] - restpose[13])
  poses[0].reshape(24,3)[17] = axis_angle(p[14], p[17],  restpose[17] - restpose[14])
  poses[0].reshape(24,3)[18] = axis_angle(p[16], p[18],  restpose[18] - restpose[16])
  poses[0].reshape(24,3)[19] = axis_angle(p[17], p[19],  restpose[19] - restpose[17])
  poses[0].reshape(24,3)[20] = axis_angle(p[18], p[20],  restpose[20] - restpose[18])
  poses[0].reshape(24,3)[21] = axis_angle(p[19], p[21],  restpose[21] - restpose[19])
  poses[0].reshape(24,3)[22] = axis_angle(p[20], p[22],  restpose[22] - restpose[20])
  poses[0].reshape(24,3)[23] = axis_angle(p[21], p[23],  restpose[23] - restpose[21])

  poses[0].reshape(24,3)[14]=torch.Tensor(np.array([0,0,1]))

  # poses[0][44] = 1
  trans = torch.FloatTensor(np.zeros((batch_size,3)))
  model = star.forward(poses, betas,trans)

  out_mesh = trimesh.Trimesh(model[0], model.f, process=False)
  trimesh.exchange.export.export_mesh(out_mesh, 'output.glb', file_type='glb', resolver=None)

# Calculate Rotation in Axis-Angle-Representation that rotates vector_orig to (p1,p2)
def axis_angle(p1, p2, vector_orig):
  if p1 is None or p2 is None:
    return torch.FloatTensor(np.array([0, 0, 0]))
  vector_fin = p2 - p1
  # Convert the vectors to unit vectors.
  vector_orig = vector_orig/np.linalg.norm(vector_orig)
  vector_fin = vector_fin/np.linalg.norm(vector_fin)

  if(np.array_equal(vector_orig, vector_fin)):
    return torch.FloatTensor(np.array([0, 0, 0]))

  # The rotation axis (normalised).
  axis = np.cross(vector_orig, vector_fin)
  axis_len = np.linalg.norm(axis)
  if axis_len != 0.0:
    axis = axis / axis_len

  # Return the data.
  return torch.FloatTensor(axis * angle)