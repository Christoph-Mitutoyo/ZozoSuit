@echo off

lualatex Thesis
makeglossaries Thesis
biber Thesis
lualatex Thesis
lualatex Thesis
