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

def render(gender):
  star = STAR(gender=gender)
  betas = np.array([
              np.array([ 2.25176191, -3.7883464, 0.46747496, 3.89178988,
                        2.20098416, 0.26102114, -3.07428093, 0.55708514,
                        -3.94442258, -2.88552087])])
  num_betas=10
  batch_size=1
  m = STAR(gender='male',num_betas=num_betas)

  # Zero pose
  poses = torch.FloatTensor(np.zeros((batch_size,72)))
  # betas = torch.FloatTensor(betas)
  betas = torch.FloatTensor(np.zeros((batch_size,10)))
  poses[0][51] = 0.5
  poses[0][52] = 0.5
  poses[0][53] = 0.5
  trans = torch.FloatTensor(np.zeros((batch_size,3)))
  print(trans)
  model = star.forward(poses, betas,trans)

  out_mesh = trimesh.Trimesh(model[0], model.f, process=False)
  trimesh.exchange.export.export_mesh(out_mesh, 'output.stl', file_type='stl', resolver=None)