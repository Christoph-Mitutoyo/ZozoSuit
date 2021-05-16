@echo off

lualatex "\def\spelling{}\input{Thesis}"
makeglossaries Thesis
biber Thesis
lualatex "\def\spelling{}\input{Thesis}"
lualatex "\def\spelling{}\input{Thesis}"
