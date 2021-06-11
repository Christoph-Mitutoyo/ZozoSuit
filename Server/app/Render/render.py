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
  for i in range(len): 
    if(data[i]['point_id'] == 3235):
      p[0] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3085):
      p[1] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 2353):
      p[2] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3505):
      p[3] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3601):
      p[4] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3604):
      p[5] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3371):
      p[6] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3873):
      p9_1 = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3846):
      p9_2 = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3249):
      p[13] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 3717):
    # if(data[i]['point_id'] == 3750):
      p[14] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 2569):
      p[16] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 2500):
    # if(data[i]['point_id'] == 2578):
      p[17] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 2572):
      p[18] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
    if(data[i]['point_id'] == 2589):
      p[19] = torch.FloatTensor(np.array([data[i]["position"][0], data[i]["position"][1], data[i]['distance']]))
  
  if(p9_1 != None and p9_2 != None):
    p[9]=p9_1+(p9_2-p9_1)/2
    
  for i in range(24):
    print("Point:" + str(i) + " :" + str(p[i]))

  star = STAR(gender=gender)
  betas = np.array([
              np.array([ 2.25176191, -3.7883464, 0.46747496, 3.89178988,
                        2.20098416, 0.26102114, -3.07428093, 0.55708514,
                        -3.94442258, -2.88552087])])
  num_betas=10
  batch_size=1
  m = STAR(gender='male',num_betas=num_betas)

  poses = torch.FloatTensor(np.zeros((batch_size,72)))
  betas = torch.FloatTensor(betas)
  betas = torch.FloatTensor(np.zeros((batch_size,10)))
  poses[0].reshape(24,3)[1]  = angle_axis(p[0],  p[1])
  poses[0].reshape(24,3)[2]  = angle_axis(p[0],  p[2])
  poses[0].reshape(24,3)[3]  = angle_axis(p[0],  p[3])
  poses[0].reshape(24,3)[4]  = angle_axis(p[1],  p[4])
  poses[0].reshape(24,3)[5]  = angle_axis(p[2],  p[5])
  poses[0].reshape(24,3)[6]  = angle_axis(p[3],  p[6])
  poses[0].reshape(24,3)[7]  = angle_axis(p[4],  p[7])
  poses[0].reshape(24,3)[8]  = angle_axis(p[5],  p[8])
  poses[0].reshape(24,3)[9]  = angle_axis(p[6],  p[9])
  poses[0].reshape(24,3)[10] = angle_axis(p[7],  p[10])
  poses[0].reshape(24,3)[11] = angle_axis(p[8],  p[11])
  poses[0].reshape(24,3)[12] = angle_axis(p[9],  p[12])
  poses[0].reshape(24,3)[13] = angle_axis(p[9],  p[13])
  poses[0].reshape(24,3)[14] = angle_axis(p[9],  p[14])
  poses[0].reshape(24,3)[15] = angle_axis(p[12], p[15])
  poses[0].reshape(24,3)[16] = angle_axis(p[13], p[16])
  poses[0].reshape(24,3)[17] = angle_axis(p[14], p[17])
  poses[0].reshape(24,3)[18] = angle_axis(p[16], p[18])
  poses[0].reshape(24,3)[19] = angle_axis(p[17], p[19])
  poses[0].reshape(24,3)[20] = angle_axis(p[18], p[20])
  poses[0].reshape(24,3)[21] = angle_axis(p[19], p[21])
  poses[0].reshape(24,3)[22] = angle_axis(p[20], p[22])
  poses[0].reshape(24,3)[23] = angle_axis(p[21], p[23])

  poses[0].reshape(24,3)[14]=torch.Tensor(np.array([0,0,1]))

  # poses[0][44] = 1
  trans = torch.FloatTensor(np.zeros((batch_size,3)))
  model = star.forward(poses, betas,trans)

  out_mesh = trimesh.Trimesh(model[0], model.f, process=False)
  trimesh.exchange.export.export_mesh(out_mesh, 'output.glb', file_type='glb', resolver=None)

  # # display mesh
  # import pyrender
  # material = pyrender.MetallicRoughnessMaterial(
  #           metallicFactor=0.0,
  #           alphaMode='OPAQUE',
  #           baseColorFactor=(1.0, 1.0, 0.9, 1.0))
  # mesh = pyrender.Mesh.from_trimesh(
  #     out_mesh,
  #     material=material)
  # scene = pyrender.Scene(bg_color=[0.0, 0.0, 0.0, 0.0],
  #                         ambient_light=(0.3, 0.3, 0.3))
  # scene.add(mesh, 'mesh')
  # pyrender.Viewer(scene, use_raymond_lighting=True)

def angle_axis(point1, point2):
  if point1 == None or point2 == None:
    return  torch.FloatTensor(np.array([0, 0, 0]))
  a_vec = point1/np.linalg.norm(point1)
  b_vec = point2/np.linalg.norm(point2)
  cross = np.cross(a_vec, b_vec)
  ab_angle = np.arccos(np.dot(a_vec,b_vec))
  vx = np.array([[0,-cross[2],cross[1]],[cross[2],0,-cross[0]],[-cross[1],cross[0],0]])  
  m = np.identity(3)*np.cos(ab_angle) + (1-np.cos(ab_angle))*np.outer(cross,cross) + np.sin(ab_angle)*vx
  
  # margin to allow for rounding errors
  epsilon2=0.01
  # margin to distinguish between 0 and 180 degrees
  epsilon=0.001
  if ((abs(m[0][1]-m[1][0])< epsilon)
  and (abs(m[0][2]-m[2][0])< epsilon)
  and (abs(m[1][2]-m[2][1])< epsilon)):
    if ((abs(m[0][1]+m[1][0]) < epsilon2)
    and (abs(m[0][2]+m[2][0]) < epsilon2)
    and (abs(m[1][2]+m[2][1]) < epsilon2)
    and (abs(m[0][0]+m[1][1]+m[2][2]-3) < epsilon2)):
  		# this singularity is identity matrix so angle = 0
      return torch.FloatTensor(np.array([0, 0, 0]))
    xx = (m[0][0]+1)/2
    yy = (m[1][1]+1)/2
    zz = (m[2][2]+1)/2
    xy = (m[0][1]+m[1][0])/4
    xz = (m[0][2]+m[2][0])/4
    yz = (m[1][2]+m[2][1])/4
    if ((xx > yy) and (xx > zz)): # // m[0][0] is the largest diagonal term
      if (xx< epsilon):
        x = 0
        y = 0.7071
        z = 0.7071
      else:
        x = math.sqrt(xx)
        y = xy/x
        z = xz/x
    elif (yy > zz): # m[1][1] is the largest diagonal term
      if (yy< epsilon):
        x = 0.7071
        y = 0
        z = 0.7071
      else:
        y = math.sqrt(yy)
        x = xy/y
        z = yz/y
    else: # m[2][2] is the largest diagonal term so base result on this
      if (zz< epsilon):
        x = 0.7071
        y = 0.7071
        z = 0
      else:
        z = math.sqrt(zz)
        x = xz/z
        y = yz/z
    return torch.FloatTensor(np.array([x, y, z])*angle)
  # as we have reached here there are no singularities so we can handle normally
  s = math.sqrt((m[2][1] - m[1][2])*(m[2][1] - m[1][2])
    +(m[0][2] - m[2][0])*(m[0][2] - m[2][0])
    +(m[1][0] - m[0][1])*(m[1][0] - m[0][1])) # used to normalize
  if (abs(s) < 0.001):
     s=1 
    # prevent divide by zero, should not happen if matrix is orthogonal and should be
    # caught by singularity test above
  angle = math.acos(( m[0][0] + m[1][1] + m[2][2] - 1)/2)
  x = (m[2][1] - m[1][2])/s
  y = (m[0][2] - m[2][0])/s
  z = (m[1][0] - m[0][1])/s
  return torch.FloatTensor(np.array([x,y,z])*angle)